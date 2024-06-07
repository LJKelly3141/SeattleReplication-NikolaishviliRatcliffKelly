clc;
clear all;
close all;
rng('shuffle')

szsr = 5000; 
lrep = 100000;  
c = 5;
H = 60;
nburn = 500;
const = 1;
p = 12;

TIME5 = 118-p; % 2008-10   EXP   
NS5 = 'shk(TIME5,1) < 0';   
TIME6 = 119-p; % 2008-11   REST  
NS6 = 'shk(TIME6,1) > 0';   
TIME11= 154-p; % 2011-10   REST 
NS11= 'shk(TIME11,1)> 0';   
TIME12= 155-p; % 2011-11   EXP   
NS12= 'shk(TIME12,1)< 0';   
N12 = 'abs(shk(TIME12,1)*srA(1,1)) > abs(0.5*res(TIME12,1))';
   
i     = 0;
k     = 0;
sz    = 0;
znsr_raw = [];
znsr     = [];

%% Data and Variables
[xlsdataL, xlstextL] = xlsread('mon_data.xlsx',1);
xlsdata = xlsdataL(1:end,:);
xlstext = [xlstextL(1,:);xlstextL(2:end,:)];
[t,n]   = size(xlsdata);

%% Arrange Data:
T  = t-p;
y  = xlsdata(p+1:t,:);
Y  = xlsdata(p:t,:);
for i=1:p-1
    Y = [Y xlsdata(p-i:t-i,:)];
end
if const == 0
    X = [Y(1:t-p,:)];
elseif const == 1
    X = [ones(T,1) Y(1:t-p,:)];
elseif const == 2
    X = [ones(T,1) cumsum(ones(T,1)) Y(1:t-p,:)];
end

%% OLS
Bhat = (X'*X)\(X'*y);
SSEhat = (y-X*Bhat)'*(y-X*Bhat);
Sigmahat = SSEhat/(T-const-n*p);
Ahat = chol(Sigmahat)';
A = Ahat;
Sigma = Sigmahat;

%% Priors
Scl0 = eye(n);
dof0 = n;
run minnesota_mon_conj
dof = T + dof0;

%% Estimation
while size(znsr_raw,1) < szsr
    Prc = Prc0 + X'*X;
    EVBL = Prc\(Prc0*B0+X'*X*Bhat);
    EvBL = EVBL(:);
    Scl = SSEhat+Scl0+Bhat'*(X'*X)*Bhat+B0'*Prc0*B0-EVBL'*(Prc0+X'*X)*EVBL;
    sd = chol(inv(Scl))'*randn(n,dof);
    Sigma = inv(sd*sd');
    A = chol(Sigma)';
    vBL = EvBL + chol(kron(Sigma,inv(Prc)))'*randn((const+n*p)*n,1);
    B = reshape(vBL,const+n*p,n);
    i = i+1;
    if i > nburn
        Phi = [B(1+const:end,:)' ; eye(n*(p-1)) zeros(n*(p-1),n)];
        nsz_temp = 0;
        ndraw = 0;
        while nsz_temp < c  &&  ndraw < lrep  
            ndraw = ndraw + 1;
            [U,R] = qr(randn(n,n));
            for j=1:n
                if R(j,j)<0
                    U(:,j)=-U(:,j);
                end
            end
            srA  = A*U;         
            res  = y - X*B;    
            shk  = (srA\res')'; 
            irf  = irfvar(Phi,srA,p,n,1);
            sz = sz + 1;
            u = 0;
            if eval(NS5)==1 && eval(NS6)==1 && eval(NS11)==1 && eval(NS12)==1 && eval(N12)==1
                if nsz_temp < c
                   nsz_temp = nsz_temp + 1;
                   if size(znsr_raw,1) < szsr
                       znsr_raw  = [znsr_raw; B(:)' A(:)' U(:)'];
                   end
               end
            end
        end
        disp(strcat(num2str(size(znsr_raw,1)),' draws with valid NSRs'))
    end
end

znsr = znsr_raw;

conjIRF  = [];
for i=1:size(znsr,1)
    B             = reshape(znsr(end-i+1,1:(const+n*p)*n),const+n*p,n);
    A             = reshape(znsr(end-i+1,(const+n*p)*n+1:(const+n*p)*n+n*n),n,n);
    U             = reshape(znsr(end-i+1,(const+n*p)*n+n*n+1:(const+n*p)*n+2*n*n),n,n);
    nsrA          = A*U;
    Phi           = [B(1+const:end,:)' ; eye(n*(p-1)) zeros(n*(p-1),n)];
    irf           = irfvar(Phi,nsrA,p,n,H)';
    conjIRF(i,:,:)    = irf;
end

run mon_fig_irf_conj

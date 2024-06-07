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

TIME1 = 47-p;  % 2002m11   REST  
NS1 = 'shk(TIME1,1) > 0';   
TIME2 = 48-p;  % 2002m12   EXP  
NS2 = 'shk(TIME2,1) < 0';   
TIME3 = 51-p;  % 2003m3    REST  
NS3 = 'shk(TIME3,1) > 0';   
TIME4 = 54-p;  % 2003m6    EXP  
NS4 = 'shk(TIME4,1) < 0';   
TIME5 = 118-p; % 2008-10   EXP   
NS5 = 'shk(TIME5,1) < 0';   
TIME6 = 119-p; % 2008-11   REST  
NS6 = 'shk(TIME6,1) > 0';   
TIME7 = 120-p; % 2008m12   REST
NS7 = 'shk(TIME7,1) > 0';   
TIME8 = 121-p; % 2009m1    EXP
NS8 = 'shk(TIME8,1) < 0';   
TIME9 = 123-p; % 2009m3    REST  
NS9 = 'shk(TIME9,1) > 0';   
TIME10= 124-p; % 2009m4    REST
NS10= 'shk(TIME10,1)> 0';   
TIME11= 154-p; % 2011-10   REST 
NS11= 'shk(TIME11,1)> 0';   
TIME12= 155-p; % 2011-11   EXP   
NS12= 'shk(TIME12,1)< 0';   
TIME13= 163-p; % 2012m7    EXP
NS13= 'shk(TIME13,1)< 0';   
TIME14= 189-p; % 2014m9    EXP
NS14= 'shk(TIME14,1)< 0';   
TIME15= 204-p; % 2015m12   REST
NS15= 'shk(TIME15,1)> 0';   

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
run minnesota_mon_baseline
dof = T + dof0;

%% Estimation
while size(znsr_raw,1) < szsr
    PrcL = Prc0L + kron(inv(Sigma),X'*X);
    EvBL = PrcL\(Prc0L*B0(:)+kron(inv(Sigma),X'*X)*Bhat(:));
    vBL = EvBL + chol(inv(PrcL))'*randn((const+n*p)*n,1);
    B = reshape(vBL,const+n*p,n);
    Scl = Scl0 + (y-X*B)'*(y-X*B);
    sd = chol(inv(Scl))'*randn(n,dof);
    Sigma = inv(sd*sd');
    A = chol(Sigma)';
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
            if eval(NS1)==1 && eval(NS3)==1 && eval(NS4)==1 && eval(NS5)==1 && eval(NS6)==1 && eval(NS7)==1 && eval(NS8)==1 && eval(NS9)==1 && eval(NS10)==1 && eval(NS11)==1 && eval(NS12)==1 && eval(NS13)==1 && eval(NS14)==1 && eval(NS15)==1 && eval(N12)==1
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

furIRF  = [];
for i=1:size(znsr,1)
    B             = reshape(znsr(end-i+1,1:(const+n*p)*n),const+n*p,n);
    A             = reshape(znsr(end-i+1,(const+n*p)*n+1:(const+n*p)*n+n*n),n,n);
    U             = reshape(znsr(end-i+1,(const+n*p)*n+n*n+1:(const+n*p)*n+2*n*n),n,n);
    nsrA          = A*U;
    Phi           = [B(1+const:end,:)' ; eye(n*(p-1)) zeros(n*(p-1),n)];
    irf           = irfvar(Phi,nsrA,p,n,H)';
    furIRF(i,:,:)    = irf;
end

run mon_fig_irf_fur

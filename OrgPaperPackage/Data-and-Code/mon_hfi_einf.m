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

i     = 0;
k     = 0;
sz    = 0;
zsr     = [];

%% Data and Variables
[xlsdataL, xlstextL] = xlsread('mon_data.xlsx',4);
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
Bhat     = (X'*X)\(X'*y);
SSEhat = (y-X*Bhat)'*(y-X*Bhat);
Sigmahat = SSEhat/(T-const-n*p);
Ahat = chol(Sigmahat)';
A = Ahat;
Sigma = Sigmahat;

%% Priors
Scl0 = eye(n);
dof0 = n;
run minnesota_mon_hfi
dof = T + dof0;

%% Estimation
while size(zsr,1) < szsr
    PrcL = Prc0L + kron(inv(Sigma),X'*X);
    EvBL = PrcL\(Prc0L*B0(:)+kron(inv(Sigma),X'*X)*Bhat(:));
    Var = nearestSPD(inv(PrcL));
    vBL = EvBL + chol(Var)'*randn((const+n*p)*n,1);
    B = reshape(vBL,const+n*p,n);
    Scl = Scl0 + (y-X*B)'*(y-X*B);
    Scl = (Scl+Scl')/2;    
    sd = chol(inv(Scl))'*randn(n,dof);
    Sigma = inv(sd*sd');
    A = chol(Sigma)';
    i = i+1;
    if i > nburn
        U = eye(n);
        zsr = [zsr; B(:)' A(:)' U(:)'];
        disp(strcat(num2str(size(zsr,1)),' draws with valid SRs'))
    end
end

hfieinfIRF  = [];
for i=1:size(zsr,1)
    B               = reshape(zsr(end-i+1,1:(const+n*p)*n),const+n*p,n);
    A               = reshape(zsr(end-i+1,(const+n*p)*n+1:(const+n*p)*n+n*n),n,n);
    U               = reshape(zsr(end-i+1,(const+n*p)*n+n*n+1:(const+n*p)*n+2*n*n),n,n);
    hfiA             = A*U;
    Phi             = [B(1+const:end,:)' ; eye(n*(p-1)) zeros(n*(p-1),n)];
    irf             = irfvar(Phi,hfiA,p,n,H)';
    hfieinfIRF(i,:,:)    = irf;
end

hfieinfIRF = hfieinfIRF(:,:,2:end);

run mon_fig_irf_einf

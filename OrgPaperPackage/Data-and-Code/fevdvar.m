function [FEVD] = fevdvar(Phi,A,U,p,n,H)

MSE   = zeros(n,n,H+1);
MSE_j = zeros(n,n,H+1);
PSI   = zeros(n,n,H+1);
FEVD  = zeros(H+1,n,n);
SE    = zeros(H+1,n);

IRFjunk = irfvar2(Phi,eye(n),p,n,H);     

for mm = 1:n
    PSI(:,mm,:) = reshape(IRFjunk(:,:,mm)',1,n,H+1);
end

sigma = A*A';
for mm = 1:n
    MSE(:,:,1) = sigma;
    for kk = 2:H
       MSE(:,:,kk) = MSE(:,:,kk-1) + PSI(:,:,kk)*sigma*PSI(:,:,kk)';
    end
    srA = A*U;
    column = srA(:,mm);
    MSE_j(:,:,1) = column*column';
    for kk = 2:H
        MSE_j(:,:,kk) = MSE_j(:,:,kk-1) + PSI(:,:,kk)*(column*column')*PSI(:,:,kk)';   
    end
    FECD = MSE_j./MSE;
    for nn = 1:H
        for ii = 1:n
            FEVD(nn,mm,ii) = FECD(ii,ii,nn);
            SE(nn,:) = sqrt( diag(MSE(:,:,nn))' );
        end
    end
end

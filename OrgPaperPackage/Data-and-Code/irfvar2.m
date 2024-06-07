function [IRF]=irfvar2(Phi,A,p,n,H)

IRF = nan(H+1,n,n);

for mm = 1:n
    response = zeros(n,H+1);
    impulse = zeros(n,1); 
    impulse(mm,1) = 1;           % one stdev shock
%    impulse(mm,1) = 1/A(mm,mm); % unitary shock
    response(:,1) = A*impulse;
    impulse_big  = [response(:,1)' zeros(1,n*(p-1))]';
    Phi_eye = eye(size(Phi,1)); 
    for kk = 2:H+1
        Phi_eye = Phi * Phi_eye;
        response_big   = Phi_eye * impulse_big;
        response(:,kk) = response_big(1:n);
    end
    IRF(:,:,mm) = response';
end



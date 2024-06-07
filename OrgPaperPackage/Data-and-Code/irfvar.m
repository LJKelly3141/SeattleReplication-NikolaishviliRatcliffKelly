% IRFVAR.M
% Lutz Kilian
% University of Michigan
% April 1997

function [IRF]=irfvar(Phi,A,p,n,H)

J=[eye(n,n) zeros(n,n*(p-1))];
IRF=reshape(J*Phi^0*J'*A,n^2,1);
for i=1:H
	IRF=([IRF reshape(J*Phi^i*J'*A,n^2,1)]);
end



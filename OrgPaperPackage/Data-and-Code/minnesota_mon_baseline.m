c0 = 1;     % hyperparameter for AR(1)-coefficient; 0...white noise, 1...random walk
c1 = 100;   % hyperparameter for intercepts
c2 = 0.1;   % hyperparameter for slopes; 0.1...tight, 1.0...weak
c3 = c2*0.5;

B0   = [zeros(const,n); c0*eye(n); zeros((p-1)*n,n)];

sigma_sq = zeros(n,1);
for i = 1:n
    ylag_i = mlag2(xlsdata(:,i),p);
    ylag_i = ylag_i(p+1:t,:);
    beta_i = (ylag_i'*ylag_i)\(ylag_i'*y(:,i));
    sigma_sq(i) = (1./(t-p+1))*(y(:,i) - ylag_i*beta_i)'*(y(:,i) - ylag_i*beta_i);
end

V_i = zeros(const+n*p,n);    
ind = zeros(n,p);
for i=1:n
        ind(i,:) = const+i:n:const+n*p;
end
for i = 1:n
    for j = 1:const+n*p
        l = ceil((j-const)/n);
         if j < const+1
             V_i(j,i) = c1*sigma_sq(i);                              % variance on CONSTANT
         elseif find(j==ind(i,:))>0
             V_i(j,i) = c2./(l^2);                                   % variance on OWN lags
         else
             for kj=1:n
                 if find(j==ind(kj,:))>0
                     ll = kj;
                 end
             end
             V_i(j,i) = (c3*sigma_sq(i))./((l^2)*sigma_sq(ll));   % variance on OTHER lags
         end
     end
end
Prc0 = 1./V_i;
Prc0L = sparse(1:n*(p*n+const),1:n*(p*n+const),Prc0);

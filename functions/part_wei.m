function P=part_wei(C)  
check=[];
for iter=1:100
       M_Louvain = community_louvain(C);
       check=[check,M_Louvain];
end

[S2, Q2, X_new3, qpc] = consensus_iterative(check');
newM     = S2(1,:);
P=participation_coef(X_new3,newM);

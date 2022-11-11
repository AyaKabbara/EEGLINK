function [P_global,index_sigRegions_Bonf,index_sigRegions_FDR]=findRegions(X,Y,alpha)

% % X=  distribution of the first condition (nbregions x nbsamples)
% % Y=  distribution of the second condition (nbregions x nbsamples)
% % Tail: 
% % 'both'  -- "medians are not equal" (two-tailed test, default)
% %         'right' -- "median of X is greater than median of Y" (right-tailed test)
% %         'left'  -- "median of X is less than median of Y" (left-tailed test)
% % alpha: significance level (ex: 0.05)

global tail;

nbRegions=size(X,1);
nbregions2=size(Y,1);
switch tail
    case 1
% %         G1>G2
Taill='right';
    case 2
        Taill='left';

    case 3
        Taill='both';

end
if(nbRegions==nbregions2)
    P_global=ranksum(mean(X),mean(Y),'tail',Taill);
    
% % get the statistical difference between all regional distributions
P_values=[];
for region=1:nbRegions
    P_values(region)=ranksum(X(region,:),Y(region,:));
end

% % multiple comparison correction
% Bonferroni as example:
index_sigRegions_Bonf=find(P_values<alpha/nbRegions);

% % FDR as example
p_sorted = sort(P_values,'descend');
n_vals = length(P_values);
num_tests = n_vals; 
comp = (num_tests:-1:1)/num_tests * alpha;
comp = comp((end-n_vals+1):end);
i = find(p_sorted <= comp,1,'first');
if isempty(i)
    thres = 0;
else
    thres = p_sorted(i);
end
index_sigRegions_FDR = find(P_values<=thres);
else
    index_sigRegions_FDR = [];
    index_sigRegions_Bonf = [];
    msgbox('All networks should have the same number of nodes');
end
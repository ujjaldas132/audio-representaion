function [ output_matrix ] = required_A_matrix(matrix,no,list_r)

%%
% this is the function is to get required A
% from the a list of A
% in the list of A we are saving all the A
% So that for the requirement we can take the A

% ; list of r in the prog=[2,4,6,8......]
%%
%

index=find(list_r==no);
temp=list_r(1:index);
final_point=sum(temp);
initial_point=(final_point-list_r(index))+1;


%extract the required matrix
output_matrix=matrix(initial_point:final_point,:);



end


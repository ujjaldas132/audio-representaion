function [new_matrix ] = differently_visualisation( data,matrix )
%%
% this function  is for plotting A of different set of data differently
% putting some zero after one type of data
% matrix have the record from where to where a set of same are present
%%


m=size(matrix,2);
matrix=[1,matrix];
%now put zeros inbetween different speech
new_matrix=[];
no_of_rows_in_data=size(data,1);
%intilise the zero matrix
temp=matrix(2)-matrix(1);
no_of_added_column=ceil(.4*temp);
new_zero_lines=zeros(no_of_rows_in_data,no_of_added_column);

for i=1:m
    temp_matrix=data(:,matrix(i):matrix(i+1));
    new_matrix=[new_matrix,temp_matrix,new_zero_lines];
    
    
end

surf(new_matrix);


end


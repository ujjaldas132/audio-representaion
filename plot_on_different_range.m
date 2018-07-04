function [ matrix ] = plot_on_different_range( matrix,upper_bound,lower_bound )

%%
% this function is to plot the the given matrix on a diffrent range of values
% better visualisation
% 
% let say the values of given values lie between    [min_value,max_value]
% now with the help of this function we are going to map these values
% in the range   [lower_bound,upper_bound]


%%



min_value=min(min(matrix));
max_value=max(max(matrix));
[m,n]=size(matrix);


multiplication_factor=upper_bound-lower_bound;

for i=1:m*n
    matrix(i)=(((matrix(i)-min_value)/(max_value-min_value))*multiplication_factor)+lower_bound;
    
end
surf(matrix);



end


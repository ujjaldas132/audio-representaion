function [ new_matrix ] = no_of_non_zero( data,serial )

[m,n]=size(data);
new_matrix=[];
new_zero_lines=zeros(1,10);
serial_no=1;

for column=1:n
    count=0;
    checking_data=data(:,column);
for i=1:m 
    
    if(checking_data(i)~=0)
        count=count+1;
    
    end
end
if(serial(serial_no)==column)
    new_matrix=[new_matrix,count,new_zero_lines];
else
        new_matrix=[new_matrix,count];
end



end
stem(new_matrix);
end


function [ output_matrix,list_splitting ] = make_same_amount_of_data( matrix,serial_list)

serial_list=[0,serial_list];
length=serial_list(2)-serial_list(1);
output_matrix=[];list_splitting=[];

for i=2:size(serial_list,2)-1
    temp=serial_list(i+1)-serial_list(i);
    if(temp<length)
        length=temp;
    end
end

for i=1:size(serial_list,2)-1
    serial_list(i)+1
    serial_list(i+1)
    temp_mat=matrix(:,serial_list(i)+1:serial_list(i)+length);
    output_matrix=[output_matrix,temp_mat];
    list_splitting=[list_splitting,i*length];
    
end





end


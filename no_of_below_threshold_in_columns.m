function [ new_matrix ] = no_of_below_threshold_in_columns( data,serial,threshold )

[m,n]=size(data);
new_matrix_for_average=[];
new_matrix=[];
new_zero_lines=zeros(1,5);
serial_no=1;
serial_for_plotting=1;
zero_matrix=zeros(1,20);
% threshold=mean(mean(data));

for column=1:n
    count=0;
    checking_data=data(:,column);
for i=1:m 
    if(checking_data(i)>threshold)
        count=count+1;
    
    end
end
if(serial(serial_no)==column)
            new_matrix=[new_matrix,count,zero_matrix]

%     count=mean(new_matrix_for_average)
%     stem(serial_for_plotting,count);
    serial_for_plotting=serial_for_plotting+1;
%     hold on;
%     new_matrix=[new_matrix,count,new_zero_lines];
new_matrix=[new_matrix,count];
%     new_matrix_for_average=[];
    serial_no=serial_no+1;
else
        new_matrix=[new_matrix,count];
end



end
% legend('multispeaker','speaker1','speaker2','speaker3','speaker4','speaker5');
% hold off;

stem(new_matrix);
end


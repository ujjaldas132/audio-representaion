%taking abs
%main

clc;
close all;
clear all;

%%
%splitting list is for taking record of the set of same audio
% set1>> multispeaker
% set2>> speaker 1
% set3>> speaker 2
% set4>> speaker 3
% set5>> speaker 4
% set6>> speaker 5
last_data_splitting=[];
data_splitting=[34,40,41,43,50,51];
%%

%uploading the data

%y is the list where we're gonna store the data
y_old=[];

%data from 5th file>>>> 5xy----xy<=30
%data from 6th file>>>> 6xy----xy<=30
%data from 8th file>>>> 8xy----xy<=30

taken_files=100*[5,6,8];
data_taken_from_no_files=size(taken_files,2);

%if eah vector is very large then the time taken by the system become more
%so we need to compress the data 
% compressing_factor=10000;
data=[];
%for i=1:data_taken_from_no_files
    no_of_type_of_audio=size(data_splitting,2);
    for type_audio=1:no_of_type_of_audio
    for j=1:51
        %serial_no_data=(taken_files(i))+j;
        sprintf('%d.wave',j)
        [new_data,fs]=audioread(sprintf('%d.wav',j));
        data=[data;new_data];
%         %compressing the data
%         data=resample(new_data,8000,fs);
%          data_window=windowing(data,fs,.5,1);
%          
%          no_of_columns_in_window=size(data_window,2);
%          column_multiplication_factor=no_of_columns_in_window;
%          
%          for i_col=1:no_of_columns_in_window
%           a=melfcc(data_window(:,i_col), fs, 'lifterexp', -22, 'nbands', 20, ...
%       'dcttype', 3, 'maxfreq',8000, 'fbtype', 'htkmel', 'sumpower', 0);
%         
%         
%         
%         %writing the vector in our input matrix y
%         y=[y,a'];
%          end

%taking the mfcc
%frame size length everything in the function 
%if u want to change change in the function
if(j==data_splitting(type_audio))
a=mfcc_log_energy( data,fs );
column_multiplication_factor=size(a,2);
y_old=[y_old,a'];
last_data_splitting=[last_data_splitting,size(y_old,2)];
data=[];
end

    end
    end
    
   
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
%     data_splitting=data_splitting*column_multiplication_factor;
 y_old=abs(y_old);
%  y(y>1)=1;
%  y(y<0)=0;
% data_splitting=last_data_splitting;
%to make the every set of same size
[y,data_splitting]=make_same_amount_of_data( y_old,last_data_splitting);

%making the data loading simple because everytime the data is same
%load('final_input_data_splitng_list.mat')
max_value=max(max(y));
min_value=min(min(y));
[m,n]=size(y);
for i=1:m*n
    y(i)=y(i)/(max_value+min_value);
end

%%



length_for_overlapping=size(y,1)*0.5;
length_vector=size(y,1);
no_of_vector=size(y,2);



 

%%

%matrix to store the coefficient matrix for different values of r
matrix_for_A=[];
%matrix to store the best A of all r
A_best=[];
V_best=[];
size_input_matrix=size(y);
%to store the error for every best alpha
list_of_error=[];
%getting r<=min(m,n)
%the values of r
list_of_r=[2,3,4,5 ,6,7,8,9,10,11,12];

for value_of_r=1:size(list_of_r,2)
r=list_of_r(value_of_r);

[V,A]=nnmf(y,r);
A=abs(A);
matrix_for_A=[matrix_for_A;A];
temp_error=sum(sum(y-V*A));
list_of_error=[list_of_error,temp_error]
end
index_of_best_r=find(list_of_error==min(list_of_error));
r=list_of_r(index_of_best_r);
A=required_A_matrix(matrix_for_A,r,list_of_r   );


%plotting error
figure();
plot(list_of_r,list_of_error);
title('error vs r');
xlabel('value of r');
ylabel('value of error');




A_new_matrix_zero=[];



%select the best value of alpha





% alpha=best_r_alpha(2);
% 
% A=A_best;
% V=V_best;




%%

%ploting V
% figure();
% %mesh(V);
% plot(V);title('2d plot of basis matrix')
% figure();
% surf(V);title('3d plot of basis matrix')
% colormap(jet)

%ploting a
figure();subplot(2,1,1);
%mesh(A);
plot(A);title('2d plot of best coeffient matrix')
subplot(2,1,2);
surf(A);title('3d plot of best coeffient matrix')
xlabel('no of frames');ylabel('value of r');
zlabel('values of elements');
colormap(jet)





%%



%%


%%

%testing




%%

%%
% this function  is for plotting A of different set of data differently
% putting some zero after one type of data

figure();
matrix_for_visulisation=differently_visualisation(A,data_splitting);
title('separete different data putting zero vector in between');
xlabel('frames');ylabel('R');
zlabel('values');



%%
% this part is to calculate the no of element below the mean value
figure();
% c2=no_of_below_mean_in_columns( A,data_splitting );
c2=no_of_zero_in_columns( A,data_splitting,mean(mean(A)) );
title('matrix for calculating below the mean of the A matrix')

%%





%%
% this part is to calculate the no of element below the threshold value
% precision value is the no of digit after decimal
% for better plot we mapped the value in the range [lower_bound,upper_bound]


precision_factor=4;
list_of_threshold=(10^(-precision_factor))*[1,2,3,4,5,6,7,8,9];
[a,iteration_plot]=size(list_of_threshold);

upper_bound=255;
lower_bound=1;

for i=1:iteration_plot
%for i=1:1
   figure();
c2=no_of_zero_in_columns( A,data_splitting,list_of_threshold(i) ); 

A_new_matrix_zero=[A_new_matrix_zero;c2];
% 
 %title(sprintf('matrix for calculating no of element below==%d_ ',list_of_threshold(i)));
  figure();
 
 c2= plot_on_different_range( matrix_for_visulisation,upper_bound,lower_bound );
  

  matrix_for_visulisation=differently_visualisation(c2,data_splitting);       
title(sprintf('3d plot>>> values are in the range (%d,%d)',lower_bound,upper_bound));
xlabel('no of frames');ylabel('value of r');
zlabel('values of elements');
pause;
close; 
end

%%






% ploting A for different r
for i=1:size(list_of_r,2)
    temp=required_A_matrix(matrix_for_A,list_of_r(i),list_of_r);
    figure()
    matrix_for_visulisation=differently_visualisation(temp,data_splitting);
   title(sprintf('A matrix r==%d_ ',list_of_r(i)));
xlabel('no of frames');ylabel('value of r');
zlabel('values of elements');
pause;
close;
    
end



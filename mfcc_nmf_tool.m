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
y=[];

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
y=[y,a'];
last_data_splitting=[last_data_splitting,size(y,2)];
data=[];
end

    end
    end
    
   
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
%     data_splitting=data_splitting*column_multiplication_factor;
 y=abs(y);
%  y(y>1)=1;
%  y(y<0)=0;
data_splitting=last_data_splitting;
%%

%creating the overlapping

length_for_overlapping=size(y,1)*0.5;
length_vector=size(y,1);
no_of_vector=size(y,2);

%run the sequence
% for i=1:no_of_vector-1
%     %i
%     y(1:length_for_overlapping,i+1)=y(length_for_overlapping+1:length_vector,i);
% end



%%

%intilize the coefficient matrix
%we have y=VA
%A>>(r,n)
%r<=min(m,n)

size_input_matrix=size(y);

limit=min(size(y));
r=limit+1;

%getting r<=min(m,n)
while (r>=limit || r==1)
r=ceil(10*rand());
end
list_of_r=[2,4,6,8,10,12];
for value_of_r=1:size(list_of_r,2)
r=list_of_r(value_of_r);

%randomly create A
 A=rand(r,size_input_matrix(2));
% temp_a=cov(y);
% A=temp_a(1:r,:);



%normalising A
%first randomly create the value
%then divide by sum of them so that sunnation will be 1
for i=1:r
    summation=sum(A(i,:));
    A(i,:)=A(i,:)./summation;
end


% %%
% %now initilize the basis vector
% %y=VA
% V=y*A'*(inv(A*A'));
% 
% %make V non-negative and normalize
% % V(V<0)=0;
% % V(V>1)=1;
%  V=abs(V);
% %  V(V>1)=1;
% 
% %%
% %optimizing 
% %here we follow this step
% %1st>>take a set of alpha
% %2nd>>updating V along with A
% %3rd>> visualize the results and take the best alpha
% 
% 
% 
% 
% 
% list_alpha=[0.0001,0.0002,0.0003,0.0004,0.0005,0.0006,0.0007,0.0008,0.0009];
% iteration=50;
% multiplication_factor= .01;
% 
% 
% %take difference
% 
% %taking the size of V
% [m,n]=size(V);
% 
% 
% %this list is for visuling which alpha is better
% visulising_list=[];
% new_list=[];
% 
% %size(list_alpha,2)
% 
% for index_alpha=1:size(list_alpha,2)
% %for index_alpha=1:1
% 
% 
% 
% %y-V*A
% V_work=V;
% A_work=A;
% %list is for storing data for one element of V
% %so that by visualisation we can confirm that error is decreasing
% 
% alpha=list_alpha(index_alpha);
% 
% list=[];
% 
% 
% for i=1:iteration
%     %error=mod(y-(V*A));
%     %alpha
%     for j=1:m*n
%         gradiant=sum(gradient_decent_v(alpha,y,V_work,A_work,j));
%         V_work(j)=V_work(j)-(multiplication_factor*gradiant);
%         
%         
%         
%     end
%     %make the negative value 0
% %     V_work(V_work<0)=0;
% %     V_work(V_work>1)=1;
%       V_work=abs(V_work);
% %      V_work(V_work>1)=1;
%     
%     A_work=(inv(V_work'*V_work))*V_work'*y;
% %     A_work(A_work<0)=0;
% %     A_work(A_work>1)=1;
% %     
%   A_work=abs(A_work);
% %  A_work(A_work>1)=1;
% 
%     list=[list,(sum(sum(abs(y-V_work*A_work))))];
%     
%     
%     
% end
% plot(1:iteration,list);
% hold on;
% 
% list(iteration);
% 
% new_list=[new_list,list(iteration)]
% 
% visulising_list=[visulising_list;list];
% 
% end
% 
% hold off;
% %visualising the decreasing the error for one case
% %plot([1:iteration],list)
% title('plot for different alpha');
% 
% 
% 
% 
% %select the best value of alpha
% index_of_better_alpha=find(new_list==min(new_list));
% alpha=list_alpha(index_of_better_alpha);
% 
% 
% 
% 
% 
% last_list=[];
% for i=1:iteration
%     %error=mod(y-(V*A));
%     %alpha
%     for j=1:m*n
%         gradiant=sum(gradient_decent_v(alpha(1),y,V,A,j));
%         V(j)=V(j)-multiplication_factor*gradiant;
%         
%         
%         %V(j)=(1-gradiant)*V(j);
%         %V(j)=gradiant*V(j);
%         
%         
%         %V(j)=(1-alpha)*V(j);
%         %V(j)=alpha*V(j);
%         
%         
%     end
%     %make the negative value 0
% %     V(V<0)=0;
% %     V(V>1)=1;
% 
%   V=abs(V);
% %  V(V>1)=1;
%     
%     
%     A=(inv(V'*V))*V'*y;
% %     A(A<0)=0;
% %     A(A>1)=1;
% 
%  A=abs(A);
% %  A(A>1)=1;
%     last_list=[last_list,abs(sum(sum(abs(y-V*A))))];
%     
%     
%     
% end
% figure();title('plot for best alpha');
% plot(1:iteration,last_list);

[V,A]=nnmf(y,r);


%%

%ploting V
figure();title('2d plot of basis matrix')
%mesh(V);
plot(V)
figure();title('3d plot of basis matrix')
surf(V);
colormap(jet)

%ploting a
figure();title('2d plot of coeffient matrix')
%mesh(A);
plot(A)
figure();title('3d plot of coeffient matrix')
surf(A);
colormap(jet)





%%



%%


%%

%testing

%%

%for single speaker
% y_test=[];
% speakers=[4];
% data_taken_from_no_speakers=size(taken_files,2);
% 
% %if eah vector is very large then the time taken by the system become more
% %so we need to compress the data 
% % compressing_factor=10000;
% 
% %for i=1:data_taken_from_no_speakers
%   for i=1:1  
%     for j=1:8
%         %serial_no_data=(taken_files(i))+j;
%         sprintf('s%d%d.wave',speakers(i),j)
%         new_data=audioread(sprintf('s%d%d.wav',speakers(i),j));
%         
%         %compressing the data
%         data=resample(new_data,1,compressing_factor);
%         
%         
%         %writing the vector in our input matrix y
%         y_test=[y_test,data];
%         
%     end
%     
%     
% end
% 
% 
% 
% %%
% 
% %creating the overlapping
% 
% length_for_overlapping=size(y_test,1)*0.5;
% length_vector=size(y_test,1);
% no_of_vector=size(y_test,2);
% 
% %run the sequence
% for i=1:no_of_vector-1
%     %i
%     y_test(1:length_for_overlapping,i+1)=y_test(length_for_overlapping+1:length_vector,i);
% end
% % y_test=[y_test,y_test];
% % y_test=[y_test,y_test(:,1:14)];
% 
% 
% 
% 
% 
% %%
% 
% %we have V
% %just calculate A for y_test
% 
% A_test=(inv(V'*V))*V'*y_test;
%     A_test(A_test<0)=0;
%     A_test(A_test>1)=1;
% 
% %%
% %ploting a
% figure();
% plot(A_test);
% figure();
% surf(A_test);
% colormap(jet)
% figure();
% quiver(A_test,zeros(size(A_test)))


%%

%%

%diterming the non zero element

% sprintf('non zero in A_train====    %d',no_of_non_zero(A));
% 
% sprintf('non zero in A_test====    %d',no_of_non_zero(A_test));

% disp('non zero in A_train===');no_of_non_zero(A)
%disp('non zero in A_test===');no_of_non_zero(A_test)
figure();title('different visulisation')
matrix_for_visulisation=differently_visualisation(A,data_splitting);


% chckig for non zero valuses
figure();
matrix_for_non_zero_values=no_of_non_zero( A,data_splitting );
title('matrix_for_non_zero_values')


figure();
c1=no_of_non_zero_in_columns( A,data_splitting );
title('matrix_for_non_zero_values in each and every column')


figure();
c2=no_of_below_mean_in_columns( A,data_splitting );
title('matrix_for_calculating below a mean _values in each and every column')


prescision_factor=5;
list_of_threshold=(10^(-prescision_factor))*[1,2,3,4,5,6,7,8,9];
[a,iteration_plot]=size(list_of_threshold);

% for i=1:iteration_plot
%    figure();title('matrix_for_calculating below a threshold_ ')
% c2=no_of_below_threshold_in_columns( A,data_splitting,list_of_threshold(i) ); 
%     
% end


for i=1:iteration_plot
   figure();
c2=no_of_zero_in_columns( A,data_splitting,list_of_threshold(i) ); 
title(sprintf('matrix_for_calculating no of element below==%d_ ',list_of_threshold(i)));
    
end
pause;
end

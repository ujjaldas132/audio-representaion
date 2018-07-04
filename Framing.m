function [ShortFrame] = Framing(x,fs,lframe,over_lap)
no_of_samples=floor(lframe*10^-3*fs);         

no_samples_shift = floor(over_lap*10^-3*fs)  

no_frame = 1+ floor((length(x)-no_of_samples)/no_samples_shift)     %% no_frame is total number of frames
ShortFrame=ones(no_frame,no_of_samples)
m=1;
for ii=0:no_frame-1
    frame=x(floor(ii*no_samples_shift)+1:floor(ii*no_samples_shift)+no_of_samples);%collecting a speech frame
    %frame=hamming(no_of_samples).*frame; 
    
    ShortFrame(:,m) = frame;
    m=m+1;
  
end

end

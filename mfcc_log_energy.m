function [ mfcc] = mfcc_log_energy( speech,fs )




% []=wavread('NDTV_3_12_2015_0.wav');


%resampling
%do if require
speech=resample(speech,8000,fs);


% Parameters to compute MFCC 
framesize_ms=20;                            % framesize in millisecond
frameshift_ms=10;                           % frameshift in millisecond  
framesize=floor(framesize_ms*fs/1000);      % no of samples in a frame
frameshift=floor(frameshift_ms*fs/1000);    % no of samples in overlap 
     w='t';                                 % triangular shaped filters in mel domain
     nc=13;                                 % nc  number of cepstral coefficients excluding 0'th coefficient (default 12)
     p=26;                                  % p   number of filters in filterbank (default: floor(3*log(fs)) = approx 2.1 per ocatave)
     fl = 0;                                % fl  low end of the lowest filter as a fraction of fs (default = 0)
     fh = 0.5;                              % fh  high end of highest filter as a fraction of fs (default = 0.5)
       


% [mfcc,z]=melcepst(speech,fs,w,nc,p,framesize,frameshift,fl,fh)
mfcc=melcepst(speech,fs,w,nc,p,framesize,frameshift,fl,fh);
% figure;
% plot(mfcc)





end


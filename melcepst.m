 function [c]=melcepst(s,fs,w,nc,p,n,inc,fl,fh)
 
0002 %MELCEPST Calculate the mel cepstrum of a signal C=(S,FS,W,NC,P,N,INC,FL,FH)
0003 %
0004 %
0005 % Simple use: c=melcepst(s,fs)    % calculate mel cepstrum with 12 coefs, 256 sample frames
0006 %                  c=melcepst(s,fs,'e0dD') % include log energy, 0th cepstral coef, delta and delta-delta coefs
0007 %
0008 % Inputs:
0009 %     s     speech signal
0010 %     fs  sample rate in Hz (default 11025)
0011 %     nc  number of cepstral coefficients excluding 0'th coefficient (default 12)
0012 %     n   length of frame in samples (default power of 2 < (0.03*fs))
0013 %     p   number of filters in filterbank (default: floor(3*log(fs)) = approx 2.1 per ocatave)
0014 %     inc frame increment (default n/2)
0015 %     fl  low end of the lowest filter as a fraction of fs (default = 0)
0016 %     fh  high end of highest filter as a fraction of fs (default = 0.5)
0017 %
0018 %        w   any sensible combination of the following:
0019 %
0020 %                'R'  rectangular window in time domain
0021 %                'N'    Hanning window in time domain
0022 %                'M'    Hamming window in time domain (default)
0023 %
0024 %              't'  triangular shaped filters in mel domain (default)
0025 %              'n'  hanning shaped filters in mel domain
0026 %              'm'  hamming shaped filters in mel domain
0027 %
0028 %                'p'    filters act in the power domain
0029 %                'a'    filters act in the absolute magnitude domain (default)
0030 %
0031 %               '0'  include 0'th order cepstral coefficient
0032 %                'E'  include log energy
0033 %                'd'    include delta coefficients (dc/dt)
0034 %                'D'    include delta-delta coefficients (d^2c/dt^2)
0035 %
0036 %              'z'  highest and lowest filters taper down to zero (default)
0037 %              'y'  lowest filter remains at 1 down to 0 frequency and
0038 %                     highest filter remains at 1 up to nyquist freqency
0039 %
0040 %               If 'ty' or 'ny' is specified, the total power in the fft is preserved.
0041 %
0042 % Outputs:    c     mel cepstrum output: one frame per row. Log energy, if requested, is the
0043 %                 first element of each row followed by the delta and then the delta-delta
0044 %                 coefficients.
0045 %
0046 
0047 % BUGS: (1) should have power limit as 1e-16 rather than 1e-6 (or possibly a better way of choosing this)
0048 %           and put into VOICEBOX
0049 %       (2) get rdct to change the data length (properly) instead of doing it explicitly (wrongly)
0050 
0051 %      Copyright (C) Mike Brookes 1997
0052 %      Version: $Id: melcepst.m 1683 2012-03-22 12:55:45Z dmb $
0053 %
0054 %   VOICEBOX is a MATLAB toolbox for speech processing.
0055 %   Home page: http://www.ee.ic.ac.uk/hp/staff/dmb/voicebox/voicebox.html
0056 %
0057 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
0058 %   This program is free software; you can redistribute it and/or modify
0059 %   it under the terms of the GNU General Public License as published by
0060 %   the Free Software Foundation; either version 2 of the License, or
0061 %   (at your option) any later version.
0062 %
0063 %   This program is distributed in the hope that it will be useful,
0064 %   but WITHOUT ANY WARRANTY; without even the implied warranty of
0065 %   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
0066 %   GNU General Public License for more details.
0067 %
 %   You can obtain a copy of the GNU General Public License from
 %   http://www.gnu.org/copyleft/gpl.html or by writing to
 %   Free Software Foundation, Inc.,675 Mass Ave, Cambridge, MA 02139, USA.
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
 if nargin<2 fs=11025; end
 if nargin<3 w='M'; end
 if nargin<4 nc=12; end
 if nargin<5 p=floor(3*log(fs)); end
 if nargin<6 n=pow2(floor(log2(0.03*fs))); end
 if nargin<9
    fh=0.5;   
    if nargin<8
      fl=0;
      if nargin<7
         inc=floor(n/2);
      end
   end
 end
 
 if isempty(w)
    w='M';
 end
 if any(w=='R')
    z=enframe(s,n,inc);
 elseif any (w=='N')
    z=enframe(s,hanning(n),inc);
 else
    z=enframe(s,hamming(n),inc);
 end
 zz=z
 f=rfft(z.');
 [m,a,b]=melbankm(p,n,fs,fl,fh,w);
 pw=f(a:b,:).*conj(f(a:b,:));
 pth=max(pw(:))*1E-20;
 if any(w=='p')
    y=log(max(m*pw,pth));
 else
    ath=sqrt(pth);
    y=log(max(m*abs(f(a:b,:)),ath));
 end
 c=rdct(y).';
 nf=size(c,1);
 nc=nc+1;
 if p>nc
    c(:,nc+1:end)=[];
 elseif p<nc
    c=[c zeros(nf,nc-p)];
 end
 if ~any(w=='0')
    c(:,1)=[];
    nc=nc-1;
 end
 if any(w=='E')
    c=[log(sum(pw)).' c];
    nc=nc+1;
 end
 
 % calculate derivative
 
 if any(w=='D')
   vf=(4:-1:-4)/60;
   af=(1:-1:-1)/2;
   ww=ones(5,1);
   cx=[c(ww,:); c; c(nf*ww,:)];
   vx=reshape(filter(vf,1,cx(:)),nf+10,nc);
   vx(1:8,:)=[];
   ax=reshape(filter(af,1,vx(:)),nf+2,nc);
   ax(1:2,:)=[];
   vx([1 nf+2],:)=[];
   if any(w=='d')
      c=[c vx ax];
   else
      c=[c ax];
   end
 elseif any(w=='d')
   vf=(4:-1:-4)/60;
   ww=ones(4,1);
   cx=[c(ww,:); c; c(nf*ww,:)];
   vx=reshape(filter(vf,1,cx(:)),nf+8,nc);
   vx(1:8,:)=[];
   c=[c vx];
 end
  
 if nargout<1
    [nf,nc]=size(c);
    t=((0:nf-1)*inc+(n-1)/2)/fs;
    ci=(1:nc)-any(w=='0')-any(w=='E');
    imh = imagesc(t,ci,c.');
    axis('xy');
    xlabel('Time (s)');
    ylabel('Mel-cepstrum coefficient');
     map = (0:63)'/63;
     colormap([map map map]);
     colorbar;
 end


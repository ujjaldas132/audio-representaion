 function [f,t,w]=enframe(x,win,inc,m)
0002 %ENFRAME split signal up into (overlapping) frames: one per row. [F,T]=(X,WIN,INC)
0003 %
0004 % Usage:  (1) f=enframe(x,n)     % split into frames of length n
0005 %
0006 %         (2) f=enframe(x,hamming(n,'periodic'),n/4)     % use a 75% overlapped Hamming window of length n
0007 %
0008 %  Inputs:   x    input signal
0009 %          win    window or window length in samples
0010 %          inc    frame increment in samples
0011 %            m    mode input:
0012 %                  'z'  zero pad to fill up final frame
0013 %                  'r'  reflect last few samples for final frame
0014 %                  'A'  calculate window times as the centre of mass
0015 %                  'E'  calculate window times as the centre of energy
0016 %
0017 % Outputs:   f    enframed data - one frame per row
0018 %            t    fractional time in samples at the centre of each frame
0019 %            w    window function used
0020 %
0021 % By default, the number of frames will be rounded down to the nearest
0022 % integer and the last few samples of x() will be ignored unless its length
0023 % is lw more than a multiple of inc. If the 'z' or 'r' options are given,
0024 % the number of frame will instead be rounded up and no samples will be ignored.
0025 %
0026 % Example of frame-based processing:
0027 %          INC=20                               % set frame increment in samples
0028 %          NW=INC*2                             % oversample by a factor of 2 (4 is also often used)
0029 %          S=cos((0:NW*7)*6*pi/NW);                % example input signal
0030 %          W=sqrt(hamming(NW),'periodic'));      % sqrt hamming window of period NW
0031 %          F=enframe(S,W,INC);                   % split into frames
0032 %          ... process frames ...
0033 %          X=overlapadd(F,W,INC);               % reconstitute the time waveform (omit "X=" to plot waveform)
0034 
0035 % Bugs/Suggestions:
0036 %  (1) Possible additional mode options:
0037 %        'u'  modify window for first and last few frames to ensure WOLA
0038 %        'a'  normalize window to give a mean of unity after overlaps
0039 %        'e'  normalize window to give an energy of unity after overlaps
0040 %        'wm' use Hamming window
0041 %        'wn' use Hanning window
0042 %        'x'  include all frames that include any of the x samples
0043 
0044 %       Copyright (C) Mike Brookes 1997-2012
0045 %      Version: $Id: enframe.m 1713 2012-03-30 21:27:46Z dmb $
0046 %
0047 %   VOICEBOX is a MATLAB toolbox for speech processing.
0048 %   Home page: http://www.ee.ic.ac.uk/hp/staff/dmb/voicebox/voicebox.html
0049 %
0050 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
0051 %   This program is free software; you can redistribute it and/or modify
0052 %   it under the terms of the GNU General Public License as published by
0053 %   the Free Software Foundation; either version 2 of the License, or
0054 %   (at your option) any later version.
0055 %
0056 %   This program is distributed in the hope that it will be useful,
0057 %   but WITHOUT ANY WARRANTY; without even the implied warranty of
0058 %   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
0059 %   GNU General Public License for more details.
0060 %
0061 %   You can obtain a copy of the GNU General Public License from
0062 %   http://www.gnu.org/copyleft/gpl.html or by writing to
0063 %   Free Software Foundation, Inc.,675 Mass Ave, Cambridge, MA 02139, USA.
0064 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 nx=length(x(:));
 if nargin<2 || isempty(win)
     win=nx;
 end
 if nargin<4 || isempty(m)
     m='';
 end
 nwin=length(win);
 if nwin == 1
     lw = win;
     w = ones(1,lw);
 else
     lw = nwin;
     w = win(:)';
 end
 if (nargin < 3) || isempty(inc)
     inc = lw;
 end
 nli=nx-lw+inc;        %nx=202, lw= 20; inc=10; ie, nli=192
 nf = fix((nli)/inc);   %nf=fix(192/10)=19
 na=nli-inc*nf;         % na=192-10*19=2
 f=zeros(nf,lw);        % f=19X20 matrix of zero
 indf= inc*(0:(nf-1)).'; % indf = [0 10 20 30 40 50 60 70 80 90 100 110 ...... 180]
 inds = (1:lw);            % inds = [1 2 3 4 ... 20]
 f(:) = x(indf(:,ones(1,lw))+inds(ones(nf,1),:));
 if nargin>3 && (any(m=='z') || any(m=='r')) && na>0
     if any(m=='r')
         ix=1+mod(nx-na:nx-na+lw-1,2*nx);
        f(nf+1,:)=x(ix+(ix>nx).*(2*nx+1-2*ix));
     else
         f(nf+1,1:na)=x(1+nx-na:nx);
     end
     nf=size(f,1);
 end
 if (nwin > 1)   % if we have a non-unity window
     f = f .* w(ones(nf,1),:);
 end
 if nargout>1
     if any(m=='E')
         t0=sum((1:lw).*w.^2)/sum(w.^2);
     elseif any(m=='E')
         t0=sum((1:lw).*w)/sum(w);
     else
         t0=(1+lw)/2;
     end
     t=t0+inc*(0:(nf-1)).';
   
 end
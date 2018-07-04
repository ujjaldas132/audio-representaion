function y=rfft(x,n,d)
0002 %RFFT     Calculate the DFT of real data Y=(X,N,D)
0003 % Data is truncated/padded to length N if specified.
0004 %   N even:    (N+2)/2 points are returned with
0005 %             the first and last being real
0006 %   N odd:    (N+1)/2 points are returned with the
0007 %             first being real
0008 % In all cases fix(1+N/2) points are returned
0009 % D is the dimension along which to do the DFT
0010 
0011 
0012 
0013 %      Copyright (C) Mike Brookes 1998
0014 %      Version: $Id: rfft.m 713 2011-10-16 14:45:43Z dmb $
0015 %
0016 %   VOICEBOX is a MATLAB toolbox for speech processing.
0017 %   Home page: http://www.ee.ic.ac.uk/hp/staff/dmb/voicebox/voicebox.html
0018 %
0019 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
0020 %   This program is free software; you can redistribute it and/or modify
0021 %   it under the terms of the GNU General Public License as published by
0022 %   the Free Software Foundation; either version 2 of the License, or
0023 %   (at your option) any later version.
0024 %
0025 %   This program is distributed in the hope that it will be useful,
0026 %   but WITHOUT ANY WARRANTY; without even the implied warranty of
0027 %   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
0028 %   GNU General Public License for more details.
0029 %
0030 %   You can obtain a copy of the GNU General Public License from
0031 %   http://www.gnu.org/copyleft/gpl.html or by writing to
0032 %   Free Software Foundation, Inc.,675 Mass Ave, Cambridge, MA 02139, USA.
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
 s=size(x);
 if prod(s)==1
     y=x;
 else
     if nargin <3 || isempty(d)
         d=find(s>1,1);
         if nargin<2
             n=s(d);
         end
     end
     if isempty(n) 
         n=s(d);
     end
    
     y=fft(x,n,d);
    
     y=reshape(y,prod(s(1:d-1)),n,prod(s(d+1:end))); 
     s(d)=1+fix(n/2);
     y(:,s(d)+1:end,:)=[];
     y=reshape(y,s);
 end
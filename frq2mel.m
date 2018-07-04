function [mel,mr] = frq2mel(frq)
0002 %FRQ2ERB  Convert Hertz to Mel frequency scale MEL=(FRQ)
0003 %    [mel,mr] = frq2mel(frq) converts a vector of frequencies (in Hz)
0004 %    to the corresponding values on the Mel scale which corresponds
0005 %    to the perceived pitch of a tone.
0006 %   mr gives the corresponding gradients in Hz/mel.
0007 
0008 %    The relationship between mel and frq is given by [1]:
0009 %
0010 %    m = ln(1 + f/700) * 1000 / ln(1+1000/700)
0011 %
0012 %      This means that m(1000) = 1000
0013 %
0014 %    References:
0015 %
0016 %     [1] J. Makhoul and L. Cosell. "Lpcw: An lpc vocoder with
0017 %         linear predictive spectral warping", In Proc IEEE Intl
0018 %         Conf Acoustics, Speech and Signal Processing, volume 1,
0019 %         pages 466–469, 1976. doi: 10.1109/ICASSP.1976.1170013.
0020 %      [2] S. S. Stevens & J. Volkman "The relation of pitch to
0021 %          frequency", American J of Psychology, V 53, p329 1940
0022 %      [3] C. G. M. Fant, "Acoustic description & classification
0023 %          of phonetic units", Ericsson Tchnics, No 1 1959
0024 %          (reprinted in "Speech Sounds & Features", MIT Press 1973)
0025 %      [4] S. B. Davis & P. Mermelstein, "Comparison of parametric
0026 %          representations for monosyllabic word recognition in
0027 %          continuously spoken sentences", IEEE ASSP, V 28,
0028 %          pp 357-366 Aug 1980
0029 %      [5] J. R. Deller Jr, J. G. Proakis, J. H. L. Hansen,
0030 %          "Discrete-Time Processing of Speech Signals", p380,
0031 %          Macmillan 1993
0032 
0033 %      Copyright (C) Mike Brookes 1998
0034 %      Version: $Id: frq2mel.m 1874 2012-05-25 15:41:53Z dmb $
0035 %
0036 %   VOICEBOX is a MATLAB toolbox for speech processing.
0037 %   Home page: http://www.ee.ic.ac.uk/hp/staff/dmb/voicebox/voicebox.html
0038 %
0039 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
0040 %   This program is free software; you can redistribute it and/or modify
0041 %   it under the terms of the GNU General Public License as published by
0042 %   the Free Software Foundation; either version 2 of the License, or
0043 %   (at your option) any later version.
0044 %
0045 %   This program is distributed in the hope that it will be useful,
0046 %   but WITHOUT ANY WARRANTY; without even the implied warranty of
0047 %   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
0048 %   GNU General Public License for more details.
0049 %
0050 %   You can obtain a copy of the GNU General Public License from
0051 %   http://www.gnu.org/copyleft/gpl.html or by writing to
0052 %   Free Software Foundation, Inc.,675 Mass Ave, Cambridge, MA 02139, USA.
0053 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 persistent k
 if isempty(k)
     k=1000/log(1+1000/700); %  1127.01048
 end
 af=abs(frq);
 mel = sign(frq).*log(1+af/700)*k;
 mr=(700+af)/k;
 if ~nargout
     plot(frq,mel,'-x');
     xlabel(['Frequency (' xticksi 'Hz)']);
     ylabel(['Frequency (' yticksi 'Mel)']);
 end
function WriteSonogram (fid,sng,noiseThreshold,freqRange,offset,absB)

%Copyright 2013 LabDaemons <info@labdaemons.com>

%This file is part of Mouse Song Analyzer.

%Mouse Song Analyzer is free software: you can redistribute it and/or modify
%it under the terms of the GNU General Public License as published by
%the Free Software Foundation, either version 3 of the License, or
%(at your option) any later version.

%Mouse Song Analyzer is distributed in the hope that it will be useful,
%but WITHOUT ANY WARRANTY; without even the implied warranty of
%MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%GNU General Public License for more details.

%You should have received a copy of the GNU General Public License
%along with Mouse Song Analyzer.  If not, see <http://www.gnu.org/licenses/>.

if (nargin < 6)
    absB = abs(sng);
end
index = find(absB >= noiseThreshold);
[row,col] = ind2sub(size(sng),index);
index2 = find(row >= freqRange(1) & row <= freqRange(2));
fwrite(fid,length(index2),'int32');
fwrite(fid,col(index2)+offset,'int32');
fwrite(fid,row(index2),'int16');
index = index(index2);
sng=full(sng);
fwrite(fid,real(sng(index)),'float64');
fwrite(fid,imag(sng(index)),'float64');
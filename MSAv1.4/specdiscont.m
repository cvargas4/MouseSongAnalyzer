function [dch,sdsng] = specdiscont(sng)

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

offset = -3:3;
moff = max(abs(offset));
frange = 1+moff:size(sng,1)-moff;
pow = sum(sng)';
[i,j,s] = find(sng);
nsng = sparse(i,j,s./pow(j),size(sng,1),size(sng,2));
sdsng = zeros(length(offset),size(sng,2)-1);
for i = 1:length(offset)
  dsng = nsng(frange,2:end) - nsng(frange+offset(i),1:end-1);
  sdsng(i,:) = sum(abs(dsng));
end
dch = [min(sdsng),2];
zindx = pow == 0;
dch(zindx) = 2;
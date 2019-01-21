function whis = whissnip(sng,header,twhis)

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

T = header.nscans/header.scanrate;
twhisc = round(twhis * ((size(sng,2))-1)/T + 1);
nwhis = size(twhis,2);
whis = cell(1,nwhis);
for i = 1:nwhis
  whis{i} = sng(:,twhisc(1,i):twhisc(2,i));
end
function filePosition = WriteHeaderGUI(fid,h)

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

magicNum = 992732356;
fwrite(fid,magicNum,'int32');
filePosition.magicNum=ftell(fid);
headersize = 0;
fwrite(fid,headersize,'uint32');
filePosition.headersize=ftell(fid);
type = 0;
type = bitset(type,4);
fwrite(fid,type,'int32');
filePosition.nscans=ftell(fid);
fwrite(fid,h.nscans,'uint32');
filePosition.scanrate=ftell(fid);
fwrite(fid,h.scanrate, 'float32');
filePosition.nfreq=ftell(fid);
fwrite(fid,h.nfreq,'int32');
filePosition.columnTotal=ftell(fid);
fwrite(fid,h.columnTotal, 'float32');
filePosition.threshold=ftell(fid);
fwrite(fid,h.threshold,'float32');
filePosition.tacq=ftell(fid);
fwrite(fid,h.tacq,'int32');
filePosition.freqMin=ftell(fid);
fwrite(fid,h.freqMin,'int32');
filePosition.freqMax=ftell(fid);
fwrite(fid,h.freqMax,'int32');
fcur = ftell(fid);
fseek(fid,4,-1);
fwrite(fid,fcur,'uint32');
fseek(fid,fcur,-1);
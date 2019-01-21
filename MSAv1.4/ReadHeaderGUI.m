function [header,headersize] = ReadHeaderGUI(file)

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

fid = file;
magicNum = fread(fid,1,'int32');
if (magicNum == 992732356)
  headersize = fread(fid,1,'uint32');
  header.headersize = headersize;
  type = fread(fid,1,'int32');
  if (bitget(type,4))
    header.nscans = fread(fid,1,'uint32');
    header.scanrate = fread(fid,1,'float32');
    header.nfreq = fread(fid,1,'int32');
    header.columnTotal = fread(fid,1,'float32');
    header.threshold = fread(fid,1,'float32');
    header.tacq = fread(fid,1,'int32');
    header.freqMin = fread(fid,1,'int32');
    header.freqMax = fread(fid,1,'int32');
  end
  fseek(fid,headersize,-1);
  header.flag = 'WU1';
elseif (magicNum == -991679685)
  error(['File has non-native endian status.  Call FOPEN with the reverse' ...
      ' byte order (see FOPEN help)']);
end
if (ischar(file))
  status = fclose(fid);
  if (status < 0)
    error('File did not close');
  end
end


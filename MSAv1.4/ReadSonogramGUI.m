 function [sng,header] = ReadSonogramGUI(file)

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

  [fid] = fopen(file,'r','l');
  [header,headersize] = ReadHeaderGUI(fid);
  fseek(fid,headersize,-1);
    length = fread(fid,1,'int32');
    col = fread(fid,length,'int32');
    colAccum{1} = col;
    row = fread(fid,length,'int16');
    rowAccum{1} = row;
    realB = fread(fid,length,'float64');
    realAccum{1} = realB;
    imagB = fread(fid,length,'float64'); 
    imagAccum{1} = imagB;
  colAccum = cat(1,colAccum{:});
  rowAccum = cat(1,rowAccum{:});
  realAccum = cat(1,realAccum{:});
  imagAccum = cat(1,imagAccum{:});
  Belements = realAccum + imagAccum*1i;
  sngMat = [rowAccum, colAccum, Belements];
  sng=spconvert(sngMat);
  if (ischar(file))
    status = fclose(fid);
    if (status < 0)
      error('File did not close');
    end
  end
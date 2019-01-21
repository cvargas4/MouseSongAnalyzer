function [sng] = sound2sngGUI(infilename,header,sound,sngparms)

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

[~,name] = fileparts(infilename);
outfilename = [name '.sng'];

[fidSng,message] = fopen(outfilename,'w');
    if (fidSng == -1)
        error(message);
    end
  columnOffset = 0;
  freqRange = [1 header.nfreq];
  WriteHeaderGUI(fidSng,header);
  fprintf('\n');
  [sng,~,~]=sparsesng(sound,header.scanrate,header.nfreq,header.threshold,sngparms);
  WriteSonogram(fidSng,sng,header.threshold,freqRange,columnOffset);
  fprintf('\n');
  status = fclose(fidSng); 

  if (status < 0)
    error('Sng file did not close');
  end
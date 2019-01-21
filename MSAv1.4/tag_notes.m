function [noteMat2] = tag_notes(jumpMat, traceMat, noteMat)

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

totalnotes = 0;
for m = 1 : size(traceMat,1)
    refpointsx = jumpMat{m};
    if isempty(refpointsx)
        notenumber = 1;
    else
        notenumber = length(refpointsx)+1;
    end
    totalnotes = totalnotes + notenumber;
end
noteMat2 = cell(2,totalnotes);
noteindex = 1;
for whisnum = 1 : size(traceMat,1)
    pitch=traceMat{whisnum};
    refpointsx =jumpMat{whisnum};
    if isempty(refpointsx) == 0
        for notenum = 1 : length(refpointsx)+1
            if notenum > 1
                noteindex1 = refpointsx(notenum-1)+1;
            else
                noteindex1 = 1;
            end
            if notenum == length(refpointsx) + 1
                noteindex2 = length(pitch);
            else
                noteindex2 = refpointsx(notenum)-1;
            end
            if noteindex2 > length(pitch)
                noteindex2 = length(pitch);
            end
            notetype1 = noteMat{whisnum,2};
            notetype2 = num2str(notenum);
            notelabel = cat(2,notetype1, notetype2);
            notesamples = noteindex1:noteindex2;
            notepitch = pitch(notesamples);
            noteMat2{1,noteindex} = notelabel;
            noteMat2{2,noteindex} = notepitch;
            noteMat2{3,noteindex} = whisnum;
            noteindex = noteindex + 1;
        end
    else
        notelabel = noteMat{whisnum,2};
        notepitch = pitch;
        noteMat2{1,noteindex} = notelabel;
        noteMat2{2,noteindex} = notepitch;
        noteMat2{3,noteindex} = whisnum;
        noteindex = noteindex + 1;
    end
end
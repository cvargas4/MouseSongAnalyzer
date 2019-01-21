function [notepitch] = find_note(pitch, refpointsx, notenum)

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

if isempty(refpointsx) == 0 
    noteindex1 = 1;
    noteindex2 = refpointsx(notenum);
    if noteindex2 > length(pitch)
        noteindex2 = length(pitch);
    end
    notesamples = noteindex1:noteindex2;
    notepitch = pitch(notesamples); 
else
    notepitch = pitch;
end
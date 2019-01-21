function plot_notes(pitch, refpointsx, notenum, handles)

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
    notesamples = noteindex1:noteindex2;
    notepitch = pitch(notesamples);  
else
    notepitch = pitch;
end
if length(notepitch) > 1
    xend = length(notepitch);
else
    xend = 1;
end

set(gcf,'CurrentAxes',handles.sngaxes2)
plot(notepitch, '-wo', ...
    'MarkerEdgeColor', 'r', ...
    'MarkerFaceColor', 'r')
ylim([0 125000])
xlim([0 xend])
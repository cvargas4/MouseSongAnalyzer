function [syl] = breakup_s(syl,num,pitch,harm)

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

pitch_der = diff(pitch);
total_diff = sum(pitch_der);
minp = min(pitch);
maxp = max(pitch);
if isempty(pitch) == 0
    start = pitch(1);
    final = pitch(end);
    if length(pitch) < 15
        syl{num} = 'shrt';
    elseif harm == 1
        syl{num} = 'harm';
    elseif (maxp - minp) < 3000
        syl{num} = 'flat';
    elseif (maxp - start) > 12500 && (maxp - final) > 6250
        syl{num} = 'chev';
    elseif (final - start) > 6250 && (maxp - minp) > 12500 && total_diff > 0
        syl{num} = 'up';
    elseif (start - final) > 6250 && (maxp - minp) > 12500 && total_diff < 0
        syl{num} = 'down';
    else
        syl{num} = 's';
    end
else
    syl{num} = 'unclassified';
end
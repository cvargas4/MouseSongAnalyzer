function process_syllables(noteMat, syllTag, animalID, sessionID, min_count)

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

syllTags = noteMat(:,2);
a_index = find(strcmp(syllTag,syllTags));
xTag = 'Unclassified';
x_index = find(strcmp(xTag,syllTags));
x_count = length(x_index);
a_count = length(a_index);
a_Name = [animalID '-' sessionID '-' syllTag];
a_Name2 = [a_Name '.csv'];
a_MeanName = [a_Name '-means' '.csv'];
numCols = size(noteMat,2);
means_a = zeros(3,numCols);
if a_count > min_count
    a_Mat = cell(a_count,size(noteMat,2));
    for i = 1 : a_count
        noteNum = a_index(i);
        a_Mat(i,:) = noteMat(noteNum,:);
    end
    a_Cat = cell(1,numCols);
    for i = 2 : numCols
        a_Cat{i} = cat(1,a_Mat{:,i});
    end
    nogaps = isnan(a_Cat{4});
    a_Cat{4}(nogaps) = [];
    for i = 1 : numCols
        if isnumeric(a_Cat{i})
            means_a(1,i) = mean(a_Cat{i});
            means_a(2,i) = median(a_Cat{i});
            means_a(3,i) = std(a_Cat{i});
        end
    end
    cell2csv(a_Name2, a_Mat)
end
    means_a(:,numCols+1) = a_count;
    means_a(:,numCols+2) = length(syllTags) - x_count;
    means_a(:,numCols+3) = (a_count/(length(syllTags) - x_count))*100;
    means_a(:,1:2) = [];
    save(a_MeanName, 'means_a', '-ascii', '-tabs')
clear means_a a_Mat a_Cat a_MeanName a_Name a_Name2 means_a a_count a_Save nogaps noindex amplitudes amplitudeS noteNum nonum
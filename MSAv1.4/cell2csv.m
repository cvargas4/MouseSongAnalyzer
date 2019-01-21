function cell2csv(datName,cellArray)

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

seperator = ';';
datei = fopen(datName,'w');
for z=1:size(cellArray,1)
    for s=1:size(cellArray,2)
        var = eval('cellArray{z,s}');
        if size(var,1) == 0
            var = '';
        end
        if isnumeric(var) == 1
            var = num2str(var);
        end       
        if islogical(var) == 1
            if var == 1
                var = 'TRUE';
            else
                var = 'FALSE';
            end
        end        
        var = ['"' var '"'];
        fprintf(datei,var);        
        if s ~= size(cellArray,2)
            fprintf(datei,seperator);
        end
    end
    fprintf(datei,'\n');
end
fclose(datei);
function [ljdownindx,ljupindx] = whisjclassifyGUI(pitch,pitchnext)

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

dclust = [40 30; 125 117; 125 30; 40 30]*1000;
uclust = [30 40; 30 125; 110 125; 30 40]*1000;
ljdown = inpolygon(pitch,pitchnext,dclust(:,1),dclust(:,2));
ljup = inpolygon(pitch,pitchnext,uclust(:,1),uclust(:,2));
ljdownindx = find(ljdown);
ljupindx = find(ljup);
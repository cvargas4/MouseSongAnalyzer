function whistimesplotGUI(sng,header,twhis,handles)

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

  f = linspace(0,125000,header.nfreq);
  t = linspace(0,header.nscans/header.scanrate,size(sng,2));
  xlim = [min(t) max(t)];
  ylim = [min(f) max(f)];
  [i,j,s] = find(sng);
  spm = sparse(i,j,log(abs(s)/0.1),size(sng,1),size(sng,2));
  set(handles.sng_axes, 'NextPlot', 'replacechildren', 'UserData', ...
              struct('m',spm,'xlim',xlim,'ylim',ylim,'climrank',0.9));
  colormap(jet(128));
  axis xy;
  setspimg(handles.sng_axes, 'XLim', xlim, 'YLim', ylim);
  sz = size(twhis);
  if (sz(2) == 2 && sz(1) > 2)
    twhis = twhis';
  end
  ylim2 = [0 2];
  plot(handles.twhis_axes,twhis, ones(size(twhis)), 'r');
  set(handles.twhis_axes,'XLim',xlim, 'YLim',ylim2)
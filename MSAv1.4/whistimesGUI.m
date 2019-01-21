function [twhiso,meanfreq,outdata] = whistimesGUI(sng,header,options)

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

  t = linspace(0,header.nscans/header.scanrate,size(sng,2));
  dt = t(end)/size(sng,2);
  filterduration = 1;
  if isfield(options,'filterduration')
    filterduration = round(options.filterduration/dt);
  end
  durationthresh = round(options.durationthresh/dt);
  df = header.scanrate/2/header.nfreq;
  sng = abs(sng);
  [i,j,s] = find(sng);
  pow = sng.^2;
  if (isfield(options,'log') && options.log)
    pow = sparse(i,j,log(s/header.threshold),size(sng,1),size(sng,2));
  end
  totPower = sum(pow);
  [maxPower] = max(pow);
  nzindex = find(totPower);
  specpurity = zeros(size(t));
  specpurity(nzindex) = maxPower(nzindex)./totPower(nzindex);
  if isfield(options,'meanfreqthresh')
    spfreq = sparse(i,j,i,size(sng,1),size(sng,2));
    meanfreq = sum(spfreq.*pow)*df;
    meanfreq(nzindex) = meanfreq(nzindex)./totPower(nzindex);
  end
  if isfield(options,'specdiscthresh')
    sd = specdiscont(pow);
  end
  if (isfield(options,'filterduration'))
    specpurity = medfilt1(specpurity,filterduration);
    if isfield(options,'meanfreqthresh')
      meanfreq = medfilt1(full(meanfreq),filterduration);                                                                                                                                                                                                                     
    end
    if isfield(options,'specdiscthresh')
      sd = medfilt1(sd,filterduration);
    end
  end
  badindx = specpurity < options.puritythresh;
  if isfield(options,'meanfreqthresh')
    badindx(end+1,:) = meanfreq < options.meanfreqthresh;
  end
  if isfield(options,'specdiscthresh')
    badindx(end+1,:) = sd > options.specdiscthresh;
  end
  badindx = find(max(badindx));
  longindx = find(diff(badindx) > durationthresh);
  twhis = [t(badindx(longindx)); t(badindx(longindx+1))];
  if isfield(options,'mergeclose')
    dt = twhis(1,2:end)-twhis(2,1:end-1);
    closei = find(dt <  options.mergeclose);
    for i = length(closei):-1:1
      twhis(2,closei(i)) = twhis(2,closei(i)+1);
      twhis(:,closei(i)+1) = [];
    end
  end
  featurevecs(1).name = 'purity';
  featurevecs(1).value = specpurity;
  featurevecs(1).thresh = options.puritythresh;
  if isfield(options,'meanfreqthresh')
    featurevecs(end+1).name = 'meanfreq';
    featurevecs(end).value = meanfreq;
    featurevecs(end).thresh = options.meanfreqthresh;
  end
  if isfield(options,'specdiscthresh')
    featurevecs(end+1).name = 'specdisc';
    featurevecs(end).value = sd;
    featurevecs(end).thresh = options.specdiscthresh;
  end
  twhiso = twhis;
  outdata = featurevecs;
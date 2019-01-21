function p = whisparamsGUI(whis,header,wt,options,find_harmonics)

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

harmonicThreshold = 0.175;
nwhis = length(whis);
df = 125000/header.nfreq;
f = linspace(0,125000,header.nfreq);
findx = find(f >= options.freqrange(1) & f <= options.freqrange(2));
p.wt = wt; %start and end of syllable in absolute time
p.dt = diff(wt);
p.gap = wt(1,2:end)-wt(2,1:end-1);
p.gap(end+1) = NaN;
for i = 1:nwhis
    curwhis = whis{i};
    
    if find_harmonics == 1;
        cepstrum = ifft(log(abs(fft(full(curwhis)))));
        cepstrum(63:size(cepstrum,1),:) = 0;
        cepstrum(1:30,:) = 0;
        [cepmax,cepmaxi] = max(abs(cepstrum));
        maxcep = max(cepmax);
        if maxcep > harmonicThreshold
            p.harmonic{i} = 1;
        else
            p.harmonic{i} = 0;
        end
        
    else
        p.harmonic{i} = 0;
    end
    
    junkindx = setdiff(1:header.nfreq,findx);
    curwhis(junkindx,:) = 0;
    pow = abs(curwhis).^2;
    totPower = sum(pow);
    p.pow(i) = full(sum(totPower));
    nzindex = find(totPower);
    [maxp,maxpi] = max(pow);
    [~,y,~] = find(maxp);
    peakfreq = maxpi(y)*df;
    pfpow = full(maxp(y));
    spow = full(totPower(y));
    pforig = peakfreq;
    if isfield(options,'medfilter')
        if (options.medfilter < 3)
            options.medfilter = 3;
        end
        if (~mod(options.medfilter,2))
            options.medfilter = options.medfilter+1;
        end
        peakfreq = medfilt1(peakfreq,options.medfilter);
    end
    if isfield(options,'discardends')
        endsz = options.discardends;
        peakfreq = peakfreq(1+endsz:end-endsz);
        pfpow = pfpow(1+endsz:end-endsz);
        spow = spow(1+endsz:end-endsz);
        pforig = pforig(1+endsz:end-endsz);
    end
    
    if length(peakfreq) > 1
        if abs(peakfreq(1) - peakfreq(2)) >= 5000
            peakfreq = peakfreq(2:end);
        end
        if abs(peakfreq(end-1) - peakfreq(end)) >= 5000
            peakfreq = peakfreq(1:end-1);
        end
    end
    
    if find_harmonics == 1;
        for x = 1 : length(peakfreq);
            if cepmax(x) > harmonicThreshold;
                peakfreq(x) = (cepmaxi(x))*512;
            end
        end
    end
    
    amplitude = mean(totPower(nzindex));
    p.peakfreq{i} = peakfreq;
    p.pfpow{i} = pfpow;
    p.spow{i} = spow;
    p.pforig{i} = pforig;
    p.amplitude(i) = amplitude;
    [maxPower] = max(pow);
    specpurity = zeros(size(nzindex));
    specpurity(nzindex) = maxPower(nzindex)./totPower(nzindex);
    p.spectralpurity(i) = mean(specpurity);
end
p.adjf = cell(1,nwhis);
p.dadjf = cell(1,nwhis);
p.maxjump = zeros(1,nwhis)+nan;
p.thetarange = zeros(2,nwhis)+nan;
if isfield(options,'boxfilt')
    b = ones(1,options.boxfilt);
    b = b/sum(b);
    a = zeros(size(b));
    a(1) = 1;
else
    a = [1 0];
    b = [1 0];
end
for i = 1:nwhis
    freqvst = p.peakfreq{i};
    if (length(freqvst) > 1)
        p.maxjump(i) = max(abs(diff(freqvst)));
        if (length(freqvst) >= 3*length(b))
            freqvst = filtfilt(b,a,freqvst);
            p.adjf{i} = freqvst;
            p.dadjf{i} = diff(freqvst);
        end
    end
end
p.dpf = cell(1,nwhis);
p.pfs = cell(1,nwhis);
for i = 1:nwhis
    if (length(p.peakfreq{i}) > 1)
        p.dpf{i} = diff(p.peakfreq{i});
        p.pfs{i} = p.peakfreq{i}(1:end-1);
        freqvst = p.peakfreq{i} * 2;
        p.meanf(i) = mean(freqvst);
        p.varf(i) = mean((freqvst - p.meanf(i)).^2);
    end
end
p.hasdj= zeros(1,length(p.pfs));
p.hasuj = p.hasdj;
for i = 1:length(p.pfs)
    pitch=p.pfs{i}*2;
    dpitch=p.dpf{i}*2;
    pitchnext=pitch+dpitch;
    [ljdtmp,ljutmp] = whisjclassifyGUI(pitch,pitchnext);
    if ~isempty(ljdtmp)
        p.hasdj(i) = 1;
    end
    if ~isempty(ljutmp)
        p.hasuj(i) = 1;
    end
end

return;
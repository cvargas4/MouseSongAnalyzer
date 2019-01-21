function [sng,f,t] = sparsesng(y,Fs,NFFT,thresh,sngparms,options)

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

if (nargin < 6)
    options = [];
  end
  if ~isfield(options,'band')
    options.band = sngparms.freqrange/1000;
  end
  if ~isfield(options,'numoverlap')
    options.numoverlap = NFFT/2;
  end
  fromfile = 0;
  if (ischar(y))
    fromfile = 1;
  end
  if (isnumeric(y) && length(y) == 1)
    fromfile = 1;
    fseek(y,0,'bof');
  end
  tovolts = 1;
  npts = length(y);
  l2 = log2(NFFT);
  if (floor(l2) ~= l2)
    error('NFFT must be a power of 2');
  end
  if (NFFT < options.numoverlap)
    error('Cannot overlap by more than NFFT');
  end
  thewindow = hanning(NFFT)';
  nfreqs = NFFT/2+1;
  nnew = NFFT - options.numoverlap;
  f = linspace(0,Fs/2000,nfreqs);
  bandsig = find(f >= options.band(1) & f <= options.band(2));
  nblocks = floor((npts-options.numoverlap)/nnew);
  indx1 = cell(1,nblocks);
  sng1 = cell(1,nblocks);
  s = zeros(1,NFFT);
  if (fromfile)
    s(nnew+1:end) = tovolts * ReadBinaryData(fid,1,[0 options.numoverlap-1]);
  else
    s(nnew+1:end) = y(1:options.numoverlap);
  end
  for k = 1:nblocks
    s(1:options.numoverlap) = s(nnew+1:end);
    if (fromfile)
      s(options.numoverlap+1:end) = tovolts * ReadBinaryData(fid,1,[0 nnew-1]);
    else
      s(options.numoverlap+1:end) = y(options.numoverlap + ...
                                      ((k-1)*nnew+1:k*nnew));
    end
    st = fft(thewindow .* s,NFFT);
    indx = find(abs(st(bandsig)) > thresh);
    indx1{k} = bandsig(indx);
    sng1{k} = st(bandsig(indx));
  end
  lennz = zeros(1,nblocks);
  for k = 1:nblocks
    lennz(k) = length(indx1{k});
  end
  indx2 = zeros(1,sum(lennz));
  start = 1;
  for k = 1:nblocks
    indx2(start:start+lennz(k)-1) = k;
    start = start+lennz(k);
  end
  sng = sparse(cat(2,indx1{:}),indx2,cat(2,sng1{:}),nfreqs,nblocks);
  t = linspace(0,npts-options.numoverlap,nblocks)/Fs;
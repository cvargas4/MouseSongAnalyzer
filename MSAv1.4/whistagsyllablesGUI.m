function [syl, jumptime, cleanpitch] = whistagsyllablesGUI(p,min_note,split_s_status)

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

nsyl = length(p.pfs);
syl = cell(1,nsyl);
jumptime = cell(1,nsyl);
cleanpitch = cell(1,nsyl);
for j = 1:nsyl
    harm = p.harmonic{j};
    pitch=p.pfs{j}*2;
    dpitch=p.dpf{j}*2;
    pitchnext=pitch+dpitch;
    [ljdi,ljui] = whisjclassifyGUI(pitch,pitchnext);
    syltmp = [repmat('d',1,length(ljdi)),...
        repmat('u',1,length(ljui))];
    if isempty(syltmp)
        if split_s_status == 0
            syl{j} = 's';
        else
            [syl] = breakup_s(syl,j,pitch,harm);
        end
    else
        temporder = [ljdi ljui];
        [stemp,permindx] = sort(temporder);
        stemp = [stemp, length(pitch)];
        notedur = diff(stemp);
        stemp(end) = [];
        fakejumps = find(notedur<min_note);
        while isempty(fakejumps) == 0 && fakejumps(end) == length(notedur)
            fakesample1 = stemp(fakejumps(end));
            fakesample2 = length(pitch);
            nullsamples = fakesample1:fakesample2;
            pitch(nullsamples) = [];
            fakejumps(end) = [];
        end
        while isempty(fakejumps) == 0
            fakerev = fliplr(fakejumps);
            for i = 1 : length(fakerev)
                fakenotestart = fakerev(i);
                fakenoteend = fakenotestart + 1;
                fakesample1 = stemp(fakenotestart);
                fakesample2 = stemp(fakenoteend);
                nullsamples = fakesample1:fakesample2;
                if fakesample2 < length(pitch)
                    if fakesample1 == 1;
                        fakesample1 = 2;
                    end
                    pitch(nullsamples) = pitch(fakesample1-1);
                end
            end
            dpitch = [diff(pitch), 0];
            pitchnext=pitch+dpitch;
            [ljdi,ljui] = whisjclassifyGUI(pitch,pitchnext);
            syltmp = [repmat('d',1,length(ljdi)),...
                repmat('u',1,length(ljui))];
            temporder = [ljdi ljui];
            [stemp,permindx] = sort(temporder);
            notedur = diff(stemp);
            fakejumps = find(notedur<min_note);
        end
        if isempty(syltmp)
            if split_s_status == 0
                syl{j} = 's';
            else
                [syl] = breakup_s(syl,j,pitch,harm);
            end
        else
            syl{j} = syltmp(permindx);
            jumptime{j} = stemp;
        end
    end
    cleanpitch{j} = pitch;
    if min(pitch) < 37000
        syl{j} = 'noise';
    end
end
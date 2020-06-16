function varargout = showwhisGUI(varargin)

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

% Begin initialization code - DO NOT EDIT
warning('off', 'MATLAB:str2func:invalidFunctionName')
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @showwhisGUI_OpeningFcn, ...
    'gui_OutputFcn',  @showwhisGUI_OutputFcn, ...
    'gui_LayoutFcn',  [], ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

function showwhisGUI_OpeningFcn(hObject, ~, handles, varargin)
handles.output = hObject;
name = varargin{1};
sng = varargin{2};
header = varargin{3};
twhis = varargin{4};
whis = varargin{5};
meanfreq = varargin{6};
options = varargin{7};
min_note = varargin{8};
split_s_status = varargin{9};
find_harmonics = varargin{10};
buf = options.buf;
icons = swicons;
set(handles.leftbutton,'CData',icons.left);
set(handles.rightbutton,'CData',icons.right);
set(handles.leftnote,'CData',icons.left);
set(handles.rightnote,'CData',icons.right);
handles.name = name;
handles.sng = sng;
handles.header = header;
handles.twhis = twhis;
handles.meanfreq = meanfreq;
handles.buf = buf;
handles.options = options;
paramoptions.freqrange = [header.freqMin header.freqMax];
paramoptions.medfilter = 3;
paramoptions.discardends = 0;
paramoptions.boxfilt = 5;
paramoptions.skipzeros = 1;
p=whisparamsGUI(whis,header,twhis,paramoptions,find_harmonics);
[syl, jumptime, cleanpitch] = whistagsyllablesGUI(p,min_note,split_s_status);
p.syl = syl;
p.xjump = jumptime;
p.cleanpitch = cleanpitch;
if isempty(p.dt)
    return
elseif isempty(p.wt)
    return
else
    syllmat_size = size(p.dt,2);
    syllmat = cell(syllmat_size, 13);
    syll_traces = cell(syllmat_size, 1);
    for note_num = 1 : syllmat_size;
        syll_pitch = p.cleanpitch{note_num};
        if length(syll_pitch) > 1
        syll_traces{note_num} = syll_pitch;
        maxfreq = max(syll_pitch);
        minfreq = min(syll_pitch);
        meanfreq = mean(syll_pitch);
        startfreq = syll_pitch(1);
        finalfreq = syll_pitch(end);
        bandwidth = maxfreq - minfreq;
        syllmat{note_num,1} = name;

        syllmat{note_num,2} = p.syl{note_num};
 
        if length(p.syl{note_num}) > 4
            syllmat{note_num,2} = 'Unclassified';
            p.syl{note_num} = 'Unclassified';
        end
        handles.p = p;
        syllmat{note_num,3} = p.harmonic{note_num};
        syllmat{note_num,4} = p.dt(note_num);
        syllmat{note_num,5} = p.gap(note_num);
        syllmat{note_num,6} = p.varf(note_num);
        syllmat{note_num,7} = p.spectralpurity(note_num);
        syllmat{note_num,8} = p.amplitude(note_num);
        syllmat{note_num,9} = minfreq;
        syllmat{note_num,10}= meanfreq;
        syllmat{note_num,11}= maxfreq;
        syllmat{note_num,12}= startfreq;
        syllmat{note_num,13}= finalfreq;
        syllmat{note_num,14}= bandwidth;
        else
        
        
            
        syllmat{note_num,1} = name;
        syllmat{note_num,2} = 'Unclassified';
        p.syl{note_num} = 'Unclassified';

        handles.p = p;
        syllmat{note_num,3} = [];
        syllmat{note_num,4} = [];
        syllmat{note_num,5} = [];
        syllmat{note_num,6} = [];
        syllmat{note_num,7} = [];
        syllmat{note_num,8} = [];
        syllmat{note_num,9} = [];
        syllmat{note_num,10}= [];
        syllmat{note_num,11}= [];
        syllmat{note_num,12}= [];
        syllmat{note_num,13}= [];
        syllmat{note_num,14}= [];
        end
            
    end
    whisnum = 1;
    set(handles.totalwhis,'String',['/' num2str(size(twhis,2))]);
    set(handles.whisnum,'String',1);
    pitch=p.cleanpitch{whisnum};
    refpointsx = p.xjump{whisnum};
    refpointsy(1:length(refpointsx)) = 40000;
    set(handles.notenum, 'String', 1);
    set(handles.totalnote,'String',['/' num2str(size(refpointsx,2)+1)]);
    [notepitch] = find_note(pitch, refpointsx, 1);
    wsp_display(handles.sng,handles.header,handles.twhis(:,whisnum),handles.buf,notepitch,pitch,whisnum,refpointsx,refpointsy,handles);
    handles.output1 = syllmat;
    handles.output2 = p.xjump;
    handles.output3 = syll_traces;
end
guidata(hObject, handles);
function varargout = showwhisGUI_OutputFcn(~, ~, handles)
varargout{1} = handles.output1;
varargout{2} = handles.output2;
varargout{3} = handles.output3;

function whisnum_CreateFcn(hObject, ~, ~)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function leftbutton_Callback(~, ~, handles)
whisnum = str2double(get(handles.whisnum,'String'));
if (whisnum > 1)
    whisnum = whisnum-1;
    set(handles.whisnum,'String',int2str(whisnum));
end
set(gcf,'CurrentAxes',handles.freqaxes);
cla
p=handles.p;
pitch=p.cleanpitch{whisnum};
refpointsx = p.xjump{whisnum};
refpointsy(1:length(refpointsx)) = 40000;
set(handles.notenum, 'String', 1);
set(handles.totalnote,'String',['/' num2str(size(refpointsx,2)+1)]);
[notepitch] = find_note(pitch, refpointsx, 1);
wsp_display(handles.sng,handles.header,handles.twhis(:,whisnum),handles.buf,notepitch,pitch,whisnum,refpointsx,refpointsy,handles);
wsp_enable(handles,whisnum);

function rightbutton_Callback(~, ~, handles)
whisnum = str2double(get(handles.whisnum,'String'));
if (whisnum < size(handles.twhis,2))
    whisnum = whisnum+1;
    set(handles.whisnum,'String',int2str(whisnum));
end
set(gcf,'CurrentAxes',handles.freqaxes)
cla
p=handles.p;
pitch=p.cleanpitch{whisnum};
refpointsx = p.xjump{whisnum};
refpointsy(1:length(refpointsx)) = 40000;
set(handles.notenum, 'String', 1);
set(handles.totalnote,'String',['/' num2str(size(refpointsx,2)+1)]);
[notepitch] = find_note(pitch, refpointsx, 1);
wsp_display(handles.sng,handles.header,handles.twhis(:,whisnum),handles.buf,notepitch,pitch,whisnum,refpointsx,refpointsy, handles);
wsp_enable(handles,whisnum);

function whisnum_Callback(~, ~, handles)
whisnum = str2double(get(handles.whisnum,'String'));
if (whisnum < 1)
    whisnum = 1;
elseif (whisnum > size(handles.twhis,2))
    whisnum = size(handles.twhis,2);
end
set(handles.whisnum,'String',int2str(whisnum));
p=handles.p;
set(gcf,'CurrentAxes',handles.freqaxes)
cla
pitch=p.cleanpitch{whisnum};
refpointsx = p.xjump{whisnum};
refpointsy(1:length(refpointsx)) = 40000;
set(handles.notenum, 'String', 1);
set(handles.totalnote,'String',['/' num2str(size(refpointsx,2)+1)]);
[notepitch] = find_note(pitch, refpointsx, 1);
wsp_display(handles.sng,handles.header,handles.twhis(:,whisnum),handles.buf,notepitch,pitch,whisnum,refpointsx,refpointsy,handles);
wsp_enable(handles,whisnum);

function ws = wsp_display(sng,header,t,buf,notepitch,pitch,whisnum,refpointsx,refpointsy,handles)
t1 = t + buf';
f = [0 125000];
tc = round(t * size(sng,2)/(header.nscans/header.scanrate));
if tc(1) == 0
    tc(1) = 1;
end
ws = sng(:,tc(1):tc(2));
set(gcf,'CurrentAxes',handles.freqaxes)
if (nargout == 0)
    imagesc(t1,f,abs(ws));
    line((t*[1 1])',[f' f'],'Color','r');
    set(gca,'YDir','normal');
    xlabel('Time (s)')
end

set(gcf,'CurrentAxes',handles.sngaxes)
plot(pitch, '-wo', ...
    'MarkerEdgeColor', 'k', ...
    'MarkerFaceColor', 'k')
hold on
plot(refpointsx,refpointsy,'ob', ...
    'MarkerFaceColor', 'b')
hold off
if length(pitch) > 1
    xend = length(pitch);
else
    xend = 1;
end
ylim([0 125000])
xlim([0 xend])
plot_notes(notepitch, refpointsx, 1, handles)
p=handles.p;
set(handles.syl_type,'String',p.syl{whisnum});

function wsp_enable(handles,whisnum)
if (whisnum > 1)
    set(handles.leftbutton,'Enable','on')
else
    set(handles.leftbutton,'Enable','off')
end
if (whisnum < size(handles.twhis,2))
    set(handles.rightbutton,'Enable','on')
else
    set(handles.rightbutton,'Enable','off')
end

function icons = swicons
iconsize = [17 17];
bkgrnd = get(0,'DefaultUicontrolBackgroundColor');
blank = zeros(iconsize) + bkgrnd(1);
right = blank;
index = mask(iconsize,1,1);
right(index) = 0;
right = repmat(right,[1 1 3]);
rightsm = blank;
index = mask(iconsize,0.5,1);
rightsm(index) = 0;
rightsm = repmat(rightsm,[1 1 3]);
left = blank;
index = mask(iconsize,1,-1);
left(index) = 0;
left = repmat(left,[1 1 3]);
leftsm = blank;
index = mask(iconsize,0.5,-1);
leftsm(index) = 0;
leftsm = repmat(leftsm,[1 1 3]);
icons.right = right;
icons.rightsm = rightsm;
icons.left = left;
icons.leftsm = leftsm;

function index = mask(iconsize,width,direction)
[row,col] = find(ones(iconsize));
row = (row-1)/(iconsize(1)-1);
col = (col-1)/(iconsize(2)-1);
if (direction > 0)
    index = find(2*abs(row-0.5) <= (width-col)/width);
else
    index = find(2*abs(row-0.5) + (1 - width)/width <= col/width);
end
return;

function leftnote_Callback(~, ~, handles)
whisnum = str2double(get(handles.whisnum,'String'));
notenum = str2double(get(handles.notenum,'String'));
p=handles.p;
refpointsx = p.xjump{whisnum};
pitch=p.cleanpitch{whisnum};
if (notenum > 1)
    notenum = notenum-1;
    set(handles.notenum,'String',int2str(notenum));
end
plot_notes(pitch, refpointsx, notenum, handles)

function notenum_Callback(~, ~, ~)

function notenum_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function rightnote_Callback(~, ~, handles)
whisnum = str2double(get(handles.whisnum,'String'));
notenum = str2double(get(handles.notenum,'String'));
p=handles.p;
refpointsx = p.xjump{whisnum};
pitch=p.cleanpitch{whisnum};
if (notenum < size(refpointsx,2)+1)
    notenum = notenum+1;
    set(handles.notenum,'String',int2str(notenum));
end
plot_notes(pitch, refpointsx, notenum, handles)

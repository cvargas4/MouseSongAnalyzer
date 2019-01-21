function view_traces_GUI(varargin)

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
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @view_traces_GUI_OpeningFcn, ...
    'gui_OutputFcn',  @view_traces_GUI_OutputFcn, ...
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

function view_traces_GUI_OpeningFcn(hObject, ~, handles,varargin)
icons = swicons;
set(handles.leftbutton,'CData',icons.left);
set(handles.rightbutton,'CData',icons.right);

file_name = varargin{1};
set(handles.uipanel1, 'Title', file_name);
load(file_name);
if exist('syll_traces', 'var')
traceMat = syll_traces;
clear syll_traces
end
pitch = traceMat{1};
whis_num = 1;
handles.whis_num = whis_num;
lastwhis = size(traceMat,1);
handles.lastwhis = lastwhis;
handles.traceMat = traceMat;
handles.XMin = -10;
handles.XMax = length(pitch)+10;
set(handles.totalwhis,'String',['/' num2str(lastwhis)]);
set(handles.x_min, 'String', num2str(-10));
set(handles.x_max, 'String', num2str(length(pitch)+10));
wsp_display(hObject,pitch,handles);
wsp_enable(handles);

function varargout = view_traces_GUI_OutputFcn(~, ~, ~)

function whisnum_CreateFcn(hObject, ~, ~)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function leftbutton_Callback(hObject, ~, handles)
whis_num = handles.whis_num;
traceMat = handles.traceMat;
if (whis_num > 1)
    whis_num = whis_num-1;
    set(handles.whisnum,'String',int2str(whis_num));
    handles.whis_num = whis_num;
    guidata(hObject, handles);
end
set(handles.whisnum,'String',int2str(whis_num));
pitch=traceMat{whis_num};
    handles.XMin = -10;
    handles.XMax = length(pitch)+10;
    guidata(hObject, handles);
wsp_display(hObject,pitch,handles);
wsp_enable(handles);

function rightbutton_Callback(hObject, ~, handles)
whis_num = handles.whis_num;
lastwhis = handles.lastwhis;
traceMat = handles.traceMat;
if (whis_num < lastwhis)
    whis_num = whis_num+1;
    set(handles.whisnum,'String',int2str(whis_num));
    handles.whis_num = whis_num;
    guidata(hObject, handles);
end
set(handles.whisnum,'String',int2str(whis_num));
pitch=traceMat{whis_num};
    handles.XMin = -10;
    handles.XMax = length(pitch)+10;
    guidata(hObject, handles);
wsp_display(hObject,pitch,handles);
wsp_enable(handles);

function whisnum_Callback(hObject, ~, handles)
whis_num = str2double(get(handles.whisnum, 'String'));
lastwhis = handles.lastwhis;
traceMat = handles.traceMat;
if (whis_num < 1)
    whis_num = 1;
elseif (whis_num > lastwhis)
    whis_num = lastwhis;
end
set(handles.whisnum,'String',int2str(whis_num));
handles.whis_num = whis_num;
guidata(hObject, handles);
pitch=traceMat{whis_num};
    handles.XMin = -10;
    handles.XMax = length(pitch)+10;
    guidata(hObject, handles);
wsp_display(hObject,pitch,handles);
wsp_enable(handles);

function wsp_display(hObject,pitch,handles)
XMin = handles.XMin;
XMax = handles.XMax;
set(gcf,'CurrentAxes',handles.freqaxes1)
plot(pitch, '-wo', ...
    'MarkerEdgeColor', 'k', ...
    'MarkerFaceColor', 'k')
ylim([0 125000])
xlim([XMin XMax])
h = gca;
handles.h = h;
guidata(hObject, handles)
set(handles.x_min, 'String', num2str(XMin));
set(handles.x_max, 'String', num2str(XMax));

function wsp_enable(handles)
whisnum = handles.whis_num;
lastwhis = handles.lastwhis;
if (whisnum > 1)
    set(handles.leftbutton,'Enable','on')
else
    set(handles.leftbutton,'Enable','off')
end
if (whisnum < lastwhis)
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

function save_plot_Callback(~, ~, handles)
h = handles.h;
j = figure(1);
i = copyobj(h,j);
save_name = get(handles.save_name, 'String');
file_name = [save_name '.tif'];
saveas(i,file_name)
close(j)

function x_min_Callback(hObject, ~, handles)
handles.XMin = str2double(get(handles.x_min, 'String'));
whisnum = handles.whis_num;
traceMat = handles.traceMat;
guidata(hObject, handles);
pitch=traceMat{whisnum};
wsp_display(hObject,pitch,handles);

function x_min_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function x_max_Callback(hObject, ~, handles)
handles.XMax = str2double(get(handles.x_max, 'String'));
whisnum = handles.whis_num;
traceMat = handles.traceMat;
guidata(hObject, handles);
pitch=traceMat{whisnum};
wsp_display(hObject,pitch,handles);

function x_max_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function save_name_Callback(hObject, eventdata, handles)
function save_name_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

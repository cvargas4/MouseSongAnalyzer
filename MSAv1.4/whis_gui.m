function varargout = whis_gui(varargin)

%Copyright 2019 Jarvis Lab 
%Contact  Erich Jarvis <ejarvis@rockefeller.edu> Cesar Vargasor <cvargas@rockefeller.edu>
%MSAv1.4 is a simple update by Cesar Vargas <cvargas@rockefeller.edu>
%to MSAv1.3 (2013) by LabDaemons <info@labdaemons.com>

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
    'gui_OpeningFcn', @whis_gui_OpeningFcn, ...
    'gui_OutputFcn',  @whis_gui_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
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

function whis_gui_OpeningFcn(hObject, ~, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);
if nargin == 3, %#ok<*NOCOL>
    initial_dir = pwd;
elseif nargin > 4
    if strcmpi(varargin{1},'dir')
        if exist(varargin{2},'dir')
            initial_dir = varargin{2};
        else
            errordlg({'Input argument must be a valid',...
                'directory'},'Input Argument Error!')
            return
        end
    else
        errordlg('Unrecognized input argument',...
            'Input Argument Error!');
        return;
    end
end
load_listbox(hObject,initial_dir,handles)

function varargout = whis_gui_OutputFcn(~, ~, handles)
varargout{1} = handles.output;

function min_freq_Callback(~, ~, ~)
function min_freq_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function max_freq_Callback(~, ~, ~)
function max_freq_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function num_freq_Callback(~, ~, ~)
function num_freq_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function sng_thresh_Callback(~, ~, ~)
function sng_thresh_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function purity_thresh_Callback(~, ~, ~)
function purity_thresh_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function duration_thresh_Callback(~, ~, ~)
function duration_thresh_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function meanfreq_thresh_Callback(~, ~, ~)
function meanfreq_thresh_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function listbox1_Callback(hObject, ~, handles)
global isDir
get(handles.figure1,'SelectionType');
if strcmp(get(handles.figure1,'SelectionType'),'open')
    index_selected = get(handles.listbox1,'Value');
    file_list = get(handles.listbox1,'String');
    filename = file_list{index_selected};
    if  isDir(handles.sorted_index(index_selected))
        cd (filename)
        set(handles.listbox1, 'ListboxTop', 1)
        load_listbox(hObject,pwd,handles)
        file_names = get(handles.listbox1, 'String');
        set(handles.listbox1, 'ListboxTop', size(file_names,1))
        dir_struct = dir(pwd);
        [sorted_names,sorted_index] = sortrows({dir_struct.name}');
        handles.file_names = sorted_names;
        handles.is_dir = [dir_struct.isdir];
        isDir = handles.is_dir;
        handles.sorted_index = sorted_index;
        set(handles.listbox1, 'ListboxTop', size(sorted_index,1))
    else
        [~,name,ext] = fileparts(filename);
        switch ext
            case '.WAV'
                [sound,Fs]=audioread(filename);
                header.freqMin = str2double(get(handles.min_freq,'String'));
                header.freqMax = str2double(get(handles.max_freq,'String'));
                header.nfreq = str2double(get(handles.num_freq,'String'));
                header.threshold = str2double(get(handles.sng_thresh,'String'));
                header.scanrate = Fs;
                header.nscans = length(sound);
                header.tacq = header.nscans/header.scanrate;
                header.columnTotal = header.nscans/header.nfreq;
                sngparms.freqrange = [header.freqMin header.freqMax];
                cd ..
                a = exist('sonograms', 'dir');
                if a == 0
                    mkdir('sonograms')
                    cd sonograms
                elseif a ==7
                    cd sonograms
                end
                sound2sngGUI(filename,header,sound,sngparms);
            case '.wav'
                [sound,Fs]=audioread(filename);
                header.freqMin = str2double(get(handles.min_freq,'String'));
                header.freqMax = str2double(get(handles.max_freq,'String'));
                header.nfreq = str2double(get(handles.num_freq,'String'));
                header.threshold = str2double(get(handles.sng_thresh,'String'));
                header.scanrate = Fs;
                header.nscans = length(sound);
                header.tacq = header.nscans/header.scanrate;
                header.columnTotal = header.nscans/header.nfreq;
                sngparms.freqrange = [header.freqMin header.freqMax];
                cd ..
                a = exist('sonograms', 'dir');
                if a == 0
                    mkdir('sonograms')
                    cd sonograms
                elseif a ==7
                    cd sonograms
                end
                sound2sngGUI(filename,header,sound,sngparms);
            case '.sng'
                [~,name] = fileparts(filename);
        end
        sngfilename = [name '.sng'];
        [sng,header]=ReadSonogramGUI(sngfilename);
        handles.name = name;
        handles.sng = sng;
        handles.header = header;
        header.freqMin = str2double(get(handles.min_freq,'String'));
        header.freqMax = str2double(get(handles.max_freq,'String'));
        header.nfreq = str2double(get(handles.num_freq,'String'));
        header.threshold = str2double(get(handles.sng_thresh,'String'));
        options.log = 0;
        options.filterduration = str2double(get(handles.filter_dur,'String'))/1000;
        options.puritythresh = str2double(get(handles.purity_thresh, 'String'));
        options.specdiscthresh = 1;
        options.meanfreqthresh = str2double(get(handles.meanfreq_thresh,'String'));
        options.durationthresh = str2double(get(handles.duration_thresh,'String'))/1000;
        options.mergeclose = .01;
        handles.options = options;
        [twhis,meanfreq,whisfeatures] = whistimesGUI(sng,header,options);
        handles.twhis = twhis;
        handles.meanfreq = meanfreq;
        handles.whisfeatures = whisfeatures;
        whistimesplotGUI(sng,header,twhis,handles)
        set(handles.listbox1, 'ListboxTop', 1);
        load_listbox(hObject,pwd,handles)
    end
end
guidata(hObject,handles)

function load_listbox(hObject,dir_path,handles)
global isDir
cd (dir_path)
dir_struct = dir(dir_path);
[sorted_names,sorted_index] = sortrows({dir_struct.name}');
handles.file_names = sorted_names;
handles.is_dir = [dir_struct.isdir];
isDir = handles.is_dir;
handles.sorted_index = sorted_index;
guidata(handles.figure1,handles)
set(handles.listbox1,'String',handles.file_names,...
    'Value',1)
set(handles.listbox1, 'ListboxTop', size(sorted_index,1));
guidata(hObject,handles)

function listbox1_CreateFcn(hObject, ~, ~) %#ok<*DEFNU>
usewhitebg = 1;
if usewhitebg
    set(hObject,'BackgroundColor','white')
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor')); %#ok<*UNRCH>
end

function radiobutton2_Callback(~, ~, ~)

function filter_dur_Callback(~, ~, ~)
function filter_dur_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function show_whis_Callback(hObject, ~, handles)
sort_name = get(handles.sorting_file,'String');
split_s_status = get(handles.split_s,'Value');
find_harmonics = get(handles.find_harm, 'Value');
if strcmp(sort_name,'Enter Sorting File Name')
    use_sort = 0;
else
    use_sort = 1;
end
namesToOpen = get(handles.listbox1,'String');
options.log = 0;
options.filterduration = str2double(get(handles.filter_dur,'String'))/1000;
options.puritythresh = str2double(get(handles.purity_thresh, 'String'));
options.specdiscthresh = 1;
options.meanfreqthresh = str2double(get(handles.meanfreq_thresh,'String'));
options.durationthresh = str2double(get(handles.duration_thresh,'String'))/1000;
options.mergeclose = .01;
handles.options = options;
min_note = str2double(get(handles.min_note, 'String'));
min_count = str2double(get(handles.min_count, 'String'));
if use_sort == 0
    numToOpen = get(handles.listbox1,'Value');
    animalID = get(handles.animalID, 'String');
    sessionID = get(handles.sessionID, 'String');
    if length(numToOpen) > 1
        for i = 1 : length(numToOpen)
            sngfilename = namesToOpen{numToOpen(i)};
            [~,name] = fileparts(sngfilename);
            [sng,header]=ReadSonogramGUI(sngfilename);
            handles.name = name;
            handles.sng = sng;
            handles.header = header;
            [twhis,meanfreq,whisfeatures] = whistimesGUI(sng,header,options);
            handles.twhis = twhis;
            handles.meanfreq = meanfreq;
            handles.whisfeatures = whisfeatures;
            name = handles.name;
            sng = handles.sng;
            header = handles.header;
            twhis = handles.twhis;
            whis = whissnip(sng,header,twhis);
            handles.whis = whis;
            guidata(hObject,handles)
            showoptions.buf = [-0.001 0.001];
            showoptions.todisk = 0;
            if isempty(twhis) == 0
                [syllMat, jumptimes, syll_traces] = showwhisGUI(name,sng,header,twhis,whis,meanfreq,showoptions,min_note,split_s_status,find_harmonics);
                clear sng header path name ext ver twhis meanfreq whis showoptions
                if exist('noteMat', 'var') == 0
                    noteMat = syllMat;
                else
                    b = syllMat;
                    noteMat = cat(1,noteMat,b);
                end
                clear syllMat b
                if exist('jumpMat', 'var') == 0
                    jumpMat = jumptimes;
                else
                    c = jumptimes;
                    jumpMat = cat(2,jumpMat,c);
                end
                clear jumptimes c
                if exist('traceMat','var') == 0
                    traceMat = syll_traces;
                else
                    d = syll_traces;
                    traceMat = cat(1,traceMat,d);
                end
                clear sylltraces d
            end
            if i == length(numToOpen)
                base_Name = [animalID '-' sessionID];
                syll_Name = [base_Name '-Syllables.csv'];
                cell2csv(syll_Name,noteMat)
                [noteMat2] = tag_notes(jumpMat, traceMat, noteMat);
                note_data = analyze_notes(noteMat2);
                note_Name = [base_Name '-Notes.csv'];
                cell2csv(note_Name, note_data)
                trace_name = [base_Name '-Traces.mat'];
                save(trace_name, 'traceMat')
                clear note_data traceMat noteMat2 jumpMat
            end
        end
        clear sngfilename namesToOpen numToOpen whisfeatures
    else
        name = handles.name;
        sng = handles.sng;
        header = handles.header;
        twhis = handles.twhis;
        meanfreq = handles.meanfreq;
        whis = whissnip(sng,header,twhis);
        handles.whis = whis;
        guidata(hObject,handles)
        showoptions.buf = [-0.001 0.001];
        showoptions.todisk = 0;
        if isempty(twhis) == 0
            [noteMat, jumptimes, syll_traces] = showwhisGUI(name,sng,header,twhis,whis,meanfreq,showoptions,min_note,split_s_status,find_harmonics);
            clear sng header path name ext ver twhis meanfreq whis showoptions
        end
        if exist('noteMat', 'var')
            base_Name = [animalID '-' sessionID];
            syll_Name = [base_Name '-Syllables.csv'];
            cell2csv(syll_Name,noteMat)
            [noteMat2] = tag_notes(jumptimes, syll_traces, noteMat);
            note_data = analyze_notes(noteMat2);
            note_Name = [base_Name '-Notes.csv'];
            cell2csv(note_Name, note_data)
            trace_name = [base_Name '-Traces.mat'];
            save(trace_name, 'syll_traces')
            clear noteMat2 note_data syll_traces
        end
    end
    if exist('noteMat', 'var')
        if get(handles.a_note, 'Value') == 1
            syllTag = 's';
            process_syllables(noteMat, syllTag, animalID, sessionID, min_count)
            if split_s_status == 1
                syllTag = 'shrt';
                process_syllables(noteMat, syllTag, animalID, sessionID, min_count)
                syllTag = 'flat';
                process_syllables(noteMat, syllTag, animalID, sessionID, min_count)
                syllTag = 'up';
                process_syllables(noteMat, syllTag, animalID, sessionID, min_count)
                syllTag = 'down';
                process_syllables(noteMat, syllTag, animalID, sessionID, min_count)
                syllTag = 'chev';
                process_syllables(noteMat, syllTag, animalID, sessionID, min_count)
                if find_harmonics == 1
                    syllTag = 'harm';
                    process_syllables(noteMat, syllTag, animalID, sessionID, min_count)
                end
            end
        end
        if get(handles.b_note, 'Value') == 1
            syllTag = 'd';
            process_syllables(noteMat, syllTag, animalID, sessionID, min_count)
        end
        if get(handles.c_note, 'Value') == 1
            syllTag = 'u';
            process_syllables(noteMat, syllTag, animalID, sessionID, min_count)
        end
        if get(handles.d_note, 'Value') == 1
            syllTag = 'dd';
            process_syllables(noteMat, syllTag, animalID, sessionID, min_count)
        end
        if get(handles.e_note, 'Value') == 1
            syllTag = 'du';
            process_syllables(noteMat, syllTag, animalID, sessionID, min_count)
        end
        if get(handles.f_note, 'Value') == 1
            syllTag = 'ddu';
            process_syllables(noteMat, syllTag, animalID, sessionID, min_count)
        end
        if get(handles.g_note, 'Value') == 1
            syllTag = 'dud';
            process_syllables(noteMat, syllTag, animalID, sessionID, min_count)
        end
        if get(handles.h_note, 'Value') == 1
            syllTag = 'dudu';
            process_syllables(noteMat, syllTag, animalID, sessionID, min_count)
        end
        if get(handles.i_note, 'Value') == 1
            syllTag = 'ud';
            process_syllables(noteMat, syllTag, animalID, sessionID, min_count)
        end
        if get(handles.j_note, 'Value') == 1
            syllTag = 'udu';
            process_syllables(noteMat, syllTag, animalID, sessionID, min_count)
        end
        if get(handles.k_note, 'Value') == 1
            syllTag = 'udud';
            process_syllables(noteMat, syllTag, animalID, sessionID, min_count)
        end
        clear noteMat syllTag
    end
elseif use_sort == 1
    [~, sort_mat] = xlsread(sort_name);
    for i = 1 : size(sort_mat,1)
        animalID = sort_mat{i,1};
        sessionID = sort_mat{i,2};
        start_file = sort_mat{i,3};
        stop_file = sort_mat{i,4};
        start_num = find(strcmp(start_file,namesToOpen));
        stop_num = find(strcmp(stop_file,namesToOpen));
        clear start_file stop_file
        for x = start_num : stop_num
            sngfilename = namesToOpen{x};
            [~,name] = fileparts(sngfilename);
            [sng,header]=ReadSonogramGUI(sngfilename);
            handles.name = name;
            handles.sng = sng;
            handles.header = header;
            [twhis,meanfreq,whisfeatures] = whistimesGUI(sng,header,options);
            handles.twhis = twhis;
            handles.meanfreq = meanfreq;
            handles.whisfeatures = whisfeatures;
            name = handles.name;
            sng = handles.sng;
            header = handles.header;
            twhis = handles.twhis;
            meanfreq = handles.meanfreq;
            whis = whissnip(sng,header,twhis);
            handles.whis = whis;
            guidata(hObject,handles)
            showoptions.buf = [-0.001 0.001];
            showoptions.todisk = 0;
            if isempty(twhis) == 0
                [syllMat, jumptimes, syll_traces] = showwhisGUI(name,sng,header,twhis,whis,meanfreq,showoptions,min_note,split_s_status,find_harmonics);
                clear sng header path name ext ver twhis meanfreq whis showoptions
                if exist('noteMat', 'var') == 0
                    noteMat = syllMat;
                else
                    b = syllMat;
                    noteMat = cat(1,noteMat,b);
                end
                clear syllMat b
                if exist('jumpMat', 'var') == 0
                    jumpMat = jumptimes;
                else
                    c = jumptimes;
                    jumpMat = cat(2,jumpMat,c);
                end
                clear jumptimes c
                if exist('traceMat','var') == 0
                    traceMat = syll_traces;
                else
                    d = syll_traces;
                    traceMat = cat(1,traceMat,d);
                end
                clear sylltraces d
            end
            if x == stop_num && exist('noteMat', 'var')
                base_Name = [animalID '-' sessionID];
                syll_Name = [base_Name '-Syllables.csv'];
                cell2csv(syll_Name,noteMat)
                [noteMat2] = tag_notes(jumpMat, traceMat, noteMat);
                note_data = analyze_notes(noteMat2);
                note_Name = [base_Name '-Notes.csv'];
                cell2csv(note_Name, note_data)
                trace_name = [base_Name '-Traces.mat'];
                save(trace_name, 'traceMat')
                clear noteMat2 note_data traceMat
            end
        end
        clear sngfilename whisfeatures sng header path name ext ver twhis meanfreq whis showoptions start_num stop_num
        if exist('noteMat', 'var')
            if get(handles.a_note, 'Value') == 1
                syllTag = 's';
                process_syllables(noteMat, syllTag, animalID, sessionID, min_count)
                if split_s_status == 1
                    syllTag = 'shrt';
                    process_syllables(noteMat, syllTag, animalID, sessionID, min_count)
                    syllTag = 'flat';
                    process_syllables(noteMat, syllTag, animalID, sessionID, min_count)
                    syllTag = 'up';
                    process_syllables(noteMat, syllTag, animalID, sessionID, min_count)
                    syllTag = 'down';
                    process_syllables(noteMat, syllTag, animalID, sessionID, min_count)
                    syllTag = 'chev';
                    process_syllables(noteMat, syllTag, animalID, sessionID, min_count)
                    if find_harmonics == 1
                        syllTag = 'harm';
                        process_syllables(noteMat, syllTag, animalID, sessionID, min_count)
                    end
                end
            end
            if get(handles.b_note, 'Value') == 1
                syllTag = 'd';
                process_syllables(noteMat, syllTag, animalID, sessionID, min_count)
            end
            if get(handles.c_note, 'Value') == 1
                syllTag = 'u';
                process_syllables(noteMat, syllTag, animalID, sessionID, min_count)
            end
            if get(handles.d_note, 'Value') == 1
                syllTag = 'dd';
                process_syllables(noteMat, syllTag, animalID, sessionID, min_count)
            end
            if get(handles.e_note, 'Value') == 1
                syllTag = 'du';
                process_syllables(noteMat, syllTag, animalID, sessionID, min_count)
            end
            if get(handles.f_note, 'Value') == 1
                syllTag = 'ddu';
                process_syllables(noteMat, syllTag, animalID, sessionID, min_count)
            end
            if get(handles.g_note, 'Value') == 1
                syllTag = 'dud';
                process_syllables(noteMat, syllTag, animalID, sessionID, min_count)
            end
            if get(handles.h_note, 'Value') == 1
                syllTag = 'dudu';
                process_syllables(noteMat, syllTag, animalID, sessionID, min_count)
            end
            if get(handles.i_note, 'Value') == 1
                syllTag = 'ud';
                process_syllables(noteMat, syllTag, animalID, sessionID, min_count)
            end
            if get(handles.j_note, 'Value') == 1
                syllTag = 'udu';
                process_syllables(noteMat, syllTag, animalID, sessionID, min_count)
            end
            if get(handles.k_note, 'Value') == 1
                syllTag = 'udud';
                process_syllables(noteMat, syllTag, animalID, sessionID, min_count)
            end
            clear noteMat syllTag
        end
    end
    clear numToOpen namesToOpen data sort_mat
end
msgbox('Done Processing Sonograms')
set(handles.listbox1, 'ListboxTop', 1);
load_listbox(hObject,pwd,handles)

function sparse_button_Callback(hObject, ~, handles)
namesToOpen = get(handles.listbox1,'String');
numToOpen = get(handles.listbox1,'Value');
homeFolder = pwd;

for i = 1 : length(numToOpen)
    filename = namesToOpen{numToOpen(i)};
    [sound,Fs]=audioread(namesToOpen{numToOpen(i)});
    header.freqMin = str2double(get(handles.min_freq,'String'));
    header.freqMax = str2double(get(handles.max_freq,'String'));
    header.nfreq = str2double(get(handles.num_freq,'String'));
    header.threshold = str2double(get(handles.sng_thresh,'String'));
    header.scanrate = Fs;
    header.nscans = length(sound);
    header.tacq = header.nscans/header.scanrate;
    header.columnTotal = header.nscans/header.nfreq;
    sngparms.freqrange = [header.freqMin header.freqMax];
    cd ..
    a = exist('sonograms', 'dir');
    if a == 0
        mkdir('sonograms')
        cd sonograms
    elseif a ==7
        cd sonograms
    end
    sound2sngGUI(filename,header,sound,sngparms);
    cd(homeFolder)
    
end
clear namesToOpen numToOpen homefolder sound Fs filename
cd ../sonograms
set(handles.listbox1, 'ListboxTop', 1);
load_listbox(hObject,pwd,handles)
namesToOpen = get(handles.listbox1,'String');
file_index = strfind(namesToOpen,'.sng');
sng_index = (1 : length(file_index));
for i = 1 : length(file_index)
    if file_index{i}
        sng_index(i) = 1;
    else
        sng_index(i) = 0;
    end
end
numToOpen = find(sng_index);
for i = 1 : length(numToOpen)
    filename = namesToOpen{numToOpen(i)};
    [fid] = fopen(filename,'r','l');
    [~,headersize] = ReadHeaderGUI(fid);
    fseek(fid,headersize,-1);
    length1 = fread(fid,1,'int32');
    col = fread(fid,length1,'int32');
    if isempty(col) == 1
        if (ischar(filename))
            status = fclose(fid);
            if (status < 0)
                error('File did not close');
            end
        end
        delete(filename)
    elseif isempty(col) == 0
        if (ischar(filename))
            status = fclose(fid);
            if (status < 0)
                error('File did not close');
            end
        end
    end
end

msgbox('Done Making Sonograms')

function sessionID_Callback(~, ~, ~)
function sessionID_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function animalID_Callback(~, ~, ~)
function animalID_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function a_note_Callback(~, ~, ~)
function b_note_Callback(~, ~, ~)
function c_note_Callback(~, ~, ~)
function d_note_Callback(~, ~, ~)
function e_note_Callback(~, ~, ~)
function f_note_Callback(~, ~, ~)
function g_note_Callback(~, ~, ~)
function h_note_Callback(~, ~, ~)
function i_note_Callback(~, ~, ~)
function j_note_Callback(~, ~, ~)
function k_note_Callback(~, ~, ~)

function sorting_file_Callback(~, ~, ~)

function sorting_file_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function min_note_Callback(~, ~, ~)

function min_note_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function min_count_Callback(~, ~, ~)

function min_count_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function split_s_Callback(~, ~, ~)


function find_harm_Callback(~, ~, ~)

function varargout = Form_loadfiles(varargin)
% FORM_LOADFILES MATLAB code for Form_loadfiles.fig
%      FORM_LOADFILES, by itself, creates a new FORM_LOADFILES or raises the existing
%      singleton*.
%
%      H = FORM_LOADFILES returns the handle to a new FORM_LOADFILES or the handle to
%      the existing singleton*.
%
%      FORM_LOADFILES('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FORM_LOADFILES.M with the given input arguments.
%
%      FORM_LOADFILES('Property','Value',...) creates a new FORM_LOADFILES or raises
%      the existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Form_loadfiles_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Form_loadfiles_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Form_loadfiles

% Last Modified by GUIDE v2.5 14-Feb-2021 09:54:53

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Form_loadfiles_OpeningFcn, ...
                   'gui_OutputFcn',  @Form_loadfiles_OutputFcn, ...
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

% --- Executes just before Form_loadfiles is made visible.
function Form_loadfiles_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Form_loadfiles (see VARARGIN)

% Choose default command line output for Form_loadfiles
handles.output = hObject;
  movegui(handles.figure1,'center')  

fn = fieldnames(handles);
    
    for i = 1:numel(fn)
        fni = string(fn(i));
        field = handles.(fni);
        try
            set(field,'Units', 'normalized');
        catch
        end
        try
            set(field,'FontUnits', 'normalized');

        catch
        end
    end
% Update handles structure
guidata(hObject, handles);

global node_in;
node_in = varargin{1};

[YourImage, ~, ImageAlpha] = imread('Icons/logo_eegnet_greybkg.png');
axes(handles.axes1);
imshow(YourImage)
% Make the GUI modal
set(handles.figure1,'WindowStyle','modal')
set(handles.figure1, 'Name', 'Import EEG');

% % clear edit text when the user press the mouse
jEditbox = findjobj(handles.channels_edit);
set(jEditbox, 'MousePressedCallback',@ClearFunction);
jEditbox1 = findjobj(handles.eegfile_edit);
set(jEditbox1, 'MousePressedCallback',@ClearFunction);
jEditbox2 = findjobj(handles.samplingrate_edit);
set(jEditbox2, 'MousePressedCallback',@ClearFunction);

% Callback function definition
% UIWAIT makes Form_New wait for user response (see UIRESUME)
uiwait(handles.figure1);

% jb = javax.swing.JButton;
% jbh = handle(jb,'CallbackProperties');
function ClearFunction(jEditbox, eventData)
    % The following comments refer to the case of Alt-Shift-b
    name=jEditbox.getText;
    if(strcmp(name,'EEG file'))
    jEditbox.setText('');
    end
        if(strcmp(name,'Sampling rate'))
    jEditbox.setText('');
    end
    if(strcmp(name,'Channels file'))
    jEditbox.setText('');
    end

    % (now decide what to do with this key-press...)

% UIWAIT makes Form_loadfiles wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Form_loadfiles_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
% varargout{1} = handles.output;


% --- Executes on button press in push_add.
function push_add_Callback(hObject, eventdata, handles)
% hObject    handle to push_add (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global node_in;
% % external globals
global tree;
global treeModel;
global fig1;
global plotting_panel;
% global fpath;
global info_panel;
% global subjname;
global allsubjects;
% global numberSubjects;
global alleegs; 
global hh;
global jRangeSlider;

EEG=hh.EEG;
filename=hh.filename;
pathname=hh.pathname;

try 
   nodeName = char(node_in.getName);
   subjectname=nodeName;
   subjectname=subjectname(3:end);
    % %              index of the subject to show its eeg in the figure
   subjIndex=find(strcmp(allsubjects.names, subjectname));
   allsubjects.paths{subjIndex}=[pathname '/' filename];

    switch get(handles.popupmenu1,'Value')

        case {1, 6 ,7}
            channelfile=hh.locs;
            samplingrate=get(handles.samplingrate_edit,'String');
            sr=str2num(samplingrate);
% 
            EEG=writeEEGLAB_struct(EEG,sr,subjectname,filename,pathname,channelfile);
% %        for cases 2 and 3, the eeg are already in eeglab structs
            
    end
    alleegs{subjIndex}=EEG;
    ViewSignal(EEG.data,fig1,plotting_panel);
    WriteInfo(EEG.data,EEG.srate,subjectname,info_panel,1);
    
    nochild=0;
    create=1;
    try
        node_in.getFirstChild.getName
    catch
        nochild=1;
        
    end
    
    if(nochild==0)
    if (strcmp(node_in.getFirstChild.getName,'EEG'))
        create=0;
    end
    end
    
    if(create)
    % % Add EEG in tree
    parent = node_in;
    childNode = uitreenode('v0','dummy', 'EEG', [], 0);
    [I] = imread('Icons/javaImage_eeg.png');
    javaImage_eeg = im2java(I);

    childNode.setIcon(javaImage_eeg);
    treeModel.insertNodeInto(childNode,parent,parent.getChildCount()); 
    % expand to show added child
    tree.setSelectedNode( childNode );
    % insure additional nodes are added to parent
    tree.setSelectedNode( parent );
    end
    % end
    closereq;       %Close the actual GUI

catch
    msgbox('EEGNET: A problem in the loading process is detected!');
end

% --- Executes on button press in push_cancel.
function push_cancel_Callback(hObject, eventdata, handles)
% hObject    handle to push_cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uiresume(handles.figure1);
closereq;       %Close the actual GUI



function eegfile_edit_Callback(hObject, eventdata, handles)
% hObject    handle to eegfile_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of eegfile_edit as text
%        str2double(get(hObject,'String')) returns contents of eegfile_edit as a double


% --- Executes during object creation, after setting all properties.
function eegfile_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to eegfile_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1
switch(get(handles.popupmenu1,'Value'))
    case 1
        set(handles.channels_edit,'enable','on');
       set(handles.samplingrate_edit,'enable','on');
        set(handles.push_browseChannels,'enable','on');

    case 2
        set(handles.channels_edit,'enable','off');
       set(handles.samplingrate_edit,'enable','off');
        set(handles.push_browseChannels,'enable','off');
    case 3
             set(handles.channels_edit,'enable','off');
       set(handles.samplingrate_edit,'enable','off');
        set(handles.push_browseChannels,'enable','off');
    case 4
% %         raw
       set(handles.channels_edit,'enable','off');
       set(handles.samplingrate_edit,'enable','off');
       set(handles.push_browseChannels,'enable','off');

    case 5
% %         cnt
       set(handles.channels_edit,'enable','off');
       set(handles.samplingrate_edit,'enable','off');
       set(handles.push_browseChannels,'enable','off');

    case 6
% %         edf
        set(handles.channels_edit,'enable','on');
       set(handles.samplingrate_edit,'enable','on');
        set(handles.push_browseChannels,'enable','on');

    case 7 
% %         bdf
        set(handles.channels_edit,'enable','on');
       set(handles.samplingrate_edit,'enable','on');
        set(handles.push_browseChannels,'enable','on');

end


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function samplingrate_edit_Callback(hObject, eventdata, handles)
% hObject    handle to samplingrate_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of samplingrate_edit as text
%        str2double(get(hObject,'String')) returns contents of samplingrate_edit as a double


% --- Executes during object creation, after setting all properties.
function samplingrate_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to samplingrate_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function channels_edit_Callback(hObject, eventdata, handles)
% hObject    handle to channels_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of channels_edit as text
%        str2double(get(hObject,'String')) returns contents of channels_edit as a double


% --- Executes during object creation, after setting all properties.
function channels_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to channels_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in push_browse_eeg.
function push_browse_eeg_Callback(hObject, eventdata, handles)
% hObject    handle to push_browse_eeg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB

% handles    structure with handles and user data (see GUIDATA)
global hh;
ext=get(handles.popupmenu1,'Value');
% % ext-1:mat, ext-2: .set, ext=3: eeglab mat
switch ext
    case 1
        [filename,pathname]=uigetfile({'*.mat','Import EEG Signal File (*.mat)'});
            if isequal(filename,0)||isequal(pathname,0)
                return
            else
                fpath=fullfile(pathname,filename);
              cellOut=struct2cell(load(fpath));
             EEG=(cellOut{1})

            end
    case 3
            [filename,pathname]=uigetfile({'*.mat','Import EEGLAB set as matlab array'});
            if isequal(filename,0)||isequal(pathname,0)
                return
            else
                fpath=fullfile(pathname,filename);
            end
                        cellOut=struct2cell(load(fpath));
             EEG=(cellOut{1})

    case 2
            [filename,pathname]=uigetfile({'*.set','Import EEGLAB set (*.set)'});
            if isequal(filename,0)||isequal(pathname,0)
                return
            else
                fpath=fullfile(pathname,filename);
            end
            EEG = pop_loadset(filename,pathname);
    case 4
% %         raw egi
            [filename,pathname]=uigetfile({'*.raw','Import EGI raw file (*.raw)'});
            if isequal(filename,0)||isequal(pathname,0)
                return
            else
                fpath=fullfile(pathname,filename);
            end
            addpath(genpath('external/eeglab13_1_1b'));
            EEG = pop_readegi(fpath);
            try
                EEG.chanlocs(1).type;
                for i=1:EEG.nbchan
                    if(isempty(EEG.chanlocs(i).type))
                        EEG.chanlocs(i).type='EEG';
                    end
                end
            catch
                
            end
    case 5
% %         cnt
            [filename,pathname]=uigetfile({'*.cnt','Import EEG file (*.cnt)'});
            if isequal(filename,0)||isequal(pathname,0)
                return
            else
                fpath=fullfile(pathname,filename);
            end
            addpath(genpath('external/eeglab13_1_1b'));
            EEG = pop_loadcnt(fpath);
    case 6
       % %         edf
            [filename,pathname]=uigetfile({'*.edf','Import EEG file (*.edf)'});
            if isequal(filename,0)||isequal(pathname,0)
                return
            else
                fpath=fullfile(pathname,filename);
            end
            [e EEG] = edfread(fpath);
    case 7
               % %         bdf
            [filename,pathname]=uigetfile({'*.bdf','Import EEG file (*.bdf)'});
            if isequal(filename,0)||isequal(pathname,0)
                return
            else
                fpath=fullfile(pathname,filename);
            end
            [EEG,numChan,labels,txt,fs,gain,prefiltering,ChanDim] = eeg_read_bdf(fpath,'all','n');

end
set(handles.eegfile_edit,'String',fpath);
hh.EEG=EEG;
hh.filename=filename;
hh.pathname=pathname;
% --- Executes on button press in push_browseChannels.
function push_browseChannels_Callback(hObject, eventdata, handles)
% hObject    handle to push_browseChannels (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global hh;
[filename,pathname]=uigetfile({'*','Import Channel locs File'});
if isequal(filename,0)||isequal(pathname,0)
    return
else
    fpath=fullfile(pathname,filename);
end
addpath(genpath('external/eeglab13_1_1b'));
locs=readlocs(fpath);
set(handles.channels_edit,'String',fpath);
hh.locs=locs;


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2


% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in segment_push.
function segment_push_Callback(hObject, eventdata, handles)
% hObject    handle to segment_push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function event_file_edit_Callback(hObject, eventdata, handles)
% hObject    handle to event_file_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of event_file_edit as text
%        str2double(get(hObject,'String')) returns contents of event_file_edit as a double


% --- Executes during object creation, after setting all properties.
function event_file_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to event_file_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function pre_stimulus_edit_Callback(hObject, eventdata, handles)
% hObject    handle to pre_stimulus_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pre_stimulus_edit as text
%        str2double(get(hObject,'String')) returns contents of pre_stimulus_edit as a double


% --- Executes during object creation, after setting all properties.
function pre_stimulus_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pre_stimulus_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function post_stimulus_edit_Callback(hObject, eventdata, handles)
% hObject    handle to post_stimulus_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of post_stimulus_edit as text
%        str2double(get(hObject,'String')) returns contents of post_stimulus_edit as a double


% --- Executes during object creation, after setting all properties.
function post_stimulus_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to post_stimulus_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in browse_push.
function browse_push_Callback(hObject, eventdata, handles)
% hObject    handle to browse_push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function epoch_length_edit_Callback(hObject, eventdata, handles)
% hObject    handle to epoch_length_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of epoch_length_edit as text
%        str2double(get(hObject,'String')) returns contents of epoch_length_edit as a double


% --- Executes during object creation, after setting all properties.
function epoch_length_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to epoch_length_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

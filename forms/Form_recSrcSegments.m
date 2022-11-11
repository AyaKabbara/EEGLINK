function varargout = Form_recSrcSegments(varargin)
% Form_recSrcSegments MATLAB code for Form_recSrcSegments.fig
%      Form_recSrcSegments, by itself, creates a new Form_recSrcSegments or raises the existing
%      singleton*.
%
%      H = Form_recSrcSegments returns the handle to a new Form_recSrcSegments or the handle to
%      the existing singleton*.
%
%      Form_recSrcSegments('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in Form_recSrcSegments.M with the given input arguments.
%
%      Form_recSrcSegments('Property','Value',...) creates a new Form_recSrcSegments or raises
%      the existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Form_recSrcSegments_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Form_recSrcSegments_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Form_recSrcSegments

% Last Modified by GUIDE v2.5 21-Apr-2021 16:09:24

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Form_recSrcSegments_OpeningFcn, ...
                   'gui_OutputFcn',  @Form_recSrcSegments_OutputFcn, ...
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

% --- Executes just before Form_recSrcSegments is made visible.
function Form_recSrcSegments_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Form_recSrcSegments (see VARARGIN)

% Choose default command line output for Form_recSrcSegments
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

[YourImage, ~, ImageAlpha] = imread('Icons/logo_eegnet_greybkg.png');
axes(handles.axes2);
imshow(YourImage)
% Make the GUI modal
set(handles.figure1,'WindowStyle','modal')
set(handles.figure1, 'Name', 'Preprocess selected epochs');
% % the inout should be the subject index
global subjectParent;
subjIndex = varargin{1};
subjectParent=varargin{2};

global allepochs;
global allepochs_preprocessed;
global subjIndex_in;

subjIndex_in=subjIndex;

input_files={};
nbsegments=0;
for i=1:size(allepochs,2)
    try
        allepochs{subjIndex,i}.data;
        nbsegments=nbsegments+1;         
        input_files{i}=['Epoch ' num2str(i)];
    catch
        break;
    end
end
% size(allepochs_preprocessed,2)
for i=1:size(allepochs_preprocessed,2)
    try
        allepochs_preprocessed{subjIndex,i}.data;  
        nbsegments=length(input_files);
        input_files{nbsegments+1}=['Preprocessed Epoch ' num2str(i)];
    catch
        continue;
    end
end

if(length(input_files)>0)
set(handles.listbox1,'String',input_files);
end

% Callback function definition
% UIWAIT makes Form_New wait for user response (see UIRESUME)
uiwait(handles.figure1);

% jb = javax.swing.JButton;
% jbh = handle(jb,'CallbackProperties');


% UIWAIT makes Form_recSrcSegments wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Form_recSrcSegments_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
% varargout{1} = handles.output;



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


% --- Executes on button press in push_reconstruct.
function push_reconstruct_Callback(hObject, eventdata, handles)
% hObject    handle to push_reconstruct (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global allepochs;
global allepochs_preprocessed;

global subjIndex_in;
global subjectParent;
global isPreprocessed;
global IndSegments;
isPreprocessed=[];
IndSegments=[];

segments=get(handles.listbox2,'String');
for i=1:length(segments)
    numb=segments{i};
    if(strcmp(numb(1:5),'Epoch'))
   
        numb=numb(7:end);
   
        IndSegments(i)=str2double(numb);
        isPreprocessed(i)=0;
        EEG{i}=allepochs{subjIndex_in,IndSegments(i)};
    else
% %         preprocessed segment
        numb=numb(20:end);
        isPreprocessed(i)=1;
        IndSegments(i)=str2double(numb);
        EEG{i}=allepochs_preprocessed{subjIndex_in,IndSegments(i)};
    end
end
    Form_inverseMethod(EEG,subjectParent,subjIndex_in);  

% % EEGs to reconstruct are in EEG

closereq;



% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox2.
function listbox2_Callback(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox2


% --- Executes during object creation, after setting all properties.
function listbox2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in push_remove.
function push_remove_Callback(hObject, eventdata, handles)
% hObject    handle to push_remove (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
v=handles.listbox2.Value;
s1=get(handles.listbox1,'String');
s2=get(handles.listbox2,'String');
s1=[s1;s2(v)];
set(handles.listbox1,'String',s1)
s2(v)=[];
set(handles.listbox2,'String',s2)
set(handles.listbox2,'Value',1)


% --- Executes on button press in push_add.
function push_add_Callback(hObject, eventdata, handles)
% hObject    handle to push_add (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
v=handles.listbox1.Value;
s1=get(handles.listbox1,'String');
s2=get(handles.listbox2,'String');
s2=[s2;s1(v)];
set(handles.listbox2,'String',s2')
s1(v)=[];
set(handles.listbox1,'String',s1')
set(handles.listbox1,'Value',1)

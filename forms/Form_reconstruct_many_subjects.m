function varargout = Form_reconstruct_many_subjects(varargin)
% PREPROCESS_MANY_SUBJECTS MATLAB code for preprocess_many_subjects.fig
%      PREPROCESS_MANY_SUBJECTS, by itself, creates a new PREPROCESS_MANY_SUBJECTS or raises the existing
%      singleton*.
%
%      H = PREPROCESS_MANY_SUBJECTS returns the handle to a new PREPROCESS_MANY_SUBJECTS or the handle to
%      the existing singleton*.
%
%      PREPROCESS_MANY_SUBJECTS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PREPROCESS_MANY_SUBJECTS.M with the given input arguments.
%
%      PREPROCESS_MANY_SUBJECTS('Property','Value',...) creates a new PREPROCESS_MANY_SUBJECTS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before preprocess_many_subjects_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to preprocess_many_subjects_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help preprocess_many_subjects

% Last Modified by GUIDE v2.5 23-Aug-2022 21:37:39

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @preprocess_many_subjects_OpeningFcn, ...
                   'gui_OutputFcn',  @preprocess_many_subjects_OutputFcn, ...
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


% --- Executes just before preprocess_many_subjects is made visible.
function preprocess_many_subjects_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to preprocess_many_subjects (see VARARGIN)

% Choose default command line output for preprocess_many_subjects
handles.output = hObject;


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

global subjectsParent;
subjectsParent=varargin{1};


[YourImage, ~, ImageAlpha] = imread('Icons/logo_eegnet_greybkg.png');
axes(handles.axes1);
imshow(YourImage)
% Make the GUI modal
set(handles.figure1,'WindowStyle','modal')
set(handles.figure1, 'Name', 'Reconstruct sources for multiple subjects');

global allsubjects;
global allepochs;
global subjIndex;
global allepochs;
global allepochs_preprocessed;


try
input_files=allsubjects.names;
catch
    msgbox('No subjects are included in the database');
    input_files=[];
end
if(length(input_files)>0)
    set(handles.pop_subjects,'String',input_files);
    % % put the epochs in list_allepochs
    subjIndex=get(handles.pop_subjects,'Value');
    strsubjIndex=num2str(subjIndex);
    count=1;
    for i=1:size(allepochs,2)
    try
        data{count}=allepochs{subjIndex,i}.data;
        list_epochs{count}=['S_' strsubjIndex '_epoch' num2str(i)];
        count=count+1;
    catch
        break;
    end
    end
    
    for i=1:size(allepochs_preprocessed,2)
    try
        data{count}=allepochs_preprocessed{subjIndex,i}.data;  
        list_epochs{count}=['S_' strsubjIndex '_Preprocessed Epoch ' num2str(i)];
        count=count+1;

    catch
        continue;
    end
    end
try
set(handles.list_all,'String',list_epochs);
catch
end
end


  
% UIWAIT makes preprocess_many_subjects wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = preprocess_many_subjects_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in pop_subjects.
function pop_subjects_Callback(hObject, eventdata, handles)
% hObject    handle to pop_subjects (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pop_subjects contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pop_subjects

global allsubjects;
global allepochs;
global subjIndex;
global allepochs;
global allepochs_preprocessed;
list_epochs={};
    subjIndex=get(handles.pop_subjects,'Value');
    strsubjIndex=num2str(subjIndex);
    count=1;
    for i=1:size(allepochs,2)
    try
        data{count}=allepochs{subjIndex,i}.data;
        list_epochs{count}=['S_' strsubjIndex '_epoch' num2str(i)];
        count=count+1;
    catch
        break;
    end
    end
    
    for i=1:size(allepochs_preprocessed,2)
    try
        data{count}=allepochs_preprocessed{subjIndex,i}.data;  
        list_epochs{count}=['S_' strsubjIndex '_Preprocessed Epoch ' num2str(i)];
        count=count+1;

    catch
        continue;
    end
    end
try
set(handles.list_all,'String',list_epochs);
catch
end

% --- Executes during object creation, after setting all properties.
function pop_subjects_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pop_subjects (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in list_selected.
function list_selected_Callback(hObject, eventdata, handles)
% hObject    handle to list_selected (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns list_selected contents as cell array
%        contents{get(hObject,'Value')} returns selected item from list_selected


% --- Executes during object creation, after setting all properties.
function list_selected_CreateFcn(hObject, eventdata, handles)
% hObject    handle to list_selected (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in list_all.
function list_all_Callback(hObject, eventdata, handles)
% hObject    handle to list_all (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns list_all contents as cell array
%        contents{get(hObject,'Value')} returns selected item from list_all


% --- Executes during object creation, after setting all properties.
function list_all_CreateFcn(hObject, eventdata, handles)
% hObject    handle to list_all (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
v=handles.list_selected.Value;
s1=get(handles.list_selected,'String');
s2=get(handles.list_all,'String');
s2=[s2;s1(v)];
set(handles.list_all,'String',s2')
s1(v)=[];
set(handles.list_selected,'String',s1')


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global allsubjects; 
global allepochs;
global subjectsParent;
global allepochs_preprocessed;
global isPreprocessed;
global IndSegments;

isPreprocessed=[];
IndSegments=[];

sel_epochs=get(handles.list_selected,'String');
% % preprocessed or epoch..
for e1=1:length(sel_epochs)
    subjectname=sel_epochs{e1};
    splits = split(subjectname,"_");
    subjIndex(e1)=str2double(splits{2});
    type=splits{3};
    if(strcmp(type(1),'P'))
           ep=str2double(type(20:end));
           EEG_in{e1}=allepochs_preprocessed{subjIndex(e1),ep};
           isPreprocessed(e1)=1;
           IndSegments(e1)=ep;

    else
            if(strcmp(type(1),'e'))
            ep=str2double(type(6:end));
            EEG_in{e1}=allepochs{subjIndex(e1),ep};
           isPreprocessed(e1)=0;
           IndSegments(e1)=ep;

            end
    end
end
closereq;
Form_inverseMethod(EEG_in,subjectsParent,subjIndex);  



% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
v=handles.list_all.Value;
s1=get(handles.list_all,'String');
s2=get(handles.list_selected,'String');
s2=[s2;s1(v)];

set(handles.list_selected,'String',s2')
s1(v)=[];
set(handles.list_all,'String',s1')

function varargout = dyn_SL1(varargin)
% DYN_SL1 MATLAB code for dyn_SL1.fig
%      DYN_SL1, by itself, creates a new DYN_SL1 or raises the existing
%      singleton*.
%
%      H = DYN_SL1 returns the handle to a new DYN_SL1 or the handle to
%      the existing singleton*.
%
%      DYN_SL1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DYN_SL1.M with the given input arguments.
%
%      DYN_SL1('Property','Value',...) creates a new DYN_SL1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before dyn_SL1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to dyn_SL1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help dyn_SL1

% Last Modified by GUIDE v2.5 29-Jun-2021 22:32:33

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @dyn_SL1_OpeningFcn, ...
                   'gui_OutputFcn',  @dyn_SL1_OutputFcn, ...
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


% --- Executes just before dyn_SL1 is made visible.
function dyn_SL1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to dyn_SL1 (see VARARGIN)

% Choose default command line output for dyn_SL1
handles.output = hObject;
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

set(handles.figure1,'WindowStyle','modal')
set(handles.figure1, 'Name', 'Dynamic analysis - select subject');
  movegui(handles.figure1,'center')  

[YourImage, ~, ImageAlpha] = imread('Icons/logo_eegnet_greybkg.png');
axes(handles.axes1);
imshow(YourImage)

% % get subject names
global allsubjects;
global alleegs_src_conn;
global alleegs_preprocessed_src_conn;
global allepochs_preprocessed_src_conn;
global allepochs_src_conn;
global subjIndex;

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

count=1;
    try 
        data1{count}=alleegs_src_conn{subjIndex}.conn.dynamic;
        list_epochs{count}='EEG';
                count=count+1;

    catch
    end

    try
        data1{count}=alleegs_preprocessed_src_conn{subjIndex}.conn.dynamic;
            list_epochs{count}='Preprocessed EEG';
        count=count+1;

    catch
    end
    

try
nbepochsPre=size(allepochs_preprocessed_src_conn(subjIndex,:),2);
    
if(nbepochsPre>0)
for ep=1:nbepochsPre
try
    data1{count}=allepochs_preprocessed_src_conn{subjIndex,ep}.conn.dynamic;
    list_epochs{count}= ['Preprocessed Epoch ' num2str(ep)];
    count=count+1;

catch
end
end
end
catch
end

try
nbepochsPre=size(allepochs_src_conn(subjIndex,:),2);
if(nbepochsPre>0)
for ep=1:nbepochsPre
try
    data1{count}=allepochs_src_conn{subjIndex,ep}.conn.dynamic;
    list_epochs{count}= ['Epoch ' num2str(ep)];
    count=count+1;

catch
end
end
end
catch
end

try
set(handles.list_allEpochs,'String',list_epochs);
catch
   msgbox('No available epochs','Warning');     
  
end
end
try
set(handles.list_selectedEpochs,'String','');
catch
       msgbox('No available epochs','Warning');     
end
% UIWAIT makes dyn_SL1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = dyn_SL1_OutputFcn(hObject, eventdata, handles) 
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
% % put the epochs in list_allepochs
% % get subject names
global allsubjects;
global alleegs_src_conn;
global alleegs_preprocessed_src_conn;
global allepochs_preprocessed_src_conn;
global allepochs_src_conn;

subjIndex=get(handles.pop_subjects,'Value')
list_epochs={};
count=1;
    try 
        data1{count}=alleegs_src_conn{subjIndex}.conn.dynamic;
        list_epochs{count}='EEG';
                count=count+1;

    catch
    end

    try
        data1{count}=alleegs_preprocessed_src_conn{subjIndex}.conn.dynamic;
            list_epochs{count}='Preprocessed EEG';
        count=count+1;

    catch
    end
    

try
nbepochsPre=size(allepochs_preprocessed_src_conn(subjIndex,:),2);
    
if(nbepochsPre>0)
for ep=1:nbepochsPre
try
    data1{count}=allepochs_preprocessed_src_conn{subjIndex,ep}.conn.dynamic;
    list_epochs{count}= ['Preprocessed Epoch ' num2str(ep)];
        count=count+1;

catch
end
end
end
catch
end

try
nbepochsPre=size(allepochs_src_conn(subjIndex,:),2);
if(nbepochsPre>0)
for ep=1:nbepochsPre
try
    data1{count}=allepochs_src_conn{subjIndex,ep}.conn.dynamic;
    list_epochs{count}= ['Epoch ' num2str(ep)];
    count=count+1;

catch
end
end
end
catch
end

set(handles.list_allEpochs,'String',list_epochs);
set(handles.list_selectedEpochs,'String','');


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


% --- Executes on selection change in list_allEpochs.
function list_allEpochs_Callback(hObject, eventdata, handles)
% hObject    handle to list_allEpochs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns list_allEpochs contents as cell array
%        contents{get(hObject,'Value')} returns selected item from list_allEpochs


% --- Executes during object creation, after setting all properties.
function list_allEpochs_CreateFcn(hObject, eventdata, handles)
% hObject    handle to list_allEpochs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in list_selectedEpochs.
function list_selectedEpochs_Callback(hObject, eventdata, handles)
% hObject    handle to list_selectedEpochs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns list_selectedEpochs contents as cell array
%        contents{get(hObject,'Value')} returns selected item from list_selectedEpochs


% --- Executes during object creation, after setting all properties.
function list_selectedEpochs_CreateFcn(hObject, eventdata, handles)
% hObject    handle to list_selectedEpochs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in push_add.
function push_add_Callback(hObject, eventdata, handles)
% hObject    handle to push_add (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
v=handles.list_allEpochs.Value;
s1=get(handles.list_allEpochs,'String');
s2=get(handles.list_selectedEpochs,'String');
s2=[s2;s1(v)];
set(handles.list_selectedEpochs,'String',s2')
s1(v)=[];
set(handles.list_allEpochs,'String',s1')
set(handles.list_allEpochs,'Value',1)


% --- Executes on button press in push_next.
function push_next_Callback(hObject, eventdata, handles)
% hObject    handle to push_next (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global alleegs_src_conn;
global alleegs_preprocessed_src_conn;
global allepochs_preprocessed_src_conn;
global allepochs_src_conn;
global subjIndex;
s2=get(handles.list_selectedEpochs,'String');
if(length(s2)>0)

subjIndex=get(handles.pop_subjects,'Value');

for i=1:length(s2)
    nom=s2{i};
    if(strcmp(s2{i},'EEG'))
        data1{i}=alleegs_src_conn{subjIndex}.conn.dynamic;

    else

    if(strcmp(s2{i},'Preprocessed EEG'))
        data1{i}=alleegs_preprocessed_src_conn{subjIndex}.conn.dynamic;
    else
    
          if(strcmp(nom(1:5),'Epoch'))
        epp=nom(7:end);
    data1{i}=allepochs_src_conn{subjIndex,str2double(epp)}.conn.dynamic;
    
          else 
        if(strcmp(nom(1:18),'Preprocessed Epoch'))
        epp=nom(20:end);
    data1{i}=allepochs_preprocessed_src_conn{subjIndex,str2double(epp)}.conn.dynamic;
        end
        
              
          end
    end
    end
    
end
end
closereq
Dyn_SL(data1,subjIndex,0);

% --- Executes on button press in push_remove.
function push_remove_Callback(hObject, eventdata, handles)
% hObject    handle to push_remove (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
v=handles.list_selectedEpochs.Value;
s2=get(handles.list_allEpochs,'String');
s1=get(handles.list_selectedEpochs,'String');
s2=[s2;s1(v)];
set(handles.list_allEpochs,'String',s2')
s1(v)=[];
set(handles.list_selectedEpochs,'String',s1')

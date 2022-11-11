function varargout = Form_GroupAnalysis(varargin)
% Form_GroupAnalysis MATLAB code for Form_GroupAnalysis.fig
%      Form_GroupAnalysis, by itself, creates a new Form_GroupAnalysis or raises the existing
%      singleton*.
%
%      H = Form_GroupAnalysis returns the handle to a new Form_GroupAnalysis or the handle to
%      the existing singleton*.
%
%      Form_GroupAnalysis('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in Form_GroupAnalysis.M with the given input arguments.
%
%      Form_GroupAnalysis('Property','Value',...) creates a new Form_GroupAnalysis or raises
%      the existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Form_GroupAnalysis_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Form_GroupAnalysis_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Form_GroupAnalysis

% Last Modified by GUIDE v2.5 16-Sep-2021 11:41:57

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Form_GroupAnalysis_OpeningFcn, ...
                   'gui_OutputFcn',  @Form_GroupAnalysis_OutputFcn, ...
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

% --- Executes just before Form_GroupAnalysis is made visible.
function Form_GroupAnalysis_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Form_GroupAnalysis (see VARARGIN)
  movegui(handles.figure1,'center')  

% Choose default command line output for Form_GroupAnalysis
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

[YourImage, ~, ImageAlpha] = imread('Icons/logo_eegnet_greybkg.png');
axes(handles.axes2);
imshow(YourImage)
% Make the GUI modal
set(handles.figure1,'WindowStyle','modal')
set(handles.figure1, 'Name', 'Group analysis');

% % the inout should be the subject index

global allsubjects;
global count_ext
global extG_mat;
global extG_fname;

extG_mat={};
extG_fname={};
count_ext=1;

input_files={};

try
input_files=allsubjects.names;
catch
    msgbox('No subjects are included in the database');
    input_files=[];
end

if(length(input_files)>0)
set(handles.list_all,'String',input_files);
end

set(handles.list_G1,'String',{});
set(handles.list_G2,'String',{});

% Callback function definition
% UIWAIT makes Form_New wait for user response (see UIRESUME)
uiwait(handles.figure1);

% jb = javax.swing.JButton;
% jbh = handle(jb,'CallbackProperties');


    % (now decide what to do with this key-press...)

% UIWAIT makes Form_GroupAnalysis wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Form_GroupAnalysis_OutputFcn(hObject, eventdata, handles)
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
% --- Executes on button press in push_browseChannels.

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


% --- Executes on button press in push_run.
function push_run_Callback(hObject, eventdata, handles)
% hObject    handle to push_run (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 

global extG_mat;
global extG_fname;
global allsubjects; 
global alleegs_src_conn;
global alleegs_preprocessed_src_conn;
global allepochs_preprocessed_src_conn;
global allepochs_src_conn;

group1_names=get(handles.list_G1,'String');
group2_names=get(handles.list_G2,'String');

data1=[];
data2=[];

count=1;
for g1=1:length(group1_names)
    subjectname=group1_names{g1};
    if(find(strcmp(subjectname,extG_fname)))
        fileIndex=find(strcmp(subjectname,extG_fname));
        
      data1{count}=extG_mat{fileIndex};
    count=count+1;

    else
     subjIndex=find(strcmp(allsubjects.names, subjectname));
%              pathfile= allsubjects.paths{subjIndex};
    
try 
    data1{count}=alleegs_src_conn{subjIndex}.conn.static;
    count=count+1;

catch
end

try
    data1{count}=alleegs_preprocessed_src_conn{subjIndex}.conn.static;
    count=count+1;
catch
end
    end

try
nbepochsPre=size(allepochs_preprocessed_src_conn(subjIndex,:),2);
    
if(nbepochsPre>0)
for ep=1:nbepochsPre
try
    data1{count}=allepochs_preprocessed_src_conn{subjIndex,ep}.conn.static;
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
    data1{count}=allepochs_src_conn{subjIndex,ep}.conn.static;
    count=count+1;
catch
end
end
end
catch
end
end
count=1;
for g2=1:length(group2_names)
    subjectname=group2_names{g2};
    
        if(find(strcmp(subjectname,extG_fname)))
        fileIndex=find(strcmp(subjectname,extG_fname));
        
      data2{count}=extG_mat{fileIndex};
    count=count+1;
        else
     subjIndex=find(strcmp(allsubjects.names, subjectname));
%              pathfile= allsubjects.paths{subjIndex};
try 
    data2{count}=alleegs_src_conn{subjIndex}.conn.static;
    count=count+1;

catch
end

try
    data2{count}=alleegs_preprocessed_src_conn{subjIndex}.conn.static;
    count=count+1;
catch
end

try
nbepochsPre=size(allepochs_preprocessed_src_conn(subjIndex,:),2);
    
if(nbepochsPre>0)
for ep=1:nbepochsPre
try
    data2{count}=allepochs_preprocessed_src_conn{subjIndex,ep}.conn.static;
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
    data2{count}=allepochs_src_conn{subjIndex,ep}.conn.static;
    count=count+1;
catch
end
end
end
catch
end
end
end


closereq;
if(isempty(data1)||isempty(data2))
    msgbox('Please ensure that both groups have connectivity matrices');
else
results_GA(data1,data2);
end
% 

% --- Executes on selection change in list_G1.
function list_G1_Callback(hObject, eventdata, handles)
% hObject    handle to list_G1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns list_G1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from list_G1


% --- Executes during object creation, after setting all properties.
function list_G1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to list_G1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in list_G2.
function list_G2_Callback(hObject, eventdata, handles)
% hObject    handle to list_G2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns list_G2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from list_G2


% --- Executes during object creation, after setting all properties.
function list_G2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to list_G2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in push_remove_G1.
function push_remove_G1_Callback(hObject, eventdata, handles)
% hObject    handle to push_remove_G1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
v=handles.list_G1.Value;
s1=get(handles.list_G1,'String');
s2=get(handles.list_all,'String');
s2=[s2;s1(v)];
set(handles.list_all,'String',s2')
s1(v)=[];
set(handles.list_G1,'String',s1')
set(handles.list_all,'Value',1)


% --- Executes on button press in push_add_G1.
function push_add_G1_Callback(hObject, eventdata, handles)
% hObject    handle to push_add_G1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
v=handles.list_all.Value;
s1=get(handles.list_all,'String');
s2=get(handles.list_G1,'String');
s2=[s2;s1(v)];
set(handles.list_G1,'String',s2')
s1(v)=[];
set(handles.list_all,'String',s1')
set(handles.list_G1,'Value',1)


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


% --- Executes on button press in push_removeG2.
function push_removeG2_Callback(hObject, eventdata, handles)
% hObject    handle to push_removeG2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

v=handles.list_G2.Value;
s1=get(handles.list_G2,'String');
s2=get(handles.list_all,'String');
s2=[s2;s1(v)];
set(handles.list_all,'String',s2')
s1(v)=[];
set(handles.list_G2,'String',s1')
set(handles.list_all,'Value',1)

% --- Executes on button press in push_addG2.
function push_addG2_Callback(hObject, eventdata, handles)
% hObject    handle to push_addG2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
v=handles.list_all.Value;
s1=get(handles.list_all,'String');
s2=get(handles.list_G2,'String');
s2=[s2;s1(v)];
set(handles.list_G2,'String',s2')
s1(v)=[];
set(handles.list_all,'String',s1')
set(handles.list_G2,'Value',1)


% --- Executes on button press in push_extG1.
function push_extG1_Callback(hObject, eventdata, handles)
% hObject    handle to push_extG1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global count_ext
global extG_mat;
global extG_fname;

% % add conn matrices
[filename,pathname]=uigetfile({'*.mat','Import external connectivity matrix (*.mat)'});
if isequal(filename,0)||isequal(pathname,0)
    return
else
    fpath=fullfile(pathname,filename);
end
try
cellOut=struct2cell(load(fpath));
mat=(cellOut{1}); 
extG_fname{count_ext}=filename;
extG_mat{count_ext}=mat;

count_ext=count_ext+1;
s1=get(handles.list_G1,'String');
s1{end+1}=filename;
set(handles.list_G1,'String',s1')
catch
end

% --- Executes on button press in push_remextG1.
function push_remextG1_Callback(hObject, eventdata, handles)
% hObject    handle to push_remextG1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in push_extG2.
function push_extG2_Callback(hObject, eventdata, handles)
% hObject    handle to push_extG2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global count_ext
global extG_mat;
global extG_fname;
% % add conn matrices
[filename,pathname]=uigetfile({'*.mat','Import external connectivity matrix (*.mat)'});
if isequal(filename,0)||isequal(pathname,0)
    return
else
    fpath=fullfile(pathname,filename);
end

try
 cellOut=struct2cell(load(fpath));
 mat=(cellOut{1});
 
s2=get(handles.list_G2,'String');
s2{end+1}=filename;
set(handles.list_G2,'String',s2')

extG_fname{count_ext}=filename;
extG_mat{count_ext}=mat;
count_ext=count_ext+1;
catch
end

function varargout = Form_DA_GA(varargin)
% Form_DA_GA MATLAB code for Form_DA_GA.fig
%      Form_DA_GA, by itself, creates a new Form_DA_GA or raises the existing
%      singleton*.
%
%      H = Form_DA_GA returns the handle to a new Form_DA_GA or the handle to
%      the existing singleton*.
%
%      Form_DA_GA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in Form_DA_GA.M with the given input arguments.
%
%      Form_DA_GA('Property','Value',...) creates a new Form_DA_GA or raises
%      the existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Form_DA_GA_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Form_DA_GA_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Form_DA_GA

% Last Modified by GUIDE v2.5 13-Jul-2021 21:26:12

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Form_DA_GA_OpeningFcn, ...
                   'gui_OutputFcn',  @Form_DA_GA_OutputFcn, ...
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

% --- Executes just before Form_DA_GA is made visible.
function Form_DA_GA_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Form_DA_GA (see VARARGIN)

% Choose default command line output for Form_DA_GA
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
set(handles.figure1, 'Name', 'Group analysis');

% % the inout should be the subject index

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
set(handles.pop_subject,'String',input_files);

% % put the epochs in list_allepochs
subjIndex=get(handles.pop_subject,'Value');
strsubjIndex=num2str(subjIndex);
count=1;
    try 
        data1{count}=alleegs_src_conn{subjIndex}.conn.dynamic;
        list_epochs{count}=['S_' strsubjIndex '_EEG'];
                count=count+1;

    catch
    end

    try
        data1{count}=alleegs_preprocessed_src_conn{subjIndex}.conn.dynamic;
            list_epochs{count}=['S_' strsubjIndex '_Preprocessed EEG'];
        count=count+1;

    catch
    end
    

try
nbepochsPre=size(allepochs_preprocessed_src_conn(subjIndex,:),2);
    
if(nbepochsPre>0)
for ep=1:nbepochsPre
try
    data1{count}=allepochs_preprocessed_src_conn{subjIndex,ep}.conn.dynamic;
    list_epochs{count}= ['S_' strsubjIndex '_Preprocessed Epoch_' num2str(ep)];
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
    list_epochs{count}= ['S_' strsubjIndex '_Epoch_' num2str(ep)];
    count=count+1;

catch
end
end
end
catch
end

set(handles.list_all,'String',list_epochs);
end

set(handles.list_G1,'String',{});
set(handles.list_G2,'String',{});

% Callback function definition
% UIWAIT makes Form_New wait for user response (see UIRESUME)
uiwait(handles.figure1);

% jb = javax.swing.JButton;
% jbh = handle(jb,'CallbackProperties');


    % (now decide what to do with this key-press...)

% UIWAIT makes Form_DA_GA wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Form_DA_GA_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
% varargout{1} = handles.output;






% --- Executes during object creation, after setting all properties

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

global allsubjects; 
global alleegs_src_conn;
global alleegs_preprocessed_src_conn;
global allepochs_preprocessed_src_conn;
global allepochs_src_conn;

group1_names=get(handles.list_G1,'String');
group2_names=get(handles.list_G2,'String');

data1=[];
data2=[];

for g1=1:length(group1_names)
    subjectname=group1_names{g1};
    splits = split(subjectname,"_");
    subjIndex=str2double(splits{2});
    type=splits{3};
    switch (type)
        case 'EEG'
            data1{g1}=alleegs_src_conn{subjIndex}.conn.dynamic;
        case 'Preprocessed EEG'
             data1{g1}=alleegs_preprocessed_src_conn{subjIndex}.conn.dynamic;

        case 'Preprocessed Epoch'
            ep=str2double(splits{4});
            data1{g1}=allepochs_preprocessed_src_conn{subjIndex,ep}.conn.dynamic;
        case 'Epoch'
                        ep=str2double(splits{4});
            data1{g1}=allepochs_src_conn{subjIndex,ep}.conn.dynamic;

    end
end


for g2=1:length(group2_names)
    subjectname=group2_names{g2};
    splits = split(subjectname,"_");
    subjIndex=str2double(splits{2});
    type=splits{3};
    switch (type)
        case 'EEG'
            data2{g2}=alleegs_src_conn{subjIndex}.conn.dynamic;
        case 'Preprocessed EEG'
             data2{g2}=alleegs_preprocessed_src_conn{subjIndex}.conn.dynamic;

        case 'Preprocessed Epoch'
            ep=str2double(splits{4});
            data2{g2}=allepochs_preprocessed_src_conn{subjIndex,ep}.conn.dynamic;
        case 'Epoch'
                        ep=str2double(splits{4});
            data2{g2}=allepochs_src_conn{subjIndex,ep}.conn.dynamic;

    end
end

closereq;
if(isempty(data1)||isempty(data2))
    msgbox('Please ensure that both groups have connectivity matrices');
else
    % % 1: if there is common bands: for each band compute the difference in the selected parameter 
    theta_dat1=0;
    alpha_dat1=0;
    beta_dat1=0;
    delta_dat1=0;
    gamma_dat1=0;
    custom_dat1=0;

    theta_dat2=0;
    alpha_dat2=0;
    beta_dat2=0;
    delta_dat2=0;
    gamma_dat2=0;
    custom_dat2=0;
    
    theta_common=0;
    alpha_common=0;
    beta_common=0;
    delta_common=0;
    gamma_common=0;
    custom_common=0;

    for i=1:length(data1)
    if(isfield(data1{i},'theta'))
        theta_dat1=1;
     %break; 
    end
    if(isfield(data1{i},'alpha'))
        alpha_dat1=1;
     %break; 
    end

    if(isfield(data1{i},'delta'))
        delta_dat1=1;
     %break; 
    end
    if(isfield(data1{i},'beta'))
        beta_dat1=1;
     %break; 
    end

    if(isfield(data1{i},'gamma'))
        gamma_dat1=1;
     %break; 
    end
    if(isfield(data1{i},'custom'))
        custom_dat1=1;
     %break; 
    end

    end

    for i=1:length(data2)
    if(isfield(data2{i},'theta'))
        theta_dat2=1;
     %break; 
    end
    if(isfield(data2{i},'alpha'))
        alpha_dat2=1;
     %break; 
    end

    if(isfield(data2{i},'delta'))
        delta_dat2=1;
     %break; 
    end
    if(isfield(data2{i},'beta'))
        beta_dat2=1;
     %break; 
    end

    if(isfield(data2{i},'gamma'))
        gamma_dat2=1;
     %break; 
    end
    if(isfield(data2{i},'custom'))
        custom_dat2=1;
     %break; 
    end

    end

    if(theta_dat1)&&(theta_dat2)
        theta_common=1;
    end
    if(alpha_dat1)&&(alpha_dat2)
        alpha_common=1;
    end
    if(delta_dat1)&&(delta_dat2)
        delta_common=1;
    end
    if(gamma_dat1)&&(gamma_dat2)
        gamma_common=1;
    end
    if(beta_dat1)&&(beta_dat2)
        beta_common=1;
    end
    if(custom_dat1)&&(custom_dat2)
        custom_common=1;
    end

    if(custom_common==0)&&(delta_common==0)&&(theta_common==0)&&(alpha_common==0)&&(beta_common==0)&&(gamma_common==0)
    msgbox('There is no common bands between the two selected groups');
    closereq;
    else
                       allmat_g1={};
numberEpochsG1.theta=0;
numberEpochsG1.alpha=0;
numberEpochsG1.beta=0;
numberEpochsG1.delta=0;
numberEpochsG1.gamma=0;
numberEpochsG1.custom=0;

         if(custom_common)
               for i=1:length(data1)
                if(isfield(data1{i},'custom'))
                    allmat_g1{end+1}.custom=data1{i}.custom;
                    numberEpochsG1.custom=numberEpochsG1.custom+size(data1{i}.custom,1);

                end
               end
                for i=1:length(data2)
                if(isfield(data2{i},'custom'))
                    allmat_g1{end+1}.custom=data2{i}.custom;
                end
                end      
         end

          if(delta_common)
%                allmat_g1.delta={};
               
               for i=1:length(data1)
                if(isfield(data1{i},'delta'))
                    allmat_g1{end+1}.delta=data1{i}.delta;
                 numberEpochsG1.delta=numberEpochsG1.delta+size(data1{i}.delta,1);

                end
               end
                for i=1:length(data2)
                if(isfield(data2{i},'delta'))
                    allmat_g1{end+1}.delta=data2{i}.delta;
                end
               end

          end

             if(alpha_common)
%                allmat_g1.alpha={};
               for i=1:length(data1)
                if(isfield(data1{i},'alpha'))
                    allmat_g1{end+1}.alpha=data1{i}.alpha;
                 numberEpochsG1.alpha=numberEpochsG1.alpha+size(data1{i}.alpha,1);

                end
               end
                for i=1:length(data2)
                if(isfield(data2{i},'alpha'))
                    allmat_g1{end+1}.alpha=data2{i}.alpha;
                end
               end

             end

                if(theta_common)
%                allmat_g1.theta={};
               for i=1:length(data1)
                if(isfield(data1{i},'theta'))
                    allmat_g1{end+1}.theta=data1{i}.theta;
                    numberEpochsG1.theta=numberEpochsG1.theta+size(data1{i}.theta,1);
                end
               end
                for i=1:length(data2)
                if(isfield(data2{i},'theta'))
                    allmat_g1{end+1}.theta=data2{i}.theta;
                end
               end

                end
            if(beta_common)
%                allmat_g1.beta={};
               for i=1:length(data1)
                if(isfield(data1{i},'beta'))
                    allmat_g1{end+1}.beta=data1{i}.beta;
                      numberEpochsG1.beta=numberEpochsG1.beta+size(data1{i}.beta,1);

                end
               end
                for i=1:length(data2)
                if(isfield(data2{i},'beta'))
                    allmat_g1{end+1}.beta=data2{i}.beta;
                end
               end

            end

               if(gamma_common)
%                allmat_g1.gamma={};
               for i=1:length(data1)
                if(isfield(data1{i},'gamma'))
                    allmat_g1{end+1}.gamma=data1{i}.gamma;
                    numberEpochsG1.gamma=numberEpochsG1.gamma+size(data1{i}.gamma,1);

                end
               end
                for i=1:length(data2)
                if(isfield(data2{i},'gamma'))
                    allmat_g1{end+1}.gamma=data2{i}.gamma;
                end
                end
               end
      Dyn_SL(allmat_g1,numberEpochsG1,1);       
    end
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
% set(handles.list_all,'Value',1)


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
% set(handles.list_G1,'Value',1)


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
% set(handles.list_all,'Value',1)

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
% set(handles.list_G2,'Value',1)


% --- Executes on button press in push_extG1.

% --- Executes on button press in push_remextG1.
function push_remextG1_Callback(hObject, eventdata, handles)
% hObject    handle to push_remextG1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in push_extG2.


% --- Executes on selection change in pop_subject.
function pop_subject_Callback(hObject, eventdata, handles)
% hObject    handle to pop_subject (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pop_subject contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pop_subject
% % put the epochs in list_allepochs
global allsubjects;
global alleegs_src_conn;
global alleegs_preprocessed_src_conn;
global allepochs_preprocessed_src_conn;
global allepochs_src_conn;

subjIndex=get(handles.pop_subject,'Value');
strsubjIndex=num2str(subjIndex);
list_epochs={};

count=1;
    try 
        data1{count}=alleegs_src_conn{subjIndex}.conn.dynamic;
        list_epochs{count}=['S_' strsubjIndex '_EEG'];
                count=count+1;

    catch
    end

    try
        data1{count}=alleegs_preprocessed_src_conn{subjIndex}.conn.dynamic;
            list_epochs{count}=['S_' strsubjIndex '_Preprocessed EEG'];
        count=count+1;

    catch
    end
    

try
nbepochsPre=size(allepochs_preprocessed_src_conn(subjIndex,:),2);
    
if(nbepochsPre>0)
for ep=1:nbepochsPre
try
    data1{count}=allepochs_preprocessed_src_conn{subjIndex,ep}.conn.dynamic;
    list_epochs{count}= ['S_' strsubjIndex '_Preprocessed Epoch_' num2str(ep)];
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
    list_epochs{count}= ['S_' strsubjIndex '_Epoch_' num2str(ep)];
    count=count+1;

catch
end
end
end
catch
end

set(handles.list_all,'String',list_epochs);


% --- Executes during object creation, after setting all properties.
function pop_subject_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pop_subject (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

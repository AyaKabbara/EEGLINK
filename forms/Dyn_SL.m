function varargout = Dyn_SL(varargin)
% Dyn_SL MATLAB code for Dyn_SL.fig
%      Dyn_SL, by itself, creates a new Dyn_SL or raises the existing
%      singleton*.
%
%      H = Dyn_SL returns the handle to a new Dyn_SL or the handle to
%      the existing singleton*.
%
%      Dyn_SL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in Dyn_SL.M with the given input arguments.
%
%      Dyn_SL('Property','Value',...) creates a new Dyn_SL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Dyn_SL_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Dyn_SL_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Dyn_SL

% Last Modified by GUIDE v2.5 12-Aug-2021 18:07:53

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Dyn_SL_OpeningFcn, ...
                   'gui_OutputFcn',  @Dyn_SL_OutputFcn, ...
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


% --- Executes just before Dyn_SL is made visible.
function Dyn_SL_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Dyn_SL (see VARARGIN)

set(handles.figure1,'WindowStyle','modal')
set(handles.figure1, 'Name', 'Dynamic analysis');
  movegui(handles.figure1,'center')  

[YourImage, ~, ImageAlpha] = imread('Icons/logo_eegnet_greybkg.png');
axes(handles.axes1);
imshow(YourImage)
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
global data1 subjIndex multiple secondparam;
data1 = varargin{1};
secondparam=varargin{2};
multiple=varargin{3};

if(multiple==0)
    subjIndex=secondparam;
else
    set(handles.pop_dataForm,'Visible','off');
    set(handles.pop_dataForm,'Value',1);
    subjIndex=1;
end

 set(handles.push_deltaRes,'Enable','off')
 set(handles.push_thetaRes,'Enable','off')
 set(handles.push_alphaRes,'Enable','off')
 set(handles.push_betaRes,'Enable','off')
 set(handles.push_gammaRes,'Enable','off')
 set(handles.push_customRes,'Enable','off')

% Choose default command line output for Dyn_SL
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


% UIWAIT makes Dyn_SL wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Dyn_SL_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in push_run.


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in list_subjects.
function list_subjects_Callback(hObject, eventdata, handles)
% hObject    handle to list_subjects (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns list_subjects contents as cell array
%        contents{get(hObject,'Value')} returns selected item from list_subjects

% --- Executes during object creation, after setting all properties.
function list_subjects_CreateFcn(hObject, eventdata, handles)
% hObject    handle to list_subjects (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


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



function edit_maxIter_Callback(hObject, eventdata, handles)
% hObject    handle to edit_maxIter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_maxIter as text
%        str2double(get(hObject,'String')) returns contents of edit_maxIter as a double


% --- Executes during object creation, after setting all properties.
function edit_maxIter_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_maxIter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_ttest_alpha_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ttest_alpha (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ttest_alpha as text
%        str2double(get(hObject,'String')) returns contents of edit_ttest_alpha as a double


% --- Executes during object creation, after setting all properties.
function edit_ttest_alpha_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ttest_alpha (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Nrep_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Nrep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Nrep as text
%        str2double(get(hObject,'String')) returns contents of edit_Nrep as a double


% --- Executes during object creation, after setting all properties.
function edit_Nrep_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Nrep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in push_deltaRes.

% --- Executes on selection change in list_contrast.
function list_contrast_Callback(hObject, eventdata, handles)
% hObject    handle to list_contrast (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns list_contrast contents as cell array
%        contents{get(hObject,'Value')} returns selected item from list_contrast


% --- Executes during object creation, after setting all properties.
function list_contrast_CreateFcn(hObject, eventdata, handles)
% hObject    handle to list_contrast (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_ttestThresh_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ttestThresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ttestThresh as text
%        str2double(get(hObject,'String')) returns contents of edit_ttestThresh as a double


% --- Executes during object creation, after setting all properties.
function edit_ttestThresh_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ttestThresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Nmicrostates_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Nmicrostates (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Nmicrostates as text
%        str2double(get(hObject,'String')) returns contents of edit_Nmicrostates as a double


% --- Executes during object creation, after setting all properties.
function edit_Nmicrostates_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Nmicrostates (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pop_algo.
function pop_algo_Callback(hObject, eventdata, handles)
% hObject    handle to pop_algo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pop_algo contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pop_algo
al = get(handles.pop_algo,'Value');
if(al==3)
  set(handles.panel_taahc,'Visible','on');
   set(handles.panel_kmeans,'Visible','off');
  set(handles.panel_taahc,'Visible','on');

else
      set(handles.panel_taahc,'Visible','off');
   set(handles.panel_kmeans,'Visible','on');

end


% --- Executes during object creation, after setting all properties.
function pop_algo_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pop_algo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in list_tail.
function list_tail_Callback(hObject, eventdata, handles)
% hObject    handle to list_tail (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns list_tail contents as cell array
%        contents{get(hObject,'Value')} returns selected item from list_tail


% --- Executes during object creation, after setting all properties.
function list_tail_CreateFcn(hObject, eventdata, handles)
% hObject    handle to list_tail (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pop_dataForm.
function pop_dataForm_Callback(hObject, eventdata, handles)
% hObject    handle to pop_dataForm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pop_dataForm contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pop_dataForm


% --- Executes during object creation, after setting all properties.
function pop_dataForm_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pop_dataForm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pop_sorting.
function pop_sorting_Callback(hObject, eventdata, handles)
% hObject    handle to pop_sorting (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pop_sorting contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pop_sorting


% --- Executes during object creation, after setting all properties.
function pop_sorting_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pop_sorting (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_convThresh_Callback(hObject, eventdata, handles)
% hObject    handle to edit_convThresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_convThresh as text
%        str2double(get(hObject,'String')) returns contents of edit_convThresh as a double


% --- Executes during object creation, after setting all properties.
function edit_convThresh_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_convThresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in check_polarity.
function check_polarity_Callback(hObject, eventdata, handles)
% hObject    handle to check_polarity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of check_polarity


% --- Executes on button press in check_det.
function check_det_Callback(hObject, eventdata, handles)
% hObject    handle to check_det (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of check_det


% --- Executes on button press in push_run.
function push_run_Callback(hObject, eventdata, handles)
% hObject    handle to push_run (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global data1;
global subjIndex; 
global alleegs;
global allsubjects;
conc=get(handles.pop_dataForm,'Value');
% try
%     srate=alleegs{subjIndex}.srate;
%     
% catch
%     srate=1;
% end
srate=1;
% %  aggregate all frequency specific dynamic matrices from epochs
for i=1:length(data1)
    if(isfield(data1{i},'delta'))
      con.delta{i}=reshape(data1{i}.delta,size(data1{i}.delta,1),size(data1{i}.delta,2)*size(data1{i}.delta,3));
    end
       if(isfield(data1{i},'theta'))
      con.theta{i}=reshape(data1{i}.theta,size(data1{i}.theta,1),size(data1{i}.theta,2)*size(data1{i}.theta,3));
       end
           if(isfield(data1{i},'alpha'))
      con.alpha{i}=reshape(data1{i}.alpha,size(data1{i}.alpha,1),size(data1{i}.alpha,2)*size(data1{i}.alpha,3));
    end
           if(isfield(data1{i},'beta'))
      con.beta{i}=reshape(data1{i}.beta,size(data1{i}.beta,1),size(data1{i}.beta,2)*size(data1{i}.beta,3));
           end
               if(isfield(data1{i},'gamma'))
      con.gamma{i}=reshape(data1{i}.gamma,size(data1{i}.gamma,1),size(data1{i}.gamma,2)*size(data1{i}.gamma,3));
    end
               if(isfield(data1{i},'custom'))
      con.custom{i}=reshape(data1{i}.custom,size(data1{i}.custom,1),size(data1{i}.custom,2)*size(data1{i}.custom,3));
               end
end
% % if the user chooses to concatenate epochs or average epochs

switch(conc)
    
    case 1
        if(isfield(con,'delta'))
            dataeeg.delta=[];
        for i=1:length(con.delta)
                        dataeeg.delta=[dataeeg.delta; con.delta{i}];
        end
        end
         if(isfield(con,'theta'))
% %         concatenate epochs
        dataeeg.theta=[];
        for i=1:length(con.theta)
            dataeeg.theta=[dataeeg.theta; con.theta{i}];
        end
         end
         if(isfield(con,'alpha'))
            dataeeg.alpha=[];
        for i=1:length(con.alpha)
                        dataeeg.alpha=[dataeeg.alpha; con.alpha{i}];
        end
         end
        if(isfield(con,'beta'))
            dataeeg.beta=[];
        for i=1:length(con.beta)
                        dataeeg.beta=[dataeeg.beta; con.beta{i}];
        end
        end
        if(isfield(con,'gamma'))
            dataeeg.gamma=[];
        for i=1:length(con.gamma)
                        dataeeg.gamma=[dataeeg.gamma; con.gamma{i}];
        end
        end
        if(isfield(con,'custom'))
            dataeeg.custom=[];
        for i=1:length(con.custom)
                        dataeeg.custom=[dataeeg.custom; con.custom{i}];
        end
        end
    case 2
        if(isfield(con,'theta'))
% %         average epochs
        dataeeg.theta=[];
        for i=1:length(con.theta)
            dataeeg.theta(i,:,:)=con.theta{i};
        end
        dataeeg.theta=squeeze(mean(dataeeg.theta,1));
        end
         if(isfield(con,'delta'))
% %         average epochs
        dataeeg.delta=[];
        for i=1:length(con.delta)
            dataeeg.delta(i,:,:)=con.delta{i};
        end
        dataeeg.delta=squeeze(mean(dataeeg.delta,1));
         end
         if(isfield(con,'alpha'))
% %         average epochs
        dataeeg.alpha=[];
        for i=1:length(con.alpha)
            dataeeg.alpha(i,:,:)=con.alpha{i};
        end
        dataeeg.alpha=squeeze(mean(dataeeg.alpha,1));
         end
         if(isfield(con,'beta'))
% %         average epochs
        dataeeg.beta=[];
        for i=1:length(con.beta)
            dataeeg.beta(i,:,:)=con.beta{i};
        end
        dataeeg.beta=squeeze(mean(dataeeg.beta,1));
         end
         if(isfield(con,'gamma'))
% %         average epochs
        dataeeg.gamma=[];
        for i=1:length(con.gamma)
            dataeeg.gamma(i,:,:)=con.gamma{i};
        end
        dataeeg.gamma=squeeze(mean(dataeeg.gamma,1));
         end
         if(isfield(con,'custom'))
% %         average epochs
        dataeeg.custom=[];
        for i=1:length(con.custom)
            dataeeg.custom(i,:,:)=con.custom{i};
        end
        dataeeg.custom=squeeze(mean(dataeeg.custom,1));
        end
end


% % read params
sorting_index=get(handles.pop_sorting,'Value');
all_sorting=get(handles.pop_sorting,'String');
sorting_function=all_sorting{sorting_index};

Nmicrostates=get(handles.edit_Nmicrostates,'String');
index=strfind(Nmicrostates,':');
if(index>0)
    Nstates=str2double(Nmicrostates(1:index-1)):str2double(Nmicrostates(index+1:end));
else
    Nstates=str2double(Nmicrostates);
    
end

Nrepetitions=str2double(get(handles.edit_Nrep,'String'));

Thresh_conv=str2double(get(handles.edit_convThresh,'String'));
maximumIterations=str2double(get(handles.edit_maxIter,'String'));

polarity=get(handles.check_polarity,'Value');
determinism=get(handles.check_det,'Value');

global results;
addpath(genpath('external/eeglab13_1_1b'));
f = waitbar(0,'Please wait...');

% % write EEGLAB structure to run the code
if(isfield(dataeeg,'delta'))
EEG=writeEEGLAB_struct(dataeeg.delta',srate,allsubjects.names{subjIndex},'','','');
EEG = pop_micro_selectdata ( EEG,EEG,'datatype','ERPconc');

switch(get(handles.pop_algo,'Value'))
    case 1
   EEG = pop_micro_segment ( EEG,'algorithm','kmeans','sorting',sorting_function,'Nmicrostates',Nstates,'Nrepetitions',Nrepetitions,'max_iterations',maximumIterations);
    case 2
   EEG = pop_micro_segment ( EEG,'algorithm','modkmeans' ,'sorting',sorting_function,'Nmicrostates',Nstates,'Nrepetitions',Nrepetitions,'max_iterations',maximumIterations,'threshold',Thresh_conv);
    case 3
   EEG = pop_micro_segment ( EEG,'algorithm','varmicro' ,'sorting',sorting_function,'Nmicrostates',Nstates,'Nrepetitions',Nrepetitions,'max_iterations',maximumIterations,'threshold',Thresh_conv);
    case 4
      EEG = pop_micro_segment ( EEG,'algorithm','taahc' ,'sorting',sorting_function,'Nmicrostates',Nstates,'polarity',polarity,'determinism',determinism);
end
results.delta=EEG;
set(handles.push_deltaRes,'Enable','on');
end
if(isfield(dataeeg,'theta'))
EEG=writeEEGLAB_struct(dataeeg.theta',srate,allsubjects.names{subjIndex},'','','');
EEG = pop_micro_selectdata ( EEG,EEG,'datatype','ERPconc');

switch(get(handles.pop_algo,'Value'))
    case 1
   EEG = pop_micro_segment ( EEG,'algorithm','kmeans','sorting',sorting_function,'Nmicrostates',Nstates,'Nrepetitions',Nrepetitions,'max_iterations',maximumIterations);
    case 2
   EEG = pop_micro_segment ( EEG,'algorithm','modkmeans' ,'sorting',sorting_function,'Nmicrostates',Nstates,'Nrepetitions',Nrepetitions,'max_iterations',maximumIterations,'threshold',Thresh_conv);
    case 3
   EEG = pop_micro_segment ( EEG,'algorithm','varmicro' ,'sorting',sorting_function,'Nmicrostates',Nstates,'Nrepetitions',Nrepetitions,'max_iterations',maximumIterations,'threshold',Thresh_conv);
    case 4
      EEG = pop_micro_segment ( EEG,'algorithm','taahc' ,'sorting',sorting_function,'Nmicrostates',Nstates,'polarity',polarity,'determinism',determinism);
end
results.theta=EEG;
set(handles.push_thetaRes,'Enable','on');

end
if(isfield(dataeeg,'alpha'))
EEG=writeEEGLAB_struct(dataeeg.alpha',srate,allsubjects.names{subjIndex},'','','');
EEG = pop_micro_selectdata ( EEG,EEG,'datatype','ERPconc');

switch(get(handles.pop_algo,'Value'))
    case 1
   EEG = pop_micro_segment ( EEG,'algorithm','kmeans','sorting',sorting_function,'Nmicrostates',Nstates,'Nrepetitions',Nrepetitions,'max_iterations',maximumIterations);
    case 2
   EEG = pop_micro_segment ( EEG,'algorithm','modkmeans' ,'sorting',sorting_function,'Nmicrostates',Nstates,'Nrepetitions',Nrepetitions,'max_iterations',maximumIterations,'threshold',Thresh_conv);
    case 3
   EEG = pop_micro_segment ( EEG,'algorithm','varmicro' ,'sorting',sorting_function,'Nmicrostates',Nstates,'Nrepetitions',Nrepetitions,'max_iterations',maximumIterations,'threshold',Thresh_conv);
    case 4
      EEG = pop_micro_segment ( EEG,'algorithm','taahc' ,'sorting',sorting_function,'Nmicrostates',Nstates,'polarity',polarity,'determinism',determinism);
end
results.alpha=EEG;
set(handles.push_alphaRes,'Enable','on');

end
if(isfield(dataeeg,'beta'))
EEG=writeEEGLAB_struct(dataeeg.beta',srate,allsubjects.names{subjIndex},'','','');
EEG = pop_micro_selectdata ( EEG,EEG,'datatype','ERPconc');

switch(get(handles.pop_algo,'Value'))
    case 1
   EEG = pop_micro_segment ( EEG,'algorithm','kmeans','sorting',sorting_function,'Nmicrostates',Nstates,'Nrepetitions',Nrepetitions,'max_iterations',maximumIterations);
    case 2
   EEG = pop_micro_segment ( EEG,'algorithm','modkmeans' ,'sorting',sorting_function,'Nmicrostates',Nstates,'Nrepetitions',Nrepetitions,'max_iterations',maximumIterations,'threshold',Thresh_conv);
    case 3
   EEG = pop_micro_segment ( EEG,'algorithm','varmicro' ,'sorting',sorting_function,'Nmicrostates',Nstates,'Nrepetitions',Nrepetitions,'max_iterations',maximumIterations,'threshold',Thresh_conv);
    case 4
      EEG = pop_micro_segment ( EEG,'algorithm','taahc' ,'sorting',sorting_function,'Nmicrostates',Nstates,'polarity',polarity,'determinism',determinism);
end
results.beta=EEG;
set(handles.push_betaRes,'Enable','on');

end
if(isfield(dataeeg,'gamma'))
EEG=writeEEGLAB_struct(dataeeg.gamma',srate,allsubjects.names{subjIndex},'','','');
EEG = pop_micro_selectdata ( EEG,EEG,'datatype','ERPconc');

switch(get(handles.pop_algo,'Value'))
    case 1
   EEG = pop_micro_segment ( EEG,'algorithm','kmeans','sorting',sorting_function,'Nmicrostates',Nstates,'Nrepetitions',Nrepetitions,'max_iterations',maximumIterations);
    case 2
   EEG = pop_micro_segment ( EEG,'algorithm','modkmeans' ,'sorting',sorting_function,'Nmicrostates',Nstates,'Nrepetitions',Nrepetitions,'max_iterations',maximumIterations,'threshold',Thresh_conv);
    case 3
   EEG = pop_micro_segment ( EEG,'algorithm','varmicro' ,'sorting',sorting_function,'Nmicrostates',Nstates,'Nrepetitions',Nrepetitions,'max_iterations',maximumIterations,'threshold',Thresh_conv);
    case 4
      EEG = pop_micro_segment ( EEG,'algorithm','taahc' ,'sorting',sorting_function,'Nmicrostates',Nstates,'polarity',polarity,'determinism',determinism);
   EEG = pop_micro_segment ( EEG,'algorithm','varmicro' ,'sorting',sorting_function,'Nmicrostates',Nstates,'Nrepetitions',Nrepetitions,'max_iterations',maximumIterations,'threshold',Thresh_conv);
end
results.gamma=EEG;
set(handles.push_gammaRes,'Enable','on');

end
if(isfield(dataeeg,'custom'))
EEG=writeEEGLAB_struct(dataeeg.custom',srate,allsubjects.names{subjIndex},'','','');
EEG = pop_micro_selectdata ( EEG,EEG,'datatype','ERPconc');

switch(get(handles.pop_algo,'Value'))
    case 1
   EEG = pop_micro_segment ( EEG,'algorithm','kmeans','sorting',sorting_function,'Nmicrostates',Nstates,'Nrepetitions',Nrepetitions,'max_iterations',maximumIterations);
    case 2
   EEG = pop_micro_segment ( EEG,'algorithm','modkmeans' ,'sorting',sorting_function,'Nmicrostates',Nstates,'Nrepetitions',Nrepetitions,'max_iterations',maximumIterations,'threshold',Thresh_conv);
    case 3
   EEG = pop_micro_segment ( EEG,'algorithm','varmicro' ,'sorting',sorting_function,'Nmicrostates',Nstates,'Nrepetitions',Nrepetitions,'max_iterations',maximumIterations,'threshold',Thresh_conv);
    case 4
      EEG = pop_micro_segment ( EEG,'algorithm','taahc' ,'sorting',sorting_function,'Nmicrostates',Nstates,'polarity',polarity,'determinism',determinism);
     
end

results.custom=EEG;
set(handles.push_customRes,'Enable','on');

end
waitbar(1,f,'Finished');
close(f);

% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% --- Executes on button press in push_deltaRes.
function push_deltaRes_Callback(hObject, eventdata, handles)
% hObject    handle to push_thetaRes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global results multiple secondparam;
res=results.delta;
dynamic_labels=res.microstate.labels;
maps=res.microstate.prototypes;
if(multiple==0)
segment_Visualize(dynamic_labels,maps,0);
else
  numberEpochsG1=secondparam.delta;
  segment_Visualize(dynamic_labels,maps,numberEpochsG1);
end  

% % plot states dynamically in axes 

% % create 

% --- Executes on button press in push_thetaRes.
function push_thetaRes_Callback(hObject, eventdata, handles)
% hObject    handle to push_thetaRes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global results multiple secondparam;
res=results.theta;
dynamic_labels=res.microstate.labels;
maps=res.microstate.prototypes;
if(multiple==0)
segment_Visualize(dynamic_labels,maps,0);
else
  numberEpochsG1=secondparam.theta;
  segment_Visualize(dynamic_labels,maps,numberEpochsG1);
end  


% --- Executes on button press in push_alphaRes.
function push_alphaRes_Callback(hObject, eventdata, handles)
% hObject    handle to push_alphaRes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global results multiple secondparam;
res=results.alpha;
dynamic_labels=res.microstate.labels;
maps=res.microstate.prototypes;

if(multiple==0)
segment_Visualize(dynamic_labels,maps,0);
else
  numberEpochsG1=secondparam.alpha;
  segment_Visualize(dynamic_labels,maps,numberEpochsG1);
end  

% --- Executes on button press in push_alphaRes.
function push_betaRes_Callback(hObject, eventdata, handles)
% hObject    handle to push_alphaRes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global results multiple secondparam;
res=results.beta;
dynamic_labels=res.microstate.labels;
maps=res.microstate.prototypes;
if(multiple==0)
segment_Visualize(dynamic_labels,maps,0);
else
  numberEpochsG1=secondparam.beta;
  segment_Visualize(dynamic_labels,maps,numberEpochsG1);
end  


% --- Executes on button press in push_alphaRes.
function push_gammaRes_Callback(hObject, eventdata, handles)
% hObject    handle to push_alphaRes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global results multiple secondparam;
res=results.gamma;
dynamic_labels=res.microstate.labels;
maps=res.microstate.prototypes;
if(multiple==0)
segment_Visualize(dynamic_labels,maps,0);
else
  numberEpochsG1=secondparam.gamma;
  segment_Visualize(dynamic_labels,maps,numberEpochsG1);
end  


% --- Executes on button press in push_alphaRes.
function push_customRes_Callback(hObject, eventdata, handles)
% hObject    handle to push_alphaRes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global results multiple secondparam;
res=results.custom;
dynamic_labels=res.microstate.labels;
maps=res.microstate.prototypes;
if(multiple==0)
segment_Visualize(dynamic_labels,maps,0);
else
  numberEpochsG1=secondparam.custom;
  segment_Visualize(dynamic_labels,maps,numberEpochsG1);
end  



% --- Executes on button press in push_save.
function push_save_Callback(hObject, eventdata, handles)
% hObject    handle to push_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global results;
[filename, filepath] = uiputfile('*.mat', 'Save results:');
FileName = fullfile(filepath, filename);
save(FileName, 'results', '-v7.3');

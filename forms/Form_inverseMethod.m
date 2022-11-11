function varargout = Form_inverseMethod(varargin)
% FORM_INVERSEMETHOD MATLAB code for FORM_INVERSEMETHOD.fig
%      FORM_INVERSEMETHOD, by itself, creates a new FORM_INVERSEMETHOD or raises the existing
%      singleton*.
%
%      H = FORM_INVERSEMETHOD returns the handle to a new FORM_INVERSEMETHOD or the handle to
%      the existing singleton*.
%
%      FORM_INVERSEMETHOD('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FORM_INVERSEMETHOD.M with the given input arguments.
%
%      FORM_INVERSEMETHOD('Property','Value',...) creates a new FORM_INVERSEMETHOD or raises
%      the existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before FORM_INVERSEMETHOD_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to FORM_INVERSEMETHOD_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help FORM_INVERSEMETHOD

% Last Modified by GUIDE v2.5 16-Jun-2021 13:21:34

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @FORM_INVERSEMETHOD_OpeningFcn, ...
                   'gui_OutputFcn',  @FORM_INVERSEMETHOD_OutputFcn, ...
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

% --- Executes just before FORM_INVERSEMETHOD is made visible.
function FORM_INVERSEMETHOD_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to FORM_INVERSEMETHOD (see VARARGIN)

% Choose default command line output for FORM_INVERSEMETHOD
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

global EEG_in;
EEG_in = varargin{1};

global node_in;
node_in = varargin{2};
% % in multiple=1, node in is the subject directory 

global subjIndex_in;
subjIndex_in = varargin{3};

global multiple;
global mult_subj;

if(length(EEG_in)==1)
    multiple=0;
    mult_subj=0;
else
   multiple=1;
   if(length(subjIndex_in>1))
       mult_subj=1;
   else
       mult_subj=0;
   end
end

% Determine the position of the dialog - centered on the callback figure
% if available, else, centered on the screen
FigPos=get(0,'DefaultFigurePosition');
OldUnits = get(hObject, 'Units');
set(hObject, 'Units', 'pixels');
OldPos = get(hObject,'Position');
FigWidth = OldPos(3);
FigHeight = OldPos(4);
if isempty(gcbf)
    ScreenUnits=get(0,'Units');
    set(0,'Units','pixels');
    ScreenSize=get(0,'ScreenSize');
    set(0,'Units',ScreenUnits);

    FigPos(1)=1/2*(ScreenSize(3)-FigWidth);
    FigPos(2)=2/3*(ScreenSize(4)-FigHeight);
else
    GCBFOldUnits = get(gcbf,'Units');
    set(gcbf,'Units','pixels');
    GCBFPos = get(gcbf,'Position');
    set(gcbf,'Units',GCBFOldUnits);
    FigPos(1:2) = [(GCBFPos(1) + GCBFPos(3) / 2) - FigWidth / 2, ...
                   (GCBFPos(2) + GCBFPos(4) / 2) - FigHeight / 2];
end
FigPos(3:4)=[FigWidth FigHeight];
set(hObject, 'Position', FigPos);
set(hObject, 'Units', OldUnits);

% 
[YourImage, ~, ImageAlpha] = imread('Icons/logo_eegnet_greybkg.png');
axes(handles.axes1);
imshow(YourImage)
% Make the GUI modal
set(handles.figure1,'WindowStyle','modal')
set(handles.figure1, 'Name', 'Compute sources');


% Callback function definition
% UIWAIT makes Form_New wait for user response (see UIRESUME)
uiwait(handles.figure1);

% jb = javax.swing.JButton;
% jbh = handle(jb,'CallbackProperties');

    % (now decide what to do with this key-press...)

% UIWAIT makes FORM_INVERSEMETHOD wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = FORM_INVERSEMETHOD_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
% varargout{1} = handles.output;


% --- Executes on button press in push_go.
function push_go_Callback(hObject, eventdata, handles)
% hObject    handle to push_go (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global EEG_in;
global node_in;
% % % external globals
global allmodels;
global tree;
global treeModel;
global fig1;
global plotting_panel;
global info_panel;
global allsubjects;
global alleegs;
global alleegs_src;
global subjIndex_in;
global allnoise;
global multiple;
global alleegs_src;
global allepochs_src;
global alleegs_preprocessed_src;
global allepochs_preprocessed_src;
global IndSegments;
global isPreprocessed;
global mult_subj;

default_head='data/Inverse/tess_head.mat';
default_cortex='data/Inverse/tess_cortex_pial_low.mat';
default_outer='data/Inverse/tess_outerskull.mat';
default_inner='data/Inverse/tess_innerskull.mat';

% subjIndex_in=find(strcmp(allsubjects.names, subjectname));
try
    cond1=str2double(get(handles.scalp_cond,'String'));
    cond2=str2double(get(handles.skull_cond,'String'));
    cond3=str2double(get(handles.brain_cond,'String'));
catch
    msgbox('Please enter valid numbers in conductivity parameters','Warning');     
end
Cond=[cond1,cond2,cond3];

InvMeth=get(handles.pop_inversemethod,'Value');
ok=1;


% % ext-4: LCMV
        
atlas=get(handles.pop_atlas,'Value');

ext=get(handles.pop_scoutfunction,'Value')
switch ext
    case 1
        ScoutFunction='mean';
    case 2        
        ScoutFunction='pca';
    case 3
      ScoutFunction='fastpca';
    case 4
        ScoutFunction='mean_norm';
    case 5
        ScoutFunction='max';
    case 6
      ScoutFunction='power';
       case 7
      ScoutFunction='none';
end


if(get(handles.rd_default,'Value'))
    FileHead=default_head;
    FileInner=default_inner;
    FileOuter=default_outer;
    FileCortex=default_cortex;
    
else
   if(get(handles.rd_fs,'Value'))
       selpath = uigetdir(matlabroot,'Import freesurfer folder');

       if(isempty(selpath))
           msgbox('No freesurfer folder is selected');
           ok=0;
       else
           
           [FileHead,FileInner,FileOuter,FileCortex]=import_anatomy_fs_AK(selpath, [], 0,[]);
           if(strcmp(FileInner,''))||(strcmp(FileInner,''))||(strcmp(FileOuter,''))||(strcmp(FileCortex,''))
               ok=0;
              msgbox('A problem is detected when loading the freesurfer folder');

           else
               ok=1;
           end
       end
   end
  
end

if(ok)
if(multiple==0)
try
    noisecov=allnoise{subjIndex_in};
    if(sum(isnan(noisecov))>0)
            noisecov=eye(size(EEG_in.data,1),size(EEG_in.data,1));
            noisecov=noisecov.*0.00000001;

    else
    end

catch
    noisecov=eye(size(EEG_in.data,1),size(EEG_in.data,1));
    noisecov=noisecov.*0.00000001;
end
datacov=noisecov;  

if (strcmp(ScoutFunction,'none'))  
        [hh,Sc_timeseries]=reconstruct_src(EEG_in,Cond,InvMeth,noisecov,datacov,atlas,ScoutFunction,FileHead,FileCortex,FileInner,FileOuter);
else
try
   allmodels{subjIndex_in}.Gain;
   [Sc_timeseries]=reconstruct_src_withheadmodel(EEG_in,allmodels{subjIndex_in},InvMeth,noisecov,datacov,atlas,ScoutFunction,FileHead,FileCortex,FileInner,FileOuter);
%    alleegs_src{subjIndex_in}=Sc_timeseries;
catch
    
    [HeadModel,Sc_timeseries]=reconstruct_src(EEG_in,Cond,InvMeth,noisecov,datacov,atlas,ScoutFunction,FileHead,FileCortex,FileInner,FileOuter);
    if (strcmp(ScoutFunction,'none')==0) 
% %         save the model if computed on all vertices
    allmodels{subjIndex_in}=HeadModel;
    end
%     alleegs_src{subjIndex_in}=Sc_timeseries;
end
end
ViewSignal(Sc_timeseries,fig1,plotting_panel);
% WriteInfo(Sc_timeseries,EEG_in.srate,'',info_panel);
%     % % Add EEG_src in tree
parent = node_in;

nodeName = char(node_in.getName);
if(strcmp(nodeName,'EEG'))
% %              Plot EEG in a new window
    create=1;
    try
     if(size(alleegs_src{subjIndex_in},1)>0)
        create=0;
    else
        create=1;
     end
    catch
        create=1;
    end
          alleegs_src{subjIndex_in}=Sc_timeseries;
  
    if(create)

        childNode = uitreenode('v0','dummy', 'Reconstructed EEG', [], 0);
        [I] = imread('Icons/javaImage_eeg.png');
        javaImage_eeg = im2java(I);
        childNode.setIcon(javaImage_eeg);
        parent=node_in.getParent;
        treeModel.insertNodeInto(childNode,parent,parent.getChildCount()); 
        % expand to show added child
        tree.setSelectedNode( childNode );
        % insure additional nodes are added to parent
        tree.setSelectedNode( parent );
    end
              
         else
         
         if(strcmp(nodeName,'EEG_preprocessed'))
% %              Plot EEG in a new window
       try     
    if(size(alleegs_preprocessed_src{subjIndex_in},1)>0)
        create=0;
    else
        create=1;
    end
       catch
           create=1;
       end
    alleegs_preprocessed_src{subjIndex_in}=Sc_timeseries;

    if(create)
        childNode = uitreenode('v0','dummy', 'Reconstructed Preprocessed EEG', [], 0);
        [I] = imread('Icons/javaImage_eeg.png');
        javaImage_eeg = im2java(I);
        childNode.setIcon(javaImage_eeg);
        treeModel.insertNodeInto(childNode,parent,parent.getChildCount()); 
        % expand to show added child
        tree.setSelectedNode( childNode );
        % insure additional nodes are added to parent
        tree.setSelectedNode( parent );
    end 

         else
        if(strcmp(nodeName(1:6),'Epoch_'))
% %              Plot EEG in a new window
             number=str2double(nodeName(7:end));
             try
            if(size(allepochs_src{subjIndex_in,number},1)>0)
                create=0;
            else
                create=1;
            end
             catch
                 create=1;
             end
allepochs_src{subjIndex_in,number}=Sc_timeseries;
  
    if(create)
        childNode = uitreenode('v0','dummy', ['Reconstructed Epoch_' num2str(number)], [], 0);
        [I] = imread('Icons/javaImage_eeg.png');
        javaImage_eeg = im2java(I);
        childNode.setIcon(javaImage_eeg);
        treeModel.insertNodeInto(childNode,parent,parent.getChildCount()); 
        % expand to show added child
        tree.setSelectedNode( childNode );
        % insure additional nodes are added to parent
        tree.setSelectedNode( parent );
    end  
           
        else 
        
        if(strcmp(nodeName(1:12),'Preprocessed'))
             number=str2double(nodeName(20:end));
            try
            if(size(allepochs_preprocessed_src{subjIndex_in,number},1)>0)
                create=0;
                
            else
                create=1;

            end
            catch
                create=1;
            end
 allepochs_preprocessed_src{subjIndex_in,number}=Sc_timeseries;
   
    if(create)
        childNode = uitreenode('v0','dummy', ['Reconstructed Preprocessed Epoch_' num2str(number)], [], 0);
        [I] = imread('Icons/javaImage_eeg.png');
        javaImage_eeg = im2java(I);
        childNode.setIcon(javaImage_eeg);
        treeModel.insertNodeInto(childNode,parent,parent.getChildCount()); 
        % expand to show added child
        tree.setSelectedNode( childNode );
        % insure additional nodes are added to parent
        tree.setSelectedNode( parent );
    end   
        end
        
        end
        
         end
         
end
else
% %     multiple=1
for sig=1:size(EEG_in,2)
    if(mult_subj==1)
        si=subjIndex_in(sig);
    else
        si=subjIndex_in;
    end
try
    noisecov=allnoise{si};
    if(sum(isnan(noisecov))>0)
            noisecov=eye(size(EEG_in{sig}.data,1),size(EEG_in{sig}.data,1));
            noisecov=noisecov.*0.00000001;

    else
    end

catch
    noisecov=eye(size(EEG_in{sig}.data,1),size(EEG_in{sig}.data,1));
    noisecov=noisecov.*0.00000001;
end
datacov=noisecov;  

try
   allmodels{si}.Gain;
      [Sc_timeseries]=reconstruct_src_withheadmodel(EEG_in{sig},allmodels{si},InvMeth,noisecov,datacov,atlas,ScoutFunction,FileHead,FileCortex,FileInner,FileOuter);

%    alleegs_src{subjIndex_in}=Sc_timeseries;
catch
   [hh,Sc_timeseries]=reconstruct_src(EEG_in{sig},Cond,InvMeth,noisecov,datacov,atlas,ScoutFunction,FileHead,FileCortex,FileInner,FileOuter);
    if (strcmp(ScoutFunction,'none')==0) 
% %         save the model if computed on all vertices
    allmodels{si}=HeadModel;
    end
%     alleegs_src{subjIndex_in}=Sc_timeseries;
end

% % create the node in tree for each signal. 
% % Signals may be for segments or preprocessed segments

% % two variables are needed : IndSegments and isPreprocessed
Indice=IndSegments(sig);
isPre=isPreprocessed(sig);

if(isPre)
    try
     if(size(allepochs_preprocessed_src{si,Indice},1)>0)
        empty=0;
    else
        empty=1;
    end
    catch
        empty=1;
    end
     allepochs_preprocessed_src{si,Indice}=Sc_timeseries;
     
     if(empty)
    childNode = uitreenode('v0','dummy', ['Reconstructed Preprocessed Epoch_' num2str(Indice)], [], 0);
    [I] = imread('Icons/javaImage_eeg.png');
    javaImage_eeg = im2java(I);
    childNode.setIcon(javaImage_eeg);
%     getfirstchild=eeg, then next node after indice
         if(mult_subj==0)

    eeg_node=node_in.getFirstChild;
    parent=eeg_node;
    while(1)
        parent=parent.getNextNode;
        
        if(strcmp(char(parent.getName),['Preprocessed Epoch_' num2str(Indice)])==1)
        break;
        else
            continue;
        end
    end
         else
             subjectnode=node_in;
% %        we should first get the subject node , the next node is the eeg
% node then we should get the epoch node
        while(1)
        subjectnode=subjectnode.getNextNode;
            if(strcmp(char(subjectnode.getName),['S_' allsubjects.names{si}])==1)
            break;
            else
                continue;
            end
        end
        
%         get the eeg node
    eeg_node=subjectnode.getFirstChild;
    parent=eeg_node;
    while(1)
        parent=parent.getNextNode;
        
        if(strcmp(char(parent.getName),['Preprocessed Epoch_' num2str(Indice)])==1)
        break;
        else
            continue;
        end
    end
   
         end
    treeModel.insertNodeInto(childNode,parent,parent.getChildCount()); 
     end
else
    try
     if(size(allepochs_src{si,Indice},1)>0)
        empty=0;
    else
        empty=1;
     end
    catch
        empty=1;
    end
           
     allepochs_src{si,Indice}=Sc_timeseries;
     
     if(empty)
    childNode = uitreenode('v0','dummy', ['Reconstructed Epoch_' num2str(Indice)], [], 0);
    [I] = imread('Icons/javaImage_eeg.png');
    javaImage_eeg = im2java(I);
    childNode.setIcon(javaImage_eeg);
%     getfirstchild=eeg, then next node after indice
    if(mult_subj==0)
    eeg_node=node_in.getFirstChild;
    parent=eeg_node;
    while(1)
        parent=parent.getNextNode;
        
        if(strcmp(char(parent.getName),['Epoch_' num2str(Indice)])==1)
        break;
        else
            continue;
        end
    end
    else
                     subjectnode=node_in;
% %        we should first get the subject node , the next node is the eeg
% node then we should get the epoch node
        while(1)
        subjectnode=subjectnode.getNextNode;
            if(strcmp(char(subjectnode.getName),['S_' allsubjects.names{si}])==1)
            break;
            else
                continue;
            end
        end
        
%         get the eeg node
    eeg_node=subjectnode.getFirstChild;
    parent=eeg_node;
    while(1)
        parent=parent.getNextNode;
        
        if(strcmp(char(parent.getName),['Epoch_' num2str(Indice)])==1)
        break;
        else
            continue;
        end
    end

    end
    treeModel.insertNodeInto(childNode,parent,parent.getChildCount()); 
     end
end
end
end

closereq;       %Close the actual GUI
end



function scalp_cond_Callback(hObject, eventdata, handles)
% hObject    handle to scalp_cond (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of scalp_cond as text
%        str2double(get(hObject,'String')) returns contents of scalp_cond as a double


% --- Executes during object creation, after setting all properties.
function scalp_cond_CreateFcn(hObject, eventdata, handles)
% hObject    handle to scalp_cond (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





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


% --- Executes on selection change in pop_atlas.
function pop_atlas_Callback(hObject, eventdata, handles)
% hObject    handle to pop_atlas (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pop_atlas contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pop_atlas


% --- Executes during object creation, after setting all properties.
function pop_atlas_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pop_atlas (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pop_scoutfunction.
function pop_scoutfunction_Callback(hObject, eventdata, handles)
% hObject    handle to pop_scoutfunction (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pop_scoutfunction contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pop_scoutfunction


% --- Executes during object creation, after setting all properties.
function pop_scoutfunction_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pop_scoutfunction (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pop_inversemethod.
function pop_inversemethod_Callback(hObject, eventdata, handles)
% hObject    handle to pop_inversemethod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pop_inversemethod contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pop_inversemethod

% --- Executes during object creation, after setting all properties.
function pop_inversemethod_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pop_inversemethod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function noisecov_file_Callback(hObject, eventdata, handles)
% hObject    handle to noisecov_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of noisecov_file as text
%        str2double(get(hObject,'String')) returns contents of noisecov_file as a double


% --- Executes during object creation, after setting all properties.
function noisecov_file_CreateFcn(hObject, eventdata, handles)
% hObject    handle to noisecov_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in push_loadNoiseMatrix.
function push_loadNoiseMatrix_Callback(hObject, eventdata, handles)
% hObject    handle to push_loadNoiseMatrix (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global params;
[filename,pathname]=uigetfile({'*.mat','Import Noise covariance matrix'});
if isequal(filename,0)||isequal(pathname,0)
    return
else
    fpath=fullfile(pathname,filename);
    cellOut=struct2cell(load(fpath));
    noisecov=(cellOut{1});

end
% % if noisecov dimension not equal to channels size then return messgae
% box
set(handles.noisecov_file,'String',fpath);
params.noisecov=noisecov;


function Datacov_file_Callback(hObject, eventdata, handles)
% hObject    handle to Datacov_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Datacov_file as text
%        str2double(get(hObject,'String')) returns contents of Datacov_file as a double


% --- Executes during object creation, after setting all properties.
function Datacov_file_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Datacov_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in push_loadDataMatrix.
function push_loadDataMatrix_Callback(hObject, eventdata, handles)
% hObject    handle to push_loadDataMatrix (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global params;
[filename,pathname]=uigetfile({'*.mat','Import Noise covariance matrix'});
if isequal(filename,0)||isequal(pathname,0)
    return
else
    fpath=fullfile(pathname,filename);
    cellOut=struct2cell(load(fpath));
    datacov=(cellOut{1});

end
% % if noisecov dimension not equal to channels size then return messgae
% box
set(handles.Datacov_file,'String',fpath);
params.datacov=noisecov;


function skull_cond_Callback(hObject, eventdata, handles)
% hObject    handle to skull_cond (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of skull_cond as text
%        str2double(get(hObject,'String')) returns contents of skull_cond as a double


% --- Executes during object creation, after setting all properties.
function skull_cond_CreateFcn(hObject, eventdata, handles)
% hObject    handle to skull_cond (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function brain_cond_Callback(hObject, eventdata, handles)
% hObject    handle to brain_cond (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of brain_cond as text
%        str2double(get(hObject,'String')) returns contents of brain_cond as a double


% --- Executes during object creation, after setting all properties.
function brain_cond_CreateFcn(hObject, eventdata, handles)
% hObject    handle to brain_cond (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in rd_default.
function rd_default_Callback(hObject, eventdata, handles)
% hObject    handle to rd_default (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rd_default


% --- Executes on button press in rd_fs.
function rd_fs_Callback(hObject, eventdata, handles)
% hObject    handle to rd_fs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rd_fs

function varargout = Form_segment(varargin)
% FORM_SEGMENT MATLAB code for Form_segment.fig
%      FORM_SEGMENT, by itself, creates a new FORM_SEGMENT or raises the existing
%      singleton*.
%
%      H = FORM_SEGMENT returns the handle to a new FORM_SEGMENT or the handle to
%      the existing singleton*.
%
%      FORM_SEGMENT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FORM_SEGMENT.M with the given input arguments.
%
%      FORM_SEGMENT('Property','Value',...) creates a new FORM_SEGMENT or raises
%      the existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Form_segment_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Form_segment_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Form_segment

% Last Modified by GUIDE v2.5 14-Feb-2021 09:55:04

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Form_segment_OpeningFcn, ...
                   'gui_OutputFcn',  @Form_segment_OutputFcn, ...
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

% --- Executes just before Form_segment is made visible.
function Form_segment_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Form_segment (see VARARGIN)

% Choose default command line output for Form_segment
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
global node_in;
global subjIndex_in;
EEG_in = varargin{1};
node_in=varargin{2};
subjIndex_in=varargin{3};
[YourImage, ~, ImageAlpha] = imread('Icons/logo_eegnet_greybkg.png');
axes(handles.axes1);
imshow(YourImage)
% Make the GUI modal
set(handles.figure1,'WindowStyle','modal')
set(handles.figure1, 'Name', 'Divide EEG into epochs');

        set(handles.panel_rest,'Visible','on');
       set(handles.task_panel,'Visible','off');


% Callback function definition
% UIWAIT makes Form_New wait for user response (see UIRESUME)
uiwait(handles.figure1);

% jb = javax.swing.JButton;
% jbh = handle(jb,'CallbackProperties');

    % (now decide what to do with this key-press...)

% UIWAIT makes Form_segment wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Form_segment_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
% varargout{1} = handles.output;



% --- Executes on button press in push_cancel.
function push_cancel_Callback(hObject, eventdata, handles)
% hObject    handle to push_cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% uiresume(handles.figure1);
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



function overlap_edit_Callback(hObject, eventdata, handles)
% hObject    handle to overlap_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of overlap_edit as text
%        str2double(get(hObject,'String')) returns contents of overlap_edit as a double


% --- Executes during object creation, after setting all properties.
function overlap_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to overlap_edit (see GCBO)
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


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2
switch(get(handles.popupmenu2,'Value'))
    case 1
        set(handles.panel_rest,'Visible','on');
       set(handles.task_panel,'Visible','off');
 
    case 2
        set(handles.panel_rest,'Visible','off');
       set(handles.task_panel,'Visible','on');
 
end

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
global EEG_in;    
global allepochs;
global tree;
global treeModel;
global rootNode;
global javaImage_subj;
global node_in;
global subjIndex_in;
import javax.swing.*
import javax.swing.tree.*;

pass=0;
segment={};
allepochs_before=allepochs;
deleteNodes=0;
subjIndex=subjIndex_in;
switch get(handles.popupmenu2,'Value')

        case 1  
            epoch_length=get(handles.epoch_length_edit,'String');
            epochL=str2double(epoch_length);
            overlap=get(handles.overlap_edit,'String');
            overlapL=str2double(overlap);
            samplesEpoch=epochL*EEG_in.srate;
            samplesOverlap=overlapL*EEG_in.srate;
            if(samplesEpoch>(EEG_in.pnts))
                msgbox('Error: The epoch length is greater than the total number of samples');
            else
                if(samplesOverlap>samplesEpoch)
                    msgbox('Error: The overlap window is greater than the segment length');
                else
                    pass=1;
%                     normal segmentation
                      original=EEG_in.data;
                      if(samplesOverlap==0)
                          for e=1:floor(size(original,2)/samplesEpoch)
                            segment{e}=original(:,(e-1)*samplesEpoch+1:samplesEpoch*e);
                            allepochs{subjIndex_in,e}=EEG_in;
                            allepochs{subjIndex_in,e}.data=segment{e};
                            allepochs{subjIndex_in,e}.pnts=size(segment{e},2);
                            allepochs{subjIndex_in,e}.xmax=size(segment{e},2)/allepochs{subjIndex_in,e}.srate;
                            allepochs{subjIndex_in,e}.times=allepochs{subjIndex_in,e}.times(:,1:size(segment{e},2));
%                             delete previous epochs if present 
                          end
                           if(size(allepochs,2)>floor(size(original,2)/samplesEpoch))
                                    deleteNodes=1;
                                for plus=e+1:size(allepochs,2)
                                    allepochs{subjIndex_in,plus}=struct();
                                end
                            
                            end
                      else
                          maxE=(size(original,2)-samplesEpoch)/samplesOverlap+1;
                          for e=1:maxE
                            segment{e}=original(:,(e-1)*samplesOverlap+1:samplesEpoch+(e-1)*samplesOverlap);
                            allepochs{subjIndex_in,e}=EEG_in;
                            allepochs{subjIndex_in,e}.data=segment{e};
                            allepochs{subjIndex_in,e}.pnts=size(segment{e},2);
                            allepochs{subjIndex_in,e}.xmax=size(segment{e},2)/allepochs{subjIndex_in,e}.srate;
                            allepochs{subjIndex_in,e}.times=allepochs{subjIndex_in,e}.times(:,1:size(segment{e},2));

                          end
                          if(size(allepochs,2)>maxE)
                                                 deleteNodes=1;

                                for plus=e+1:size(allepochs,2)
                                    allepochs{subjIndex_in,plus}=struct();
                                end
                          end
                      end
                      
                end
            end
        case 2
            preSt=get(handles.pre_stimulus_edit,'String');
            preStt=num2str(preSt);
            postSt=get(handles.post_stimulus_edit,'String');
            postStt=num2str(postSt);
            samplesPre=preStt*EEG_in.srate;
            samplesPost= postStt*EEG_in.srate;
            
            eventfile=get(handles.event_file_edit,'String');
            cellOut=struct2cell(load(eventfile));
             events=(cellOut{1});
            if(length(events.time)==length(events.name))
%                 normal parcellation
% event.time in seconds
                pass=1;
                for e=1:length(events.time)
                    evSample=events.time(e)*EEG_in.srate;
                    segment{e}=original(:,evSample-samplesPre:evSample+samplesPost);
                    allepochs{subjIndex_in,e}=EEG_in;
                            allepochs{subjIndex_in,e}.data=segment{e};
                            allepochs{subjIndex_in,e}.pnts=size(segment{e},2);
                            allepochs{subjIndex_in,e}.xmax=size(segment{e},2)/allepochs{subjIndex_in,e}.srate;
                            allepochs{subjIndex_in,e}.times=allepochs{subjIndex_in,e}.times(:,1:size(segment{e},2));

                end
               if(size(allepochs,2)>length(events.time))
                   deleteNodes=1;
                                for plus=e+1:size(allepochs,2)
                                    allepochs{subjIndex_in,plus}=struct();
                                end
               end
                          
            end
end

% % pass=1 means that all the files are entered in a good way
if(pass==1)
%     Create segments as nodes in the tree under the correspondant EEG
for i=1:node_in.getChildCount
    treeModel.removeNodeFromParent(node_in.getFirstChild);
end

for e=1:length(segment)
    
    childNode = uitreenode('v0','dummy', ['Epoch_' num2str(e)], [], 0);
    [I] = imread('Icons/javaImage_eeg.png');
    javaImage_eeg = im2java(I);
    childNode.setIcon(javaImage_eeg);
    parent=node_in;
    treeModel.insertNodeInto(childNode,parent,parent.getChildCount()); 
    % expand to show added child
    tree.setSelectedNode( childNode );
    % insure additional nodes are added to parent
    tree.setSelectedNode(parent);
end
end

closereq;


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
global hh;
[filename,pathname]=uigetfile({'*.mat','Import Events File'});
if isequal(filename,0)||isequal(pathname,0)
    return
else
    fpath=fullfile(pathname,filename);
end
% locs=readlocs(fpath);
set(handles.event_file_edit,'String',fpath);
% hh.locs=locs;


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

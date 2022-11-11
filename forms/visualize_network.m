function varargout = visualize_network(varargin)
% VISUALIZE_NETWORK MATLAB code for visualize_network.fig
%      VISUALIZE_NETWORK, by itself, creates a new VISUALIZE_NETWORK or raises the existing
%      singleton*.
%
%      H = VISUALIZE_NETWORK returns the handle to a new VISUALIZE_NETWORK or the handle to
%      the existing singleton*.
%
%      VISUALIZE_NETWORK('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VISUALIZE_NETWORK.M with the given input arguments.
%
%      VISUALIZE_NETWORK('Property','Value',...) creates a new VISUALIZE_NETWORK or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before visualize_network_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to visualize_network_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help visualize_network

% Last Modified by GUIDE v2.5 08-Jun-2021 00:03:22

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @visualize_network_OpeningFcn, ...
                   'gui_OutputFcn',  @visualize_network_OutputFcn, ...
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


% --- Executes just before visualize_network is made visible.
function visualize_network_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to visualize_network (see VARARGIN)

% Choose default command line output for visualize_network
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
axes(handles.axes1);
imshow(YourImage)
% global count;
% count=0;
% Make the GUI modal
set(handles.figure1,'WindowStyle','modal')
set(handles.figure1, 'Name', 'Visualize network');
global mat;
global fig2;
mat=varargin{1};
label_id = get(handles.labels_check, 'Value');
     if(size(mat,2)==68)
% %          desikan
            load('data/visualization/desikan/desikan_labels.mat');
            load('data/visualization/desikan/desikan_mni_icbm.mat');
     else
         if(size(mat,2)==148)
% %         destrieux 
            load('data/visualization/destrieux/destrieux_labels.mat');
            load('data/visualization/destrieux/destrieux_mni_icbm.mat');
         else
             if(size(mat,2)==210)
% %                  brainnetome
            load('data/visualization/brainnetome/brainnetome_labels.mat');
            load('data/visualization/brainnetome/brainnetome_mni_icbm.mat');

             end
     end
     end
    load('data/visualization/Surfmatrix_icbm.mat');
    
fig2=handles.axes2;
mat=varargin{1};
if(ndims(mat)==2)
    set(handles.uibuttongroup1,'Visible','off');
    % %     everything is good as params
   
    axes(handles.axes2);
    go_view_brainnetviewer_eeg(mat,'thresh_abs',0.9,label_id,scout_labels,scout_mni,Surfmatrix)
   
            
else
   set(handles.uibuttongroup1,'Visible','on');
   global jsliderVis;
%    global jrangeVis;
      numberWindows=size(mat,1);
   jsliderVis = javax.swing.JSlider;
   javacomponent(jsliderVis,[50,10,200,45],handles.uibuttongroup1);
   set( jsliderVis, 'Value',1,'Maximum',numberWindows,'Minimum',1,'MajorTickSpacing',numberWindows/4, 'MinorTickSpacing',numberWindows/16, 'PaintTicks',true, 'PaintLabels',true,'MouseReleasedCallback',{@rangeSlider_change,mat,jsliderVis,handles});
   jsliderVis.setVisible(true);
  
    axes(handles.axes2);
    go_view_brainnetviewer_eeg(squeeze(mat(1,:,:)),'thresh_abs',0.9,label_id,scout_labels,scout_mni,Surfmatrix)
    
   
end

% UIWAIT makes visualize_network wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = visualize_network_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in push_go.
function go_plot(handles)
% hObject    handle to push_go (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
threshtype=get(handles.threshtype_pop,'Value');
global mat;
switch threshtype
    case 1
        threshmeth='thresh_abs';
    case 2        
        threshmeth='thresh_conn';
end
go=0;
try
    threshval=get(handles.thresh_edit,'String');
    val=str2double(threshval);
    if(val>0)&&(val<=1)
        go=1;
    else 
            msgbox('Please enter the threshold value as integer value between 0 and 1');
            go=0;
    end
catch
    msgbox('Please enter the threshold value as integer value between 0 and 1');
    go=0;
end

if(go)
% %     everything is good as params
    label_id = get(handles.labels_check, 'Value');
     if(size(mat,2)==68)
% %          desikan
            load('data/visualization/desikan/desikan_labels.mat');
            load('data/visualization/desikan/desikan_mni_icbm.mat');
     else
         if(size(mat,2)==148)
% %         destrieux 
            load('data/visualization/destrieux/destrieux_labels.mat');
            load('data/visualization/destrieux/destrieux_mni_icbm.mat');
         else
             if(size(mat,2)==210)
% %                  brainnetome
            load('data/visualization/brainnetome/brainnetome_labels.mat');
            load('data/visualization/brainnetome/brainnetome_mni_icbm.mat');

             end
     end
     end
    load('data/visualization/Surfmatrix_icbm.mat');
    
    if(ndims(mat)==2)
            label_id = get(handles.labels_check, 'Value');

    axes(handles.axes2);
    go_view_brainnetviewer_eeg(mat,threshmeth,val,label_id,scout_labels,scout_mni,Surfmatrix)
    else
% %         dynamic case

%                 global jrangeVis;
        global jsliderVis;

% %         dynamic matrix
% %        specific value 
        
             win = get(jsliderVis, 'Value');
            axes(handles.axes2);
            go_view_brainnetviewer_eeg(squeeze(mat(win,:,:)),threshmeth,val,label_id,scout_labels,scout_mni,Surfmatrix)
    
    end
end

function rangeSlider_change(hObj, EventData,mat,jsliderVis,handles)
% global count; 
% count=count+1
go_plot(handles)
% threshtype=get(handles.threshtype_pop,'Value');
% switch threshtype
%     case 1
%         threshmeth='thresh_abs';
%     case 2        
%         threshmeth='thresh_conn';
% end
% go=0;
% try
%     threshval=get(handles.thresh_edit,'String');
%     val=str2double(threshval);
%     if(val>0)&&(val<=1)
%         go=1;
%     else 
%             msgbox('Please enter the threshold value as integer value between 0 and 1');
%             go=0;
%     end
% catch
%     msgbox('Please enter the threshold value as integer value between 0 and 1');
%     go=0;
% end
% 
% if(go)
% % %     everything is good as params
%     label_id = get(handles.labels_check, 'Value');
%      if(size(mat,2)==68)
% % %          desikan
%             load('data/visualization/desikan/desikan_labels.mat');
%             load('data/visualization/desikan/desikan_mni_icbm.mat');
%      else
%          if(size(mat,2)==148)
% % %         destrieux 
%             load('data/visualization/destrieux/destrieux_labels.mat');
%             load('data/visualization/destrieux/destrieux_mni_icbm.mat');
%          else
%              if(size(mat,2)==210)
% % %                  brainnetome
%             load('data/visualization/brainnetome/brainnetome_labels.mat');
%             load('data/visualization/brainnetome/brainnetome_mni_icbm.mat');
% 
%              end
%      end
%      end
%     load('data/visualization/Surfmatrix_icbm.mat');
%     
% % %         dynamic case
% 
% %                 global jrangeVis;
% 
% % %         dynamic matrix
% % %        specific value 
%         
%          win = get(jsliderVis, 'Value');
%         axes(handles.axes2);
%         go_view_brainnetviewer_eeg(squeeze(mat(win,:,:)),threshmeth,val,label_id,scout_labels,scout_mni,Surfmatrix)
%     
% end



% --- Executes on selection change in threshtype_pop.
function threshtype_pop_Callback(hObject, eventdata, handles)
% hObject    handle to threshtype_pop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns threshtype_pop contents as cell array
%        contents{get(hObject,'Value')} returns selected item from threshtype_pop
go_plot(handles)

% --- Executes during object creation, after setting all properties.
function threshtype_pop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to threshtype_pop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes during object creation, after setting all properties.
function thresh_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to thresh_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in labels_check.
function labels_check_Callback(hObject, eventdata, handles)
% hObject    handle to labels_check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of labels_check
go_plot(handles)



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in onewindow_rb.


% --- Executes on selection change in popupmenu3.


% --- Executes during object creation, after setting all properties.
function popupmenu3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on key press with focus on thresh_edit and none of its controls.
function thresh_edit_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to thresh_edit (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
key=eventdata.Key;
if(strcmp(key,'return'))
    go_plot(handles)
end

function varargout = visualize_graph(varargin)
% visualize_graph MATLAB code for visualize_graph.fig
%      visualize_graph, by itself, creates a new visualize_graph or raises the existing
%      singleton*.
%
%      H = visualize_graph returns the handle to a new visualize_graph or the handle to
%      the existing singleton*.
%
%      visualize_graph('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in visualize_graph.M with the given input arguments.
%
%      visualize_graph('Property','Value',...) creates a new visualize_graph or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before visualize_graph_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to visualize_graph_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help visualize_graph

% Last Modified by GUIDE v2.5 09-Jun-2021 11:31:42

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @visualize_graph_OpeningFcn, ...
                   'gui_OutputFcn',  @visualize_graph_OutputFcn, ...
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


% --- Executes just before visualize_graph is made visible.
function visualize_graph_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to visualize_graph (see VARARGIN)

% Choose default command line output for visualize_graph
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

% Make the GUI modal
set(handles.figure1,'WindowStyle','modal')
set(handles.figure1, 'Name', 'Visualize network');
global mat;
global figG;
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
    
figG=handles.axes2;
mat=varargin{1};
if(ndims(mat)==2)
    set(handles.uibuttongroup1,'Visible','off');
    % %     everything is good as params
   
    axes(handles.axes2);
    go_view_brainnetviewer_graph(mat,'thresh_abs',0.9,label_id,scout_labels,scout_mni,Surfmatrix,'Str',0)
   
            
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
    go_view_brainnetviewer_graph(squeeze(mat(1,:,:)),'thresh_abs',0.9,label_id,scout_labels,scout_mni,Surfmatrix,'Str',0)
    
   
end

% UIWAIT makes visualize_graph wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = visualize_graph_OutputFcn(hObject, eventdata, handles) 
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
        threshmeth='thresh_conn';
        
        paramtype=get(handles.popupmenu3,'Value');
global mat;
compute=0;
switch paramtype
    case 1
        param='Str';
    case 2
        param='CC';
    case 3
        param='BC';
    case 4
        param='Con';
        compute=1;
    case 5
        param='Prov';
        compute=1;
end

        
try
    threshval=get(handles.edit4,'String');
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
    axes(handles.axes2);
    go_view_brainnetviewer_graph(mat,threshmeth,val,label_id,scout_labels,scout_mni,Surfmatrix,param,compute)
    else
% %         dynamic case

%                 global jrangeVis;
        global jsliderVis;

% %         dynamic matrix
% %        specific value 
        
             win = get(jsliderVis, 'Value');
            axes(handles.axes2);
            go_view_brainnetviewer_graph(squeeze(mat(win,:,:)),threshmeth,val,label_id,scout_labels,scout_mni,Surfmatrix,param,compute)
    
    end
end


function rangeSlider_change(hObj, EventData,mat,jsliderVis,handles)
go_plot(handles)



% --- Executes on selection change in threshtype_pop.

% --- Executes during object creation, after setting all properties.




% --- Executes during object creation, after setting all properties.


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
function popupmenu3_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu3
go_plot(handles)


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

% --- Executes on key press with focus on edit4 and none of its controls.
function edit4_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
key=eventdata.Key;
if(strcmp(key,'return'))
    go_plot(handles)
end

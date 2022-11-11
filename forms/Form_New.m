function varargout = Form_New(varargin)
% FORM_NEW MATLAB code for Form_New.fig
%      FORM_NEW by itself, creates a new FORM_NEW or raises the
%      existing singleton*.
%
%      H = FORM_NEW returns the handle to a new FORM_NEW or the handle to
%      the existing singleton*.
%
%      FORM_NEW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FORM_NEW.M with the given input arguments.
%
%      FORM_NEW('Property','Value',...) creates a new FORM_NEW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Form_New_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Form_New_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Form_New

% Last Modified by GUIDE v2.5 29-Jan-2021 10:42:10

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Form_New_OpeningFcn, ...
                   'gui_OutputFcn',  @Form_New_OutputFcn, ...
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

% --- Executes just before Form_New is made visible.
function Form_New_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Form_New (see VARARGIN)

% Choose default command line output for Form_New
handles.output = 'Yes';
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

% Insert custom Title and Text if specified by the user
% Hint: when choosing keywords, be sure they are not easily confused 
% with existing figure properties.  See the output of set(figure) for
% a list of figure properties.
if(nargin > 3)
    for index = 1:2:(nargin-3),
        if nargin-3==index, break, end
        switch lower(varargin{index})
         case 'title'
          set(hObject, 'Name', varargin{index+1});
         case 'string'
          set(handles.text1, 'String', varargin{index+1});
        end
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

% Show a question icon from dialogicons.mat - variables questIconData
% and questIconMap
% load dialogicons.mat
% 
% IconData=questIconData;
% questIconMap(256,:) = get(handles.figure1, 'Color');
% IconCMap=questIconMap;
% 
% Img=image(IconData, 'Parent', handles.axes1);
% set(handles.figure1, 'Colormap', IconCMap);
% 
% set(handles.axes1, ...
%     'Visible', 'off', ...
%     'YDir'   , 'reverse'       , ...
%     'XLim'   , get(Img,'XData'), ...
%     'YLim'   , get(Img,'YData')  ...
%     );
% UIWAIT makes opening_window wait for user response (see UIRESUME)
% uiwait(handles.figure1);
% create an axes that spans the whole gui
% ah = axes('unit', 'normalized', 'position', [0 0 1 1]); 
% % import the background image and show it on the axes
% bg = imread('opening_new/opening_new.005.jpeg'); imagesc(bg);
% % prevent plotting over the background and turn the axis off
% set(ah,'handlevisibility','off','visible','off')
% % making sure the background is behind all the other uicontrols
% uistack(ah, 'bottom');

[YourImage, ~, ImageAlpha] = imread('Icons/logo_eegnet_greybkg.png');
axes(handles.axes1);
imshow(YourImage)
% Make the GUI modal
set(handles.figure1,'WindowStyle','modal')
set(handles.figure1, 'Name', 'Add New Subject');

% % clear edit text when the user press the mouse
jEditbox = findjobj(handles.subname_edit);
set(jEditbox, 'MousePressedCallback',@ClearFunction);
% Callback function definition
% UIWAIT makes Form_New wait for user response (see UIRESUME)
uiwait(handles.figure1);

% jb = javax.swing.JButton;
% jbh = handle(jb,'CallbackProperties');
function ClearFunction(jEditbox, eventData)
    % The following comments refer to the case of Alt-Shift-b
    name=jEditbox.getText;
    if(strcmp(name,'Subject Name'))
    jEditbox.setText('');
    end
    % (now decide what to do with this key-press...)

% --- Outputs from this function are returned to the command line.
function varargout = Form_New_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
% varargout{1} = handles.output;
% 
% % The figure can be deleted now
% delete(handles.figure1);

% --- Executes on button press in add_btn.
function add_btn_Callback(hObject, eventdata, handles)
% hObject    handle to add_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.output = get(hObject,'String');
% Update handles structure
guidata(hObject, handles);

% Use UIRESUME instead of delete because the OutputFcn needs
% to get the updated handles structure.
uiresume(handles.figure1);
global subjname;
global allsubjects;
global numberSubjects;


subjname = get(handles.subname_edit,'String');
% % test if subjname is already present before. If yes, tell the user to
% change the name

if (numberSubjects>0)
    if(find(strcmp(allsubjects.names, subjname)))
   myicon = imread('Icons/logo_new_eegnet.png');
   msgbox(['Please choose another subject name as ' subjname 'is already used'],'Warning','custom',myicon);     

else
hf=findobj('Name','eegnet_main');
closereq;       %Close the actual GUI

numberSubjects=numberSubjects+1;
global tree;
global treeModel;
global rootNode;
global javaImage_subj;
import javax.swing.*
import javax.swing.tree.*;

parent = rootNode;
childNode = uitreenode('v0','dummy', ['S_' subjname], [], 0);
childNode.setIcon(javaImage_subj);

allsubjects.names{numberSubjects}=subjname;

treeModel.insertNodeInto(childNode,parent,parent.getChildCount()); 
% expand to show added child
tree.setSelectedNode( childNode );
% insure additional nodes are added to parent
tree.setSelectedNode( parent );

    end
else
    hf=findobj('Name','eegnet_main');
closereq;       %Close the actual GUI

numberSubjects=numberSubjects+1;
global tree;
global treeModel;
global rootNode;
global javaImage_subj;
import javax.swing.*
import javax.swing.tree.*;

parent = rootNode;
childNode = uitreenode('v0','dummy', ['S_' subjname], [], 0);
childNode.setIcon(javaImage_subj);

allsubjects.names{numberSubjects}=subjname;

treeModel.insertNodeInto(childNode,parent,parent.getChildCount()); 
% expand to show added child
tree.setSelectedNode( childNode );
% insure additional nodes are added to parent
tree.setSelectedNode( parent );

end

% --- Executes on button press in cancel_btn.
function cancel_btn_Callback(hObject, eventdata, handles)
% hObject    handle to cancel_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.output = get(hObject,'String');

% Update handles structure
guidata(hObject, handles);

% Use UIRESUME instead of delete because the OutputFcn needs
% to get the updated handles structure.
uiresume(handles.figure1);
closereq;       %Close the actual GUI


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isequal(get(hObject, 'waitstatus'), 'waiting')
    % The GUI is still in UIWAIT, us UIRESUME
    uiresume(hObject);
else
    % The GUI is no longer waiting, just close it
    delete(hObject);
end


% --- Executes on key press over figure1 with no controls selected.
function figure1_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Check for "enter" or "escape"
if isequal(get(hObject,'CurrentKey'),'escape')
    % User said no by hitting escape
    handles.output = 'No';
    
    % Update handles structure
    guidata(hObject, handles);
    
    uiresume(handles.figure1);
end    
    
if isequal(get(hObject,'CurrentKey'),'return')
    uiresume(handles.figure1);
end    



function subname_edit_Callback(hObject, eventdata, handles)
% hObject    handle to subname_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of subname_edit as text
%        str2double(get(hObject,'String')) returns contents of subname_edit as a double

% --- Executes during object creation, after setting all properties.
function subname_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to subname_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

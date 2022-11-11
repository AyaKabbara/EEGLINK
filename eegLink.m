function varargout = eegLink(varargin)
% eegLink MATLAB code for eegLink.fig
%      eegLink, by itself, creates a new eegLink or raises the existing
%      singleton*.
%
%      H = eegLink returns the handle to a new eegLink or the handle to
%      the existing singl feton*.
%
%      eegLink('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in eegLink.M with the given input arguments.
%
%      eegLink('Property','Value',...) creates a new eegLink or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before eegLink_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to eegLink_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help eegLink

% Last Modified by GUIDE v2.5 12-Aug-2021 18:46:01

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @eegLink_OpeningFcn, ...
                   'gui_OutputFcn',  @eegLink_OutputFcn, ...
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


% --- Executes just before eegLink is made visible.
function eegLink_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to eegLink (see VARARGIN)
set(handles.figure1,'WindowStyle','modal')
set(handles.figure1, 'Name', 'EEGLink');

% Choose default command line output for eegLink
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes eegLink wait for user response (see UIRESUME)
% uiwait(handles.figure1);
% create an axes that spans the whole gui
ah = axes('unit', 'normalized', 'position', [0 0 1 1]); 
% import the background image and show it on the axes
bg = imread('img/opening_new.004.jpeg'); imagesc(bg);
% prevent plotting over the background and turn the axis off
set(ah,'handlevisibility','off','visible','off')
% making sure the background is behind all the other uicontrols
uistack(ah, 'bottom');


% --- Outputs from this function are returned to the command line.
function varargout = eegLink_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in start_btn.
function start_btn_Callback(hObject, eventdata, handles)
% hObject    handle to start_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
closereq;       %Close the actual GUI
eegnet_main; %Open the new GUI 
warning('off')
jFrame = get(gcf,'JavaFrame');
jMenuBar = jFrame.fHG2Client.getMenuBar;
for menuIdx = 1 : jMenuBar.getComponentCount
    jMenu = jMenuBar.getComponent(menuIdx-1);
    hjMenu = handle(jMenu,'CallbackProperties');
    set(hjMenu,'MousePressedCallback','doClick(gcbo)');
end

% File icons
jFileMenu = jMenuBar.getComponent(0);
jNew = jFileMenu.getMenuComponent(0); %Java indexes start with 0!
jNewSet=jFileMenu.getMenuComponent(1);
jNewBIDS=jFileMenu.getMenuComponent(2);
jImport=jFileMenu.getMenuComponent(3);
jSave=jFileMenu.getMenuComponent(4);

% Study icons
jStudyMenu = jMenuBar.getComponent(1);
jGA = jStudyMenu.getMenuComponent(0); %Java indexes start with 0!
jDA=jStudyMenu.getMenuComponent(1);
jSL=jDA.getMenuComponent(0);
jGL=jDA.getMenuComponent(1);

% Help icons
jHelpMenu = jMenuBar.getComponent(2);
jteam = jHelpMenu.getMenuComponent(0); %Java indexes start with 0!
jsite=jHelpMenu.getMenuComponent(1);

% tooltip
% % jMenu = jMenuBar.getComponent(2);
% % jMenu.setToolTipText('modified menu item with tooltip');

% dynamic clicking
% % for menuIdx = 1 : jMenuBar.getComponentCount
% %     jMenu = jMenuBar.getComponent(menuIdx-1);
% %     hjMenu = handle(jMenu,'CallbackProperties');
% %     set(hjMenu,'MouseEnteredCallback','doClick(gcbo)');
% % end
% External icon file example
jNew.setIcon(javax.swing.ImageIcon('Icons/new_black.png'));
jNewSet.setIcon(javax.swing.ImageIcon('Icons/group.png'));
jNewBIDS.setIcon(javax.swing.ImageIcon('Icons/bids_icon.png'));

jImport.setIcon(javax.swing.ImageIcon('Icons/open_database.png'));
jSave.setIcon(javax.swing.ImageIcon('Icons/save_icon.png'));
jGA.setIcon(javax.swing.ImageIcon('Icons/group.png'));
jDA.setIcon(javax.swing.ImageIcon('Icons/flow_icon.png'));
jSL.setIcon(javax.swing.ImageIcon('Icons/single_subject.png'));
jGL.setIcon(javax.swing.ImageIcon('Icons/group.png'));

jteam.setIcon(javax.swing.ImageIcon('Icons/team_icon.png'));
jsite.setIcon(javax.swing.ImageIcon('Icons/site_icon.png'));

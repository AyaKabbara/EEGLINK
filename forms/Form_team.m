function varargout = Form_team(varargin)
% FORM_TEAM MATLAB code for Form_team.fig
%      FORM_TEAM, by itself, creates a new FORM_TEAM or raises the existing
%      singleton*.
%
%      H = FORM_TEAM returns the handle to a new FORM_TEAM or the handle to
%      the existing singleton*.
%
%      FORM_TEAM('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FORM_TEAM.M with the given input arguments.
%
%      FORM_TEAM('Property','Value',...) creates a new FORM_TEAM or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Form_team_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Form_team_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Form_team

% Last Modified by GUIDE v2.5 19-Feb-2021 20:08:51

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Form_team_OpeningFcn, ...
                   'gui_OutputFcn',  @Form_team_OutputFcn, ...
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

% --- Executes just before Form_team is made visible.
function Form_team_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Form_team (see VARARGIN)

% Choose default command line output for Form_team
handles.output = hObject;
fn = fieldnames(handles);
  movegui(handles.figure1,'center')  

    
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

% This sets up the initial plot - only do when we are invisible
% so window can get raised using Form_team.
if strcmp(get(hObject,'Visible'),'off')
    plot(rand(5));
end

ah = axes('unit', 'normalized', 'position', [0 0 1 1]); 
% import the background image and show it on the axes
bg = imread('img/EEGNET_team.001.jpeg'); imagesc(bg);
% prevent plotting over the background and turn the axis off
set(ah,'handlevisibility','off','visible','off')

set(handles.figure1,'WindowStyle','modal')
set(handles.figure1, 'Name', 'Our team');

% UIWAIT makes Form_team wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Form_team_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

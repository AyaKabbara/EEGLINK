function varargout = segment_Visualize(varargin)
% SEGMENT_VISUALIZE MATLAB code for segment_Visualize.fig
%      SEGMENT_VISUALIZE, by itself, creates a new SEGMENT_VISUALIZE or raises the existing
%      singleton*.
%
%      H = SEGMENT_VISUALIZE returns the handle to a new SEGMENT_VISUALIZE or the handle to
%      the existing singleton*.
%
%      SEGMENT_VISUALIZE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SEGMENT_VISUALIZE.M with the given input arguments.
%
%      SEGMENT_VISUALIZE('Property','Value',...) creates a new SEGMENT_VISUALIZE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before segment_Visualize_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to segment_Visualize_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help segment_Visualize

% Last Modified by GUIDE v2.5 08-Jul-2021 14:24:21

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @segment_Visualize_OpeningFcn, ...
                   'gui_OutputFcn',  @segment_Visualize_OutputFcn, ...
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


% --- Executes just before segment_Visualize is made visible.
function segment_Visualize_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to segment_Visualize (see VARARGIN)
set(handles.figure1,'WindowStyle','modal')
set(handles.figure1, 'Name', 'Illustrate results');
  movegui(handles.figure1,'center')  

% Choose default command line output for segment_Visualize
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
labels = varargin{1};
global maps; 
maps=varargin{2};
N=size(maps,2);
hGroup = handles.panel_buttons;
numberEpochsG1=varargin{3};
axes(handles.axes_labels);
imagesc(labels);
cmap=winter(max(labels));
colormap(gca, cmap);
colorbar;

if(numberEpochsG1>0)
    hold on;
    plot([numberEpochsG1 numberEpochsG1], ylim, 'r-x','LineWidth',3,'MarkerSize',5);
    text(numberEpochsG1,1.6,'\End of Group1','Color','red')
end


for i = 1:N
    RGB = cmap(i,:)
    hButton(i) = uicontrol('Style','pushbutton','String',['State' num2str(i)],...
        'Parent',hGroup,'Units','normalized','Position',[(i-1)/(N+1)+1/32 0 1/(N+1) 1/2],...
        'BackgroundColor',RGB,'Callback',@pushB);
end


function pushB(source,event)
global maps;
nameButton=get(source,'String');
numberState=str2double(nameButton(6:end));
% display(['I pushed the button named ' nameButton])
map_todisplay=maps(:,numberState);
nscouts=sqrt(size(map_todisplay,1));
map_todisplay=reshape(map_todisplay,nscouts,nscouts);
if(nscouts==68)
% %          desikan
    load('data/visualization/desikan/desikan_labels.mat');
    load('data/visualization/desikan/desikan_mni_icbm.mat');
else
 if(nscouts==148)
% %         destrieux 
    load('data/visualization/destrieux/destrieux_labels.mat');
    load('data/visualization/destrieux/destrieux_mni_icbm.mat');
 else
     if(nscouts==210)
% %                  brainnetome
    load('data/visualization/brainnetome/brainnetome_labels.mat');
    load('data/visualization/brainnetome/brainnetome_mni_icbm.mat');

     end
end
end

sphereWidths=ones(nscouts,1);
load('data/visualization/Surfmatrix_icbm.mat');
map_todisplay=ThreshMat(map_todisplay,10);
hFig=figure;movegui(hFig,'center')  
ButtonH=uicontrol('Parent',hFig,'Style','pushbutton','String','Plot BNV','Units','normalized','Position',[0.4 0.1 0.2 0.05],'Visible','on','Callback',{@pushFDR_e,sphereWidths,nscouts,scout_mni,scout_labels,map_todisplay});
go_view_brainnetviewer_eeg(map_todisplay,'thresh_abs',0,0,scout_labels,scout_mni,Surfmatrix)
%Add pushbutton to view data



% UIWAIT makes segment_Visualize wait for user response (see UIRESUME)
% uiwait(handles.figure1);

function pushFDR_e(source,event,sphereWidths,nscouts,scout_mni,scout_labels,conn)
global F_BNV;
write_node(sphereWidths,nscouts,scout_mni,scout_labels);
write_edge(sphereWidths,conn);

F_BNV.MF='BrainNetViewer_20181219/Data/SurfTemplate/BrainMesh_ICBM152.nv';
F_BNV.NI='data/temp/NodeBNV.node';
F_BNV.NT='data/temp/EdgeBNV.edge';
F_BNV.VF='';
BrainNet;

% --- Outputs from this function are returned to the command line.
function varargout = segment_Visualize_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function varargout = dynamic_view(varargin)
% DYNAMIC_VIEW MATLAB code for dynamic_view.fig
%      DYNAMIC_VIEW, by itself, creates a new DYNAMIC_VIEW or raises the existing
%      singleton*.
%
%      H = DYNAMIC_VIEW returns the handle to a new DYNAMIC_VIEW or the handle to
%      the existing singleton*.
%
%      DYNAMIC_VIEW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DYNAMIC_VIEW.M with the given input arguments.
%
%      DYNAMIC_VIEW('Property','Value',...) creates a new DYNAMIC_VIEW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before dynamic_view_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to dynamic_view_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help dynamic_view

% Last Modified by GUIDE v2.5 29-Apr-2021 12:01:16

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @dynamic_view_OpeningFcn, ...
                   'gui_OutputFcn',  @dynamic_view_OutputFcn, ...
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


% --- Executes just before dynamic_view is made visible.
function dynamic_view_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to dynamic_view (see VARARGIN)
  movegui(handles.figure1,'center')  

% Choose default command line output for dynamic_view
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
global mat;
global stepW;

mat=varargin(1);
stepW=varargin{2};

mat=mat{1};
global sample;
sample=1;
set(handles.before_push,'Enable','off');
axes(handles.axes1);
imagesc(squeeze(mat(1,:,:)));
colorbar
xticks(1:size(mat,2));
yticks(1:size(mat,2));

if(size(mat,2)==68)
load('data/visualization/desikan/desikan_labels.mat')
load('data/visualization/desikan/lobe_colors.mat')

else
    if(size(mat,2)==148)
        load('data/visualization/destrieux/destrieux_labels.mat')
        load('data/visualization/destrieux/lobe_colors.mat')

    else
                load('data/visualization/brainnetome/brainnetome_labels.mat')
                        load('data/visualization/brainnetome/lobe_colors.mat')

    end
end
 

ticklabels = get(gca,'XTickLabel');
% prepend a color for each tick label
for i = 1:length(ticklabels)
    ticklabels_new{i} = ['\color{' colors{i} '}' scout_labels{i}];
end
yticklabels(scout_labels)
set(gca, 'XTickLabel', ticklabels_new);
set(gca, 'YTickLabel', ticklabels_new);


xtickangle(90)
set(gca,'FontSize',7)

grid on
axis tight
ylabel('ROIs');
xlabel('ROIs');
set(handles.figure1, 'Name', 'Dynamic view');
beginningTime=0;
endTime=stepW;
set(handles.text_label,'String',['Corresponding time: [ ' num2str(beginningTime) '     ' num2str(endTime) ']']);
set(handles.text_label,'Visible','on');

% UIWAIT makes dynamic_view wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = dynamic_view_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in next_push.
function next_push_Callback(hObject, eventdata, handles)
% hObject    handle to next_push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global mat;
global sample;
global stepW;
if(sample+1<size(mat,1))
    sample=sample+1;
    axes(handles.axes1);
    

    imagesc(squeeze(mat(sample,:,:)));
    colorbar

    grid on
    axis tight
    ylabel('ROIs');
    xlabel('ROIs');
    % Set where ticks will be
                 
xticks(1:size(mat,2));
yticks(1:size(mat,2));

if(size(mat,2)==68)
load('data/visualization/desikan/desikan_labels.mat')
load('data/visualization/desikan/lobe_colors.mat')

else
    if(size(mat,2)==148)
        load('data/visualization/destrieux/destrieux_labels.mat')
        load('data/visualization/destrieux/lobe_colors.mat')

    else
                load('data/visualization/brainnetome/brainnetome_labels.mat')
                        load('data/visualization/brainnetome/lobe_colors.mat')

    end
end
 

ticklabels = get(gca,'XTickLabel');
% prepend a color for each tick label
for i = 1:length(ticklabels)
    ticklabels_new{i} = ['\color{' colors{i} '}' scout_labels{i}];
end
yticklabels(scout_labels)
set(gca, 'XTickLabel', ticklabels_new);
set(gca, 'YTickLabel', ticklabels_new);


xtickangle(90)
set(gca,'FontSize',7)


    
    beginningTime=stepW*(sample-1);
endTime=stepW*(sample);
set(handles.text_label,'String',['Corresponding time: [ ' num2str(beginningTime) '     ' num2str(endTime) ']']);

    set(handles.sample_edit,'String',num2str(sample))
end
if(sample-1>0)
        set(handles.before_push,'Enable','on')
end
if(sample+1>size(mat,1))
        set(handles.next_push,'Enable','off')
end

% --- Executes on button press in before_push.
function before_push_Callback(hObject, eventdata, handles)
% hObject    handle to before_push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global mat;
global sample;
global stepW;
if(sample-1>0)
    sample=sample-1;
    axes(handles.axes1);
    imagesc(squeeze(mat(sample,:,:)));
    colorbar
xticks(1:size(mat,2));
yticks(1:size(mat,2));

xticks(1:size(mat,2));
yticks(1:size(mat,2));

if(size(mat,2)==68)
load('data/visualization/desikan/desikan_labels.mat')
load('data/visualization/desikan/lobe_colors.mat')

else
    if(size(mat,2)==148)
        load('data/visualization/destrieux/destrieux_labels.mat')
        load('data/visualization/destrieux/lobe_colors.mat')

    else
                load('data/visualization/brainnetome/brainnetome_labels.mat')
                        load('data/visualization/brainnetome/lobe_colors.mat')

    end
end
 

ticklabels = get(gca,'XTickLabel');
% prepend a color for each tick label
for i = 1:length(ticklabels)
    ticklabels_new{i} = ['\color{' colors{i} '}' scout_labels{i}];
end
yticklabels(scout_labels)
set(gca, 'XTickLabel', ticklabels_new);
set(gca, 'YTickLabel', ticklabels_new);


xtickangle(90)
set(gca,'FontSize',7)
    grid on
    axis tight
    ylabel('ROIs');
    xlabel('ROIs');
        beginningTime=stepW*(sample-1);
        endTime=stepW*(sample);
set(handles.text_label,'String',['Corresponding time: [ ' num2str(beginningTime) '     ' num2str(endTime) ']']);

    set(handles.sample_edit,'String',num2str(sample))
end
if(sample-1<0)
        set(handles.before_push,'Enable','off')
end
if(sample+1<size(mat,1))
        set(handles.next_push,'Enable','on')
end


function sample_edit_Callback(hObject, eventdata, handles)
% hObject    handle to sample_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sample_edit as text
%        str2double(get(hObject,'String')) returns contents of sample_edit as a double
global sample;
global mat;
global stepW;
ss=get(handles.sample_edit,'String');
try
ssnum=str2double(ss);
if((ssnum<0)||(ssnum>size(mat,1)))
    msgbox('No matrix is found for this window');
else
% %     everything is good
    sample=ssnum;
    axes(handles.axes1);
    imagesc(squeeze(mat(sample,:,:)));
    colorbar

    grid on
    axis tight
    ylabel('ROIs');
    xlabel('ROIs'); 
    xticks(1:size(mat,2));
yticks(1:size(mat,2));

xticks(1:size(mat,2));
yticks(1:size(mat,2));

if(size(mat,2)==68)
load('data/visualization/desikan/desikan_labels.mat')
load('data/visualization/desikan/lobe_colors.mat')

else
    if(size(mat,2)==148)
        load('data/visualization/destrieux/destrieux_labels.mat')
        load('data/visualization/destrieux/lobe_colors.mat')

    else
                load('data/visualization/brainnetome/brainnetome_labels.mat')
                        load('data/visualization/brainnetome/lobe_colors.mat')

    end
end
 

ticklabels = get(gca,'XTickLabel');
% prepend a color for each tick label
for i = 1:length(ticklabels)
    ticklabels_new{i} = ['\color{' colors{i} '}' scout_labels{i}];
end
yticklabels(scout_labels)
set(gca, 'XTickLabel', ticklabels_new);
set(gca, 'YTickLabel', ticklabels_new);


xtickangle(90)
set(gca,'FontSize',7)

        beginningTime=stepW*(sample-1);
        endTime=stepW*(sample);
set(handles.text_label,'String',['Corresponding time: [ ' num2str(beginningTime) '     ' num2str(endTime) ']']);

end

catch
        msgbox('Please enter the window number as integer');
end


% --- Executes during object creation, after setting all properties.
function sample_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sample_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

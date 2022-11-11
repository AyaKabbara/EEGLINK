function varargout = results_GA(varargin)
% RESULTS_GA MATLAB code for results_GA.fig
%      RESULTS_GA, by itself, creates a new RESULTS_GA or raises the existing
%      singleton*.
%
%      H = RESULTS_GA returns the handle to a new RESULTS_GA or the handle to
%      the existing singleton*.
%
%      RESULTS_GA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RESULTS_GA.M with the given input arguments.
%
%      RESULTS_GA('Property','Value',...) creates a new RESULTS_GA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before results_GA_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to results_GA_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help results_GA

% Last Modified by GUIDE v2.5 05-Aug-2021 23:10:22

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @results_GA_OpeningFcn, ...
                   'gui_OutputFcn',  @results_GA_OutputFcn, ...
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


% --- Executes just before results_GA is made visible.
function results_GA_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to results_GA (see VARARGIN)
  movegui(handles.figure1,'center')  

set(handles.figure1,'WindowStyle','modal')
set(handles.figure1, 'Name', 'Group analysis');
[YourImage, ~, ImageAlpha] = imread('Icons/logo_eegnet_greybkg.png');
axes(handles.axes1);
imshow(YourImage)
global data1 data2

% % get group1 names, group2 names from varargin
data1 = varargin{1};
data2= varargin{2};

% load('group_example.mat')
% group1_data = data1;
% group2_data=data2;

 set(handles.push_deltaRes,'Enable','off')
 set(handles.push_thetaRes,'Enable','off')
 set(handles.push_alphaRes,'Enable','off')
 set(handles.push_betaRes,'Enable','off')
 set(handles.push_gammaRes,'Enable','off')
 set(handles.push_customRes,'Enable','off')

% Choose default command line output for results_GA
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


% UIWAIT makes results_GA wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = results_GA_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in push_run.
function push_run_Callback(hObject, eventdata, handles)
% hObject    handle to push_run (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% % get the ttest significance value, wilcoxon significance value (alpha)


try
    threshold=str2double(get(handles.edit_threshold,'String'));
    alpha=str2double(get(handles.edit_wilc_alpha,'String'));
catch
    msgbox('Please enter valid numbers for the ttest2 and wilcoxon significance levels','Warning');     
end

global tail;
global data1 data2
global nscouts
global  P_global index_sigRegions_Bonf index_sigRegions_FDR  

P_global=struct();
index_sigRegions_Bonf=struct();
index_sigRegions_FDR  = struct();
tail=get(handles.list_tail,'Value');
% % 1: if there is common bands: for each band compute the difference in the selected parameter 
    theta_dat1=0;
    alpha_dat1=0;
    beta_dat1=0;
    delta_dat1=0;
    gamma_dat1=0;
    custom_dat1=0;

    theta_dat2=0;
    alpha_dat2=0;
    beta_dat2=0;
    delta_dat2=0;
    gamma_dat2=0;
    custom_dat2=0;
    
theta_common=0;
    alpha_common=0;
    beta_common=0;
    delta_common=0;
    gamma_common=0;
    custom_common=0;

for i=1:length(data1)
if(isfield(data1{i},'theta'))
    theta_dat1=1;
 %break; 
end
if(isfield(data1{i},'alpha'))
    alpha_dat1=1;
 %break; 
end

if(isfield(data1{i},'delta'))
    delta_dat1=1;
 %break; 
end
if(isfield(data1{i},'beta'))
    beta_dat1=1;
 %break; 
end

if(isfield(data1{i},'gamma'))
    gamma_dat1=1;
 %break; 
end
if(isfield(data1{i},'custom'))
    custom_dat1=1;
 %break; 
end

end

for i=1:length(data2)
if(isfield(data2{i},'theta'))
    theta_dat2=1;
 %break; 
end
if(isfield(data2{i},'alpha'))
    alpha_dat2=1;
 %break; 
end

if(isfield(data2{i},'delta'))
    delta_dat2=1;
 %break; 
end
if(isfield(data2{i},'beta'))
    beta_dat2=1;
 %break; 
end

if(isfield(data2{i},'gamma'))
    gamma_dat2=1;
 %break; 
end
if(isfield(data2{i},'custom'))
    custom_dat2=1;
 %break; 
end

end

if(theta_dat1)&&(theta_dat2)
    theta_common=1;
end
if(alpha_dat1)&&(alpha_dat2)
    alpha_common=1;
end
if(delta_dat1)&&(delta_dat2)
    delta_common=1;
end
if(gamma_dat1)&&(gamma_dat2)
    gamma_common=1;
end
if(beta_dat1)&&(beta_dat2)
    beta_common=1;
end
if(custom_dat1)&&(custom_dat2)
    custom_common=1;
end

if(custom_common==0)&&(delta_common==0)&&(theta_common==0)&&(alpha_common==0)&&(beta_common==0)&&(gamma_common==0)
msgbox('There is no common bands between the two selected groups');
closereq;
else
     if(custom_common)
           allmat_g1.custom={};
           for i=1:length(data1)
            if(isfield(data1{i},'custom'))
                allmat_g1.custom{end+1}=data1{i}.custom;
            end
           end
           allmat_g2.custom={};
            for i=1:length(data2)
            if(isfield(data2{i},'custom'))
                allmat_g2.custom{end+1}=data2{i}.custom;
            end
            end      
     end
       
      if(delta_common)
           allmat_g1.delta={};
           for i=1:length(data1)
            if(isfield(data1{i},'delta'))
                allmat_g1.delta{end+1}=data1{i}.delta;
            end
           end
           allmat_g2.delta={};
            for i=1:length(data2)
            if(isfield(data2{i},'delta'))
                allmat_g2.delta{end+1}=data2{i}.delta;
            end
           end
           
      end
     
         if(alpha_common)
           allmat_g1.alpha={};
           for i=1:length(data1)
            if(isfield(data1{i},'alpha'))
                allmat_g1.alpha{end+1}=data1{i}.alpha;
            end
           end
           allmat_g2.alpha={};
            for i=1:length(data2)
            if(isfield(data2{i},'alpha'))
                allmat_g2.alpha{end+1}=data2{i}.alpha;
            end
           end
           
         end
     
            if(theta_common)
           allmat_g1.theta={};
           for i=1:length(data1)
            if(isfield(data1{i},'theta'))
                allmat_g1.theta{end+1}=data1{i}.theta;
            end
           end
           allmat_g2.theta={};
            for i=1:length(data2)
            if(isfield(data2{i},'theta'))
                allmat_g2.theta{end+1}=data2{i}.theta;
            end
           end
           
            end
        if(beta_common)
           allmat_g1.beta={};
           for i=1:length(data1)
            if(isfield(data1{i},'beta'))
                allmat_g1.beta{end+1}=data1{i}.beta;
            end
           end
           allmat_g2.beta={};
            for i=1:length(data2)
            if(isfield(data2{i},'beta'))
                allmat_g2.beta{end+1}=data2{i}.beta;
            end
           end
           
        end
     
           if(gamma_common)
           allmat_g1.gamma={};
           for i=1:length(data1)
            if(isfield(data1{i},'gamma'))
                allmat_g1.gamma{end+1}=data1{i}.gamma;
            end
           end
           allmat_g2.gamma={};
            for i=1:length(data2)
            if(isfield(data2{i},'gamma'))
                allmat_g2.gamma{end+1}=data2{i}.gamma;
            end
           end
           
           end

ListBoxValue = get(handles.list_nodevsedge,'Value');
if(ListBoxValue==1)
% %     node-wise

           dist1=[];
dist2=[];
      
      if(get(handles.rd_degree,'Value'))
%        %% Degree
if(isfield(allmat_g1,'theta'))
    for d=1:length(allmat_g1.theta)
        de=degrees_und(ThreshMat(allmat_g1.theta{d},threshold));
        dist1=[dist1 de'];
    end
    
    for d=1:length(allmat_g2.theta)
        de=degrees_und(ThreshMat(allmat_g2.theta{d},threshold));
        dist2=[dist2 de'];
    end
    [P_global.theta,index_sigRegions_Bonf.theta,index_sigRegions_FDR.theta]=findRegions(dist1,dist2,alpha)
         set(handles.push_thetaRes,'Enable','on'); nscouts=size(dist1,1);
         nscouts=size(dist1,1);

else
        set(handles.push_thetaRes,'Enable','off')

end

if(isfield(allmat_g1,'delta'))
    for d=1:length(allmat_g1.delta)
        de=degrees_und((ThreshMat(allmat_g1.delta{d},threshold)));
        dist1=[dist1 de'];
    end
    
    for d=1:length(allmat_g2.delta)
        de=degrees_und((ThreshMat(allmat_g2.delta{d},threshold)));
        dist2=[dist2 de'];
    end
    [P_global.delta,index_sigRegions_Bonf.delta,index_sigRegions_FDR.delta]=findRegions(dist1,dist2,alpha)
    set(handles.push_deltaRes,'Enable','on'); nscouts=size(dist1,1);
else
        set(handles.push_deltaRes,'Enable','off')

end

if(isfield(allmat_g1,'alpha'))
    for d=1:length(allmat_g1.alpha)
        de=degrees_und((ThreshMat(allmat_g1.alpha{d},threshold)));
        dist1=[dist1 de'];
    end
    
    for d=1:length(allmat_g2.alpha)
        de=degrees_und((ThreshMat(allmat_g2.alpha{d},threshold)));
        dist2=[dist2 de'];
    end
    [P_global.alpha,index_sigRegions_Bonf.alpha,index_sigRegions_FDR.alpha]=findRegions(dist1,dist2,alpha)
    set(handles.push_alphaRes,'Enable','on'); nscouts=size(dist1,1);
else
        set(handles.push_alphaRes,'Enable','off')

end


if(isfield(allmat_g1,'beta'))
    for d=1:length(allmat_g1.beta)
        de=degrees_und((ThreshMat(allmat_g1.beta{d},threshold)));
        dist1=[dist1 de'];
    end
    
    for d=1:length(allmat_g2.beta)
        de=degrees_und((ThreshMat(allmat_g2.beta{d},threshold)));
        dist2=[dist2 de'];
    end
    [P_global.beta,index_sigRegions_Bonf.beta,index_sigRegions_FDR.beta]=findRegions(dist1,dist2,alpha)
    set(handles.push_betaRes,'Enable','on'); nscouts=size(dist1,1);
else
        set(handles.push_betaRes,'Enable','off')

end


if(isfield(allmat_g1,'gamma'))
    for d=1:length(allmat_g1.gamma)
        de=degrees_und((ThreshMat(allmat_g1.gamma{d},threshold)));
        dist1=[dist1 de'];
    end
    
    for d=1:length(allmat_g2.gamma)
        de=degrees_und((ThreshMat(allmat_g2.gamma{d},threshold)));
        dist2=[dist2 de'];
    end
    [P_global.gamma,index_sigRegions_Bonf.gamma,index_sigRegions_FDR.gamma]=findRegions(dist1,dist2,alpha)
    set(handles.push_gammaRes,'Enable','on'); nscouts=size(dist1,1);
else
        set(handles.push_gammaRes,'Enable','off')

end


if(isfield(allmat_g1,'custom'))
    for d=1:length(allmat_g1.custom)
        de=degrees_und((ThreshMat(allmat_g1.custom{d},threshold)));
        dist1=[dist1 de'];
    end
    
    for d=1:length(allmat_g2.custom)
        de=degrees_und((ThreshMat(allmat_g2.custom{d},threshold)));
        dist2=[dist2 de'];
    end
    [P_global.custom,index_sigRegions_Bonf.custom,index_sigRegions_FDR.custom]=findRegions(dist1,dist2,alpha)
    set(handles.push_customRes,'Enable','on'); nscouts=size(dist1,1);
else
        set(handles.push_customRes,'Enable','off')

end        
     end
     if(get(handles.rd_strength,'Value'))
%        %% Degree
dist1=[];
dist2=[];

if(isfield(allmat_g1,'theta'))
    for d=1:length(allmat_g1.theta)
        de=strengths_und(ThreshMat(allmat_g1.theta{d},threshold));
        dist1=[dist1 de'];
    end
    
    for d=1:length(allmat_g2.theta)
        de=strengths_und(ThreshMat(allmat_g2.theta{d},threshold));
        dist2=[dist2 de'];
    end
    [P_global.theta,index_sigRegions_Bonf.theta,index_sigRegions_FDR.theta]=findRegions(dist1,dist2,alpha)

end

if(isfield(allmat_g1,'delta'))
    for d=1:length(allmat_g1.delta)
        de=strengths_und((ThreshMat(allmat_g1.delta{d},threshold)));
        dist1=[dist1 de'];
    end
    
    for d=1:length(allmat_g2.delta)
        de=strengths_und((ThreshMat(allmat_g2.delta{d},threshold)));
        dist2=[dist2 de'];
    end
    [P_global.delta,index_sigRegions_Bonf.delta,index_sigRegions_FDR.delta]=findRegions(dist1,dist2,alpha)
    set(handles.push_deltaRes,'Enable','on'); nscouts=size(dist1,1);
else
        set(handles.push_deltaRes,'Enable','off')

end

if(isfield(allmat_g1,'alpha'))
    for d=1:length(allmat_g1.alpha)
        de=strengths_und((ThreshMat(allmat_g1.alpha{d},threshold)));
        dist1=[dist1 de'];
    end
    
    for d=1:length(allmat_g2.alpha)
        de=strengths_und((ThreshMat(allmat_g2.alpha{d},threshold)));
        dist2=[dist2 de'];
    end
    [P_global.alpha,index_sigRegions_Bonf.alpha,index_sigRegions_FDR.alpha]=findRegions(dist1,dist2,alpha)
    set(handles.push_alphaRes,'Enable','on'); nscouts=size(dist1,1);
else
        set(handles.push_alphaRes,'Enable','off')

end


if(isfield(allmat_g1,'beta'))
    for d=1:length(allmat_g1.beta)
        de=strengths_und((ThreshMat(allmat_g1.beta{d},threshold)));
        dist1=[dist1 de'];
    end
    
    for d=1:length(allmat_g2.beta)
        de=strengths_und((ThreshMat(allmat_g2.beta{d},threshold)));
        dist2=[dist2 de'];
    end
    [P_global.beta,index_sigRegions_Bonf.beta,index_sigRegions_FDR.beta]=findRegions(dist1,dist2,alpha)
    set(handles.push_betaRes,'Enable','on'); nscouts=size(dist1,1);
else
        set(handles.push_betaRes,'Enable','off')

end


if(isfield(allmat_g1,'gamma'))
    for d=1:length(allmat_g1.gamma)
        de=strengths_und((ThreshMat(allmat_g1.gamma{d},threshold)));
        dist1=[dist1 de'];
    end
    
    for d=1:length(allmat_g2.gamma)
        de=strengths_und((ThreshMat(allmat_g2.gamma{d},threshold)));
        dist2=[dist2 de'];
    end
    [P_global.gamma,index_sigRegions_Bonf.gamma,index_sigRegions_FDR.gamma]=findRegions(dist1,dist2,alpha)
    set(handles.push_gammaRes,'Enable','on'); nscouts=size(dist1,1);
else
        set(handles.push_gammaRes,'Enable','off')

end


if(isfield(allmat_g1,'custom'))
    for d=1:length(allmat_g1.custom)
        de=strengths_und((ThreshMat(allmat_g1.custom{d},threshold)));
        dist1=[dist1 de'];
    end
    
    for d=1:length(allmat_g2.custom)
        de=strengths_und((ThreshMat(allmat_g2.custom{d},threshold)));
        dist2=[dist2 de'];
    end
    [P_global.custom,index_sigRegions_Bonf.custom,index_sigRegions_FDR.custom]=findRegions(dist1,dist2,alpha)
    set(handles.push_customRes,'Enable','on'); nscouts=size(dist1,1);
else
        set(handles.push_customRes,'Enable','off')

end        
     end
     
     if(get(handles.rd_bc,'Value'))
%        %% Degree
dist1=[];
dist2=[];

if(isfield(allmat_g1,'theta'))
    for d=1:length(allmat_g1.theta)
        de=betweenness_wei(ThreshMat(allmat_g1.theta{d},threshold));
        dist1=[dist1 de];
    end
    
    for d=1:length(allmat_g2.theta)
        de=betweenness_wei(ThreshMat(allmat_g2.theta{d},threshold));
        dist2=[dist2 de];
    end
    [P_global.theta,index_sigRegions_Bonf.theta,index_sigRegions_FDR.theta]=findRegions(dist1,dist2,alpha)
    set(handles.push_thetaRes,'Enable','on'); nscouts=size(dist1,1);
else
        set(handles.push_thetaRes,'Enable','off')

end

if(isfield(allmat_g1,'delta'))
    for d=1:length(allmat_g1.delta)
        de=betweenness_wei((ThreshMat(allmat_g1.delta{d},threshold)));
        dist1=[dist1 de];
    end
    
    for d=1:length(allmat_g2.delta)
        de=betweenness_wei((ThreshMat(allmat_g2.delta{d},threshold)));
        dist2=[dist2 de];
    end
    [P_global.delta,index_sigRegions_Bonf.delta,index_sigRegions_FDR.delta]=findRegions(dist1,dist2,alpha)
    set(handles.push_deltaRes,'Enable','on'); nscouts=size(dist1,1);
else
        set(handles.push_deltaRes,'Enable','off')

end

if(isfield(allmat_g1,'alpha'))
    for d=1:length(allmat_g1.alpha)
        de=betweenness_wei((ThreshMat(allmat_g1.alpha{d},threshold)));
        dist1=[dist1 de];
    end
    
    for d=1:length(allmat_g2.alpha)
        de=betweenness_wei((ThreshMat(allmat_g2.alpha{d},threshold)));
        dist2=[dist2 de];
    end
    [P_global.alpha,index_sigRegions_Bonf.alpha,index_sigRegions_FDR.alpha]=findRegions(dist1,dist2,alpha)
    set(handles.push_alphaRes,'Enable','on'); nscouts=size(dist1,1);
else
        set(handles.push_alphaRes,'Enable','off')

end


if(isfield(allmat_g1,'beta'))
    for d=1:length(allmat_g1.beta)
        de=betweenness_wei((ThreshMat(allmat_g1.beta{d},threshold)));
        dist1=[dist1 de];
    end
    
    for d=1:length(allmat_g2.beta)
        de=betweenness_wei((ThreshMat(allmat_g2.beta{d},threshold)));
        dist2=[dist2 de];
    end
    [P_global.beta,index_sigRegions_Bonf.beta,index_sigRegions_FDR.beta]=findRegions(dist1,dist2,alpha)
    set(handles.push_betaRes,'Enable','on'); nscouts=size(dist1,1);
else
        set(handles.push_betaRes,'Enable','off')

end


if(isfield(allmat_g1,'gamma'))
    for d=1:length(allmat_g1.gamma)
        de=betweenness_wei((ThreshMat(allmat_g1.gamma{d},threshold)));
        dist1=[dist1 de];
    end
    
    for d=1:length(allmat_g2.gamma)
        de=betweenness_wei((ThreshMat(allmat_g2.gamma{d},threshold)));
        dist2=[dist2 de];
    end
    [P_global.gamma,index_sigRegions_Bonf.gamma,index_sigRegions_FDR.gamma]=findRegions(dist1,dist2,alpha)
    set(handles.push_gammaRes,'Enable','on'); nscouts=size(dist1,1);
else
        set(handles.push_gammaRes,'Enable','off')

end


if(isfield(allmat_g1,'custom'))
    for d=1:length(allmat_g1.custom)
        de=betweenness_wei((ThreshMat(allmat_g1.custom{d},threshold)));
        dist1=[dist1 de];
    end
    
    for d=1:length(allmat_g2.custom)
        de=betweenness_wei((ThreshMat(allmat_g2.custom{d},threshold)));
        dist2=[dist2 de];
    end
    [P_global.custom,index_sigRegions_Bonf.custom,index_sigRegions_FDR.custom]=findRegions(dist1,dist2,alpha)
    set(handles.push_customRes,'Enable','on'); nscouts=size(dist1,1);
else
        set(handles.push_customRes,'Enable','off')

end        
     end
     
dist1=[];
dist2=[];
    
     if(get(handles.rd_cc,'Value'))
%        %% Degree

if(isfield(allmat_g1,'theta'))
    for d=1:length(allmat_g1.theta)
        de=clustering_coef_wu(ThreshMat(allmat_g1.theta{d},threshold));
        dist1=[dist1 de];
    end
    
    for d=1:length(allmat_g2.theta)
        de=clustering_coef_wu(ThreshMat(allmat_g2.theta{d},threshold));
        dist2=[dist2 de];
    end
    [P_global.theta,index_sigRegions_Bonf.theta,index_sigRegions_FDR.theta]=findRegions(dist1,dist2,alpha)
    set(handles.push_thetaRes,'Enable','on'); nscouts=size(dist1,1);
else
        set(handles.push_thetaRes,'Enable','off')

end

if(isfield(allmat_g1,'delta'))
    for d=1:length(allmat_g1.delta)
        de=clustering_coef_wu((ThreshMat(allmat_g1.delta{d},threshold)));
        dist1=[dist1 de];
    end
    
    for d=1:length(allmat_g2.delta)
        de=clustering_coef_wu((ThreshMat(allmat_g2.delta{d},threshold)));
        dist2=[dist2 de];
    end
    [P_global.delta,index_sigRegions_Bonf.delta,index_sigRegions_FDR.delta]=findRegions(dist1,dist2,alpha)
    set(handles.push_deltaRes,'Enable','on'); nscouts=size(dist1,1);
else
        set(handles.push_deltaRes,'Enable','off')

end

if(isfield(allmat_g1,'alpha'))
    for d=1:length(allmat_g1.alpha)
        de=clustering_coef_wu((ThreshMat(allmat_g1.alpha{d},threshold)));
        dist1=[dist1 de];
    end
    
    for d=1:length(allmat_g2.alpha)
        de=clustering_coef_wu((ThreshMat(allmat_g2.alpha{d},threshold)));
        dist2=[dist2 de];
    end
    [P_global.alpha,index_sigRegions_Bonf.alpha,index_sigRegions_FDR.alpha]=findRegions(dist1,dist2,alpha)
    set(handles.push_alphaRes,'Enable','on'); nscouts=size(dist1,1);
else
        set(handles.push_alphaRes,'Enable','off')


end


if(isfield(allmat_g1,'beta'))
    for d=1:length(allmat_g1.beta)
        de=clustering_coef_wu((ThreshMat(allmat_g1.beta{d},threshold)));
        dist1=[dist1 de];
    end
    
    for d=1:length(allmat_g2.beta)
        de=clustering_coef_wu((ThreshMat(allmat_g2.beta{d},threshold)));
        dist2=[dist2 de];
    end
    [P_global.beta,index_sigRegions_Bonf.beta,index_sigRegions_FDR.beta]=findRegions(dist1,dist2,alpha)
    set(handles.push_betaRes,'Enable','on'); nscouts=size(dist1,1);
else
        set(handles.push_betaRes,'Enable','off')


end


if(isfield(allmat_g1,'gamma'))
    for d=1:length(allmat_g1.gamma)
        de=clustering_coef_wu((ThreshMat(allmat_g1.gamma{d},threshold)));
        dist1=[dist1 de];
    end
    
    for d=1:length(allmat_g2.gamma)
        de=clustering_coef_wu((ThreshMat(allmat_g2.gamma{d},threshold)));
        dist2=[dist2 de];
    end
    [P_global.gamma,index_sigRegions_Bonf.gamma,index_sigRegions_FDR.gamma]=findRegions(dist1,dist2,alpha)
    set(handles.push_gammaRes,'Enable','on'); nscouts=size(dist1,1);
else
        set(handles.push_gammaRes,'Enable','off')

end


if(isfield(allmat_g1,'custom'))
    for d=1:length(allmat_g1.custom)
        de=clustering_coef_wu((ThreshMat(allmat_g1.custom{d},threshold)));
        dist1=[dist1 de];
    end
    
    for d=1:length(allmat_g2.custom)
        de=clustering_coef_wu((ThreshMat(allmat_g2.custom{d},threshold)));
        dist2=[dist2 de];
    end
    [P_global.custom,index_sigRegions_Bonf.custom,index_sigRegions_FDR.custom]=findRegions(dist1,dist2,alpha)
    set(handles.push_customRes,'Enable','on'); nscouts=size(dist1,1);
else
        set(handles.push_customRes,'Enable','off')

end        
     end
     
     if(get(handles.rd_pc,'Value'))
%        %% Degree
dist1=[];
dist2=[];

if(isfield(allmat_g1,'theta'))
    for d=1:length(allmat_g1.theta)
        de=part_wei(ThreshMat(allmat_g1.theta{d},threshold));
        dist1=[dist1 de];
    end
    
    for d=1:length(allmat_g2.theta)
        de=part_wei(ThreshMat(allmat_g2.theta{d},threshold));
        dist2=[dist2 de];
    end
    [P_global.theta,index_sigRegions_Bonf.theta,index_sigRegions_FDR.theta]=findRegions(dist1,dist2,alpha)
    set(handles.push_thetaRes,'Enable','on'); nscouts=size(dist1,1);
else
        set(handles.push_thetaRes,'Enable','off')


end

if(isfield(allmat_g1,'delta'))
    for d=1:length(allmat_g1.delta)
        de=part_wei((ThreshMat(allmat_g1.delta{d},threshold)));
        dist1=[dist1 de];
    end
    
    for d=1:length(allmat_g2.delta)
        de=part_wei((ThreshMat(allmat_g2.delta{d},threshold)));
        dist2=[dist2 de];
    end
    [P_global.delta,index_sigRegions_Bonf.delta,index_sigRegions_FDR.delta]=findRegions(dist1,dist2,alpha)
    set(handles.push_deltaRes,'Enable','on'); nscouts=size(dist1,1);
else
        set(handles.push_deltaRes,'Enable','off')


end

if(isfield(allmat_g1,'alpha'))
    for d=1:length(allmat_g1.alpha)
        de=part_wei((ThreshMat(allmat_g1.alpha{d},threshold)));
        dist1=[dist1 de];
    end
    
    for d=1:length(allmat_g2.alpha)
        de=part_wei((ThreshMat(allmat_g2.alpha{d},threshold)));
        dist2=[dist2 de];
    end
    [P_global.alpha,index_sigRegions_Bonf.alpha,index_sigRegions_FDR.alpha]=findRegions(dist1,dist2,alpha)
    set(handles.push_alphaRes,'Enable','on'); nscouts=size(dist1,1);
else
        set(handles.push_alphaRes,'Enable','off')


end


if(isfield(allmat_g1,'beta'))
    for d=1:length(allmat_g1.beta)
        de=part_wei((ThreshMat(allmat_g1.beta{d},threshold)));
        dist1=[dist1 de];
    end
    
    for d=1:length(allmat_g2.beta)
        de=part_wei((ThreshMat(allmat_g2.beta{d},threshold)));
        dist2=[dist2 de];
    end
    [P_global.beta,index_sigRegions_Bonf.beta,index_sigRegions_FDR.beta]=findRegions(dist1,dist2,alpha)
    set(handles.push_betaRes,'Enable','on'); nscouts=size(dist1,1);
else
        set(handles.push_betaRes,'Enable','off')


end


if(isfield(allmat_g1,'gamma'))
    for d=1:length(allmat_g1.gamma)
        de=part_wei((ThreshMat(allmat_g1.gamma{d},threshold)));
        dist1=[dist1 de];
    end
    
    for d=1:length(allmat_g2.gamma)
        de=part_wei((ThreshMat(allmat_g2.gamma{d},threshold)));
        dist2=[dist2 de];
    end
    [P_global.gamma,index_sigRegions_Bonf.gamma,index_sigRegions_FDR.gamma]=findRegions(dist1,dist2,alpha)
    set(handles.push_gammaRes,'Enable','on'); nscouts=size(dist1,1);
else
        set(handles.push_gammaRes,'Enable','off')

end


if(isfield(allmat_g1,'custom'))
    for d=1:length(allmat_g1.custom)
        de=part_wei((ThreshMat(allmat_g1.custom{d},threshold)));
        dist1=[dist1 de];
    end
    
    for d=1:length(allmat_g2.custom)
        de=part_wei((ThreshMat(allmat_g2.custom{d},threshold)));
        dist2=[dist2 de];
    end
    [P_global.custom,index_sigRegions_Bonf.custom,index_sigRegions_FDR.custom]=findRegions(dist1,dist2,alpha)
    set(handles.push_customRes,'Enable','on'); nscouts=size(dist1,1);
else
        set(handles.push_customRes,'Enable','off')

end        
     end
     
     if(get(handles.rd_le,'Value'))
%        %% Degree
dist1=[];
dist2=[];

if(isfield(allmat_g1,'theta'))
    for d=1:length(allmat_g1.theta)
        de=efficiency_wei(ThreshMat(allmat_g1.theta{d},threshold),2);
        dist1=[dist1 de];
    end
    
    for d=1:length(allmat_g2.theta)
        de=efficiency_wei(ThreshMat(allmat_g2.theta{d},threshold),2);
        dist2=[dist2 de];
    end
    [P_global.theta,index_sigRegions_Bonf.theta,index_sigRegions_FDR.theta]=findRegions(dist1,dist2,alpha)
    set(handles.push_thetaRes,'Enable','on'); nscouts=size(dist1,1);
else
        set(handles.push_thetaRes,'Enable','off')

end

if(isfield(allmat_g1,'delta'))
    for d=1:length(allmat_g1.delta)
        de=efficiency_wei(ThreshMat(allmat_g1.delta{d},threshold),2);
        dist1=[dist1 de];
    end
    
    for d=1:length(allmat_g2.delta)
        de=efficiency_wei(ThreshMat(allmat_g2.delta{d},threshold),2);
        dist2=[dist2 de];
    end
    [P_global.delta,index_sigRegions_Bonf.delta,index_sigRegions_FDR.delta]=findRegions(dist1,dist2,alpha)
    set(handles.push_deltaRes,'Enable','on'); nscouts=size(dist1,1);
else
        set(handles.push_deltaRes,'Enable','off')

end

if(isfield(allmat_g1,'alpha'))
    for d=1:length(allmat_g1.alpha)
        de=efficiency_wei(ThreshMat(allmat_g1.alpha{d},threshold),2);
        dist1=[dist1 de];
    end
    
    for d=1:length(allmat_g2.alpha)
        de=efficiency_wei(ThreshMat(allmat_g2.alpha{d},threshold),2);
        dist2=[dist2 de];
    end
    [P_global.alpha,index_sigRegions_Bonf.alpha,index_sigRegions_FDR.alpha]=findRegions(dist1,dist2,alpha)
    set(handles.push_alphaRes,'Enable','on'); nscouts=size(dist1,1);
else
       set(handles.push_alphaRes,'Enable','off')
 
end


if(isfield(allmat_g1,'beta'))
    for d=1:length(allmat_g1.beta)
        de=efficiency_wei(ThreshMat(allmat_g1.beta{d},threshold),2);
        dist1=[dist1 de];
    end
    
    for d=1:length(allmat_g2.beta)
        de=efficiency_wei(ThreshMat(allmat_g2.beta{d},threshold),2);
        dist2=[dist2 de];
    end
    [P_global.beta,index_sigRegions_Bonf.beta,index_sigRegions_FDR.beta]=findRegions(dist1,dist2,alpha)
    set(handles.push_betaRes,'Enable','on'); nscouts=size(dist1,1);
else
        set(handles.push_betaRes,'Enable','off')

end


if(isfield(allmat_g1,'gamma'))
    for d=1:length(allmat_g1.gamma)
        de=efficiency_wei(ThreshMat(allmat_g1.gamma{d},threshold),2);
        dist1=[dist1 de];
    end
    
    for d=1:length(allmat_g2.gamma)
        de=efficiency_wei(ThreshMat(allmat_g2.gamma{d},threshold),2);
        dist2=[dist2 de];
    end
    [P_global.gamma,index_sigRegions_Bonf.gamma,index_sigRegions_FDR.gamma]=findRegions(dist1,dist2,alpha)
    set(handles.push_gammaRes,'Enable','on'); nscouts=size(dist1,1);
else
       set(handles.push_gammaRes,'Enable','off')
 
end


if(isfield(allmat_g1,'custom'))
    for d=1:length(allmat_g1.custom)
        de=efficiency_wei(ThreshMat(allmat_g1.custom{d},threshold),2);
        dist1=[dist1 de];
    end
    
    for d=1:length(allmat_g2.custom)
        de=efficiency_wei(ThreshMat(allmat_g2.custom{d},threshold),2);
        dist2=[dist2 de];
    end
    [P_global.custom,index_sigRegions_Bonf.custom,index_sigRegions_FDR.custom]=findRegions(dist1,dist2,alpha)
    set(handles.push_customRes,'Enable','on'); nscouts=size(dist1,1);
else
        set(handles.push_customRes,'Enable','off')    

end        
     end
else
% %     edge-wise

switch(get(handles.pop_method_edge,'Value'))
    case 1
        UI.method.ui='Run NBS'; 

    case 2
        UI.method.ui='Run FDR'; 
end

UI.test.ui='t-test';
UI.size.ui='Extent';
global finalresults;
ttest_thresh=(get(handles.edit_ttestThresh,'String'));
perms=(get(handles.edit_perms,'String'));

UI.thresh.ui=ttest_thresh;
UI.perms.ui=perms;
global nbs;

UI.alpha.ui=(get(handles.edit_wilc_alpha,'String'));
re_compute=0;
switch get(handles.list_tail,'Value')
    case 1
% %         Group1>Group2
            UI.contrast.ui='[1,-1]'; 
    case 2
        UI.contrast.ui='[-1,1]'; 
    case 3
% %         both
        UI.contrast.ui='[-1,1]'; 
        re_compute=1;
end
if(isfield(allmat_g1,'gamma'))
        Mat=[];
nbSubjects=1;

    for d=1:length(allmat_g1.gamma)
       Mat(:,:,nbSubjects)=ThreshMat(allmat_g1.gamma{d},threshold);
       design(nbSubjects,1)=1;
       design(nbSubjects,2)=0;
       nbSubjects=nbSubjects+1;
    end
    
    for d=1:length(allmat_g2.gamma)
       Mat(:,:,nbSubjects)=ThreshMat(allmat_g2.gamma{d},threshold);
       design(nbSubjects,2)=1;
       design(nbSubjects,1)=0;
       nbSubjects=nbSubjects+1;
    end
    save('external/NBS1.2/temp/ConMat.mat','Mat');
     save('external/NBS1.2/temp/designMat.mat','design');
   
UI.design.ui='external/NBS1.2/temp/designMat.mat';
UI.exchange.ui=''; 
UI.matrices.ui='external/NBS1.2/temp/ConMat.mat';
UI.node_coor.ui='';                       
UI.node_label.ui='';
load('external/NBS1.2/S.mat');
f = waitbar(0,'Please wait...');
NBSrun(UI,S)
waitbar(1,f,'Finished');
close(f);
results=zeros(size(Mat,1),size(Mat,1));
results2=zeros(size(Mat,1),size(Mat,1));
if(isempty(nbs.NBS.con_mat))
    results=zeros(size(Mat,1),size(Mat,1));
else
aa=nbs.NBS.con_mat{1};
results=full(aa);
end
if(re_compute)
            UI.contrast.ui='[1,-1]'; 
            NBSrun(UI,S)
            if(isempty(nbs.NBS.con_mat))
                results2=zeros(size(Mat,1),size(Mat,1));
            else
            aa=nbs.NBS.con_mat{1};
            results2=full(aa);
            end
end
            finalresults.gamma=results+results2;

        set(handles.push_gammaRes,'Enable','on') 
else
            set(handles.push_gammaRes,'Enable','off') 

end

if(isfield(allmat_g1,'beta'))
        Mat=[];
nbSubjects=1;

    for d=1:length(allmat_g1.beta)
       Mat(:,:,nbSubjects)=ThreshMat(allmat_g1.beta{d},threshold);
       design(nbSubjects,1)=1;
       design(nbSubjects,2)=0;
       nbSubjects=nbSubjects+1;
    end
    
    for d=1:length(allmat_g2.beta)
       Mat(:,:,nbSubjects)=ThreshMat(allmat_g2.beta{d},threshold);
       design(nbSubjects,2)=1;
       design(nbSubjects,1)=0;
       nbSubjects=nbSubjects+1;
    end
    save('external/NBS1.2/temp/ConMat.mat','Mat');
     save('external/NBS1.2/temp/designMat.mat','design');
   
UI.design.ui='external/NBS1.2/temp/designMat.mat';
UI.exchange.ui=''; 
UI.matrices.ui='external/NBS1.2/temp/ConMat.mat';
UI.node_coor.ui='';                       
UI.node_label.ui='';
load('NBS1.2/S.mat');
NBSrun(UI,S)
results=zeros(size(Mat,1),size(Mat,1));
results2=zeros(size(Mat,1),size(Mat,1));
if(isempty(nbs.NBS.con_mat))
    results=zeros(size(Mat,1),size(Mat,1));
else
aa=nbs.NBS.con_mat{1};
results=full(aa);
end
if(re_compute)
            UI.contrast.ui='[1,-1]'; 
            NBSrun(UI,S)
            if(isempty(nbs.NBS.con_mat))
                results2=zeros(size(Mat,1),size(Mat,1));
            else
            aa=nbs.NBS.con_mat{1};
            results2=full(aa);
            end
end
            finalresults.beta=results+results2;

        set(handles.push_betaRes,'Enable','on') 
else
            set(handles.push_betaRes,'Enable','off') 

end
if(isfield(allmat_g1,'alpha'))
        Mat=[];
nbSubjects=1;

    for d=1:length(allmat_g1.alpha)
       Mat(:,:,nbSubjects)=ThreshMat(allmat_g1.alpha{d},threshold);
       design(nbSubjects,1)=1;
       design(nbSubjects,2)=0;
       nbSubjects=nbSubjects+1;
    end
    
    for d=1:length(allmat_g2.alpha)
       Mat(:,:,nbSubjects)=ThreshMat(allmat_g2.alpha{d},threshold);
       design(nbSubjects,2)=1;
       design(nbSubjects,1)=0;
       nbSubjects=nbSubjects+1;
    end
    save('external/NBS1.2/temp/ConMat.mat','Mat');
     save('external/NBS1.2/temp/designMat.mat','design');
   
UI.design.ui='external/NBS1.2/temp/designMat.mat';
UI.exchange.ui=''; 
UI.matrices.ui='external/NBS1.2/temp/ConMat.mat';
UI.node_coor.ui='';                       
UI.node_label.ui='';
load('NBS1.2/S.mat');
NBSrun(UI,S)
results=zeros(size(Mat,1),size(Mat,1));
results2=zeros(size(Mat,1),size(Mat,1));
if(isempty(nbs.NBS.con_mat))
    results=zeros(size(Mat,1),size(Mat,1));
else
aa=nbs.NBS.con_mat{1};
results=full(aa);
end
if(re_compute)
            UI.contrast.ui='[1,-1]'; 
            NBSrun(UI,S)
            if(isempty(nbs.NBS.con_mat))
                results2=zeros(size(Mat,1),size(Mat,1));
            else
            aa=nbs.NBS.con_mat{1};
            results2=full(aa);
            end
end
            finalresults.alpha=results+results2;

        set(handles.push_alphaRes,'Enable','on') 
else
            set(handles.push_alphaRes,'Enable','off') 

end
if(isfield(allmat_g1,'theta'))
        Mat=[];
nbSubjects=1;

    for d=1:length(allmat_g1.theta)
       Mat(:,:,nbSubjects)=ThreshMat(allmat_g1.theta{d},threshold);
       design(nbSubjects,1)=1;
       design(nbSubjects,2)=0;
       nbSubjects=nbSubjects+1;
    end
    
    for d=1:length(allmat_g2.theta)
       Mat(:,:,nbSubjects)=ThreshMat(allmat_g2.theta{d},threshold);
       design(nbSubjects,2)=1;
       design(nbSubjects,1)=0;
       nbSubjects=nbSubjects+1;
    end
    save('external/NBS1.2/temp/ConMat.mat','Mat');
     save('external/NBS1.2/temp/designMat.mat','design');
   
UI.design.ui='external/NBS1.2/temp/designMat.mat';
UI.exchange.ui=''; 
UI.matrices.ui='external/NBS1.2/temp/ConMat.mat';
UI.node_coor.ui='';                       
UI.node_label.ui='';
load('NBS1.2/S.mat');
NBSrun(UI,S)
results=zeros(size(Mat,1),size(Mat,1));
results2=zeros(size(Mat,1),size(Mat,1));
if(isempty(nbs.NBS.con_mat))
    results=zeros(size(Mat,1),size(Mat,1));
else
aa=nbs.NBS.con_mat{1};
results=full(aa);
end
if(re_compute)
            UI.contrast.ui='[1,-1]'; 
            NBSrun(UI,S)
            if(isempty(nbs.NBS.con_mat))
                results2=zeros(size(Mat,1),size(Mat,1));
            else
            aa=nbs.NBS.con_mat{1};
            results2=full(aa);
            end
end
            finalresults.theta=results+results2;

        set(handles.push_thetaRes,'Enable','on') 
else
            set(handles.push_thetaRes,'Enable','off') 

end
if(isfield(allmat_g1,'delta'))
        Mat=[];
nbSubjects=1;

    for d=1:length(allmat_g1.delta)
       Mat(:,:,nbSubjects)=ThreshMat(allmat_g1.delta{d},threshold);
       design(nbSubjects,1)=1;
       design(nbSubjects,2)=0;
       nbSubjects=nbSubjects+1;
    end
    
    for d=1:length(allmat_g2.delta)
       Mat(:,:,nbSubjects)=ThreshMat(allmat_g2.delta{d},threshold);
       design(nbSubjects,2)=1;
       design(nbSubjects,1)=0;
       nbSubjects=nbSubjects+1;
    end
    save('external/NBS1.2/temp/ConMat.mat','Mat');
     save('external/NBS1.2/temp/designMat.mat','design');
   
UI.design.ui='external/NBS1.2/temp/designMat.mat';
UI.exchange.ui=''; 
UI.matrices.ui='external/NBS1.2/temp/ConMat.mat';
UI.node_coor.ui='';                       
UI.node_label.ui='';
load('NBS1.2/S.mat');
NBSrun(UI,S)
results=zeros(size(Mat,1),size(Mat,1));
results2=zeros(size(Mat,1),size(Mat,1));
if(isempty(nbs.NBS.con_mat))
    results=zeros(size(Mat,1),size(Mat,1));
else
aa=nbs.NBS.con_mat{1};
results=full(aa);
end
if(re_compute)
            UI.contrast.ui='[1,-1]'; 
            NBSrun(UI,S)
            if(isempty(nbs.NBS.con_mat))
                results2=zeros(size(Mat,1),size(Mat,1));
            else
            aa=nbs.NBS.con_mat{1};
            results2=full(aa);
            end
end
            finalresults.delta=results+results2;

        set(handles.push_deltaRes,'Enable','on') 
else
            set(handles.push_deltaRes,'Enable','off') 

end
if(isfield(allmat_g1,'custom'))
        Mat=[];
nbSubjects=1;

    for d=1:length(allmat_g1.custom)
       Mat(:,:,nbSubjects)=ThreshMat(allmat_g1.custom{d},threshold);
       design(nbSubjects,1)=1;
       design(nbSubjects,2)=0;
       nbSubjects=nbSubjects+1;
    end
    
    for d=1:length(allmat_g2.custom)
       Mat(:,:,nbSubjects)=ThreshMat(allmat_g2.custom{d},threshold);
       design(nbSubjects,2)=1;
       design(nbSubjects,1)=0;
       nbSubjects=nbSubjects+1;
    end
    save('external/NBS1.2/temp/ConMat.mat','Mat');
     save('external/NBS1.2/temp/designMat.mat','design');
   
UI.design.ui='external/NBS1.2/temp/designMat.mat';
UI.exchange.ui=''; 
UI.matrices.ui='external/NBS1.2/temp/ConMat.mat';
UI.node_coor.ui='';                       
UI.node_label.ui='';
load('NBS1.2/S.mat');
NBSrun(UI,S)
results=zeros(size(Mat,1),size(Mat,1));
results2=zeros(size(Mat,1),size(Mat,1));
if(isempty(nbs.NBS.con_mat))
    results=zeros(size(Mat,1),size(Mat,1));
else
aa=nbs.NBS.con_mat{1};
results=full(aa);
end
if(re_compute)
            UI.contrast.ui='[1,-1]'; 
            NBSrun(UI,S)
            if(isempty(nbs.NBS.con_mat))
                results2=zeros(size(Mat,1),size(Mat,1));
            else
            aa=nbs.NBS.con_mat{1};
            results2=full(aa);
            end
end
            finalresults.custom=results+results2;

        set(handles.push_customRes,'Enable','on') 
else
            set(handles.push_customRes,'Enable','off') 

end

end
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in list_nodevsedge.
function list_nodevsedge_Callback(hObject, eventdata, handles)
% hObject    handle to list_nodevsedge (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns list_nodevsedge contents as cell array
%        contents{get(hObject,'Value')} returns selected item from list_nodevsedge
ListBoxString = get(handles.list_nodevsedge,'String');
ListBoxValue = get(handles.list_nodevsedge,'Value');
if(find(strcmp(ListBoxString,'Node')) == ListBoxValue)
  set(handles.panel_node,'Visible','on');
   set(handles.panel_edge,'Visible','off');

elseif(find(strcmp(ListBoxString,'Edge')) == ListBoxValue)
    set(handles.panel_node,'Visible','off');
   set(handles.panel_edge,'Visible','on');

end

% --- Executes during object creation, after setting all properties.
function list_nodevsedge_CreateFcn(hObject, eventdata, handles)
% hObject    handle to list_nodevsedge (see GCBO)
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



function edit_wilc_alpha_Callback(hObject, eventdata, handles)
% hObject    handle to edit_wilc_alpha (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_wilc_alpha as text
%        str2double(get(hObject,'String')) returns contents of edit_wilc_alpha as a double


% --- Executes during object creation, after setting all properties.
function edit_wilc_alpha_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_wilc_alpha (see GCBO)
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



function edit_threshold_Callback(hObject, eventdata, handles)
% hObject    handle to edit_threshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_threshold as text
%        str2double(get(hObject,'String')) returns contents of edit_threshold as a double


% --- Executes during object creation, after setting all properties.
function edit_threshold_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_threshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in push_deltaRes.
function push_deltaRes_Callback(hObject, eventdata, handles)
% hObject    handle to push_deltaRes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% --- Executes on button press in push_thetaRes.

global nscouts
global  P_global index_sigRegions_Bonf index_sigRegions_FDR  

ListBoxValue = get(handles.list_nodevsedge,'Value');
if(ListBoxValue==1)
% % load files for drawing
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
load('data/visualization/Surfmatrix_icbm.mat');

% % prepare the spherwidths
sphereWidths=zeros(nscouts,1);
sphereWidths(index_sigRegions_FDR.delta)=1;
if(nnz(sphereWidths)>0)
    labels_id=1;
else
      labels_id=0;
  
end
hFig=figure;
  movegui(hFig,'center')  
  %Add pushbutton to view data
  ButtonH=uicontrol('Parent',hFig,'Style','pushbutton','String','Plot BNV','Units','normalized','Position',[0.2 0.1 0.2 0.05],'Visible','on','Callback',{@pushFDR,sphereWidths,nscouts,scout_mni,scout_labels});

subplot(1,2,1);

go_view_brainnetviewer_graphGA(ones(nscouts,nscouts),labels_id,scout_labels,scout_mni,Surfmatrix,sphereWidths)
title('FDR results for delta band') 

subplot(1,2,2);

sphereWidths=zeros(nscouts,1);
sphereWidths(index_sigRegions_Bonf.delta)=1;
if(nnz(sphereWidths)>0)
    labels_id=1;
else
      labels_id=0;
  
end

go_view_brainnetviewer_graphGA(rand(nscouts,nscouts),labels_id,scout_labels,scout_mni,Surfmatrix,sphereWidths)
  ButtonJ=uicontrol('Parent',hFig,'Style','pushbutton','String','Plot BNV','Units','normalized','Position',[0.7 0.1 0.2 0.05],'Visible','on','Callback',{@pushFDR,sphereWidths,nscouts,scout_mni,scout_labels});

title('Bonferroni results for delta band') 

sgtitle(['Global p-value between the two groups:' num2str(P_global.delta)]) 
else
% %     edge
global finalresults
    if(size(finalresults.delta,1)==68)
% %          desikan
    load('data/visualization/desikan/desikan_labels.mat');
    load('data/visualization/desikan/desikan_mni_icbm.mat');
else
 if(size(finalresults.delta,1)==148)
% %         destrieux 
    load('data/visualization/destrieux/destrieux_labels.mat');
    load('data/visualization/destrieux/destrieux_mni_icbm.mat');
 else
     if(size(finalresults.delta,1)==210)
% %                  brainnetome
    load('data/visualization/brainnetome/brainnetome_labels.mat');
    load('data/visualization/brainnetome/brainnetome_mni_icbm.mat');

     end
end
end
load('data/visualization/Surfmatrix_icbm.mat');
if(sum(sum(finalresults.delta))==0)
    figure
    
   title('No significant results') 
else
    
hFig=figure;
movegui(hFig,'center')  
%Add pushbutton to view data
sphereWidths=ones(68,1);
ButtonH=uicontrol('Parent',hFig,'Style','pushbutton','String','Plot BNV','Units','normalized','Position',[0.4 0.1 0.2 0.05],'Visible','on','Callback',{@pushFDR_e,sphereWidths,nscouts,scout_mni,scout_labels,finalresults.delta});
go_view_brainnetviewer_eeg(finalresults.delta,'thresh_abs',0,0,scout_labels,scout_mni,Surfmatrix)


end

end

function push_thetaRes_Callback(hObject, eventdata, handles)
% hObject    handle to push_thetaRes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global nscouts
global  P_global index_sigRegions_Bonf index_sigRegions_FDR  

ListBoxValue = get(handles.list_nodevsedge,'Value');
if(ListBoxValue==1)
% % load files for drawing
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
load('data/visualization/Surfmatrix_icbm.mat');

% % prepare the spherwidths
sphereWidths=zeros(nscouts,1);
sphereWidths(index_sigRegions_FDR.theta)=1;
if(nnz(sphereWidths)>0)
    labels_id=1;
else
      labels_id=0;
  
end
hFig=figure;
  movegui(hFig,'center')  
  %Add pushbutton to view data
  ButtonH=uicontrol('Parent',hFig,'Style','pushbutton','String','Plot BNV','Units','normalized','Position',[0.2 0.1 0.2 0.05],'Visible','on','Callback',{@pushFDR,sphereWidths,nscouts,scout_mni,scout_labels});

go_view_brainnetviewer_graphGA(ones(nscouts,nscouts),labels_id,scout_labels,scout_mni,Surfmatrix,sphereWidths)
title('FDR results for theta band') 

subplot(1,2,2);

sphereWidths=zeros(nscouts,1);
sphereWidths(index_sigRegions_Bonf.theta)=1;
if(nnz(sphereWidths)>0)
    labels_id=1;
else
      labels_id=0;
  
end
  ButtonJ=uicontrol('Parent',hFig,'Style','pushbutton','String','Plot BNV','Units','normalized','Position',[0.7 0.1 0.2 0.05],'Visible','on','Callback',{@pushFDR,sphereWidths,nscouts,scout_mni,scout_labels});

go_view_brainnetviewer_graphGA(rand(nscouts,nscouts),labels_id,scout_labels,scout_mni,Surfmatrix,sphereWidths)
title('Bonferroni results for theta band') 

sgtitle(['Global p-value between the two groups:' num2str(P_global.theta)]) 
else
% %     edge
global finalresults
    if(size(finalresults.theta,1)==68)
% %          desikan
    load('data/visualization/desikan/desikan_labels.mat');
    load('data/visualization/desikan/desikan_mni_icbm.mat');
else
 if(size(finalresults.theta,1)==148)
% %         destrieux 
    load('data/visualization/destrieux/destrieux_labels.mat');
    load('data/visualization/destrieux/destrieux_mni_icbm.mat');
 else
     if(size(finalresults.theta,1)==210)
% %                  brainnetome
    load('data/visualization/brainnetome/brainnetome_labels.mat');
    load('data/visualization/brainnetome/brainnetome_mni_icbm.mat');

     end
end
end
load('data/visualization/Surfmatrix_icbm.mat');
if(sum(sum(finalresults.theta))==0)
    figure
    
   title('No significant results') 
else
    
hFig=figure;
movegui(hFig,'center')  
%Add pushbutton to view data
sphereWidths=ones(68,1);
ButtonH=uicontrol('Parent',hFig,'Style','pushbutton','String','Plot BNV','Units','normalized','Position',[0.4 0.1 0.2 0.05],'Visible','on','Callback',{@pushFDR_e,sphereWidths,nscouts,scout_mni,scout_labels,finalresults.theta});
go_view_brainnetviewer_eeg(finalresults.theta,'thresh_abs',0,0,scout_labels,scout_mni,Surfmatrix)


end

end


% --- Executes on button press in push_betaRes.
function push_betaRes_Callback(hObject, eventdata, handles)
% hObject    handle to push_betaRes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global nscouts
global  P_global index_sigRegions_Bonf index_sigRegions_FDR  

ListBoxValue = get(handles.list_nodevsedge,'Value');
if(ListBoxValue==1)
% % load files for drawing
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
load('data/visualization/Surfmatrix_icbm.mat');

% % prepare the spherwidths
sphereWidths=zeros(nscouts,1);
sphereWidths(index_sigRegions_FDR.beta)=1;
if(nnz(sphereWidths)>0)
    labels_id=1;
else
      labels_id=0;
  
end
hFig=figure;
  movegui(hFig,'center')  
  %Add pushbutton to view data
  ButtonH=uicontrol('Parent',hFig,'Style','pushbutton','String','Plot BNV','Units','normalized','Position',[0.2 0.1 0.2 0.05],'Visible','on','Callback',{@pushFDR,sphereWidths,nscouts,scout_mni,scout_labels});
subplot(1,2,1);

go_view_brainnetviewer_graphGA(ones(nscouts,nscouts),labels_id,scout_labels,scout_mni,Surfmatrix,sphereWidths)
title('FDR results for beta band') 

subplot(1,2,2);

sphereWidths=zeros(nscouts,1);
sphereWidths(index_sigRegions_Bonf.beta)=1;
if(nnz(sphereWidths)>0)
    labels_id=1;
else
      labels_id=0;
  
end
  ButtonJ=uicontrol('Parent',hFig,'Style','pushbutton','String','Plot BNV','Units','normalized','Position',[0.7 0.1 0.2 0.05],'Visible','on','Callback',{@pushFDR,sphereWidths,nscouts,scout_mni,scout_labels});

go_view_brainnetviewer_graphGA(rand(nscouts,nscouts),labels_id,scout_labels,scout_mni,Surfmatrix,sphereWidths)
title('Bonferroni results for beta band') 

sgtitle(['Global p-value between the two groups:' num2str(P_global.beta)]) 
else
% %     edge
global finalresults
    if(size(finalresults.beta,1)==68)
% %          desikan
    load('data/visualization/desikan/desikan_labels.mat');
    load('data/visualization/desikan/desikan_mni_icbm.mat');
else
 if(size(finalresults.beta,1)==148)
% %         destrieux 
    load('data/visualization/destrieux/destrieux_labels.mat');
    load('data/visualization/destrieux/destrieux_mni_icbm.mat');
 else
     if(size(finalresults.beta,1)==210)
% %                  brainnetome
    load('data/visualization/brainnetome/brainnetome_labels.mat');
    load('data/visualization/brainnetome/brainnetome_mni_icbm.mat');

     end
end
end
load('data/visualization/Surfmatrix_icbm.mat');
if(sum(sum(finalresults.beta))==0)
    figure
    
   title('No significant results') 
else
    
hFig=figure;
movegui(hFig,'center')  
%Add pushbutton to view data
sphereWidths=ones(68,1);
ButtonH=uicontrol('Parent',hFig,'Style','pushbutton','String','Plot BNV','Units','normalized','Position',[0.4 0.1 0.2 0.05],'Visible','on','Callback',{@pushFDR_e,sphereWidths,nscouts,scout_mni,scout_labels,finalresults.beta});
go_view_brainnetviewer_eeg(finalresults.beta,'thresh_abs',0,0,scout_labels,scout_mni,Surfmatrix)


end

end


% --- Executes on button press in push_alphaRes.
function push_alphaRes_Callback(hObject, eventdata, handles)
% hObject    handle to push_alphaRes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global nscouts
global  P_global index_sigRegions_Bonf index_sigRegions_FDR  

ListBoxValue = get(handles.list_nodevsedge,'Value');
if(ListBoxValue==1)
% % load files for drawing
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
load('data/visualization/Surfmatrix_icbm.mat');

% % prepare the spherwidths
sphereWidths=zeros(nscouts,1);
sphereWidths(index_sigRegions_FDR.alpha)=1;
if(nnz(sphereWidths)>0)
    labels_id=1;
else
      labels_id=0;
  
end

hFig=figure;
  movegui(hFig,'center')  
  %Add pushbutton to view data
  ButtonH=uicontrol('Parent',hFig,'Style','pushbutton','String','Plot BNV','Units','normalized','Position',[0.2 0.1 0.2 0.05],'Visible','on','Callback',{@pushFDR,sphereWidths,nscouts,scout_mni,scout_labels});

  % figure;
subplot(1,2,1);

go_view_brainnetviewer_graphGA(ones(nscouts,nscouts),labels_id,scout_labels,scout_mni,Surfmatrix,sphereWidths)
title('FDR results for alpha band') 
subplot(1,2,2);

sphereWidths=zeros(nscouts,1);
sphereWidths(index_sigRegions_Bonf.alpha)=1;
if(nnz(sphereWidths)>0)
    labels_id=1;
else
      labels_id=0;
  
end
  ButtonJ=uicontrol('Parent',hFig,'Style','pushbutton','String','Plot BNV','Units','normalized','Position',[0.7 0.1 0.2 0.05],'Visible','on','Callback',{@pushBONF,sphereWidths,nscouts,scout_mni,scout_labels});

go_view_brainnetviewer_graphGA(rand(nscouts,nscouts),labels_id,scout_labels,scout_mni,Surfmatrix,sphereWidths)
title('Bonferroni results for alpha band') 

sgtitle(['Global p-value between the two groups:' num2str(P_global.alpha)]) 
else
% %     edge
global finalresults
    if(size(finalresults.alpha,1)==68)
% %          desikan
    load('data/visualization/desikan/desikan_labels.mat');
    load('data/visualization/desikan/desikan_mni_icbm.mat');
else
 if(size(finalresults.alpha,1)==148)
% %         destrieux 
    load('data/visualization/destrieux/destrieux_labels.mat');
    load('data/visualization/destrieux/destrieux_mni_icbm.mat');
 else
     if(size(finalresults.alpha,1)==210)
% %                  brainnetome
    load('data/visualization/brainnetome/brainnetome_labels.mat');
    load('data/visualization/brainnetome/brainnetome_mni_icbm.mat');

     end
end
end
load('data/visualization/Surfmatrix_icbm.mat');
if(sum(sum(finalresults.alpha))==0)
    figure
    
   title('No significant results') 
else
    
hFig=figure;
movegui(hFig,'center')  
%Add pushbutton to view data
sphereWidths=ones(68,1);
ButtonH=uicontrol('Parent',hFig,'Style','pushbutton','String','Plot BNV','Units','normalized','Position',[0.4 0.1 0.2 0.05],'Visible','on','Callback',{@pushFDR_e,sphereWidths,nscouts,scout_mni,scout_labels,finalresults.alpha});
go_view_brainnetviewer_eeg(finalresults.alpha,'thresh_abs',0,0,scout_labels,scout_mni,Surfmatrix)


end

end

function pushFDR(source,event,sphereWidths,nscouts,scout_mni,scout_labels)
global F_BNV;
write_node(sphereWidths,nscouts,scout_mni,scout_labels)
F_BNV.MF='external/BrainNetViewer_20181219/Data/SurfTemplate/BrainMesh_ICBM152.nv';
F_BNV.NI='data/temp/NodeBNV.node';
F_BNV.NT='';
F_BNV.VF='';
BrainNet;

function pushFDR_e(source,event,sphereWidths,nscouts,scout_mni,scout_labels,conn)
global F_BNV;
write_node(sphereWidths,nscouts,scout_mni,scout_labels);
write_edge(sphereWidths,conn);

F_BNV.MF='external/BrainNetViewer_20181219/Data/SurfTemplate/BrainMesh_ICBM152.nv';
F_BNV.NI='data/temp/NodeBNV.node';
F_BNV.NT='data/temp/EdgeBNV.edge';
F_BNV.VF='';
BrainNet;

% uiwait(bn);
% --- Executes on button press in push_gammaRes.
function push_gammaRes_Callback(hObject, eventdata, handles)
% hObject    handle to push_gammaRes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global nscouts
global  P_global index_sigRegions_Bonf index_sigRegions_FDR  

ListBoxValue = get(handles.list_nodevsedge,'Value');
if(ListBoxValue==1)
% % load files for drawing
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
load('data/visualization/Surfmatrix_icbm.mat');

% % prepare the spherwidths
sphereWidths=zeros(nscouts,1);
sphereWidths(index_sigRegions_FDR.gamma)=1;
if(nnz(sphereWidths)>0)
    labels_id=1;
else
      labels_id=0;
  
end

hFig=figure;
  movegui(hFig,'center')  
  %Add pushbutton to view data
  ButtonH=uicontrol('Parent',hFig,'Style','pushbutton','String','Plot BNV','Units','normalized','Position',[0.2 0.1 0.2 0.05],'Visible','on','Callback',{@pushFDR,sphereWidths,nscouts,scout_mni,scout_labels});

subplot(1,2,1);

go_view_brainnetviewer_graphGA(ones(nscouts,nscouts),labels_id,scout_labels,scout_mni,Surfmatrix,sphereWidths)
title('FDR results for gamma band') 

subplot(1,2,2);

sphereWidths=zeros(nscouts,1);
sphereWidths(index_sigRegions_Bonf.gamma)=1;
if(nnz(sphereWidths)>0)
    labels_id=1;
else
      labels_id=0;
  
end
 ButtonJ=uicontrol('Parent',hFig,'Style','pushbutton','String','Plot BNV','Units','normalized','Position',[0.7 0.1 0.2 0.05],'Visible','on','Callback',{@pushBNV,sphereWidths,nscouts,scout_mni,scout_labels});

go_view_brainnetviewer_graphGA(rand(nscouts,nscouts),labels_id,scout_labels,scout_mni,Surfmatrix,sphereWidths)
title('Bonferroni results for gamma band') 

sgtitle(['Global p-value between the two groups:' num2str(P_global.gamma)]) 
else
% %     edge
global finalresults
    if(size(finalresults.gamma,1)==68)
% %          desikan
    load('data/visualization/desikan/desikan_labels.mat');
    load('data/visualization/desikan/desikan_mni_icbm.mat');
else
 if(size(finalresults.gamma,1)==148)
% %         destrieux 
    load('data/visualization/destrieux/destrieux_labels.mat');
    load('data/visualization/destrieux/destrieux_mni_icbm.mat');
 else
     if(size(finalresults.gamma,1)==210)
% %                  brainnetome
    load('data/visualization/brainnetome/brainnetome_labels.mat');
    load('data/visualization/brainnetome/brainnetome_mni_icbm.mat');

     end
end
end
load('data/visualization/Surfmatrix_icbm.mat');
if(sum(sum(finalresults.gamma))==0)
    figure
    
   title('No significant results') 
else
    
hFig=figure;
movegui(hFig,'center')  
%Add pushbutton to view data
sphereWidths=ones(68,1);
ButtonH=uicontrol('Parent',hFig,'Style','pushbutton','String','Plot BNV','Units','normalized','Position',[0.4 0.1 0.2 0.05],'Visible','on','Callback',{@pushFDR_e,sphereWidths,nscouts,scout_mni,scout_labels,finalresults.gamma});
go_view_brainnetviewer_eeg(finalresults.gamma,'thresh_abs',0,0,scout_labels,scout_mni,Surfmatrix)


end

end

% --- Executes on button press in push_customRes.
function push_customRes_Callback(hObject, eventdata, handles)
% hObject    handle to push_customRes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global nscouts
global  P_global index_sigRegions_Bonf index_sigRegions_FDR  

ListBoxValue = get(handles.list_nodevsedge,'Value');
if(ListBoxValue==1)
% % load files for drawing
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
load('data/visualization/Surfmatrix_icbm.mat');

% % prepare the spherwidths
sphereWidths=zeros(nscouts,1);
sphereWidths(index_sigRegions_FDR.custom)=1;
if(nnz(sphereWidths)>0)
    labels_id=1;
else
      labels_id=0;
  
end
hFig=figure;
  movegui(hFig,'center')  
  %Add pushbutton to view data
  ButtonH=uicontrol('Parent',hFig,'Style','pushbutton','String','Plot BNV','Units','normalized','Position',[0.2 0.1 0.2 0.05],'Visible','on','Callback',{@pushFDR,sphereWidths,nscouts,scout_mni,scout_labels});
subplot(1,2,1);

go_view_brainnetviewer_graphGA(ones(nscouts,nscouts),labels_id,scout_labels,scout_mni,Surfmatrix,sphereWidths)
title('FDR results for custom band') 

subplot(1,2,2);

sphereWidths=zeros(nscouts,1);
sphereWidths(index_sigRegions_Bonf.custom)=1;
if(nnz(sphereWidths)>0)
    labels_id=1;
else
      labels_id=0;
  
end
  ButtonJ=uicontrol('Parent',hFig,'Style','pushbutton','String','Plot BNV','Units','normalized','Position',[0.7 0.1 0.2 0.05],'Visible','on','Callback',{@pushFDR,sphereWidths,nscouts,scout_mni,scout_labels});

go_view_brainnetviewer_graphGA(rand(nscouts,nscouts),labels_id,scout_labels,scout_mni,Surfmatrix,sphereWidths)
title('Bonferroni results for custom band') 

sgtitle(['Global p-value between the two groups:' num2str(P_global.custom)]) 
else
% %     edge
global finalresults
    if(size(finalresults.custom,1)==68)
% %          desikan
    load('data/visualization/desikan/desikan_labels.mat');
    load('data/visualization/desikan/desikan_mni_icbm.mat');
else
 if(size(finalresults.custom,1)==148)
% %         destrieux 
    load('data/visualization/destrieux/destrieux_labels.mat');
    load('data/visualization/destrieux/destrieux_mni_icbm.mat');
 else
     if(size(finalresults.custom,1)==210)
% %                  brainnetome
    load('data/visualization/brainnetome/brainnetome_labels.mat');
    load('data/visualization/brainnetome/brainnetome_mni_icbm.mat');

     end
end
end
load('data/visualization/Surfmatrix_icbm.mat');
if(sum(sum(finalresults.custom))==0)
    figure
    
   title('No significant results') 
else
hFig=figure;
movegui(hFig,'center')  
%Add pushbutton to view data
sphereWidths=ones(68,1);
ButtonH=uicontrol('Parent',hFig,'Style','pushbutton','String','Plot BNV','Units','normalized','Position',[0.4 0.1 0.2 0.05],'Visible','on','Callback',{@pushFDR_e,sphereWidths,nscouts,scout_mni,scout_labels,finalresults.custom});
go_view_brainnetviewer_eeg(finalresults.custom,'thresh_abs',0,0,scout_labels,scout_mni,Surfmatrix)
    

end

end

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



function edit_perms_Callback(hObject, eventdata, handles)
% hObject    handle to edit_perms (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_perms as text
%        str2double(get(hObject,'String')) returns contents of edit_perms as a double


% --- Executes during object creation, after setting all properties.
function edit_perms_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_perms (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pop_method_edge.
function pop_method_edge_Callback(hObject, eventdata, handles)
% hObject    handle to pop_method_edge (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pop_method_edge contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pop_method_edge


% --- Executes during object creation, after setting all properties.
function pop_method_edge_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pop_method_edge (see GCBO)
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


% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in push_save.
function push_save_Callback(hObject, eventdata, handles)
% hObject    handle to push_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global finalresults;

[filename, filepath] = uiputfile('*.mat', 'Save results:');
FileName = fullfile(filepath, filename);
save(FileName, 'finalresults', '-v7.3');

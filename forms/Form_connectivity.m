function varargout = Form_connectivity(varargin)
% FORM_LOADFILES MATLAB code for Form_loadfiles.fig
%      FORM_LOADFILES, by itself, creates a new FORM_LOADFILES or raises the existing
%      singleton*.
%
%      H = FORM_LOADFILES returns the handle to a new FORM_LOADFILES or the handle to
%      the existing singleton*.
%
%      FORM_LOADFILES('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FORM_LOADFILES.M with the given input arguments.
%
%      FORM_LOADFILES('Property','Value',...) creates a new FORM_LOADFILES or raises
%      the existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Form_loadfiles_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Form_loadfiles_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Form_loadfiles

% Last Modified by GUIDE v2.5 27-Apr-2021 11:42:34

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Form_loadfiles_OpeningFcn, ...
                   'gui_OutputFcn',  @Form_loadfiles_OutputFcn, ...
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

% --- Executes just before Form_loadfiles is made visible.
function Form_loadfiles_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Form_loadfiles (see VARARGIN)

% Choose default command line output for Form_loadfiles
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

global node_in;
node_in = varargin{3};
global data;
data = varargin{1};
global srate;
srate = varargin{2};

global multiple;
multiple=varargin{4};

global mult_subj;

if(multiple==0)
    data1=data{1};
    data=data1;
    mult_subj=0;
else
    if(length(srate)>1)
        mult_subj=1;
    else
        mult_subj=0;
    end
end


[YourImage, ~, ImageAlpha] = imread('Icons/logo_eegnet_greybkg.png');
axes(handles.axes1);
imshow(YourImage)
% Make the GUI modal
set(handles.figure1,'WindowStyle','modal')
set(handles.figure1, 'Name', 'Compute connectivity');

set(handles.minfreq_edit,'Visible','off')
set(handles.maxfreq_edit,'Visible','off')
set(handles.text13,'Visible','off')

set(handles.overlap_edit,'Visible','off')
set(handles.text14,'Visible','off')

% Callback function definition
% UIWAIT makes Form_New wait for user response (see UIRESUME)
uiwait(handles.figure1);

% jb = javax.swing.JButton;
% jbh = handle(jb,'CallbackProperties');



% --- Outputs from this function are returned to the command line.
function varargout = Form_loadfiles_OutputFcn(hObject, eventdata, handles)
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
global data;
global node_in;
global srate;
global allsubjects;
global alleegs_src_conn;
global allepochs_src_conn;
global alleegs_preprocessed_src_conn;
global allepochs_preprocessed_src_conn;
global javaImage_subj;
global tree;
global treeModel;
global multiple;
global isPreprocessed;
global IndSegments;
global mult_subj;

if(mult_subj)
       global subjIndex;
       subjj=subjIndex;
end
rmpath(genpath('external/eeglab13_1_1b'));

connectivity=struct();
% % know if static or dynamic
switch(get(handles.popupmenu1,'Value'))
    case 1
        phase=1;
        meth=1;
    case 2
        phase=1;
        meth=2;

    case 3
        phase=1;
        meth=3;

    case 4
        phase=0;
        meth=4;
end
ok=1;

% % check for error first
static=get(handles.st_check,'Value');
dynamic=get(handles.dyn_check,'Value');
if(dynamic)
    try
        ovString=get(handles.overlap_edit,'String');
        overlap=str2double(ovString);
        
    catch
        msgbox('Please enter correct integer value in the overlap editbox');
        ok=0;
    end
end
if(get(handles.custom_check,'Value'))
     try
        fminStr=get(handles.minfreq_edit,'String');
       fmin=str2double(fminStr);
       fmaxStr=get(handles.maxfreq_edit,'String');
       fmax=str2double(fmaxStr);
        
    catch
        msgbox('Please enter correct integer value in the frequency editboxes');
        ok=0;
     end 
end

if(ok)
    
   if(multiple==0)
        
    f = waitbar(0,'Please wait...');

    if(static)
        dynamic=0;
% %         get all bands and do the computation for all bands
% delta
           if(get(handles.delta_check,'Value'))
               fmin=0.1; fmax=3;
               if(phase)
% %                    automatic window based on the formula of lachaux
                    f_interest=fmin+(fmax-fmin)/2;
                    window=6/(f_interest);  
               else
                   window=1;
               end
               step=window;
               if(meth==1)
                   
              connectivity.static.delta= plv_sliding_window(data,srate,window,step,fmin,fmax,dynamic); 
               else
                   if(meth==2)
                   connectivity.static.delta= pli_sliding_window(data,srate,window,step,fmin,fmax,dynamic); 

                   else
                       if(meth==3)
                                         connectivity.static.delta= aec_sliding_window(data,srate,window,step,fmin,fmax,dynamic); 

                       else
                           if(meth==4)
                                             connectivity.static.delta= wpli_ft(data,srate,window,step,fmin,fmax,dynamic); 

                           end
                       end
                   end
               end
           end
           
            if(get(handles.theta_check,'Value'))
               fmin=3; fmax=7;
               if(phase)
% %                    automatic window based on the formula of lachaux
                    f_interest=fmin+(fmax-fmin)/2;
                    window=6/(f_interest);  
               else
                   window=1;
               end
               step=window;
if(meth==1)
                   
              connectivity.static.theta= plv_sliding_window(data,srate,window,step,fmin,fmax,dynamic); 
               else
                   if(meth==2)
                   connectivity.static.theta= pli_sliding_window(data,srate,window,step,fmin,fmax,dynamic); 

                   else
                       if(meth==3)
                                         connectivity.static.theta= aec_sliding_window(data,srate,window,step,fmin,fmax,dynamic); 

                       else
                           if(meth==4)
                                             connectivity.static.theta= wpli_ft(data,srate,window,step,fmin,fmax,dynamic); 

                           end
                       end
                   end
end
            end
           
             if(get(handles.alpha_check,'Value'))
               fmin=7; fmax=13;
               if(phase)
% %                    automatic window based on the formula of lachaux
                    f_interest=fmin+(fmax-fmin)/2;
                    window=6/(f_interest);  
               else
                   window=1;
               end
               step=window;
if(meth==1)
                   
              connectivity.static.alpha= plv_sliding_window(data,srate,window,step,fmin,fmax,dynamic); 
               else
                   if(meth==2)
                   connectivity.static.alpha= pli_sliding_window(data,srate,window,step,fmin,fmax,dynamic); 

                   else
                       if(meth==3)
                                         connectivity.static.alpha= aec_sliding_window(data,srate,window,step,fmin,fmax,dynamic); 

                       else
                           if(meth==4)
                                             connectivity.static.alpha= wpli_ft(data,srate,window,step,fmin,fmax,dynamic); 

                           end
                       end
                   end
end
             end
           
              if(get(handles.beta_check,'Value'))
               fmin=13; fmax=25;
               if(phase)
% %                    automatic window based on the formula of lachaux
                    f_interest=fmin+(fmax-fmin)/2;
                    window=6/(f_interest);  
               else
                   window=1;
               end
               step=window;
if(meth==1)
                   
              connectivity.static.beta= plv_sliding_window(data,srate,window,step,fmin,fmax,dynamic); 
               else
                   if(meth==2)
                   connectivity.static.beta= pli_sliding_window(data,srate,window,step,fmin,fmax,dynamic); 

                   else
                       if(meth==3)
                                         connectivity.static.beta= aec_sliding_window(data,srate,window,step,fmin,fmax,dynamic); 

                       else
                           if(meth==4)
                                             connectivity.static.beta= wpli_ft(data,srate,window,step,fmin,fmax,dynamic); 

                           end
                       end
                   end
end
              end
           
               if(get(handles.gamma_check,'Value'))
               fmin=25; fmax=45;
               if(phase)
% %                    automatic window based on the formula of lachaux
                    f_interest=fmin+(fmax-fmin)/2;
                    window=6/(f_interest);  
               else
                   window=1;
               end
               step=window;
if(meth==1)
                   
              connectivity.static.gamma= plv_sliding_window(data,srate,window,step,fmin,fmax,dynamic); 
               else
                   if(meth==2)
                   connectivity.static.gamma= pli_sliding_window(data,srate,window,step,fmin,fmax,dynamic); 

                   else
                       if(meth==3)
                                         connectivity.static.gamma= aec_sliding_window(data,srate,window,step,fmin,fmax,dynamic); 

                       else
                           if(meth==4)
                                             connectivity.static.gamma= wpli_ft(data,srate,window,step,fmin,fmax,dynamic); 

                           end
                       end
                   end
end
               end
            if(get(handles.bb_check,'Value'))
               fmin=0.1; fmax=45;
               if(phase)
% %                    automatic window based on the formula of lachaux
                    f_interest=fmin+(fmax-fmin)/2;
                    window=6/(f_interest);  
               else
                   window=1;
               end
               step=window;
if(meth==1)
                   
              connectivity.static.broad= plv_sliding_window(data,srate,window,step,fmin,fmax,dynamic); 
               else
                   if(meth==2)
                   connectivity.static.broad= pli_sliding_window(data,srate,window,step,fmin,fmax,dynamic); 

                   else
                       if(meth==3)
                                         connectivity.static.broad= aec_sliding_window(data,srate,window,step,fmin,fmax,dynamic); 

                       else
                           if(meth==4)
                                             connectivity.static.broad= wpli_ft(data,srate,window,step,fmin,fmax,dynamic); 

                           end
                       end
                   end
end
            end
            
            if(get(handles.custom_check,'Value'))
              fminStr=get(handles.minfreq_edit,'String');
               fmin=str2double(fminStr);
               fmaxStr=get(handles.maxfreq_edit,'String');
               fmax=str2double(fmaxStr);
               if(phase)
% %                    automatic window based on the formula of lachaux
                    f_interest=fmin+(fmax-fmin)/2;
                    window=6/(f_interest);  
               else
                   window=1;
               end
               step=window;
if(meth==1)
                   
              connectivity.static.custom= plv_sliding_window(data,srate,window,step,fmin,fmax,dynamic); 
               else
                   if(meth==2)
                   connectivity.static.custom= pli_sliding_window(data,srate,window,step,fmin,fmax,dynamic); 

                   else
                       if(meth==3)
                                         connectivity.static.custom= aec_sliding_window(data,srate,window,step,fmin,fmax,dynamic); 

                       else
                           if(meth==4)
                                             connectivity.static.custom= wpli_ft(data,srate,window,step,fmin,fmax,dynamic); 

                           end
                       end
                   end
end
            end
    end
            dynamic=get(handles.dyn_check,'Value');
    if(dynamic)
% %         dynamic


      if(get(handles.delta_check,'Value'))
               fmin=0.1; fmax=3;
               if(phase)
% %                    automatic window based on the formula of lachaux
                    f_interest=fmin+(fmax-fmin)/2;
                    window=6/(f_interest);  
               else
                   window=1;
               end
               step=window*overlap/100;
if(meth==1)
                   
              connectivity.dynamic.delta= plv_sliding_window(data,srate,window,step,fmin,fmax,dynamic); 
               else
                   if(meth==2)
                   connectivity.dynamic.delta= pli_sliding_window(data,srate,window,step,fmin,fmax,dynamic); 

                   else
                       if(meth==3)
                                         connectivity.dynamic.delta= aec_sliding_window(data,srate,window,step,fmin,fmax,dynamic); 

                       else
                           if(meth==4)
                                             connectivity.dynamic.delta= wpli_ft(data,srate,window,step,fmin,fmax,dynamic); 

                           end
                       end
                   end
end
      end
           
            if(get(handles.theta_check,'Value'))
               fmin=3; fmax=7;
               if(phase)
% %                    automatic window based on the formula of lachaux
                    f_interest=fmin+(fmax-fmin)/2;
                    window=6/(f_interest);  
               else
                   window=1;
               end
               step=window*overlap/100;
if(meth==1)
                   
              connectivity.dynamic.theta= plv_sliding_window(data,srate,window,step,fmin,fmax,dynamic); 
               else
                   if(meth==2)
                   connectivity.dynamic.theta= pli_sliding_window(data,srate,window,step,fmin,fmax,dynamic); 

                   else
                       if(meth==3)
                                         connectivity.dynamic.theta= aec_sliding_window(data,srate,window,step,fmin,fmax,dynamic); 

                       else
                           if(meth==4)
                                             connectivity.dynamic.theta= wpli_ft(data,srate,window,step,fmin,fmax,dynamic); 

                           end
                       end
                   end
end
            end
           
             if(get(handles.alpha_check,'Value'))
               fmin=7; fmax=13;
               if(phase)
% %                    automatic window based on the formula of lachaux
                    f_interest=fmin+(fmax-fmin)/2;
                    window=6/(f_interest);  
               else
                   window=1;
               end
               step=window*overlap/100;
if(meth==1)
                   
              connectivity.dynamic.alpha= plv_sliding_window(data,srate,window,step,fmin,fmax,dynamic); 
               else
                   if(meth==2)
                   connectivity.dynamic.alpha= pli_sliding_window(data,srate,window,step,fmin,fmax,dynamic); 

                   else
                       if(meth==3)
                                         connectivity.dynamic.alpha= aec_sliding_window(data,srate,window,step,fmin,fmax,dynamic); 

                       else
                           if(meth==4)
                                             connectivity.dynamic.alpha= wpli_ft(data,srate,window,step,fmin,fmax,dynamic); 

                           end
                       end
                   end
end
             end
           
              if(get(handles.beta_check,'Value'))
               fmin=13; fmax=25;
               if(phase)
% %                    automatic window based on the formula of lachaux
                    f_interest=fmin+(fmax-fmin)/2;
                    window=6/(f_interest);  
               else
                   window=1;
               end
               step=window*overlap/100;
if(meth==1)
                   
              connectivity.dynamic.beta= plv_sliding_window(data,srate,window,step,fmin,fmax,dynamic); 
               else
                   if(meth==2)
                   connectivity.dynamic.beta= pli_sliding_window(data,srate,window,step,fmin,fmax,dynamic); 

                   else
                       if(meth==3)
                                         connectivity.dynamic.beta= aec_sliding_window(data,srate,window,step,fmin,fmax,dynamic); 

                       else
                           if(meth==4)
                                             connectivity.dynamic.beta= wpli_ft(data,srate,window,step,fmin,fmax,dynamic); 

                           end
                       end
                   end
end
              end
           
               if(get(handles.gamma_check,'Value'))
               fmin=25; fmax=45;
               if(phase)
% %                    automatic window based on the formula of lachaux
                    f_interest=fmin+(fmax-fmin)/2;
                    window=6/(f_interest);  
               else
                   window=1;
               end
               step=window*overlap/100;
if(meth==1)
                   
              connectivity.dynamic.gamma= plv_sliding_window(data,srate,window,step,fmin,fmax,dynamic); 
               else
                   if(meth==2)
                   connectivity.dynamic.gamma= pli_sliding_window(data,srate,window,step,fmin,fmax,dynamic); 

                   else
                       if(meth==3)
                                         connectivity.dynamic.gamma= aec_sliding_window(data,srate,window,step,fmin,fmax,dynamic); 

                       else
                           if(meth==4)
                                             connectivity.dynamic.gamma= wpli_ft(data,srate,window,step,fmin,fmax,dynamic); 

                           end
                       end
                   end
end
               end
            if(get(handles.bb_check,'Value'))
               fmin=0.1; fmax=45;
               if(phase)
% %                    automatic window based on the formula of lachaux
                    f_interest=fmin+(fmax-fmin)/2;
                    window=6/(f_interest);  
               else
                   window=1;
               end
               step=window*overlap/100;
if(meth==1)
                   
              connectivity.dynamic.broad= plv_sliding_window(data,srate,window,step,fmin,fmax,dynamic); 
               else
                   if(meth==2)
                   connectivity.dynamic.broad= pli_sliding_window(data,srate,window,step,fmin,fmax,dynamic); 

                   else
                       if(meth==3)
                                         connectivity.dynamic.broad= aec_sliding_window(data,srate,window,step,fmin,fmax,dynamic); 

                       else
                           if(meth==4)
                                             connectivity.dynamic.broad= wpli_ft(data,srate,window,step,fmin,fmax,dynamic); 

                           end
                       end
                   end
end
            end
            
            if(get(handles.custom_check,'Value'))
              fminStr=get(handles.minfreq_edit,'String');
               fmin=str2double(fminStr);
               fmaxStr=get(handles.maxfreq_edit,'String');
               fmax=str2double(fmaxStr);
               if(phase)
% %                    automatic window based on the formula of lachaux
                    f_interest=fmin+(fmax-fmin)/2;
                    window=6/(f_interest);  
               else
                   window=1;
               end
               step=window*overlap/100;
if(meth==1)
                   
              connectivity.dynamic.custom= plv_sliding_window(data,srate,window,step,fmin,fmax,dynamic); 
               else
                   if(meth==2)
                   connectivity.dynamic.custom= pli_sliding_window(data,srate,window,step,fmin,fmax,dynamic); 

                   else
                       if(meth==3)
                                         connectivity.dynamic.custom= aec_sliding_window(data,srate,window,step,fmin,fmax,dynamic); 

                       else
                           if(meth==4)
                                             connectivity.dynamic.custom= wpli_ft(data,srate,window,step,fmin,fmax,dynamic); 

                           end
                       end
                   end
end
            end
    end
        waitbar(1,f,'Done');
        close(f);
%         connectivity.static
%         connectivity.dynamic
        result=struct();
        result.conn=struct();
        try
        result.conn.static=connectivity.static;
        catch
        end
        try
            
        result.conn.dynamic=connectivity.dynamic;
        catch
        end
%         create node in the tree and assign the output to the global
%         variables
% 1- ensure if the correspondant node has already a connectivity node
% % node should be the subject node : from inputs in the case of eeg, and the segment node for segment;
nodeName=char(node_in.getName);
node=node_in;
empty=0; seg=0;

create=0;
creastatic=0;
creadynamic=0;
createstatic.delta=0;
createstatic.theta=0;
createstatic.alpha=0;
createstatic.beta=0;
createstatic.gamma=0;
createstatic.custom=0;
createstatic.bb=0;

createdynamic.delta=0;
createdynamic.theta=0;
createdynamic.alpha=0;
createdynamic.beta=0;
createdynamic.gamma=0;
createdynamic.custom=0;
createdynamic.bb=0;
% create node in tree if it's not already present
if(strcmp(nodeName,'Reconstructed EEG'))
     subjectParent=node_in.getParent;
     subjectname=char(subjectParent.getName);
     subjectname=subjectname(3:end);
% %          index of the subject to show its eeg in the figure
     subjIndex=find(strcmp(allsubjects.names, subjectname));

     try
            alleegs_src_conn{subjIndex}.conn;
% %             dont create a node connectivity
            create=0;      
% %             see if static or dynamic
    try 
            alleegs_src_conn{subjIndex}.conn.static;
%             dont create a node static
                try
                    connectivity.static;
                    try
                         connectivity.static.delta;
                         try 
                              alleegs_src_conn{subjIndex}.conn.static.delta;
                         catch
                             createstatic.delta=1;
                         end
                         
                          alleegs_src_conn{subjIndex}.conn.static.delta=connectivity.static.delta;
                          

                    catch
                        
                    end
                    
                                        try
                         connectivity.static.theta;
                         try 
                              alleegs_src_conn{subjIndex}.conn.static.theta;
                         catch
                             createstatic.theta=1;
                         end
                         
                          alleegs_src_conn{subjIndex}.conn.static.theta=connectivity.static.theta;
                          

                    catch
                        
                                        end
                    
                                                            try
                         connectivity.static.alpha;
                         try 
                              alleegs_src_conn{subjIndex}.conn.static.alpha;
                         catch
                             createstatic.alpha=1;
                         end
                         
                          alleegs_src_conn{subjIndex}.conn.static.alpha=connectivity.static.alpha;
                          

                    catch
                        
                                                            end
                    
                                                                                try
                         connectivity.static.beta;
                         try 
                              alleegs_src_conn{subjIndex}.conn.static.beta;
                         catch
                             createstatic.beta=1;
                         end
                         
                          alleegs_src_conn{subjIndex}.conn.static.beta=connectivity.static.beta;
                          

                    catch
                        
                                                                                end
                                        try
                         connectivity.static.gamma;
                         try 
                              alleegs_src_conn{subjIndex}.conn.static.gamma;
                         catch
                             createstatic.gamma=1;
                         end
                         
                          alleegs_src_conn{subjIndex}.conn.static.gamma=connectivity.static.gamma;
                          

                    catch
                        
                                        end
                                        try
                         connectivity.static.bb;
                         try 
                              alleegs_src_conn{subjIndex}.conn.static.bb;
                         catch
                             createstatic.bb=1;
                         end
                         
                          alleegs_src_conn{subjIndex}.conn.static.bb=connectivity.static.bb;
                          

                    catch
                        
                                        end
                                        
                                        try
                         connectivity.static.custom;
                         try 
                              alleegs_src_conn{subjIndex}.conn.static.custom;
                         catch
                             createstatic.custom=1;
                         end
                         
                          alleegs_src_conn{subjIndex}.conn.static.custom=connectivity.static.custom;
                          

                    catch
                        
                                        end
                    
                catch
                    
                end
    catch
        try
            connectivity.static;
            creastatic=1;
            alleegs_src_conn{subjIndex}.conn.static=connectivity.static;
              
            try
                               alleegs_src_conn{subjIndex}.conn.static.delta;
                                                createstatic.delta=1;

                        catch
                                           createstatic.delta=0;

                                           
                        
            end
                        
                        try
                               alleegs_src_conn{subjIndex}.conn.static.theta;
                                                createstatic.theta=1;

                        catch
                                           createstatic.theta=0;
                        end
                        
                        try
                               alleegs_src_conn{subjIndex}.conn.static.alpha;
                                                createstatic.alpha=1;
                        catch
                                           createstatic.alpha=0;

                        end
                        
                        try
                               alleegs_src_conn{subjIndex}.conn.static.beta;
                                                createstatic.beta=1;
                        catch
                                           createstatic.beta=0;
                        end
                        
                        try
                               alleegs_src_conn{subjIndex}.conn.static.gamma;
                                                createstatic.gamma=1;

                        catch
                                           createstatic.gamma=0;
                        end
                        
                        try
                               alleegs_src_conn{subjIndex}.conn.static.custom;
                                                createstatic.custom=1;
                        catch
                                           createstatic.custom=0;
                        end
                        
                        try
                               alleegs_src_conn{subjIndex}.conn.static.bb;
                                                createstatic.bb=1;

                        catch
                                           createstatic.bb=0;
                        end
        catch
            creastatic=0;
        
       end
        
    end
    
        try 
            alleegs_src_conn{subjIndex}.conn.dynamic;
%             dont create a node dynamic
                try
                    connectivity.dynamic;
                    try
                         connectivity.dynamic.delta;
                         try 
                              alleegs_src_conn{subjIndex}.conn.dynamic.delta;
                         catch
                             createdynamic.delta=1;
                         end
                         
                          alleegs_src_conn{subjIndex}.conn.dynamic.delta=connectivity.dynamic.delta;
                          

                    catch
                        
                    end
                    
                                        try
                         connectivity.dynamic.theta;
                         try 
                              alleegs_src_conn{subjIndex}.conn.dynamic.theta;
                         catch
                             createdynamic.theta=1;
                         end
                         
                          alleegs_src_conn{subjIndex}.conn.dynamic.theta=connectivity.dynamic.theta;
                          

                    catch
                        
                                        end
                    
                                                            try
                         connectivity.dynamic.alpha;
                         try 
                              alleegs_src_conn{subjIndex}.conn.dynamic.alpha;
                         catch
                             createdynamic.alpha=1;
                         end
                         
                          alleegs_src_conn{subjIndex}.conn.dynamic.alpha=connectivity.dynamic.alpha;
                          

                    catch
                        
                                                            end
                    
                                                                                try
                         connectivity.dynamic.beta;
                         try 
                              alleegs_src_conn{subjIndex}.conn.dynamic.beta;
                         catch
                             createdynamic.beta=1;
                         end
                         
                          alleegs_src_conn{subjIndex}.conn.dynamic.beta=connectivity.dynamic.beta;
                          

                    catch
                        
                                                                                end
                                        try
                         connectivity.dynamic.gamma;
                         try 
                              alleegs_src_conn{subjIndex}.conn.dynamic.gamma;
                         catch
                             createdynamic.gamma=1;
                         end
                         
                          alleegs_src_conn{subjIndex}.conn.dynamic.gamma=connectivity.dynamic.gamma;
                          

                    catch
                        
                                        end
                                        try
                         connectivity.dynamic.bb;
                         try 
                              alleegs_src_conn{subjIndex}.conn.dynamic.bb;
                         catch
                             createdynamic.bb=1;
                         end
                         
                          alleegs_src_conn{subjIndex}.conn.dynamic.bb=connectivity.dynamic.bb;
                          

                    catch
                        
                                        end
                                        
                                        try
                         connectivity.dynamic.custom;
                         try 
                              alleegs_src_conn{subjIndex}.conn.dynamic.custom;
                         catch
                             createdynamic.custom=1;
                         end
                         
                          alleegs_src_conn{subjIndex}.conn.dynamic.custom=connectivity.dynamic.custom;
                          

                    catch
                        
                                        end
                    
                catch
                    
                end
    catch
        try
            connectivity.dynamic;
            creadynamic=1;
            alleegs_src_conn{subjIndex}.conn.dynamic=connectivity.dynamic;
              
            try
                               alleegs_src_conn{subjIndex}.conn.dynamic.delta;
                                                createdynamic.delta=1;

                        catch
                                           createdynamic.delta=0;

                                           
                        
            end
                        
                        try
                               alleegs_src_conn{subjIndex}.conn.dynamic.theta;
                                                createdynamic.theta=1;

                        catch
                                           createdynamic.theta=0;
                        end
                        
                        try
                               alleegs_src_conn{subjIndex}.conn.dynamic.alpha;
                                                createdynamic.alpha=1;
                        catch
                                           createdynamic.alpha=0;

                        end
                        
                        try
                               alleegs_src_conn{subjIndex}.conn.dynamic.beta;
                                                createdynamic.beta=1;
                        catch
                                           createdynamic.beta=0;
                        end
                        
                        try
                               alleegs_src_conn{subjIndex}.conn.dynamic.gamma;
                                                createdynamic.gamma=1;

                        catch
                                           createdynamic.gamma=0;
                        end
                        
                        try
                               alleegs_src_conn{subjIndex}.conn.dynamic.custom;
                                                createdynamic.custom=1;
                        catch
                                           createdynamic.custom=0;
                        end
                        
                        try
                               alleegs_src_conn{subjIndex}.conn.dynamic.bb;
                                                createdynamic.bb=1;

                        catch
                                           createdynamic.bb=0;
                        end
        catch
            creadynamic=0;
        
       end
        
        end
    
catch
% %             no connectivity node that already exist for this subject
            create=1;
            alleegs_src_conn{subjIndex}.conn=connectivity;
            try
                alleegs_src_conn{subjIndex}.conn.static;
                 creastatic=1;
                        try
                               alleegs_src_conn{subjIndex}.conn.static.delta;
                                                createstatic.delta=1;

                        catch
                                           createstatic.delta=0;

                        end
                        
                        try
                               alleegs_src_conn{subjIndex}.conn.static.theta;
                                                createstatic.theta=1;

                        catch
                                           createstatic.theta=0;
                        end
                        
                        try
                               alleegs_src_conn{subjIndex}.conn.static.alpha;
                                                createstatic.alpha=1;
                        catch
                                           createstatic.alpha=0;

                        end
                        
                        try
                               alleegs_src_conn{subjIndex}.conn.static.beta;
                                                createstatic.beta=1;
                        catch
                                           createstatic.beta=0;
                        end
                        
                        try
                               alleegs_src_conn{subjIndex}.conn.static.gamma;
                                                createstatic.gamma=1;

                        catch
                                           createstatic.gamma=0;
                        end
                        
                        try
                               alleegs_src_conn{subjIndex}.conn.static.custom;
                                                createstatic.custom=1;
                        catch
                                           createstatic.custom=0;
                        end
                        
                        try
                               alleegs_src_conn{subjIndex}.conn.static.bb;
                                                createstatic.bb=1;

                        catch
                                           createstatic.bb=0;
                        end
                                               
                        
            catch
                                 creastatic=0;

            end
            
            
            
            try
                alleegs_src_conn{subjIndex}.conn.dynamic;
                 creadynamic=1;
                        try
                               alleegs_src_conn{subjIndex}.conn.dynamic.delta;
                                                createdynamic.delta=1;

                        catch
                                           createdynamic.delta=0;

                        end
                        
                        try
                               alleegs_src_conn{subjIndex}.conn.dynamic.theta;
                                                createdynamic.theta=1;

                        catch
                                           createdynamic.theta=0;
                        end
                        
                        try
                               alleegs_src_conn{subjIndex}.conn.dynamic.alpha;
                                                createdynamic.alpha=1;
                        catch
                                           createdynamic.alpha=0;

                        end
                        
                        try
                               alleegs_src_conn{subjIndex}.conn.dynamic.beta;
                                                createdynamic.beta=1;
                        catch
                                           createdynamic.beta=0;
                        end
                        
                        try
                               alleegs_src_conn{subjIndex}.conn.dynamic.gamma;
                                                createdynamic.gamma=1;

                        catch
                                           createdynamic.gamma=0;
                        end
                        
                        try
                               alleegs_src_conn{subjIndex}.conn.dynamic.custom;
                                                createdynamic.custom=1;
                        catch
                                           createdynamic.custom=0;
                        end
                        
                        try
                               alleegs_src_conn{subjIndex}.conn.dynamic.bb;
                                                createdynamic.bb=1;

                        catch
                                           createdynamic.bb=0;
                        end
                                               
                        
            catch
                                 creadynamic=0;

            end

end

    else
       if(strcmp(nodeName(1:19),'Reconstructed Epoch'))
         subjectParent=node.getParent;
         subjectParent=subjectParent.getParent;
         subjectParent=subjectParent.getParent;
         subjectname=char(subjectParent.getName);
         subjectname=subjectname(3:end);
        % %          index of the subject to show its eeg in the figure
         subjIndex=find(strcmp(allsubjects.names, subjectname));
        %              pathfile= allsubjects.paths{subjIndex};
         number=str2num(nodeName(21:end));

            

try
            allepochs_src_conn{subjIndex,number}.conn;
% %             dont create a node connectivity
            create=0;      
% %             see if static or dynamic
    try 
            allepochs_src_conn{subjIndex,number}.conn.static;
%             dont create a node static
                try
                    connectivity.static;
                    try
                         connectivity.static.delta;
                         try 
                              allepochs_src_conn{subjIndex,number}.conn.static.delta;
                         catch
                             createstatic.delta=1;
                         end
                         
                          allepochs_src_conn{subjIndex,number}.conn.static.delta=connectivity.static.delta;
                          

                    catch
                        
                    end
                    
                                        try
                         connectivity.static.theta;
                         try 
                              allepochs_src_conn{subjIndex,number}.conn.static.theta;
                         catch
                             createstatic.theta=1;
                         end
                         
                          allepochs_src_conn{subjIndex,number}.conn.static.theta=connectivity.static.theta;
                          

                    catch
                        
                                        end
                    
                                                            try
                         connectivity.static.alpha;
                         try 
                              allepochs_src_conn{subjIndex,number}.conn.static.alpha;
                         catch
                             createstatic.alpha=1;
                         end
                         
                          allepochs_src_conn{subjIndex,number}.conn.static.alpha=connectivity.static.alpha;
                          

                    catch
                        
                                                            end
                    
                                                                                try
                         connectivity.static.beta;
                         try 
                              allepochs_src_conn{subjIndex,number}.conn.static.beta;
                         catch
                             createstatic.beta=1;
                         end
                         
                          allepochs_src_conn{subjIndex,number}.conn.static.beta=connectivity.static.beta;
                          

                    catch
                        
                                                                                end
                                        try
                         connectivity.static.gamma;
                         try 
                              allepochs_src_conn{subjIndex,number}.conn.static.gamma;
                         catch
                             createstatic.gamma=1;
                         end
                         
                          allepochs_src_conn{subjIndex,number}.conn.static.gamma=connectivity.static.gamma;
                          

                    catch
                        
                                        end
                                        try
                         connectivity.static.bb;
                         try 
                              allepochs_src_conn{subjIndex,number}.conn.static.bb;
                         catch
                             createstatic.bb=1;
                         end
                         
                          allepochs_src_conn{subjIndex,number}.conn.static.bb=connectivity.static.bb;
                          

                    catch
                        
                                        end
                                        
                                        try
                         connectivity.static.custom;
                         try 
                              allepochs_src_conn{subjIndex,number}.conn.static.custom;
                         catch
                             createstatic.custom=1;
                         end
                         
                          allepochs_src_conn{subjIndex,number}.conn.static.custom=connectivity.static.custom;
                          

                    catch
                        
                                        end
                    
                catch
                    
                end
    catch
        try
            connectivity.static;
            creastatic=1;
            allepochs_src_conn{subjIndex,number}.conn.static=connectivity.static;
              
            try
                               allepochs_src_conn{subjIndex,number}.conn.static.delta;
                                                createstatic.delta=1;

                        catch
                                           createstatic.delta=0;

                                           
                        
            end
                        
                        try
                               allepochs_src_conn{subjIndex,number}.conn.static.theta;
                                                createstatic.theta=1;

                        catch
                                           createstatic.theta=0;
                        end
                        
                        try
                               allepochs_src_conn{subjIndex,number}.conn.static.alpha;
                                                createstatic.alpha=1;
                        catch
                                           createstatic.alpha=0;

                        end
                        
                        try
                               allepochs_src_conn{subjIndex,number}.conn.static.beta;
                                                createstatic.beta=1;
                        catch
                                           createstatic.beta=0;
                        end
                        
                        try
                               allepochs_src_conn{subjIndex,number}.conn.static.gamma;
                                                createstatic.gamma=1;

                        catch
                                           createstatic.gamma=0;
                        end
                        
                        try
                               allepochs_src_conn{subjIndex,number}.conn.static.custom;
                                                createstatic.custom=1;
                        catch
                                           createstatic.custom=0;
                        end
                        
                        try
                               allepochs_src_conn{subjIndex,number}.conn.static.bb;
                                                createstatic.bb=1;

                        catch
                                           createstatic.bb=0;
                        end
        catch
            creastatic=0;
        
       end
        
    end
    
        try 
            allepochs_src_conn{subjIndex,number}.conn.dynamic;
%             dont create a node dynamic
                try
                    connectivity.dynamic;
                    try
                         connectivity.dynamic.delta;
                         try 
                              allepochs_src_conn{subjIndex,number}.conn.dynamic.delta;
                         catch
                             createdynamic.delta=1;
                         end
                         
                          allepochs_src_conn{subjIndex,number}.conn.dynamic.delta=connectivity.dynamic.delta;
                          

                    catch
                        
                    end
                    
                                        try
                         connectivity.dynamic.theta;
                         try 
                              allepochs_src_conn{subjIndex,number}.conn.dynamic.theta;
                         catch
                             createdynamic.theta=1;
                         end
                         
                          allepochs_src_conn{subjIndex,number}.conn.dynamic.theta=connectivity.dynamic.theta;
                          

                    catch
                        
                                        end
                    
                                                            try
                         connectivity.dynamic.alpha;
                         try 
                              allepochs_src_conn{subjIndex,number}.conn.dynamic.alpha;
                         catch
                             createdynamic.alpha=1;
                         end
                         
                          allepochs_src_conn{subjIndex,number}.conn.dynamic.alpha=connectivity.dynamic.alpha;
                          

                    catch
                        
                                                            end
                    
                                                                                try
                         connectivity.dynamic.beta;
                         try 
                              allepochs_src_conn{subjIndex,number}.conn.dynamic.beta;
                         catch
                             createdynamic.beta=1;
                         end
                         
                          allepochs_src_conn{subjIndex,number}.conn.dynamic.beta=connectivity.dynamic.beta;
                          

                    catch
                        
                                                                                end
                                        try
                         connectivity.dynamic.gamma;
                         try 
                              allepochs_src_conn{subjIndex,number}.conn.dynamic.gamma;
                         catch
                             createdynamic.gamma=1;
                         end
                         
                          allepochs_src_conn{subjIndex,number}.conn.dynamic.gamma=connectivity.dynamic.gamma;
                          

                    catch
                        
                                        end
                                        try
                         connectivity.dynamic.bb;
                         try 
                              allepochs_src_conn{subjIndex,number}.conn.dynamic.bb;
                         catch
                             createdynamic.bb=1;
                         end
                         
                          allepochs_src_conn{subjIndex,number}.conn.dynamic.bb=connectivity.dynamic.bb;
                          

                    catch
                        
                                        end
                                        
                                        try
                         connectivity.dynamic.custom;
                         try 
                              allepochs_src_conn{subjIndex,number}.conn.dynamic.custom;
                         catch
                             createdynamic.custom=1;
                         end
                         
                          allepochs_src_conn{subjIndex,number}.conn.dynamic.custom=connectivity.dynamic.custom;
                          

                    catch
                        
                                        end
                    
                catch
                    
                end
    catch
        try
            connectivity.dynamic;
            creadynamic=1;
            allepochs_src_conn{subjIndex,number}.conn.dynamic=connectivity.dynamic;
              
            try
                               allepochs_src_conn{subjIndex,number}.conn.dynamic.delta;
                                                createdynamic.delta=1;

                        catch
                                           createdynamic.delta=0;

                                           
                        
            end
                        
                        try
                               allepochs_src_conn{subjIndex,number}.conn.dynamic.theta;
                                                createdynamic.theta=1;

                        catch
                                           createdynamic.theta=0;
                        end
                        
                        try
                               allepochs_src_conn{subjIndex,number}.conn.dynamic.alpha;
                                                createdynamic.alpha=1;
                        catch
                                           createdynamic.alpha=0;

                        end
                        
                        try
                               allepochs_src_conn{subjIndex,number}.conn.dynamic.beta;
                                                createdynamic.beta=1;
                        catch
                                           createdynamic.beta=0;
                        end
                        
                        try
                               allepochs_src_conn{subjIndex,number}.conn.dynamic.gamma;
                                                createdynamic.gamma=1;

                        catch
                                           createdynamic.gamma=0;
                        end
                        
                        try
                               allepochs_src_conn{subjIndex,number}.conn.dynamic.custom;
                                                createdynamic.custom=1;
                        catch
                                           createdynamic.custom=0;
                        end
                        
                        try
                               allepochs_src_conn{subjIndex,number}.conn.dynamic.bb;
                                                createdynamic.bb=1;

                        catch
                                           createdynamic.bb=0;
                        end
        catch
            creadynamic=0;
        
       end
        
        end
    
catch
% %             no connectivity node that already exist for this subject
            create=1;
            allepochs_src_conn{subjIndex,number}.conn=connectivity;
            try
                allepochs_src_conn{subjIndex,number}.conn.static;
                 creastatic=1;
                        try
                               allepochs_src_conn{subjIndex,number}.conn.static.delta;
                                                createstatic.delta=1;

                        catch
                                           createstatic.delta=0;

                        end
                        
                        try
                               allepochs_src_conn{subjIndex,number}.conn.static.theta;
                                                createstatic.theta=1;

                        catch
                                           createstatic.theta=0;
                        end
                        
                        try
                               allepochs_src_conn{subjIndex,number}.conn.static.alpha;
                                                createstatic.alpha=1;
                        catch
                                           createstatic.alpha=0;

                        end
                        
                        try
                               allepochs_src_conn{subjIndex,number}.conn.static.beta;
                                                createstatic.beta=1;
                        catch
                                           createstatic.beta=0;
                        end
                        
                        try
                               allepochs_src_conn{subjIndex,number}.conn.static.gamma;
                                                createstatic.gamma=1;

                        catch
                                           createstatic.gamma=0;
                        end
                        
                        try
                               allepochs_src_conn{subjIndex,number}.conn.static.custom;
                                                createstatic.custom=1;
                        catch
                                           createstatic.custom=0;
                        end
                        
                        try
                               allepochs_src_conn{subjIndex,number}.conn.static.bb;
                                                createstatic.bb=1;

                        catch
                                           createstatic.bb=0;
                        end
                                               
                        
            catch
                                 creastatic=0;

            end
            
            
            
            try
                allepochs_src_conn{subjIndex,number}.conn.dynamic;
                 creadynamic=1;
                        try
                               allepochs_src_conn{subjIndex,number}.conn.dynamic.delta;
                                                createdynamic.delta=1;

                        catch
                                           createdynamic.delta=0;

                        end
                        
                        try
                               allepochs_src_conn{subjIndex,number}.conn.dynamic.theta;
                                                createdynamic.theta=1;

                        catch
                                           createdynamic.theta=0;
                        end
                        
                        try
                               allepochs_src_conn{subjIndex,number}.conn.dynamic.alpha;
                                                createdynamic.alpha=1;
                        catch
                                           createdynamic.alpha=0;

                        end
                        
                        try
                               allepochs_src_conn{subjIndex,number}.conn.dynamic.beta;
                                                createdynamic.beta=1;
                        catch
                                           createdynamic.beta=0;
                        end
                        
                        try
                               allepochs_src_conn{subjIndex,number}.conn.dynamic.gamma;
                                                createdynamic.gamma=1;

                        catch
                                           createdynamic.gamma=0;
                        end
                        
                        try
                               allepochs_src_conn{subjIndex,number}.conn.dynamic.custom;
                                                createdynamic.custom=1;
                        catch
                                           createdynamic.custom=0;
                        end
                        
                        try
                               allepochs_src_conn{subjIndex,number}.conn.dynamic.bb;
                                                createdynamic.bb=1;

                        catch
                                           createdynamic.bb=0;
                        end
                                               
                        
            catch
                                 creadynamic=0;

            end

end

else
     if(strcmp(nodeName,'Reconstructed Preprocessed EEG'))
             subjectParent=node.getParent;
             subjectParent=subjectParent.getParent;       
             subjectname=char(subjectParent.getName);
             subjectname=subjectname(3:end);
% %          index of the subject to show its eeg in the figure
             subjIndex=find(strcmp(allsubjects.names, subjectname));
%              pathfile= allsubjects.paths{subjIndex};
             
            
    

try
            alleegs_preprocessed_src_conn{subjIndex}.conn;
% %             dont create a node connectivity
            create=0;      
% %             see if static or dynamic
    try 
            alleegs_preprocessed_src_conn{subjIndex}.conn.static;
%             dont create a node static
                try
                    connectivity.static;
                    try
                         connectivity.static.delta;
                         try 
                              alleegs_preprocessed_src_conn{subjIndex}.conn.static.delta;
                         catch
                             createstatic.delta=1;
                         end
                         
                          alleegs_preprocessed_src_conn{subjIndex}.conn.static.delta=connectivity.static.delta;
                          

                    catch
                        
                    end
                    
                                        try
                         connectivity.static.theta;
                         try 
                              alleegs_preprocessed_src_conn{subjIndex}.conn.static.theta;
                         catch
                             createstatic.theta=1;
                         end
                         
                          alleegs_preprocessed_src_conn{subjIndex}.conn.static.theta=connectivity.static.theta;
                          

                    catch
                        
                                        end
                    
                                                            try
                         connectivity.static.alpha;
                         try 
                              alleegs_preprocessed_src_conn{subjIndex}.conn.static.alpha;
                         catch
                             createstatic.alpha=1;
                         end
                         
                          alleegs_preprocessed_src_conn{subjIndex}.conn.static.alpha=connectivity.static.alpha;
                          

                    catch
                        
                                                            end
                    
                                                                                try
                         connectivity.static.beta;
                         try 
                              alleegs_preprocessed_src_conn{subjIndex}.conn.static.beta;
                         catch
                             createstatic.beta=1;
                         end
                         
                          alleegs_preprocessed_src_conn{subjIndex}.conn.static.beta=connectivity.static.beta;
                          

                    catch
                        
                                                                                end
                                        try
                         connectivity.static.gamma;
                         try 
                              alleegs_preprocessed_src_conn{subjIndex}.conn.static.gamma;
                         catch
                             createstatic.gamma=1;
                         end
                         
                          alleegs_preprocessed_src_conn{subjIndex}.conn.static.gamma=connectivity.static.gamma;
                          

                    catch
                        
                                        end
                                        try
                         connectivity.static.bb;
                         try 
                              alleegs_preprocessed_src_conn{subjIndex}.conn.static.bb;
                         catch
                             createstatic.bb=1;
                         end
                         
                          alleegs_preprocessed_src_conn{subjIndex}.conn.static.bb=connectivity.static.bb;
                          

                    catch
                        
                                        end
                                        
                                        try
                         connectivity.static.custom;
                         try 
                              alleegs_preprocessed_src_conn{subjIndex}.conn.static.custom;
                         catch
                             createstatic.custom=1;
                         end
                         
                          alleegs_preprocessed_src_conn{subjIndex}.conn.static.custom=connectivity.static.custom;
                          

                    catch
                        
                                        end
                    
                catch
                    
                end
    catch
        try
            connectivity.static;
            creastatic=1;
            alleegs_preprocessed_src_conn{subjIndex}.conn.static=connectivity.static;
              
            try
                               alleegs_preprocessed_src_conn{subjIndex}.conn.static.delta;
                                                createstatic.delta=1;

                        catch
                                           createstatic.delta=0;

                                           
                        
            end
                        
                        try
                               alleegs_preprocessed_src_conn{subjIndex}.conn.static.theta;
                                                createstatic.theta=1;

                        catch
                                           createstatic.theta=0;
                        end
                        
                        try
                               alleegs_preprocessed_src_conn{subjIndex}.conn.static.alpha;
                                                createstatic.alpha=1;
                        catch
                                           createstatic.alpha=0;

                        end
                        
                        try
                               alleegs_preprocessed_src_conn{subjIndex}.conn.static.beta;
                                                createstatic.beta=1;
                        catch
                                           createstatic.beta=0;
                        end
                        
                        try
                               alleegs_preprocessed_src_conn{subjIndex}.conn.static.gamma;
                                                createstatic.gamma=1;

                        catch
                                           createstatic.gamma=0;
                        end
                        
                        try
                               alleegs_preprocessed_src_conn{subjIndex}.conn.static.custom;
                                                createstatic.custom=1;
                        catch
                                           createstatic.custom=0;
                        end
                        
                        try
                               alleegs_preprocessed_src_conn{subjIndex}.conn.static.bb;
                                                createstatic.bb=1;

                        catch
                                           createstatic.bb=0;
                        end
        catch
            creastatic=0;
        
       end
        
    end
    
        try 
            alleegs_preprocessed_src_conn{subjIndex}.conn.dynamic;
%             dont create a node dynamic
                try
                    connectivity.dynamic;
                    try
                         connectivity.dynamic.delta;
                         try 
                              alleegs_preprocessed_src_conn{subjIndex}.conn.dynamic.delta;
                         catch
                             createdynamic.delta=1;
                         end
                         
                          alleegs_preprocessed_src_conn{subjIndex}.conn.dynamic.delta=connectivity.dynamic.delta;
                          

                    catch
                        
                    end
                    
                                        try
                         connectivity.dynamic.theta;
                         try 
                              alleegs_preprocessed_src_conn{subjIndex}.conn.dynamic.theta;
                         catch
                             createdynamic.theta=1;
                         end
                         
                          alleegs_preprocessed_src_conn{subjIndex}.conn.dynamic.theta=connectivity.dynamic.theta;
                          

                    catch
                        
                                        end
                    
                                                            try
                         connectivity.dynamic.alpha;
                         try 
                              alleegs_preprocessed_src_conn{subjIndex}.conn.dynamic.alpha;
                         catch
                             createdynamic.alpha=1;
                         end
                         
                          alleegs_preprocessed_src_conn{subjIndex}.conn.dynamic.alpha=connectivity.dynamic.alpha;
                          

                    catch
                        
                                                            end
                    
                                                                                try
                         connectivity.dynamic.beta;
                         try 
                              alleegs_preprocessed_src_conn{subjIndex}.conn.dynamic.beta;
                         catch
                             createdynamic.beta=1;
                         end
                         
                          alleegs_preprocessed_src_conn{subjIndex}.conn.dynamic.beta=connectivity.dynamic.beta;
                          

                    catch
                        
                                                                                end
                                        try
                         connectivity.dynamic.gamma;
                         try 
                              alleegs_preprocessed_src_conn{subjIndex}.conn.dynamic.gamma;
                         catch
                             createdynamic.gamma=1;
                         end
                         
                          alleegs_preprocessed_src_conn{subjIndex}.conn.dynamic.gamma=connectivity.dynamic.gamma;
                          

                    catch
                        
                                        end
                                        try
                         connectivity.dynamic.bb;
                         try 
                              alleegs_preprocessed_src_conn{subjIndex}.conn.dynamic.bb;
                         catch
                             createdynamic.bb=1;
                         end
                         
                          alleegs_preprocessed_src_conn{subjIndex}.conn.dynamic.bb=connectivity.dynamic.bb;
                          

                    catch
                        
                                        end
                                        
                                        try
                         connectivity.dynamic.custom;
                         try 
                              alleegs_preprocessed_src_conn{subjIndex}.conn.dynamic.custom;
                         catch
                             createdynamic.custom=1;
                         end
                         
                          alleegs_preprocessed_src_conn{subjIndex}.conn.dynamic.custom=connectivity.dynamic.custom;
                          

                    catch
                        
                                        end
                    
                catch
                    
                end
    catch
        try
            connectivity.dynamic;
            creadynamic=1;
            alleegs_preprocessed_src_conn{subjIndex}.conn.dynamic=connectivity.dynamic;
              
            try
                               alleegs_preprocessed_src_conn{subjIndex}.conn.dynamic.delta;
                                                createdynamic.delta=1;

                        catch
                                           createdynamic.delta=0;

                                           
                        
            end
                        
                        try
                               alleegs_preprocessed_src_conn{subjIndex}.conn.dynamic.theta;
                                                createdynamic.theta=1;

                        catch
                                           createdynamic.theta=0;
                        end
                        
                        try
                               alleegs_preprocessed_src_conn{subjIndex}.conn.dynamic.alpha;
                                                createdynamic.alpha=1;
                        catch
                                           createdynamic.alpha=0;

                        end
                        
                        try
                               alleegs_preprocessed_src_conn{subjIndex}.conn.dynamic.beta;
                                                createdynamic.beta=1;
                        catch
                                           createdynamic.beta=0;
                        end
                        
                        try
                               alleegs_preprocessed_src_conn{subjIndex}.conn.dynamic.gamma;
                                                createdynamic.gamma=1;

                        catch
                                           createdynamic.gamma=0;
                        end
                        
                        try
                               alleegs_preprocessed_src_conn{subjIndex}.conn.dynamic.custom;
                                                createdynamic.custom=1;
                        catch
                                           createdynamic.custom=0;
                        end
                        
                        try
                               alleegs_preprocessed_src_conn{subjIndex}.conn.dynamic.bb;
                                                createdynamic.bb=1;

                        catch
                                           createdynamic.bb=0;
                        end
        catch
            creadynamic=0;
        
       end
        
        end
    
catch
% %             no connectivity node that already exist for this subject
            create=1;
            alleegs_preprocessed_src_conn{subjIndex}.conn=connectivity;
            try
                alleegs_preprocessed_src_conn{subjIndex}.conn.static;
                 creastatic=1;
                        try
                               alleegs_preprocessed_src_conn{subjIndex}.conn.static.delta;
                                                createstatic.delta=1;

                        catch
                                           createstatic.delta=0;

                        end
                        
                        try
                               alleegs_preprocessed_src_conn{subjIndex}.conn.static.theta;
                                                createstatic.theta=1;

                        catch
                                           createstatic.theta=0;
                        end
                        
                        try
                               alleegs_preprocessed_src_conn{subjIndex}.conn.static.alpha;
                                                createstatic.alpha=1;
                        catch
                                           createstatic.alpha=0;

                        end
                        
                        try
                               alleegs_preprocessed_src_conn{subjIndex}.conn.static.beta;
                                                createstatic.beta=1;
                        catch
                                           createstatic.beta=0;
                        end
                        
                        try
                               alleegs_preprocessed_src_conn{subjIndex}.conn.static.gamma;
                                                createstatic.gamma=1;

                        catch
                                           createstatic.gamma=0;
                        end
                        
                        try
                               alleegs_preprocessed_src_conn{subjIndex}.conn.static.custom;
                                                createstatic.custom=1;
                        catch
                                           createstatic.custom=0;
                        end
                        
                        try
                               alleegs_preprocessed_src_conn{subjIndex}.conn.static.bb;
                                                createstatic.bb=1;

                        catch
                                           createstatic.bb=0;
                        end
                                               
                        
            catch
                                 creastatic=0;

            end
            
            
            
            try
                alleegs_preprocessed_src_conn{subjIndex}.conn.dynamic;
                 creadynamic=1;
                        try
                               alleegs_preprocessed_src_conn{subjIndex}.conn.dynamic.delta;
                                                createdynamic.delta=1;

                        catch
                                           createdynamic.delta=0;

                        end
                        
                        try
                               alleegs_preprocessed_src_conn{subjIndex}.conn.dynamic.theta;
                                                createdynamic.theta=1;

                        catch
                                           createdynamic.theta=0;
                        end
                        
                        try
                               alleegs_preprocessed_src_conn{subjIndex}.conn.dynamic.alpha;
                                                createdynamic.alpha=1;
                        catch
                                           createdynamic.alpha=0;

                        end
                        
                        try
                               alleegs_preprocessed_src_conn{subjIndex}.conn.dynamic.beta;
                                                createdynamic.beta=1;
                        catch
                                           createdynamic.beta=0;
                        end
                        
                        try
                               alleegs_preprocessed_src_conn{subjIndex}.conn.dynamic.gamma;
                                                createdynamic.gamma=1;

                        catch
                                           createdynamic.gamma=0;
                        end
                        
                        try
                               alleegs_preprocessed_src_conn{subjIndex}.conn.dynamic.custom;
                                                createdynamic.custom=1;
                        catch
                                           createdynamic.custom=0;
                        end
                        
                        try
                               alleegs_preprocessed_src_conn{subjIndex}.conn.dynamic.bb;
                                                createdynamic.bb=1;

                        catch
                                           createdynamic.bb=0;
                        end
                                               
                        
            catch
                                 creadynamic=0;

            end

end

     
else
             if(strcmp(nodeName(1:32),'Reconstructed Preprocessed Epoch'))
             subjectParent=node.getParent;
             subjectParent=subjectParent.getParent; 
             subjectParent=subjectParent.getParent;  
             subjectParent=subjectParent.getParent;  
             subjectname=char(subjectParent.getName);
             subjectname=subjectname(3:end);
% %          index of the subject to show its eeg in the figure
             subjIndex=find(strcmp(allsubjects.names, subjectname));
%              pathfile= allsubjects.paths{subjIndex};
             number=str2num(nodeName(34:end));
             
             try
            allepochs_preprocessed_src_conn{subjIndex,number}.conn;
% %             dont create a node connectivity
            create=0;      
% %             see if static or dynamic
    try 
            allepochs_preprocessed_src_conn{subjIndex,number}.conn.static;
%             dont create a node static
                try
                    connectivity.static;
                    try
                         connectivity.static.delta;
                         try 
                              allepochs_preprocessed_src_conn{subjIndex,number}.conn.static.delta;
                         catch
                             createstatic.delta=1;
                         end
                         
                          allepochs_preprocessed_src_conn{subjIndex,number}.conn.static.delta=connectivity.static.delta;
                          

                    catch
                        
                    end
                    
                                        try
                         connectivity.static.theta;
                         try 
                              allepochs_preprocessed_src_conn{subjIndex,number}.conn.static.theta;
                         catch
                             createstatic.theta=1;
                         end
                         
                          allepochs_preprocessed_src_conn{subjIndex,number}.conn.static.theta=connectivity.static.theta;
                          

                    catch
                        
                                        end
                    
                                                            try
                         connectivity.static.alpha;
                         try 
                              allepochs_preprocessed_src_conn{subjIndex,number}.conn.static.alpha;
                         catch
                             createstatic.alpha=1;
                         end
                         
                          allepochs_preprocessed_src_conn{subjIndex,number}.conn.static.alpha=connectivity.static.alpha;
                          

                    catch
                        
                                                            end
                    
                                                                                try
                         connectivity.static.beta;
                         try 
                              allepochs_preprocessed_src_conn{subjIndex,number}.conn.static.beta;
                         catch
                             createstatic.beta=1;
                         end
                         
                          allepochs_preprocessed_src_conn{subjIndex,number}.conn.static.beta=connectivity.static.beta;
                          

                    catch
                        
                                                                                end
                                        try
                         connectivity.static.gamma;
                         try 
                              allepochs_preprocessed_src_conn{subjIndex,number}.conn.static.gamma;
                         catch
                             createstatic.gamma=1;
                         end
                         
                          allepochs_preprocessed_src_conn{subjIndex,number}.conn.static.gamma=connectivity.static.gamma;
                          

                    catch
                        
                                        end
                                        try
                         connectivity.static.bb;
                         try 
                              allepochs_preprocessed_src_conn{subjIndex,number}.conn.static.bb;
                         catch
                             createstatic.bb=1;
                         end
                         
                          allepochs_preprocessed_src_conn{subjIndex,number}.conn.static.bb=connectivity.static.bb;
                          

                    catch
                        
                                        end
                                        
                                        try
                         connectivity.static.custom;
                         try 
                              allepochs_preprocessed_src_conn{subjIndex,number}.conn.static.custom;
                         catch
                             createstatic.custom=1;
                         end
                         
                          allepochs_preprocessed_src_conn{subjIndex,number}.conn.static.custom=connectivity.static.custom;
                          

                    catch
                        
                                        end
                    
                catch
                    
                end
    catch
        try
            connectivity.static;
            creastatic=1;
            allepochs_preprocessed_src_conn{subjIndex,number}.conn.static=connectivity.static;
              
            try
                               allepochs_preprocessed_src_conn{subjIndex,number}.conn.static.delta;
                                                createstatic.delta=1;

                        catch
                                           createstatic.delta=0;

                                           
                        
            end
                        
                        try
                               allepochs_preprocessed_src_conn{subjIndex,number}.conn.static.theta;
                                                createstatic.theta=1;

                        catch
                                           createstatic.theta=0;
                        end
                        
                        try
                               allepochs_preprocessed_src_conn{subjIndex,number}.conn.static.alpha;
                                                createstatic.alpha=1;
                        catch
                                           createstatic.alpha=0;

                        end
                        
                        try
                               allepochs_preprocessed_src_conn{subjIndex,number}.conn.static.beta;
                                                createstatic.beta=1;
                        catch
                                           createstatic.beta=0;
                        end
                        
                        try
                               allepochs_preprocessed_src_conn{subjIndex,number}.conn.static.gamma;
                                                createstatic.gamma=1;

                        catch
                                           createstatic.gamma=0;
                        end
                        
                        try
                               allepochs_preprocessed_src_conn{subjIndex,number}.conn.static.custom;
                                                createstatic.custom=1;
                        catch
                                           createstatic.custom=0;
                        end
                        
                        try
                               allepochs_preprocessed_src_conn{subjIndex,number}.conn.static.bb;
                                                createstatic.bb=1;

                        catch
                                           createstatic.bb=0;
                        end
        catch
            creastatic=0;
        
       end
        
    end
    
        try 
            allepochs_preprocessed_src_conn{subjIndex,number}.conn.dynamic;
%             dont create a node dynamic
                try
                    connectivity.dynamic;
                    try
                         connectivity.dynamic.delta;
                         try 
                              allepochs_preprocessed_src_conn{subjIndex,number}.conn.dynamic.delta;
                         catch
                             createdynamic.delta=1;
                         end
                         
                          allepochs_preprocessed_src_conn{subjIndex,number}.conn.dynamic.delta=connectivity.dynamic.delta;
                          

                    catch
                        
                    end
                    
                                        try
                         connectivity.dynamic.theta;
                         try 
                              allepochs_preprocessed_src_conn{subjIndex,number}.conn.dynamic.theta;
                         catch
                             createdynamic.theta=1;
                         end
                         
                          allepochs_preprocessed_src_conn{subjIndex,number}.conn.dynamic.theta=connectivity.dynamic.theta;
                          

                    catch
                        
                                        end
                    
                                                            try
                         connectivity.dynamic.alpha;
                         try 
                              allepochs_preprocessed_src_conn{subjIndex,number}.conn.dynamic.alpha;
                         catch
                             createdynamic.alpha=1;
                         end
                         
                          allepochs_preprocessed_src_conn{subjIndex,number}.conn.dynamic.alpha=connectivity.dynamic.alpha;
                          

                    catch
                        
                                                            end
                    
                                                                                try
                         connectivity.dynamic.beta;
                         try 
                              allepochs_preprocessed_src_conn{subjIndex,number}.conn.dynamic.beta;
                         catch
                             createdynamic.beta=1;
                         end
                         
                          allepochs_preprocessed_src_conn{subjIndex,number}.conn.dynamic.beta=connectivity.dynamic.beta;
                          

                    catch
                        
                                                                                end
                                        try
                         connectivity.dynamic.gamma;
                         try 
                              allepochs_preprocessed_src_conn{subjIndex,number}.conn.dynamic.gamma;
                         catch
                             createdynamic.gamma=1;
                         end
                         
                          allepochs_preprocessed_src_conn{subjIndex,number}.conn.dynamic.gamma=connectivity.dynamic.gamma;
                          

                    catch
                        
                                        end
                                        try
                         connectivity.dynamic.bb;
                         try 
                              allepochs_preprocessed_src_conn{subjIndex,number}.conn.dynamic.bb;
                         catch
                             createdynamic.bb=1;
                         end
                         
                          allepochs_preprocessed_src_conn{subjIndex,number}.conn.dynamic.bb=connectivity.dynamic.bb;
                          

                    catch
                        
                                        end
                                        
                                        try
                         connectivity.dynamic.custom;
                         try 
                              allepochs_preprocessed_src_conn{subjIndex,number}.conn.dynamic.custom;
                         catch
                             createdynamic.custom=1;
                         end
                         
                          allepochs_preprocessed_src_conn{subjIndex,number}.conn.dynamic.custom=connectivity.dynamic.custom;
                          

                    catch
                        
                                        end
                    
                catch
                    
                end
    catch
        try
            connectivity.dynamic;
            creadynamic=1;
            allepochs_preprocessed_src_conn{subjIndex,number}.conn.dynamic=connectivity.dynamic;
              
            try
                               allepochs_preprocessed_src_conn{subjIndex,number}.conn.dynamic.delta;
                                                createdynamic.delta=1;

                        catch
                                           createdynamic.delta=0;

                                           
                        
            end
                        
                        try
                               allepochs_preprocessed_src_conn{subjIndex,number}.conn.dynamic.theta;
                                                createdynamic.theta=1;

                        catch
                                           createdynamic.theta=0;
                        end
                        
                        try
                               allepochs_preprocessed_src_conn{subjIndex,number}.conn.dynamic.alpha;
                                                createdynamic.alpha=1;
                        catch
                                           createdynamic.alpha=0;

                        end
                        
                        try
                               allepochs_preprocessed_src_conn{subjIndex,number}.conn.dynamic.beta;
                                                createdynamic.beta=1;
                        catch
                                           createdynamic.beta=0;
                        end
                        
                        try
                               allepochs_preprocessed_src_conn{subjIndex,number}.conn.dynamic.gamma;
                                                createdynamic.gamma=1;

                        catch
                                           createdynamic.gamma=0;
                        end
                        
                        try
                               allepochs_preprocessed_src_conn{subjIndex,number}.conn.dynamic.custom;
                                                createdynamic.custom=1;
                        catch
                                           createdynamic.custom=0;
                        end
                        
                        try
                               allepochs_preprocessed_src_conn{subjIndex,number}.conn.dynamic.bb;
                                                createdynamic.bb=1;

                        catch
                                           createdynamic.bb=0;
                        end
        catch
            creadynamic=0;
        
       end
        
        end
    
catch
% %             no connectivity node that already exist for this subject
            create=1;
            allepochs_preprocessed_src_conn{subjIndex,number}.conn=connectivity;
            try
                allepochs_preprocessed_src_conn{subjIndex,number}.conn.static;
                 creastatic=1;
                        try
                               allepochs_preprocessed_src_conn{subjIndex,number}.conn.static.delta;
                                                createstatic.delta=1;

                        catch
                                           createstatic.delta=0;

                        end
                        
                        try
                               allepochs_preprocessed_src_conn{subjIndex,number}.conn.static.theta;
                                                createstatic.theta=1;

                        catch
                                           createstatic.theta=0;
                        end
                        
                        try
                               allepochs_preprocessed_src_conn{subjIndex,number}.conn.static.alpha;
                                                createstatic.alpha=1;
                        catch
                                           createstatic.alpha=0;

                        end
                        
                        try
                               allepochs_preprocessed_src_conn{subjIndex,number}.conn.static.beta;
                                                createstatic.beta=1;
                        catch
                                           createstatic.beta=0;
                        end
                        
                        try
                               allepochs_preprocessed_src_conn{subjIndex,number}.conn.static.gamma;
                                                createstatic.gamma=1;

                        catch
                                           createstatic.gamma=0;
                        end
                        
                        try
                               allepochs_preprocessed_src_conn{subjIndex,number}.conn.static.custom;
                                                createstatic.custom=1;
                        catch
                                           createstatic.custom=0;
                        end
                        
                        try
                               allepochs_preprocessed_src_conn{subjIndex,number}.conn.static.bb;
                                                createstatic.bb=1;

                        catch
                                           createstatic.bb=0;
                        end
                                               
                        
            catch
                                 creastatic=0;

            end
            
            
            
            try
                allepochs_preprocessed_src_conn{subjIndex,number}.conn.dynamic;
                 creadynamic=1;
                        try
                               allepochs_preprocessed_src_conn{subjIndex,number}.conn.dynamic.delta;
                                                createdynamic.delta=1;

                        catch
                                           createdynamic.delta=0;

                        end
                        
                        try
                               allepochs_preprocessed_src_conn{subjIndex,number}.conn.dynamic.theta;
                                                createdynamic.theta=1;

                        catch
                                           createdynamic.theta=0;
                        end
                        
                        try
                               allepochs_preprocessed_src_conn{subjIndex,number}.conn.dynamic.alpha;
                                                createdynamic.alpha=1;
                        catch
                                           createdynamic.alpha=0;

                        end
                        
                        try
                               allepochs_preprocessed_src_conn{subjIndex,number}.conn.dynamic.beta;
                                                createdynamic.beta=1;
                        catch
                                           createdynamic.beta=0;
                        end
                        
                        try
                               allepochs_preprocessed_src_conn{subjIndex,number}.conn.dynamic.gamma;
                                                createdynamic.gamma=1;

                        catch
                                           createdynamic.gamma=0;
                        end
                        
                        try
                               allepochs_preprocessed_src_conn{subjIndex,number}.conn.dynamic.custom;
                                                createdynamic.custom=1;
                        catch
                                           createdynamic.custom=0;
                        end
                        
                        try
                               allepochs_preprocessed_src_conn{subjIndex,number}.conn.dynamic.bb;
                                                createdynamic.bb=1;

                        catch
                                           createdynamic.bb=0;
                        end
                                               
                        
            catch
                                 creadynamic=0;

            end

end
             end
end
       end
end

% % create node
% % create node
if(create==1)
node_toadd=node_in;
childNode = uitreenode('v0','dummy', 'Connectivity', [], 0);
[I] = imread('Icons/connectivity_icon.png');
javaImage_eeg = im2java(I);
childNode.setIcon(javaImage_eeg);
treeModel.insertNodeInto(childNode,node_toadd,node_toadd.getChildCount()); 
% expand to show added child
tree.setSelectedNode( childNode );
% insure additional nodes are added to parent
tree.setSelectedNode( node_toadd );
conparentnode=childNode;

if(creastatic)
    statMat=connectivity.static;
    childNode = uitreenode('v0','dummy', 'Static', [], 0);
[I] = imread('Icons/static_icon.png');
    javaImage_eeg = im2java(I);
    childNode.setIcon(javaImage_eeg);
    treeModel.insertNodeInto(childNode,conparentnode,conparentnode.getChildCount()); 
    % expand to show added child
    tree.setSelectedNode( childNode );
    % insure additional nodes are added to parent
    tree.setSelectedNode( conparentnode );
    statparentnode=childNode;
    
    if(createstatic.delta)
           childNode = uitreenode('v0','dummy', 'Delta', [], 0);
[I] = imread('Icons/icon_conn.png');
        javaImage_eeg = im2java(I);
        childNode.setIcon(javaImage_eeg);
        treeModel.insertNodeInto(childNode,statparentnode,statparentnode.getChildCount()); 
        % expand to show added child
        tree.setSelectedNode( childNode );
        % insure additional nodes are added to parent
        tree.setSelectedNode( statparentnode );

    

    end
    
    if(createstatic.theta)
           childNode = uitreenode('v0','dummy', 'Theta', [], 0);
[I] = imread('Icons/icon_conn.png');
        javaImage_eeg = im2java(I);
        childNode.setIcon(javaImage_eeg);
        treeModel.insertNodeInto(childNode,statparentnode,statparentnode.getChildCount()); 
        % expand to show added child
        tree.setSelectedNode( childNode );
        % insure additional nodes are added to parent
        tree.setSelectedNode( statparentnode );

    
    end
if(createstatic.alpha)
           childNode = uitreenode('v0','dummy', 'Alpha', [], 0);
[I] = imread('Icons/icon_conn.png');
        javaImage_eeg = im2java(I);
        childNode.setIcon(javaImage_eeg);
        treeModel.insertNodeInto(childNode,statparentnode,statparentnode.getChildCount()); 
        % expand to show added child
        tree.setSelectedNode( childNode );
        % insure additional nodes are added to parent
        tree.setSelectedNode( statparentnode );

    
end
if(createstatic.beta)
           childNode = uitreenode('v0','dummy', 'Beta', [], 0);
[I] = imread('Icons/icon_conn.png');
        javaImage_eeg = im2java(I);
        childNode.setIcon(javaImage_eeg);
        treeModel.insertNodeInto(childNode,statparentnode,statparentnode.getChildCount()); 
        % expand to show added child
        tree.setSelectedNode( childNode );
        % insure additional nodes are added to parent
        tree.setSelectedNode( statparentnode );

    
end
if(createstatic.gamma)
           childNode = uitreenode('v0','dummy', 'Gamma', [], 0);
[I] = imread('Icons/icon_conn.png');
        javaImage_eeg = im2java(I);
        childNode.setIcon(javaImage_eeg);
        treeModel.insertNodeInto(childNode,statparentnode,statparentnode.getChildCount()); 
        % expand to show added child
        tree.setSelectedNode( childNode );
        % insure additional nodes are added to parent
        tree.setSelectedNode( statparentnode );

    
end
if(createstatic.bb)
           childNode = uitreenode('v0','dummy', 'bb', [], 0);
[I] = imread('Icons/icon_conn.png');
        javaImage_eeg = im2java(I);
        childNode.setIcon(javaImage_eeg);
        treeModel.insertNodeInto(childNode,statparentnode,statparentnode.getChildCount()); 
        % expand to show added child
        tree.setSelectedNode( childNode );
        % insure additional nodes are added to parent
        tree.setSelectedNode( statparentnode );

    
end
if(createstatic.custom)
           childNode = uitreenode('v0','dummy', 'Custom', [], 0);
[I] = imread('Icons/icon_conn.png');
        javaImage_eeg = im2java(I);
        childNode.setIcon(javaImage_eeg);
        treeModel.insertNodeInto(childNode,statparentnode,statparentnode.getChildCount()); 
        % expand to show added child
        tree.setSelectedNode( childNode );
        % insure additional nodes are added to parent
        tree.setSelectedNode( statparentnode );

    
end
else
% %     no need to create statix node but should test if subnodes should be
% created 
    if(createstatic.delta)
 statparentnode=conparentnode;
    count=0;
    while(1)
        statparentnode=statparentnode.getNextNode;
        
        if(strcmp(char(statparentnode.getName),'Static')==1)
        break;
        else
            continue;
        end
    end
    childNode = uitreenode('v0','dummy', 'Delta', [], 0);
[I] = imread('Icons/icon_conn.png');
        javaImage_eeg = im2java(I);
        childNode.setIcon(javaImage_eeg);
        treeModel.insertNodeInto(childNode,statparentnode,statparentnode.getChildCount()); 
        % expand to show added child
        tree.setSelectedNode( childNode );
        % insure additional nodes are added to parent
        tree.setSelectedNode( statparentnode );

    

    end
    
    if(createstatic.theta)
 statparentnode=conparentnode;
    count=0;
    while(1)
        statparentnode=statparentnode.getNextNode;
        
        if(strcmp(char(statparentnode.getName),'Static')==1)
        break;
        else
            continue;
        end
    end  
           childNode = uitreenode('v0','dummy', 'Theta', [], 0);
[I] = imread('Icons/icon_conn.png');
        javaImage_eeg = im2java(I);
        childNode.setIcon(javaImage_eeg);
        treeModel.insertNodeInto(childNode,statparentnode,statparentnode.getChildCount()); 
        % expand to show added child
        tree.setSelectedNode( childNode );
        % insure additional nodes are added to parent
        tree.setSelectedNode( statparentnode );

    
    end
if(createstatic.alpha)
 statparentnode=conparentnode;
    count=0;
    while(1)
        statparentnode=statparentnode.getNextNode;
        
        if(strcmp(char(statparentnode.getName),'Static')==1)
        break;
        else
            continue;
        end
    end  
           childNode = uitreenode('v0','dummy', 'Alpha', [], 0);
[I] = imread('Icons/icon_conn.png');
        javaImage_eeg = im2java(I);
        childNode.setIcon(javaImage_eeg);
        treeModel.insertNodeInto(childNode,statparentnode,statparentnode.getChildCount()); 
        % expand to show added child
        tree.setSelectedNode( childNode );
        % insure additional nodes are added to parent
        tree.setSelectedNode( statparentnode );

    
end
if(createstatic.beta)
 statparentnode=conparentnode;
    count=0;
    while(1)
        statparentnode=statparentnode.getNextNode;
        
        if(strcmp(char(statparentnode.getName),'Static')==1)
        break;
        else
            continue;
        end
    end  
    
           childNode = uitreenode('v0','dummy', 'Beta', [], 0);
[I] = imread('Icons/icon_conn.png');
        javaImage_eeg = im2java(I);
        childNode.setIcon(javaImage_eeg);
        treeModel.insertNodeInto(childNode,statparentnode,statparentnode.getChildCount()); 
        % expand to show added child
        tree.setSelectedNode( childNode );
        % insure additional nodes are added to parent
        tree.setSelectedNode( statparentnode );

    
end
if(createstatic.gamma)
    
     statparentnode=conparentnode;
    count=0;
    while(1)
        statparentnode=statparentnode.getNextNode;
        
        if(strcmp(char(statparentnode.getName),'Static')==1)
        break;
        else
            continue;
        end
    end  
           childNode = uitreenode('v0','dummy', 'Gamma', [], 0);
[I] = imread('Icons/icon_conn.png');
        javaImage_eeg = im2java(I);
        childNode.setIcon(javaImage_eeg);
        treeModel.insertNodeInto(childNode,statparentnode,statparentnode.getChildCount()); 
        % expand to show added child
        tree.setSelectedNode( childNode );
        % insure additional nodes are added to parent
        tree.setSelectedNode( statparentnode );

    
end
if(createstatic.bb)
 statparentnode=conparentnode;
    count=0;
    while(1)
        statparentnode=statparentnode.getNextNode;
        
        if(strcmp(char(statparentnode.getName),'Static')==1)
        break;
        else
            continue;
        end
    end  
    
           childNode = uitreenode('v0','dummy', 'bb', [], 0);
[I] = imread('Icons/icon_conn.png');
        javaImage_eeg = im2java(I);
        childNode.setIcon(javaImage_eeg);
        treeModel.insertNodeInto(childNode,statparentnode,statparentnode.getChildCount()); 
        % expand to show added child
        tree.setSelectedNode( childNode );
        % insure additional nodes are added to parent
        tree.setSelectedNode( statparentnode );

    
end
if(createstatic.custom)
 statparentnode=conparentnode;
    count=0;
    while(1)
        statparentnode=statparentnode.getNextNode;
        
        if(strcmp(char(statparentnode.getName),'Static')==1)
        break;
        else
            continue;
        end
    end  
    
           childNode = uitreenode('v0','dummy', 'Custom', [], 0);
[I] = imread('Icons/icon_conn.png');
        javaImage_eeg = im2java(I);
        childNode.setIcon(javaImage_eeg);
        treeModel.insertNodeInto(childNode,statparentnode,statparentnode.getChildCount()); 
        % expand to show added child
        tree.setSelectedNode( childNode );
        % insure additional nodes are added to parent
        tree.setSelectedNode( statparentnode );

    
end

end

if(creadynamic)
    statMat=connectivity.dynamic;
    childNode = uitreenode('v0','dummy', 'Dynamic', [], 0);
[I] = imread('Icons/dynamic_icon.png');
    javaImage_eeg = im2java(I);
    childNode.setIcon(javaImage_eeg);
    treeModel.insertNodeInto(childNode,conparentnode,conparentnode.getChildCount()); 
    % expand to show added child
    tree.setSelectedNode( childNode );
    % insure additional nodes are added to parent
    tree.setSelectedNode( conparentnode );
    statparentnode=childNode;
    
    if(createdynamic.delta)
           childNode = uitreenode('v0','dummy', 'Delta', [], 0);
[I] = imread('Icons/icon_conn.png');
        javaImage_eeg = im2java(I);
        childNode.setIcon(javaImage_eeg);
        treeModel.insertNodeInto(childNode,statparentnode,statparentnode.getChildCount()); 
        % expand to show added child
        tree.setSelectedNode( childNode );
        % insure additional nodes are added to parent
        tree.setSelectedNode( statparentnode );

    

    end
    
    if(createdynamic.theta)
           childNode = uitreenode('v0','dummy', 'Theta', [], 0);
[I] = imread('Icons/icon_conn.png');
        javaImage_eeg = im2java(I);
        childNode.setIcon(javaImage_eeg);
        treeModel.insertNodeInto(childNode,statparentnode,statparentnode.getChildCount()); 
        % expand to show added child
        tree.setSelectedNode( childNode );
        % insure additional nodes are added to parent
        tree.setSelectedNode( statparentnode );

    
    end
if(createdynamic.alpha)
           childNode = uitreenode('v0','dummy', 'Alpha', [], 0);
[I] = imread('Icons/icon_conn.png');
        javaImage_eeg = im2java(I);
        childNode.setIcon(javaImage_eeg);
        treeModel.insertNodeInto(childNode,statparentnode,statparentnode.getChildCount()); 
        % expand to show added child
        tree.setSelectedNode( childNode );
        % insure additional nodes are added to parent
        tree.setSelectedNode( statparentnode );

    
end
if(createdynamic.beta)
           childNode = uitreenode('v0','dummy', 'Beta', [], 0);
[I] = imread('Icons/icon_conn.png');
        javaImage_eeg = im2java(I);
        childNode.setIcon(javaImage_eeg);
        treeModel.insertNodeInto(childNode,statparentnode,statparentnode.getChildCount()); 
        % expand to show added child
        tree.setSelectedNode( childNode );
        % insure additional nodes are added to parent
        tree.setSelectedNode( statparentnode );

    
end
if(createdynamic.gamma)
           childNode = uitreenode('v0','dummy', 'Gamma', [], 0);
[I] = imread('Icons/icon_conn.png');
        javaImage_eeg = im2java(I);
        childNode.setIcon(javaImage_eeg);
        treeModel.insertNodeInto(childNode,statparentnode,statparentnode.getChildCount()); 
        % expand to show added child
        tree.setSelectedNode( childNode );
        % insure additional nodes are added to parent
        tree.setSelectedNode( statparentnode );

    
end
if(createdynamic.bb)
           childNode = uitreenode('v0','dummy', 'bb', [], 0);
[I] = imread('Icons/icon_conn.png');
        javaImage_eeg = im2java(I);
        childNode.setIcon(javaImage_eeg);
        treeModel.insertNodeInto(childNode,statparentnode,statparentnode.getChildCount()); 
        % expand to show added child
        tree.setSelectedNode( childNode );
        % insure additional nodes are added to parent
        tree.setSelectedNode( statparentnode );

    
end
if(createdynamic.custom)
           childNode = uitreenode('v0','dummy', 'Custom', [], 0);
[I] = imread('Icons/icon_conn.png');
        javaImage_eeg = im2java(I);
        childNode.setIcon(javaImage_eeg);
        treeModel.insertNodeInto(childNode,statparentnode,statparentnode.getChildCount()); 
        % expand to show added child
        tree.setSelectedNode( childNode );
        % insure additional nodes are added to parent
        tree.setSelectedNode( statparentnode );

    
end
else
% %     no need to create dynamic node but should test if subnodes should be
% created 
    if(createdynamic.delta)
        
        dynparentnode=conparentnode;
    count=0;
    while(1)
        dynparentnode=dynparentnode.getNextNode;
        
        if(strcmp(char(dynparentnode.getName),'Dynamic')==1)
        break;
        else
            continue;
        end
    end         
        
           childNode = uitreenode('v0','dummy', 'Delta', [], 0);
[I] = imread('Icons/icon_conn.png');
        javaImage_eeg = im2java(I);
        childNode.setIcon(javaImage_eeg);
        treeModel.insertNodeInto(childNode,dynparentnode,dynparentnode.getChildCount()); 
        % expand to show added child
        tree.setSelectedNode( childNode );
        % insure additional nodes are added to parent
        tree.setSelectedNode( dynparentnode );

    

    end
    
    if(createdynamic.theta)
dynparentnode=conparentnode;
    count=0;
    while(1)
        dynparentnode=dynparentnode.getNextNode;
        
        if(strcmp(char(dynparentnode.getName),'Dynamic')==1)
        break;
        else
            continue;
        end
    end 
           childNode = uitreenode('v0','dummy', 'Theta', [], 0);
[I] = imread('Icons/icon_conn.png');
        javaImage_eeg = im2java(I);
        childNode.setIcon(javaImage_eeg);
        treeModel.insertNodeInto(childNode,dynparentnode,dynparentnode.getChildCount()); 
        % expand to show added child
        tree.setSelectedNode( childNode );
        % insure additional nodes are added to parent
        tree.setSelectedNode( dynparentnode );

    
    end
if(createdynamic.alpha)
dynparentnode=conparentnode;
    count=0;
    while(1)
        dynparentnode=dynparentnode.getNextNode;
        
        if(strcmp(char(dynparentnode.getName),'Dynamic')==1)
        break;
        else
            continue;
        end
    end 
           childNode = uitreenode('v0','dummy', 'Alpha', [], 0);
[I] = imread('Icons/icon_conn.png');
        javaImage_eeg = im2java(I);
        childNode.setIcon(javaImage_eeg);
        treeModel.insertNodeInto(childNode,dynparentnode,dynparentnode.getChildCount()); 
        % expand to show added child
        tree.setSelectedNode( childNode );
        % insure additional nodes are added to parent
        tree.setSelectedNode( dynparentnode );

    
end
if(createdynamic.beta)
dynparentnode=conparentnode;
    count=0;
    while(1)
        dynparentnode=dynparentnode.getNextNode;
        
        if(strcmp(char(dynparentnode.getName),'Dynamic')==1)
        break;
        else
            continue;
        end
    end 
           childNode = uitreenode('v0','dummy', 'Beta', [], 0);
[I] = imread('Icons/icon_conn.png');
        javaImage_eeg = im2java(I);
        childNode.setIcon(javaImage_eeg);
        treeModel.insertNodeInto(childNode,dynparentnode,dynparentnode.getChildCount()); 
        % expand to show added child
        tree.setSelectedNode( childNode );
        % insure additional nodes are added to parent
        tree.setSelectedNode( dynparentnode );

    
end
if(createdynamic.gamma)
dynparentnode=conparentnode;
    count=0;
    while(1)
        dynparentnode=dynparentnode.getNextNode;
        
        if(strcmp(char(dynparentnode.getName),'Dynamic')==1)
        break;
        else
            continue;
        end
    end 
           childNode = uitreenode('v0','dummy', 'Gamma', [], 0);
[I] = imread('Icons/icon_conn.png');
        javaImage_eeg = im2java(I);
        childNode.setIcon(javaImage_eeg);
        treeModel.insertNodeInto(childNode,dynparentnode,dynparentnode.getChildCount()); 
        % expand to show added child
        tree.setSelectedNode( childNode );
        % insure additional nodes are added to parent
        tree.setSelectedNode( dynparentnode );

    
end
if(createdynamic.bb)
dynparentnode=conparentnode;
    count=0;
    while(1)
        dynparentnode=dynparentnode.getNextNode;
        
        if(strcmp(char(dynparentnode.getName),'Dynamic')==1)
        break;
        else
            continue;
        end
    end 
           childNode = uitreenode('v0','dummy', 'bb', [], 0);
[I] = imread('Icons/icon_conn.png');
        javaImage_eeg = im2java(I);
        childNode.setIcon(javaImage_eeg);
        treeModel.insertNodeInto(childNode,dynparentnode,dynparentnode.getChildCount()); 
        % expand to show added child
        tree.setSelectedNode( childNode );
        % insure additional nodes are added to parent
        tree.setSelectedNode( dynparentnode );

    
end
if(createdynamic.custom)
dynparentnode=conparentnode;
    count=0;
    while(1)
        dynparentnode=dynparentnode.getNextNode;
        
        if(strcmp(char(dynparentnode.getName),'Dynamic')==1)
        break;
        else
            continue;
        end
    end 
           childNode = uitreenode('v0','dummy', 'Custom', [], 0);
[I] = imread('Icons/icon_conn.png');
        javaImage_eeg = im2java(I);
        childNode.setIcon(javaImage_eeg);
        treeModel.insertNodeInto(childNode,dynparentnode,dynparentnode.getChildCount()); 
        % expand to show added child
        tree.setSelectedNode( childNode );
        % insure additional nodes are added to parent
        tree.setSelectedNode( dynparentnode );

    
end

end

  
else
% %     no need to create con node but may need to create subnodes
% (static,dynamic)
if(creastatic)
conparentnode=node_in.getNextNode;
    statMat=connectivity.static;
    childNode = uitreenode('v0','dummy', 'Static', [], 0);
[I] = imread('Icons/static_icon.png');
    javaImage_eeg = im2java(I);
    childNode.setIcon(javaImage_eeg);
    treeModel.insertNodeInto(childNode,conparentnode,conparentnode.getChildCount()); 
    % expand to show added child
    tree.setSelectedNode( childNode );
    % insure additional nodes are added to parent
    tree.setSelectedNode( conparentnode );
    statparentnode=childNode;
    
    if(createstatic.delta)
           childNode = uitreenode('v0','dummy', 'Delta', [], 0);
[I] = imread('Icons/icon_conn.png');
        javaImage_eeg = im2java(I);
        childNode.setIcon(javaImage_eeg);
        treeModel.insertNodeInto(childNode,statparentnode,statparentnode.getChildCount()); 
        % expand to show added child
        tree.setSelectedNode( childNode );
        % insure additional nodes are added to parent
        tree.setSelectedNode( statparentnode );

    

    end
    
    if(createstatic.theta)
           childNode = uitreenode('v0','dummy', 'Theta', [], 0);
[I] = imread('Icons/icon_conn.png');
        javaImage_eeg = im2java(I);
        childNode.setIcon(javaImage_eeg);
        treeModel.insertNodeInto(childNode,statparentnode,statparentnode.getChildCount()); 
        % expand to show added child
        tree.setSelectedNode( childNode );
        % insure additional nodes are added to parent
        tree.setSelectedNode( statparentnode );

    
    end
if(createstatic.alpha)
           childNode = uitreenode('v0','dummy', 'Alpha', [], 0);
[I] = imread('Icons/icon_conn.png');
        javaImage_eeg = im2java(I);
        childNode.setIcon(javaImage_eeg);
        treeModel.insertNodeInto(childNode,statparentnode,statparentnode.getChildCount()); 
        % expand to show added child
        tree.setSelectedNode( childNode );
        % insure additional nodes are added to parent
        tree.setSelectedNode( statparentnode );

    
end
if(createstatic.beta)
           childNode = uitreenode('v0','dummy', 'Beta', [], 0);
[I] = imread('Icons/icon_conn.png');
        javaImage_eeg = im2java(I);
        childNode.setIcon(javaImage_eeg);
        treeModel.insertNodeInto(childNode,statparentnode,statparentnode.getChildCount()); 
        % expand to show added child
        tree.setSelectedNode( childNode );
        % insure additional nodes are added to parent
        tree.setSelectedNode( statparentnode );

    
end
if(createstatic.gamma)
           childNode = uitreenode('v0','dummy', 'Gamma', [], 0);
[I] = imread('Icons/icon_conn.png');
        javaImage_eeg = im2java(I);
        childNode.setIcon(javaImage_eeg);
        treeModel.insertNodeInto(childNode,statparentnode,statparentnode.getChildCount()); 
        % expand to show added child
        tree.setSelectedNode( childNode );
        % insure additional nodes are added to parent
        tree.setSelectedNode( statparentnode );

    
end
if(createstatic.bb)
           childNode = uitreenode('v0','dummy', 'bb', [], 0);
[I] = imread('Icons/icon_conn.png');
        javaImage_eeg = im2java(I);
        childNode.setIcon(javaImage_eeg);
        treeModel.insertNodeInto(childNode,statparentnode,statparentnode.getChildCount()); 
        % expand to show added child
        tree.setSelectedNode( childNode );
        % insure additional nodes are added to parent
        tree.setSelectedNode( statparentnode );

    
end
if(createstatic.custom)
           childNode = uitreenode('v0','dummy', 'Custom', [], 0);
[I] = imread('Icons/icon_conn.png');
        javaImage_eeg = im2java(I);
        childNode.setIcon(javaImage_eeg);
        treeModel.insertNodeInto(childNode,statparentnode,statparentnode.getChildCount()); 
        % expand to show added child
        tree.setSelectedNode( childNode );
        % insure additional nodes are added to parent
        tree.setSelectedNode( statparentnode );

    
end
else
% %     no need to create statix node but should test if subnodes should be
% created 
conparentnode=node_in.getNextNode;

    if(createstatic.delta)
        statparentnode=conparentnode.getNextNode;
           childNode = uitreenode('v0','dummy', 'Delta', [], 0);
[I] = imread('Icons/icon_conn.png');
        javaImage_eeg = im2java(I);
        childNode.setIcon(javaImage_eeg);
        treeModel.insertNodeInto(childNode,statparentnode,statparentnode.getChildCount()); 
        % expand to show added child
        tree.setSelectedNode( childNode );
        % insure additional nodes are added to parent
        tree.setSelectedNode( statparentnode );

    

    end
    
    if(createstatic.theta)
                statparentnode=conparentnode.getNextNode;

           childNode = uitreenode('v0','dummy', 'Theta', [], 0);
[I] = imread('Icons/icon_conn.png');
        javaImage_eeg = im2java(I);
        childNode.setIcon(javaImage_eeg);
        treeModel.insertNodeInto(childNode,statparentnode,statparentnode.getChildCount()); 
        % expand to show added child
        tree.setSelectedNode( childNode );
        % insure additional nodes are added to parent
        tree.setSelectedNode( statparentnode );

    
    end
if(createstatic.alpha)
            statparentnode=conparentnode.getNextNode;

           childNode = uitreenode('v0','dummy', 'Alpha', [], 0);
[I] = imread('Icons/icon_conn.png');
        javaImage_eeg = im2java(I);
        childNode.setIcon(javaImage_eeg);
        treeModel.insertNodeInto(childNode,statparentnode,statparentnode.getChildCount()); 
        % expand to show added child
        tree.setSelectedNode( childNode );
        % insure additional nodes are added to parent
        tree.setSelectedNode( statparentnode );

    
end
if(createstatic.beta)
            statparentnode=conparentnode.getNextNode;

           childNode = uitreenode('v0','dummy', 'Beta', [], 0);
[I] = imread('Icons/icon_conn.png');
        javaImage_eeg = im2java(I);
        childNode.setIcon(javaImage_eeg);
        treeModel.insertNodeInto(childNode,statparentnode,statparentnode.getChildCount()); 
        % expand to show added child
        tree.setSelectedNode( childNode );
        % insure additional nodes are added to parent
        tree.setSelectedNode( statparentnode );

    
end
if(createstatic.gamma)
                statparentnode=conparentnode.getNextNode;

           childNode = uitreenode('v0','dummy', 'Gamma', [], 0);
[I] = imread('Icons/icon_conn.png');
        javaImage_eeg = im2java(I);
        childNode.setIcon(javaImage_eeg);
        treeModel.insertNodeInto(childNode,statparentnode,statparentnode.getChildCount()); 
        % expand to show added child
        tree.setSelectedNode( childNode );
        % insure additional nodes are added to parent
        tree.setSelectedNode( statparentnode );

    
end
if(createstatic.bb)
            statparentnode=conparentnode.getNextNode;

           childNode = uitreenode('v0','dummy', 'bb', [], 0);
[I] = imread('Icons/icon_conn.png');
        javaImage_eeg = im2java(I);
        childNode.setIcon(javaImage_eeg);
        treeModel.insertNodeInto(childNode,statparentnode,statparentnode.getChildCount()); 
        % expand to show added child
        tree.setSelectedNode( childNode );
        % insure additional nodes are added to parent
        tree.setSelectedNode( statparentnode );

    
end
if(createstatic.custom)
            statparentnode=conparentnode.getNextNode;

           childNode = uitreenode('v0','dummy', 'Custom', [], 0);
[I] = imread('Icons/icon_conn.png');
        javaImage_eeg = im2java(I);
        childNode.setIcon(javaImage_eeg);
        treeModel.insertNodeInto(childNode,statparentnode,statparentnode.getChildCount()); 
        % expand to show added child
        tree.setSelectedNode( childNode );
        % insure additional nodes are added to parent
        tree.setSelectedNode( statparentnode );

    
end

end

if(creadynamic)
    conparentnode=node_in.getNextNode;

    statMat=connectivity.dynamic;
    childNode = uitreenode('v0','dummy', 'Dynamic', [], 0);
[I] = imread('Icons/dynamic_icon.png');
    javaImage_eeg = im2java(I);
    childNode.setIcon(javaImage_eeg);
    treeModel.insertNodeInto(childNode,conparentnode,conparentnode.getChildCount()); 
    % expand to show added child
    tree.setSelectedNode( childNode );
    % insure additional nodes are added to parent
    tree.setSelectedNode( conparentnode );
    statparentnode=childNode;
    
    if(createdynamic.delta)
           childNode = uitreenode('v0','dummy', 'Delta', [], 0);
[I] = imread('Icons/icon_conn.png');
        javaImage_eeg = im2java(I);
        childNode.setIcon(javaImage_eeg);
        treeModel.insertNodeInto(childNode,statparentnode,statparentnode.getChildCount()); 
        % expand to show added child
        tree.setSelectedNode( childNode );
        % insure additional nodes are added to parent
        tree.setSelectedNode( statparentnode );

    

    end
    
    if(createdynamic.theta)
           childNode = uitreenode('v0','dummy', 'Theta', [], 0);
[I] = imread('Icons/icon_conn.png');
        javaImage_eeg = im2java(I);
        childNode.setIcon(javaImage_eeg);
        treeModel.insertNodeInto(childNode,statparentnode,statparentnode.getChildCount()); 
        % expand to show added child
        tree.setSelectedNode( childNode );
        % insure additional nodes are added to parent
        tree.setSelectedNode( statparentnode );

    
    end
if(createdynamic.alpha)
           childNode = uitreenode('v0','dummy', 'Alpha', [], 0);
[I] = imread('Icons/icon_conn.png');
        javaImage_eeg = im2java(I);
        childNode.setIcon(javaImage_eeg);
        treeModel.insertNodeInto(childNode,statparentnode,statparentnode.getChildCount()); 
        % expand to show added child
        tree.setSelectedNode( childNode );
        % insure additional nodes are added to parent
        tree.setSelectedNode( statparentnode );

    
end
if(createdynamic.beta)
           childNode = uitreenode('v0','dummy', 'Beta', [], 0);
[I] = imread('Icons/icon_conn.png');
        javaImage_eeg = im2java(I);
        childNode.setIcon(javaImage_eeg);
        treeModel.insertNodeInto(childNode,statparentnode,statparentnode.getChildCount()); 
        % expand to show added child
        tree.setSelectedNode( childNode );
        % insure additional nodes are added to parent
        tree.setSelectedNode( statparentnode );

    
end
if(createdynamic.gamma)
           childNode = uitreenode('v0','dummy', 'Gamma', [], 0);
[I] = imread('Icons/icon_conn.png');
        javaImage_eeg = im2java(I);
        childNode.setIcon(javaImage_eeg);
        treeModel.insertNodeInto(childNode,statparentnode,statparentnode.getChildCount()); 
        % expand to show added child
        tree.setSelectedNode( childNode );
        % insure additional nodes are added to parent
        tree.setSelectedNode( statparentnode );

    
end
if(createdynamic.bb)
           childNode = uitreenode('v0','dummy', 'bb', [], 0);
[I] = imread('Icons/icon_conn.png');
        javaImage_eeg = im2java(I);
        childNode.setIcon(javaImage_eeg);
        treeModel.insertNodeInto(childNode,statparentnode,statparentnode.getChildCount()); 
        % expand to show added child
        tree.setSelectedNode( childNode );
        % insure additional nodes are added to parent
        tree.setSelectedNode( statparentnode );

    
end
if(createdynamic.custom)
           childNode = uitreenode('v0','dummy', 'Custom', [], 0);
[I] = imread('Icons/icon_conn.png');
        javaImage_eeg = im2java(I);
        childNode.setIcon(javaImage_eeg);
        treeModel.insertNodeInto(childNode,statparentnode,statparentnode.getChildCount()); 
        % expand to show added child
        tree.setSelectedNode( childNode );
        % insure additional nodes are added to parent
        tree.setSelectedNode( statparentnode );

    
end
else
% %     no need to create dynamic node but should test if subnodes should be
% created 
    if(createdynamic.delta)
        conparentnode=node_in.getNextNode;

dynparentnode=conparentnode;
    count=0;
    while(1)
        dynparentnode=dynparentnode.getNextNode;
        
        if(strcmp(char(dynparentnode.getName),'Dynamic')==1)
        break;
        else
            continue;
        end
    end         
        
           childNode = uitreenode('v0','dummy', 'Delta', [], 0);
[I] = imread('Icons/icon_conn.png');
        javaImage_eeg = im2java(I);
        childNode.setIcon(javaImage_eeg);
        treeModel.insertNodeInto(childNode,dynparentnode,dynparentnode.getChildCount()); 
        % expand to show added child
        tree.setSelectedNode( childNode );
        % insure additional nodes are added to parent
        tree.setSelectedNode( dynparentnode );

    

    end
    
    if(createdynamic.theta)
        conparentnode=node_in.getNextNode;

dynparentnode=conparentnode;
    count=0;
    while(1)
        dynparentnode=dynparentnode.getNextNode;
        
        if(strcmp(char(dynparentnode.getName),'Dynamic')==1)
        break;
        else
            continue;
        end
    end 
           childNode = uitreenode('v0','dummy', 'Theta', [], 0);
[I] = imread('Icons/icon_conn.png');
        javaImage_eeg = im2java(I);
        childNode.setIcon(javaImage_eeg);
        treeModel.insertNodeInto(childNode,dynparentnode,dynparentnode.getChildCount()); 
        % expand to show added child
        tree.setSelectedNode( childNode );
        % insure additional nodes are added to parent
        tree.setSelectedNode( dynparentnode );

    
    end
if(createdynamic.alpha)
    conparentnode=node_in.getNextNode;

dynparentnode=conparentnode;
    count=0;
    while(1)
        dynparentnode=dynparentnode.getNextNode;
        
        if(strcmp(char(dynparentnode.getName),'Dynamic')==1)
        break;
        else
            continue;
        end
    end 
           childNode = uitreenode('v0','dummy', 'Alpha', [], 0);
[I] = imread('Icons/icon_conn.png');
        javaImage_eeg = im2java(I);
        childNode.setIcon(javaImage_eeg);
        treeModel.insertNodeInto(childNode,dynparentnode,dynparentnode.getChildCount()); 
        % expand to show added child
        tree.setSelectedNode( childNode );
        % insure additional nodes are added to parent
        tree.setSelectedNode( dynparentnode );

    
end
if(createdynamic.beta)
     conparentnode=node_in.getNextNode;

dynparentnode=conparentnode;
    count=0;
    while(1)
        dynparentnode=dynparentnode.getNextNode;
        
        if(strcmp(char(dynparentnode.getName),'Dynamic')==1)
        break;
        else
            continue;
        end
    end 
           childNode = uitreenode('v0','dummy', 'Beta', [], 0);
[I] = imread('Icons/icon_conn.png');
        javaImage_eeg = im2java(I);
        childNode.setIcon(javaImage_eeg);
        treeModel.insertNodeInto(childNode,dynparentnode,dynparentnode.getChildCount()); 
        % expand to show added child
        tree.setSelectedNode( childNode );
        % insure additional nodes are added to parent
        tree.setSelectedNode( dynparentnode );

    
end
if(createdynamic.gamma)
    conparentnode=node_in.getNextNode;

dynparentnode=conparentnode;
    count=0;
    while(1)
        dynparentnode=dynparentnode.getNextNode;
        
        if(strcmp(char(dynparentnode.getName),'Dynamic')==1)
        break;
        else
            continue;
        end
    end 
           childNode = uitreenode('v0','dummy', 'Gamma', [], 0);
[I] = imread('Icons/icon_conn.png');
        javaImage_eeg = im2java(I);
        childNode.setIcon(javaImage_eeg);
        treeModel.insertNodeInto(childNode,dynparentnode,dynparentnode.getChildCount()); 
        % expand to show added child
        tree.setSelectedNode( childNode );
        % insure additional nodes are added to parent
        tree.setSelectedNode( dynparentnode );

    
end
if(createdynamic.bb)
    conparentnode=node_in.getNextNode;

dynparentnode=conparentnode;
    count=0;
    while(1)
        dynparentnode=dynparentnode.getNextNode;
        
        if(strcmp(char(dynparentnode.getName),'Dynamic')==1)
        break;
        else
            continue;
        end
    end 
           childNode = uitreenode('v0','dummy', 'bb', [], 0);
[I] = imread('Icons/icon_conn.png');
        javaImage_eeg = im2java(I);
        childNode.setIcon(javaImage_eeg);
        treeModel.insertNodeInto(childNode,dynparentnode,dynparentnode.getChildCount()); 
        % expand to show added child
        tree.setSelectedNode( childNode );
        % insure additional nodes are added to parent
        tree.setSelectedNode( dynparentnode );

    
end
if(createdynamic.custom)
    conparentnode=node_in.getNextNode;

dynparentnode=conparentnode;
    count=0;
    while(1)
        dynparentnode=dynparentnode.getNextNode;
        
        if(strcmp(char(dynparentnode.getName),'Dynamic')==1)
        break;
        else
            continue;
        end
    end 
           childNode = uitreenode('v0','dummy', 'Custom', [], 0);
[I] = imread('Icons/icon_conn.png');
        javaImage_eeg = im2java(I);
        childNode.setIcon(javaImage_eeg);
        treeModel.insertNodeInto(childNode,dynparentnode,dynparentnode.getChildCount()); 
        % expand to show added child
        tree.setSelectedNode( childNode );
        % insure additional nodes are added to parent
        tree.setSelectedNode( dynparentnode );

    
end

end
 
end

    


   else
% %        multiple=1

for sig=1:size(data,2)
       f = waitbar(0,'Please wait...'); 
    data1=data{sig};
    if(mult_subj)
         srate1=srate(sig);

%          si=subjIndex(sig);

    else
        srate1=srate;

%         si=subjIndex;
    end
        if(static)
        dynamic=0;
% %         get all bands and do the computation for all bands
% delta
           if(get(handles.delta_check,'Value'))
               fmin=0.1; fmax=3;
               if(phase)
% %                    automatic window based on the formula of lachaux
                    f_interest=fmin+(fmax-fmin)/2;
                    window=6/(f_interest);  
               else
                   window=1;
               end
               step=window;
               if(meth==1)
                   
              connectivity.static.delta= plv_sliding_window(data1,srate1,window,step,fmin,fmax,dynamic); 
               else
                   if(meth==2)
                   connectivity.static.delta= pli_sliding_window(data1,srate1,window,step,fmin,fmax,dynamic); 

                   else
                       if(meth==3)
                                         connectivity.static.delta= aec_sliding_window(data1,srate1,window,step,fmin,fmax,dynamic); 

                       else
                           if(meth==4)
                                             connectivity.static.delta= wpli_ft(data1,srate1,window,step,fmin,fmax,dynamic); 

                           end
                       end
                   end
               end
           end
           
            if(get(handles.theta_check,'Value'))
               fmin=3; fmax=7;
               if(phase)
% %                    automatic window based on the formula of lachaux
                    f_interest=fmin+(fmax-fmin)/2;
                    window=6/(f_interest);  
               else
                   window=1;
               end
               step=window;
if(meth==1)
                   
              connectivity.static.theta= plv_sliding_window(data1,srate1,window,step,fmin,fmax,dynamic); 
               else
                   if(meth==2)
                   connectivity.static.theta= pli_sliding_window(data1,srate1,window,step,fmin,fmax,dynamic); 

                   else
                       if(meth==3)
                                         connectivity.static.theta= aec_sliding_window(data1,srate1,window,step,fmin,fmax,dynamic); 

                       else
                           if(meth==4)
                                             connectivity.static.theta= wpli_ft(data1,srate1,window,step,fmin,fmax,dynamic); 

                           end
                       end
                   end
end
            end
           
             if(get(handles.alpha_check,'Value'))
               fmin=7; fmax=13;
               if(phase)
% %                    automatic window based on the formula of lachaux
                    f_interest=fmin+(fmax-fmin)/2;
                    window=6/(f_interest);  
               else
                   window=1;
               end
               step=window;
if(meth==1)
                   
              connectivity.static.alpha= plv_sliding_window(data1,srate1,window,step,fmin,fmax,dynamic); 
               else
                   if(meth==2)
                   connectivity.static.alpha= pli_sliding_window(data1,srate1,window,step,fmin,fmax,dynamic); 

                   else
                       if(meth==3)
                                         connectivity.static.alpha= aec_sliding_window(data1,srate1,window,step,fmin,fmax,dynamic); 

                       else
                           if(meth==4)
                                             connectivity.static.alpha= wpli_ft(data1,srate1,window,step,fmin,fmax,dynamic); 

                           end
                       end
                   end
end
             end
           
              if(get(handles.beta_check,'Value'))
               fmin=13; fmax=25;
               if(phase)
% %                    automatic window based on the formula of lachaux
                    f_interest=fmin+(fmax-fmin)/2;
                    window=6/(f_interest);  
               else
                   window=1;
               end
               step=window;
if(meth==1)
                   
              connectivity.static.beta= plv_sliding_window(data1,srate1,window,step,fmin,fmax,dynamic); 
               else
                   if(meth==2)
                   connectivity.static.beta= pli_sliding_window(data1,srate1,window,step,fmin,fmax,dynamic); 

                   else
                       if(meth==3)
                                         connectivity.static.beta= aec_sliding_window(data1,srate1,window,step,fmin,fmax,dynamic); 

                       else
                           if(meth==4)
                                             connectivity.static.beta= wpli_ft(data1,srate1,window,step,fmin,fmax,dynamic); 

                           end
                       end
                   end
end
              end
           
               if(get(handles.gamma_check,'Value'))
               fmin=25; fmax=45;
               if(phase)
% %                    automatic window based on the formula of lachaux
                    f_interest=fmin+(fmax-fmin)/2;
                    window=6/(f_interest);  
               else
                   window=1;
               end
               step=window;
if(meth==1)
                   
              connectivity.static.gamma= plv_sliding_window(data1,srate1,window,step,fmin,fmax,dynamic); 
               else
                   if(meth==2)
                   connectivity.static.gamma= pli_sliding_window(data1,srate1,window,step,fmin,fmax,dynamic); 

                   else
                       if(meth==3)
                                         connectivity.static.gamma= aec_sliding_window(data1,srate1,window,step,fmin,fmax,dynamic); 

                       else
                           if(meth==4)
                                             connectivity.static.gamma= wpli_ft(data1,srate1,window,step,fmin,fmax,dynamic); 

                           end
                       end
                   end
end
               end
            if(get(handles.bb_check,'Value'))
               fmin=0.1; fmax=45;
               if(phase)
% %                    automatic window based on the formula of lachaux
                    f_interest=fmin+(fmax-fmin)/2;
                    window=6/(f_interest);  
               else
                   window=1;
               end
               step=window;
if(meth==1)
                   
              connectivity.static.broad= plv_sliding_window(data1,srate1,window,step,fmin,fmax,dynamic); 
               else
                   if(meth==2)
                   connectivity.static.broad= pli_sliding_window(data1,srate1,window,step,fmin,fmax,dynamic); 

                   else
                       if(meth==3)
                                         connectivity.static.broad= aec_sliding_window(data1,srate1,window,step,fmin,fmax,dynamic); 

                       else
                           if(meth==4)
                                             connectivity.static.broad= wpli_ft(data1,srate1,window,step,fmin,fmax,dynamic); 

                           end
                       end
                   end
end
            end
            
            if(get(handles.custom_check,'Value'))
              fminStr=get(handles.minfreq_edit,'String');
               fmin=str2double(fminStr);
               fmaxStr=get(handles.maxfreq_edit,'String');
               fmax=str2double(fmaxStr);
               if(phase)
% %                    automatic window based on the formula of lachaux
                    f_interest=fmin+(fmax-fmin)/2;
                    window=6/(f_interest);  
               else
                   window=1;
               end
               step=window;
if(meth==1)
                   
              connectivity.static.custom= plv_sliding_window(data1,srate1,window,step,fmin,fmax,dynamic); 
               else
                   if(meth==2)
                   connectivity.static.custom= pli_sliding_window(data1,srate1,window,step,fmin,fmax,dynamic); 

                   else
                       if(meth==3)
                                         connectivity.static.custom= aec_sliding_window(data1,srate1,window,step,fmin,fmax,dynamic); 

                       else
                           if(meth==4)
                                             connectivity.static.custom= wpli_ft(data1,srate1,window,step,fmin,fmax,dynamic); 

                           end
                       end
                   end
end
            end
    end
            dynamic=get(handles.dyn_check,'Value');
    if(dynamic)
% %         dynamic

      if(get(handles.delta_check,'Value'))
               fmin=0.1; fmax=3;
               if(phase)
% %                    automatic window based on the formula of lachaux
                    f_interest=fmin+(fmax-fmin)/2;
                    window=6/(f_interest);  
               else
                   window=1;
               end
               step=window*overlap/100;
if(meth==1)
                   
              connectivity.dynamic.delta= plv_sliding_window(data1,srate1,window,step,fmin,fmax,dynamic); 
               else
                   if(meth==2)
                   connectivity.dynamic.delta= pli_sliding_window(data1,srate1,window,step,fmin,fmax,dynamic); 

                   else
                       if(meth==3)
                                         connectivity.dynamic.delta= aec_sliding_window(data1,srate1,window,step,fmin,fmax,dynamic); 

                       else
                           if(meth==4)
                                             connectivity.dynamic.delta= wpli_ft(data1,srate1,window,step,fmin,fmax,dynamic); 

                           end
                       end
                   end
end
      end
           
            if(get(handles.theta_check,'Value'))
               fmin=3; fmax=7;
               if(phase)
% %                    automatic window based on the formula of lachaux
                    f_interest=fmin+(fmax-fmin)/2;
                    window=6/(f_interest);  
               else
                   window=1;
               end
               step=window*overlap/100;
if(meth==1)
                   
              connectivity.dynamic.theta= plv_sliding_window(data1,srate1,window,step,fmin,fmax,dynamic); 
               else
                   if(meth==2)
                   connectivity.dynamic.theta= pli_sliding_window(data1,srate1,window,step,fmin,fmax,dynamic); 

                   else
                       if(meth==3)
                                         connectivity.dynamic.theta= aec_sliding_window(data1,srate1,window,step,fmin,fmax,dynamic); 

                       else
                           if(meth==4)
                                             connectivity.dynamic.theta= wpli_ft(data1,srate1,window,step,fmin,fmax,dynamic); 

                           end
                       end
                   end
end
            end
           
             if(get(handles.alpha_check,'Value'))
               fmin=7; fmax=13;
               if(phase)
% %                    automatic window based on the formula of lachaux
                    f_interest=fmin+(fmax-fmin)/2;
                    window=6/(f_interest);  
               else
                   window=1;
               end
               step=window*overlap/100;
if(meth==1)
                   
              connectivity.dynamic.alpha= plv_sliding_window(data1,srate1,window,step,fmin,fmax,dynamic); 
               else
                   if(meth==2)
                   connectivity.dynamic.alpha= pli_sliding_window(data1,srate1,window,step,fmin,fmax,dynamic); 

                   else
                       if(meth==3)
                                         connectivity.dynamic.alpha= aec_sliding_window(data1,srate1,window,step,fmin,fmax,dynamic); 

                       else
                           if(meth==4)
                                             connectivity.dynamic.alpha= wpli_ft(data1,srate1,window,step,fmin,fmax,dynamic); 

                           end
                       end
                   end
end
             end
           
              if(get(handles.beta_check,'Value'))
               fmin=13; fmax=25;
               if(phase)
% %                    automatic window based on the formula of lachaux
                    f_interest=fmin+(fmax-fmin)/2;
                    window=6/(f_interest);  
               else
                   window=1;
               end
               step=window*overlap/100;
if(meth==1)
                   
              connectivity.dynamic.beta= plv_sliding_window(data1,srate1,window,step,fmin,fmax,dynamic); 
               else
                   if(meth==2)
                   connectivity.dynamic.beta= pli_sliding_window(data1,srate1,window,step,fmin,fmax,dynamic); 

                   else
                       if(meth==3)
                                         connectivity.dynamic.beta= aec_sliding_window(data1,srate1,window,step,fmin,fmax,dynamic); 

                       else
                           if(meth==4)
                                             connectivity.dynamic.beta= wpli_ft(data1,srate1,window,step,fmin,fmax,dynamic); 

                           end
                       end
                   end
end
              end
           
               if(get(handles.gamma_check,'Value'))
               fmin=25; fmax=45;
               if(phase)
% %                    automatic window based on the formula of lachaux
                    f_interest=fmin+(fmax-fmin)/2;
                    window=6/(f_interest);  
               else
                   window=1;
               end
               step=window*overlap/100;
if(meth==1)
                   
              connectivity.dynamic.gamma= plv_sliding_window(data1,srate1,window,step,fmin,fmax,dynamic); 
               else
                   if(meth==2)
                   connectivity.dynamic.gamma= pli_sliding_window(data1,srate1,window,step,fmin,fmax,dynamic); 

                   else
                       if(meth==3)
                                         connectivity.dynamic.gamma= aec_sliding_window(data1,srate1,window,step,fmin,fmax,dynamic); 

                       else
                           if(meth==4)
                                             connectivity.dynamic.gamma= wpli_ft(data1,srate1,window,step,fmin,fmax,dynamic); 

                           end
                       end
                   end
end
               end
            if(get(handles.bb_check,'Value'))
               fmin=0.1; fmax=45;
               if(phase)
% %                    automatic window based on the formula of lachaux
                    f_interest=fmin+(fmax-fmin)/2;
                    window=6/(f_interest);  
               else
                   window=1;
               end
               step=window*overlap/100;
if(meth==1)
                   
              connectivity.dynamic.broad= plv_sliding_window(data1,srate1,window,step,fmin,fmax,dynamic); 
               else
                   if(meth==2)
                   connectivity.dynamic.broad= pli_sliding_window(data1,srate1,window,step,fmin,fmax,dynamic); 

                   else
                       if(meth==3)
                                         connectivity.dynamic.broad= aec_sliding_window(data1,srate1,window,step,fmin,fmax,dynamic); 

                       else
                           if(meth==4)
                                             connectivity.dynamic.broad= wpli_ft(data1,srate1,window,step,fmin,fmax,dynamic); 

                           end
                       end
                   end
end
            end
            
            if(get(handles.custom_check,'Value'))
              fminStr=get(handles.minfreq_edit,'String');
               fmin=str2double(fminStr);
               fmaxStr=get(handles.maxfreq_edit,'String');
               fmax=str2double(fmaxStr);
               if(phase)
% %                    automatic window based on the formula of lachaux
                    f_interest=fmin+(fmax-fmin)/2;
                    window=6/(f_interest);  
               else
                   window=1;
               end
               step=window*overlap/100;
if(meth==1)
                   
              connectivity.dynamic.custom= plv_sliding_window(data1,srate1,window,step,fmin,fmax,dynamic); 
               else
                   if(meth==2)
                   connectivity.dynamic.custom= pli_sliding_window(data1,srate1,window,step,fmin,fmax,dynamic); 

                   else
                       if(meth==3)
                                         connectivity.dynamic.custom= aec_sliding_window(data1,srate1,window,step,fmin,fmax,dynamic); 

                       else
                           if(meth==4)
                                             connectivity.dynamic.custom= wpli_ft(data1,srate1,window,step,fmin,fmax,dynamic); 

                           end
                       end
                   end
end
            end
    end
        waitbar(1,f,'Done');
%         connectivity.static
%         connectivity.dynamic
        result=struct();
        result.conn=struct();
        try
        result.conn.static=connectivity.static;
        catch
        end
        try
            
        result.conn.dynamic=connectivity.dynamic;
        catch
        end
%         create node in the tree and assign the output to the global
%         variables
% 1- ensure if the correspondant node has already a connectivity node
% % node should be the subject node : from inputs in the case of eeg, and the segment node for segment;
empty=0; seg=0;
if(mult_subj==0)
    node=node_in;
    nodeName=char(node_in.getName);
    subjectname=nodeName;
    subjectname=subjectname(3:end);
% %          index of the subject to show its eeg in the figure
    subjIndex=find(strcmp(allsubjects.names, subjectname));
else
    subjectnode=node_in;
    si=subjj(sig);
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
        
        node=subjectnode;
       nodeName=char(node.getName);
    subjectname=nodeName;
    subjectname=subjectname(3:end);
% %          index of the subject to show its eeg in the figure
    subjIndex=find(strcmp(allsubjects.names, subjectname));

end
Indice=IndSegments(sig);
isPre=isPreprocessed(sig);

if(isPre)
   
    eeg_node=node.getFirstChild;
    parent=eeg_node;
    count=0;
    while(1)
        parent=parent.getNextNode;
        
        if(strcmp(char(parent.getName),['Reconstructed Preprocessed Epoch_' num2str(Indice)])==1)
        break;
        else
            continue;
        end
    end 
else
    eeg_node=node.getFirstChild;
    parent=eeg_node;
    while(1)
        parent.getNextNode;
        
        parent=parent.getNextNode;
        
        if(strcmp(char(parent.getName),['Reconstructed Epoch_' num2str(Indice)])==1)
        break;
        else
            continue;
        end
        
    end
            
end


create=0;
creastatic=0;
creadynamic=0;
createstatic.delta=0;
createstatic.theta=0;
createstatic.alpha=0;
createstatic.beta=0;
createstatic.gamma=0;
createstatic.custom=0;
createstatic.bb=0;

createdynamic.delta=0;
createdynamic.theta=0;
createdynamic.alpha=0;
createdynamic.beta=0;
createdynamic.gamma=0;
createdynamic.custom=0;
createdynamic.bb=0;

nodeName=char(parent.getName);
node=parent;
% create node in tree if it's not already present
if(strcmp(nodeName,'Reconstructed EEG'))
%      subjectParent=node_in.getParent;
%      subjectname=char(subjectParent.getName);
%      subjectname=subjectname(3:end);
% %          index of the subject to show its eeg in the figure
%      subjIndex=find(strcmp(allsubjects.names, subjectname));

     try
            alleegs_src_conn{subjIndex}.conn;
% %             dont create a node connectivity
            create=0;      
% %             see if static or dynamic
    try 
            alleegs_src_conn{subjIndex}.conn.static;
%             dont create a node static
                try
                    connectivity.static;
                    try
                         connectivity.static.delta;
                         try 
                              alleegs_src_conn{subjIndex}.conn.static.delta;
                         catch
                             createstatic.delta=1;
                         end
                         
                          alleegs_src_conn{subjIndex}.conn.static.delta=connectivity.static.delta;
                          

                    catch
                        
                    end
                    
                                        try
                         connectivity.static.theta;
                         try 
                              alleegs_src_conn{subjIndex}.conn.static.theta;
                         catch
                             createstatic.theta=1;
                         end
                         
                          alleegs_src_conn{subjIndex}.conn.static.theta=connectivity.static.theta;
                          

                    catch
                        
                                        end
                    
                                                            try
                         connectivity.static.alpha;
                         try 
                              alleegs_src_conn{subjIndex}.conn.static.alpha;
                         catch
                             createstatic.alpha=1;
                         end
                         
                          alleegs_src_conn{subjIndex}.conn.static.alpha=connectivity.static.alpha;
                          

                    catch
                        
                                                            end
                    
                                                                                try
                         connectivity.static.beta;
                         try 
                              alleegs_src_conn{subjIndex}.conn.static.beta;
                         catch
                             createstatic.beta=1;
                         end
                         
                          alleegs_src_conn{subjIndex}.conn.static.beta=connectivity.static.beta;
                          

                    catch
                        
                                                                                end
                                        try
                         connectivity.static.gamma;
                         try 
                              alleegs_src_conn{subjIndex}.conn.static.gamma;
                         catch
                             createstatic.gamma=1;
                         end
                         
                          alleegs_src_conn{subjIndex}.conn.static.gamma=connectivity.static.gamma;
                          

                    catch
                        
                                        end
                                        try
                         connectivity.static.bb;
                         try 
                              alleegs_src_conn{subjIndex}.conn.static.bb;
                         catch
                             createstatic.bb=1;
                         end
                         
                          alleegs_src_conn{subjIndex}.conn.static.bb=connectivity.static.bb;
                          

                    catch
                        
                                        end
                                        
                                        try
                         connectivity.static.custom;
                         try 
                              alleegs_src_conn{subjIndex}.conn.static.custom;
                         catch
                             createstatic.custom=1;
                         end
                         
                          alleegs_src_conn{subjIndex}.conn.static.custom=connectivity.static.custom;
                          

                    catch
                        
                                        end
                    
                catch
                    
                end
    catch
        try
            connectivity.static;
            creastatic=1;
            alleegs_src_conn{subjIndex}.conn.static=connectivity.static;
              
            try
                               alleegs_src_conn{subjIndex}.conn.static.delta;
                                                createstatic.delta=1;

                        catch
                                           createstatic.delta=0;

                                           
                        
            end
                        
                        try
                               alleegs_src_conn{subjIndex}.conn.static.theta;
                                                createstatic.theta=1;

                        catch
                                           createstatic.theta=0;
                        end
                        
                        try
                               alleegs_src_conn{subjIndex}.conn.static.alpha;
                                                createstatic.alpha=1;
                        catch
                                           createstatic.alpha=0;

                        end
                        
                        try
                               alleegs_src_conn{subjIndex}.conn.static.beta;
                                                createstatic.beta=1;
                        catch
                                           createstatic.beta=0;
                        end
                        
                        try
                               alleegs_src_conn{subjIndex}.conn.static.gamma;
                                                createstatic.gamma=1;

                        catch
                                           createstatic.gamma=0;
                        end
                        
                        try
                               alleegs_src_conn{subjIndex}.conn.static.custom;
                                                createstatic.custom=1;
                        catch
                                           createstatic.custom=0;
                        end
                        
                        try
                               alleegs_src_conn{subjIndex}.conn.static.bb;
                                                createstatic.bb=1;

                        catch
                                           createstatic.bb=0;
                        end
        catch
            creastatic=0;
        
       end
        
    end
    
        try 
            alleegs_src_conn{subjIndex}.conn.dynamic;
%             dont create a node dynamic
                try
                    connectivity.dynamic;
                    try
                         connectivity.dynamic.delta;
                         try 
                              alleegs_src_conn{subjIndex}.conn.dynamic.delta;
                         catch
                             createdynamic.delta=1;
                         end
                         
                          alleegs_src_conn{subjIndex}.conn.dynamic.delta=connectivity.dynamic.delta;
                          

                    catch
                        
                    end
                    
                                        try
                         connectivity.dynamic.theta;
                         try 
                              alleegs_src_conn{subjIndex}.conn.dynamic.theta;
                         catch
                             createdynamic.theta=1;
                         end
                         
                          alleegs_src_conn{subjIndex}.conn.dynamic.theta=connectivity.dynamic.theta;
                          

                    catch
                        
                                        end
                    
                                                            try
                         connectivity.dynamic.alpha;
                         try 
                              alleegs_src_conn{subjIndex}.conn.dynamic.alpha;
                         catch
                             createdynamic.alpha=1;
                         end
                         
                          alleegs_src_conn{subjIndex}.conn.dynamic.alpha=connectivity.dynamic.alpha;
                          

                    catch
                        
                                                            end
                    
                                                                                try
                         connectivity.dynamic.beta;
                         try 
                              alleegs_src_conn{subjIndex}.conn.dynamic.beta;
                         catch
                             createdynamic.beta=1;
                         end
                         
                          alleegs_src_conn{subjIndex}.conn.dynamic.beta=connectivity.dynamic.beta;
                          

                    catch
                        
                                                                                end
                                        try
                         connectivity.dynamic.gamma;
                         try 
                              alleegs_src_conn{subjIndex}.conn.dynamic.gamma;
                         catch
                             createdynamic.gamma=1;
                         end
                         
                          alleegs_src_conn{subjIndex}.conn.dynamic.gamma=connectivity.dynamic.gamma;
                          

                    catch
                        
                                        end
                                        try
                         connectivity.dynamic.bb;
                         try 
                              alleegs_src_conn{subjIndex}.conn.dynamic.bb;
                         catch
                             createdynamic.bb=1;
                         end
                         
                          alleegs_src_conn{subjIndex}.conn.dynamic.bb=connectivity.dynamic.bb;
                          

                    catch
                        
                                        end
                                        
                                        try
                         connectivity.dynamic.custom;
                         try 
                              alleegs_src_conn{subjIndex}.conn.dynamic.custom;
                         catch
                             createdynamic.custom=1;
                         end
                         
                          alleegs_src_conn{subjIndex}.conn.dynamic.custom=connectivity.dynamic.custom;
                          

                    catch
                        
                                        end
                    
                catch
                    
                end
    catch
        try
            connectivity.dynamic;
            creadynamic=1;
            alleegs_src_conn{subjIndex}.conn.dynamic=connectivity.dynamic;
              
            try
                               alleegs_src_conn{subjIndex}.conn.dynamic.delta;
                                                createdynamic.delta=1;

                        catch
                                           createdynamic.delta=0;

                                           
                        
            end
                        
                        try
                               alleegs_src_conn{subjIndex}.conn.dynamic.theta;
                                                createdynamic.theta=1;

                        catch
                                           createdynamic.theta=0;
                        end
                        
                        try
                               alleegs_src_conn{subjIndex}.conn.dynamic.alpha;
                                                createdynamic.alpha=1;
                        catch
                                           createdynamic.alpha=0;

                        end
                        
                        try
                               alleegs_src_conn{subjIndex}.conn.dynamic.beta;
                                                createdynamic.beta=1;
                        catch
                                           createdynamic.beta=0;
                        end
                        
                        try
                               alleegs_src_conn{subjIndex}.conn.dynamic.gamma;
                                                createdynamic.gamma=1;

                        catch
                                           createdynamic.gamma=0;
                        end
                        
                        try
                               alleegs_src_conn{subjIndex}.conn.dynamic.custom;
                                                createdynamic.custom=1;
                        catch
                                           createdynamic.custom=0;
                        end
                        
                        try
                               alleegs_src_conn{subjIndex}.conn.dynamic.bb;
                                                createdynamic.bb=1;

                        catch
                                           createdynamic.bb=0;
                        end
        catch
            creadynamic=0;
        
       end
        
        end
    
catch
% %             no connectivity node that already exist for this subject
            create=1;
            alleegs_src_conn{subjIndex}.conn=connectivity;
            try
                alleegs_src_conn{subjIndex}.conn.static;
                 creastatic=1;
                        try
                               alleegs_src_conn{subjIndex}.conn.static.delta;
                                                createstatic.delta=1;

                        catch
                                           createstatic.delta=0;

                        end
                        
                        try
                               alleegs_src_conn{subjIndex}.conn.static.theta;
                                                createstatic.theta=1;

                        catch
                                           createstatic.theta=0;
                        end
                        
                        try
                               alleegs_src_conn{subjIndex}.conn.static.alpha;
                                                createstatic.alpha=1;
                        catch
                                           createstatic.alpha=0;

                        end
                        
                        try
                               alleegs_src_conn{subjIndex}.conn.static.beta;
                                                createstatic.beta=1;
                        catch
                                           createstatic.beta=0;
                        end
                        
                        try
                               alleegs_src_conn{subjIndex}.conn.static.gamma;
                                                createstatic.gamma=1;

                        catch
                                           createstatic.gamma=0;
                        end
                        
                        try
                               alleegs_src_conn{subjIndex}.conn.static.custom;
                                                createstatic.custom=1;
                        catch
                                           createstatic.custom=0;
                        end
                        
                        try
                               alleegs_src_conn{subjIndex}.conn.static.bb;
                                                createstatic.bb=1;

                        catch
                                           createstatic.bb=0;
                        end
                                               
                        
            catch
                                 creastatic=0;

            end
            
            
            
            try
                alleegs_src_conn{subjIndex}.conn.dynamic;
                 creadynamic=1;
                        try
                               alleegs_src_conn{subjIndex}.conn.dynamic.delta;
                                                createdynamic.delta=1;

                        catch
                                           createdynamic.delta=0;

                        end
                        
                        try
                               alleegs_src_conn{subjIndex}.conn.dynamic.theta;
                                                createdynamic.theta=1;

                        catch
                                           createdynamic.theta=0;
                        end
                        
                        try
                               alleegs_src_conn{subjIndex}.conn.dynamic.alpha;
                                                createdynamic.alpha=1;
                        catch
                                           createdynamic.alpha=0;

                        end
                        
                        try
                               alleegs_src_conn{subjIndex}.conn.dynamic.beta;
                                                createdynamic.beta=1;
                        catch
                                           createdynamic.beta=0;
                        end
                        
                        try
                               alleegs_src_conn{subjIndex}.conn.dynamic.gamma;
                                                createdynamic.gamma=1;

                        catch
                                           createdynamic.gamma=0;
                        end
                        
                        try
                               alleegs_src_conn{subjIndex}.conn.dynamic.custom;
                                                createdynamic.custom=1;
                        catch
                                           createdynamic.custom=0;
                        end
                        
                        try
                               alleegs_src_conn{subjIndex}.conn.dynamic.bb;
                                                createdynamic.bb=1;

                        catch
                                           createdynamic.bb=0;
                        end
                                               
                        
            catch
                                 creadynamic=0;

            end

end

    else
       if(strcmp(nodeName(1:19),'Reconstructed Epoch'))
%          subjectParent=node.getParent;
%          subjectParent=subjectParent.getParent;
%          subjectParent=subjectParent.getParent;
%          subjectname=char(subjectParent.getName);
%          subjectname=subjectname(3:end);
%         % %          index of the subject to show its eeg in the figure
%          subjIndex=find(strcmp(allsubjects.names, subjectname));
        %              pathfile= allsubjects.paths{subjIndex};
         number=str2num(nodeName(21:end));

            

try
            allepochs_src_conn{subjIndex,number}.conn;
% %             dont create a node connectivity
            create=0;      
% %             see if static or dynamic
    try 
            allepochs_src_conn{subjIndex,number}.conn.static;
%             dont create a node static
                try
                    connectivity.static;
                    try
                         connectivity.static.delta;
                         try 
                              allepochs_src_conn{subjIndex,number}.conn.static.delta;
                         catch
                             createstatic.delta=1;
                         end
                         
                          allepochs_src_conn{subjIndex,number}.conn.static.delta=connectivity.static.delta;
                          

                    catch
                        
                    end
                    
                                        try
                         connectivity.static.theta;
                         try 
                              allepochs_src_conn{subjIndex,number}.conn.static.theta;
                         catch
                             createstatic.theta=1;
                         end
                         
                          allepochs_src_conn{subjIndex,number}.conn.static.theta=connectivity.static.theta;
                          

                    catch
                        
                                        end
                    
                                                            try
                         connectivity.static.alpha;
                         try 
                              allepochs_src_conn{subjIndex,number}.conn.static.alpha;
                         catch
                             createstatic.alpha=1;
                         end
                         
                          allepochs_src_conn{subjIndex,number}.conn.static.alpha=connectivity.static.alpha;
                          

                    catch
                        
                                                            end
                    
                                                                                try
                         connectivity.static.beta;
                         try 
                              allepochs_src_conn{subjIndex,number}.conn.static.beta;
                         catch
                             createstatic.beta=1;
                         end
                         
                          allepochs_src_conn{subjIndex,number}.conn.static.beta=connectivity.static.beta;
                          

                    catch
                        
                                                                                end
                                        try
                         connectivity.static.gamma;
                         try 
                              allepochs_src_conn{subjIndex,number}.conn.static.gamma;
                         catch
                             createstatic.gamma=1;
                         end
                         
                          allepochs_src_conn{subjIndex,number}.conn.static.gamma=connectivity.static.gamma;
                          

                    catch
                        
                                        end
                                        try
                         connectivity.static.bb;
                         try 
                              allepochs_src_conn{subjIndex,number}.conn.static.bb;
                         catch
                             createstatic.bb=1;
                         end
                         
                          allepochs_src_conn{subjIndex,number}.conn.static.bb=connectivity.static.bb;
                          

                    catch
                        
                                        end
                                        
                                        try
                         connectivity.static.custom;
                         try 
                              allepochs_src_conn{subjIndex,number}.conn.static.custom;
                         catch
                             createstatic.custom=1;
                         end
                         
                          allepochs_src_conn{subjIndex,number}.conn.static.custom=connectivity.static.custom;
                          

                    catch
                        
                                        end
                    
                catch
                    
                end
    catch
        try
            connectivity.static;
            creastatic=1;
            allepochs_src_conn{subjIndex,number}.conn.static=connectivity.static;
              
            try
                               allepochs_src_conn{subjIndex,number}.conn.static.delta;
                                                createstatic.delta=1;

                        catch
                                           createstatic.delta=0;

                                           
                        
            end
                        
                        try
                               allepochs_src_conn{subjIndex,number}.conn.static.theta;
                                                createstatic.theta=1;

                        catch
                                           createstatic.theta=0;
                        end
                        
                        try
                               allepochs_src_conn{subjIndex,number}.conn.static.alpha;
                                                createstatic.alpha=1;
                        catch
                                           createstatic.alpha=0;

                        end
                        
                        try
                               allepochs_src_conn{subjIndex,number}.conn.static.beta;
                                                createstatic.beta=1;
                        catch
                                           createstatic.beta=0;
                        end
                        
                        try
                               allepochs_src_conn{subjIndex,number}.conn.static.gamma;
                                                createstatic.gamma=1;

                        catch
                                           createstatic.gamma=0;
                        end
                        
                        try
                               allepochs_src_conn{subjIndex,number}.conn.static.custom;
                                                createstatic.custom=1;
                        catch
                                           createstatic.custom=0;
                        end
                        
                        try
                               allepochs_src_conn{subjIndex,number}.conn.static.bb;
                                                createstatic.bb=1;

                        catch
                                           createstatic.bb=0;
                        end
        catch
            creastatic=0;
        
       end
        
    end
    
        try 
            allepochs_src_conn{subjIndex,number}.conn.dynamic;
%             dont create a node dynamic
                try
                    connectivity.dynamic;
                    try
                         connectivity.dynamic.delta;
                         try 
                              allepochs_src_conn{subjIndex,number}.conn.dynamic.delta;
                         catch
                             createdynamic.delta=1;
                         end
                         
                          allepochs_src_conn{subjIndex,number}.conn.dynamic.delta=connectivity.dynamic.delta;
                          

                    catch
                        
                    end
                    
                                        try
                         connectivity.dynamic.theta;
                         try 
                              allepochs_src_conn{subjIndex,number}.conn.dynamic.theta;
                         catch
                             createdynamic.theta=1;
                         end
                         
                          allepochs_src_conn{subjIndex,number}.conn.dynamic.theta=connectivity.dynamic.theta;
                          

                    catch
                        
                                        end
                    
                                                            try
                         connectivity.dynamic.alpha;
                         try 
                              allepochs_src_conn{subjIndex,number}.conn.dynamic.alpha;
                         catch
                             createdynamic.alpha=1;
                         end
                         
                          allepochs_src_conn{subjIndex,number}.conn.dynamic.alpha=connectivity.dynamic.alpha;
                          

                    catch
                        
                                                            end
                    
                                                                                try
                         connectivity.dynamic.beta;
                         try 
                              allepochs_src_conn{subjIndex,number}.conn.dynamic.beta;
                         catch
                             createdynamic.beta=1;
                         end
                         
                          allepochs_src_conn{subjIndex,number}.conn.dynamic.beta=connectivity.dynamic.beta;
                          

                    catch
                        
                                                                                end
                                        try
                         connectivity.dynamic.gamma;
                         try 
                              allepochs_src_conn{subjIndex,number}.conn.dynamic.gamma;
                         catch
                             createdynamic.gamma=1;
                         end
                         
                          allepochs_src_conn{subjIndex,number}.conn.dynamic.gamma=connectivity.dynamic.gamma;
                          

                    catch
                        
                                        end
                                        try
                         connectivity.dynamic.bb;
                         try 
                              allepochs_src_conn{subjIndex,number}.conn.dynamic.bb;
                         catch
                             createdynamic.bb=1;
                         end
                         
                          allepochs_src_conn{subjIndex,number}.conn.dynamic.bb=connectivity.dynamic.bb;
                          

                    catch
                        
                                        end
                                        
                                        try
                         connectivity.dynamic.custom;
                         try 
                              allepochs_src_conn{subjIndex,number}.conn.dynamic.custom;
                         catch
                             createdynamic.custom=1;
                         end
                         
                          allepochs_src_conn{subjIndex,number}.conn.dynamic.custom=connectivity.dynamic.custom;
                          

                    catch
                        
                                        end
                    
                catch
                    
                end
    catch
        try
            connectivity.dynamic;
            creadynamic=1;
            allepochs_src_conn{subjIndex,number}.conn.dynamic=connectivity.dynamic;
              
            try
                               allepochs_src_conn{subjIndex,number}.conn.dynamic.delta;
                                                createdynamic.delta=1;

                        catch
                                           createdynamic.delta=0;

                                           
                        
            end
                        
                        try
                               allepochs_src_conn{subjIndex,number}.conn.dynamic.theta;
                                                createdynamic.theta=1;

                        catch
                                           createdynamic.theta=0;
                        end
                        
                        try
                               allepochs_src_conn{subjIndex,number}.conn.dynamic.alpha;
                                                createdynamic.alpha=1;
                        catch
                                           createdynamic.alpha=0;

                        end
                        
                        try
                               allepochs_src_conn{subjIndex,number}.conn.dynamic.beta;
                                                createdynamic.beta=1;
                        catch
                                           createdynamic.beta=0;
                        end
                        
                        try
                               allepochs_src_conn{subjIndex,number}.conn.dynamic.gamma;
                                                createdynamic.gamma=1;

                        catch
                                           createdynamic.gamma=0;
                        end
                        
                        try
                               allepochs_src_conn{subjIndex,number}.conn.dynamic.custom;
                                                createdynamic.custom=1;
                        catch
                                           createdynamic.custom=0;
                        end
                        
                        try
                               allepochs_src_conn{subjIndex,number}.conn.dynamic.bb;
                                                createdynamic.bb=1;

                        catch
                                           createdynamic.bb=0;
                        end
        catch
            creadynamic=0;
        
       end
        
        end
    
catch
% %             no connectivity node that already exist for this subject
            create=1;
            allepochs_src_conn{subjIndex,number}.conn=connectivity;
            try
                allepochs_src_conn{subjIndex,number}.conn.static;
                 creastatic=1;
                        try
                               allepochs_src_conn{subjIndex,number}.conn.static.delta;
                                                createstatic.delta=1;

                        catch
                                           createstatic.delta=0;

                        end
                        
                        try
                               allepochs_src_conn{subjIndex,number}.conn.static.theta;
                                                createstatic.theta=1;

                        catch
                                           createstatic.theta=0;
                        end
                        
                        try
                               allepochs_src_conn{subjIndex,number}.conn.static.alpha;
                                                createstatic.alpha=1;
                        catch
                                           createstatic.alpha=0;

                        end
                        
                        try
                               allepochs_src_conn{subjIndex,number}.conn.static.beta;
                                                createstatic.beta=1;
                        catch
                                           createstatic.beta=0;
                        end
                        
                        try
                               allepochs_src_conn{subjIndex,number}.conn.static.gamma;
                                                createstatic.gamma=1;

                        catch
                                           createstatic.gamma=0;
                        end
                        
                        try
                               allepochs_src_conn{subjIndex,number}.conn.static.custom;
                                                createstatic.custom=1;
                        catch
                                           createstatic.custom=0;
                        end
                        
                        try
                               allepochs_src_conn{subjIndex,number}.conn.static.bb;
                                                createstatic.bb=1;

                        catch
                                           createstatic.bb=0;
                        end
                                               
                        
            catch
                                 creastatic=0;

            end
            
            
            
            try
                allepochs_src_conn{subjIndex,number}.conn.dynamic;
                 creadynamic=1;
                        try
                               allepochs_src_conn{subjIndex,number}.conn.dynamic.delta;
                                                createdynamic.delta=1;

                        catch
                                           createdynamic.delta=0;

                        end
                        
                        try
                               allepochs_src_conn{subjIndex,number}.conn.dynamic.theta;
                                                createdynamic.theta=1;

                        catch
                                           createdynamic.theta=0;
                        end
                        
                        try
                               allepochs_src_conn{subjIndex,number}.conn.dynamic.alpha;
                                                createdynamic.alpha=1;
                        catch
                                           createdynamic.alpha=0;

                        end
                        
                        try
                               allepochs_src_conn{subjIndex,number}.conn.dynamic.beta;
                                                createdynamic.beta=1;
                        catch
                                           createdynamic.beta=0;
                        end
                        
                        try
                               allepochs_src_conn{subjIndex,number}.conn.dynamic.gamma;
                                                createdynamic.gamma=1;

                        catch
                                           createdynamic.gamma=0;
                        end
                        
                        try
                               allepochs_src_conn{subjIndex,number}.conn.dynamic.custom;
                                                createdynamic.custom=1;
                        catch
                                           createdynamic.custom=0;
                        end
                        
                        try
                               allepochs_src_conn{subjIndex,number}.conn.dynamic.bb;
                                                createdynamic.bb=1;

                        catch
                                           createdynamic.bb=0;
                        end
                                               
                        
            catch
                                 creadynamic=0;

            end

end

else
     if(strcmp(nodeName,'Reconstructed Preprocessed EEG'))
%              subjectParent=node.getParent;
%              subjectParent=subjectParent.getParent;       
%              subjectname=char(subjectParent.getName);
%              subjectname=subjectname(3:end);
% % %          index of the subject to show its eeg in the figure
%              subjIndex=find(strcmp(allsubjects.names, subjectname));
% %              pathfile= allsubjects.paths{subjIndex};
             
            
    

try
            alleegs_preprocessed_src_conn{subjIndex}.conn;
% %             dont create a node connectivity
            create=0;      
% %             see if static or dynamic
    try 
            alleegs_preprocessed_src_conn{subjIndex}.conn.static;
%             dont create a node static
                try
                    connectivity.static;
                    try
                         connectivity.static.delta;
                         try 
                              alleegs_preprocessed_src_conn{subjIndex}.conn.static.delta;
                         catch
                             createstatic.delta=1;
                         end
                         
                          alleegs_preprocessed_src_conn{subjIndex}.conn.static.delta=connectivity.static.delta;
                          

                    catch
                        
                    end
                    
                                        try
                         connectivity.static.theta;
                         try 
                              alleegs_preprocessed_src_conn{subjIndex}.conn.static.theta;
                         catch
                             createstatic.theta=1;
                         end
                         
                          alleegs_preprocessed_src_conn{subjIndex}.conn.static.theta=connectivity.static.theta;
                          

                    catch
                        
                                        end
                    
                                                            try
                         connectivity.static.alpha;
                         try 
                              alleegs_preprocessed_src_conn{subjIndex}.conn.static.alpha;
                         catch
                             createstatic.alpha=1;
                         end
                         
                          alleegs_preprocessed_src_conn{subjIndex}.conn.static.alpha=connectivity.static.alpha;
                          

                    catch
                        
                                                            end
                    
                                                                                try
                         connectivity.static.beta;
                         try 
                              alleegs_preprocessed_src_conn{subjIndex}.conn.static.beta;
                         catch
                             createstatic.beta=1;
                         end
                         
                          alleegs_preprocessed_src_conn{subjIndex}.conn.static.beta=connectivity.static.beta;
                          

                    catch
                        
                                                                                end
                                        try
                         connectivity.static.gamma;
                         try 
                              alleegs_preprocessed_src_conn{subjIndex}.conn.static.gamma;
                         catch
                             createstatic.gamma=1;
                         end
                         
                          alleegs_preprocessed_src_conn{subjIndex}.conn.static.gamma=connectivity.static.gamma;
                          

                    catch
                        
                                        end
                                        try
                         connectivity.static.bb;
                         try 
                              alleegs_preprocessed_src_conn{subjIndex}.conn.static.bb;
                         catch
                             createstatic.bb=1;
                         end
                         
                          alleegs_preprocessed_src_conn{subjIndex}.conn.static.bb=connectivity.static.bb;
                          

                    catch
                        
                                        end
                                        
                                        try
                         connectivity.static.custom;
                         try 
                              alleegs_preprocessed_src_conn{subjIndex}.conn.static.custom;
                         catch
                             createstatic.custom=1;
                         end
                         
                          alleegs_preprocessed_src_conn{subjIndex}.conn.static.custom=connectivity.static.custom;
                          

                    catch
                        
                                        end
                    
                catch
                    
                end
    catch
        try
            connectivity.static;
            creastatic=1;
            alleegs_preprocessed_src_conn{subjIndex}.conn.static=connectivity.static;
              
            try
                               alleegs_preprocessed_src_conn{subjIndex}.conn.static.delta;
                                                createstatic.delta=1;

                        catch
                                           createstatic.delta=0;

                                           
                        
            end
                        
                        try
                               alleegs_preprocessed_src_conn{subjIndex}.conn.static.theta;
                                                createstatic.theta=1;

                        catch
                                           createstatic.theta=0;
                        end
                        
                        try
                               alleegs_preprocessed_src_conn{subjIndex}.conn.static.alpha;
                                                createstatic.alpha=1;
                        catch
                                           createstatic.alpha=0;

                        end
                        
                        try
                               alleegs_preprocessed_src_conn{subjIndex}.conn.static.beta;
                                                createstatic.beta=1;
                        catch
                                           createstatic.beta=0;
                        end
                        
                        try
                               alleegs_preprocessed_src_conn{subjIndex}.conn.static.gamma;
                                                createstatic.gamma=1;

                        catch
                                           createstatic.gamma=0;
                        end
                        
                        try
                               alleegs_preprocessed_src_conn{subjIndex}.conn.static.custom;
                                                createstatic.custom=1;
                        catch
                                           createstatic.custom=0;
                        end
                        
                        try
                               alleegs_preprocessed_src_conn{subjIndex}.conn.static.bb;
                                                createstatic.bb=1;

                        catch
                                           createstatic.bb=0;
                        end
        catch
            creastatic=0;
        
       end
        
    end
    
        try 
            alleegs_preprocessed_src_conn{subjIndex}.conn.dynamic;
%             dont create a node dynamic
                try
                    connectivity.dynamic;
                    try
                         connectivity.dynamic.delta;
                         try 
                              alleegs_preprocessed_src_conn{subjIndex}.conn.dynamic.delta;
                         catch
                             createdynamic.delta=1;
                         end
                         
                          alleegs_preprocessed_src_conn{subjIndex}.conn.dynamic.delta=connectivity.dynamic.delta;
                          

                    catch
                        
                    end
                    
                                        try
                         connectivity.dynamic.theta;
                         try 
                              alleegs_preprocessed_src_conn{subjIndex}.conn.dynamic.theta;
                         catch
                             createdynamic.theta=1;
                         end
                         
                          alleegs_preprocessed_src_conn{subjIndex}.conn.dynamic.theta=connectivity.dynamic.theta;
                          

                    catch
                        
                                        end
                    
                                                            try
                         connectivity.dynamic.alpha;
                         try 
                              alleegs_preprocessed_src_conn{subjIndex}.conn.dynamic.alpha;
                         catch
                             createdynamic.alpha=1;
                         end
                         
                          alleegs_preprocessed_src_conn{subjIndex}.conn.dynamic.alpha=connectivity.dynamic.alpha;
                          

                    catch
                        
                                                            end
                    
                                                                                try
                         connectivity.dynamic.beta;
                         try 
                              alleegs_preprocessed_src_conn{subjIndex}.conn.dynamic.beta;
                         catch
                             createdynamic.beta=1;
                         end
                         
                          alleegs_preprocessed_src_conn{subjIndex}.conn.dynamic.beta=connectivity.dynamic.beta;
                          

                    catch
                        
                                                                                end
                                        try
                         connectivity.dynamic.gamma;
                         try 
                              alleegs_preprocessed_src_conn{subjIndex}.conn.dynamic.gamma;
                         catch
                             createdynamic.gamma=1;
                         end
                         
                          alleegs_preprocessed_src_conn{subjIndex}.conn.dynamic.gamma=connectivity.dynamic.gamma;
                          

                    catch
                        
                                        end
                                        try
                         connectivity.dynamic.bb;
                         try 
                              alleegs_preprocessed_src_conn{subjIndex}.conn.dynamic.bb;
                         catch
                             createdynamic.bb=1;
                         end
                         
                          alleegs_preprocessed_src_conn{subjIndex}.conn.dynamic.bb=connectivity.dynamic.bb;
                          

                    catch
                        
                                        end
                                        
                                        try
                         connectivity.dynamic.custom;
                         try 
                              alleegs_preprocessed_src_conn{subjIndex}.conn.dynamic.custom;
                         catch
                             createdynamic.custom=1;
                         end
                         
                          alleegs_preprocessed_src_conn{subjIndex}.conn.dynamic.custom=connectivity.dynamic.custom;
                          

                    catch
                        
                                        end
                    
                catch
                    
                end
    catch
        try
            connectivity.dynamic;
            creadynamic=1;
            alleegs_preprocessed_src_conn{subjIndex}.conn.dynamic=connectivity.dynamic;
              
            try
                               alleegs_preprocessed_src_conn{subjIndex}.conn.dynamic.delta;
                                                createdynamic.delta=1;

                        catch
                                           createdynamic.delta=0;

                                           
                        
            end
                        
                        try
                               alleegs_preprocessed_src_conn{subjIndex}.conn.dynamic.theta;
                                                createdynamic.theta=1;

                        catch
                                           createdynamic.theta=0;
                        end
                        
                        try
                               alleegs_preprocessed_src_conn{subjIndex}.conn.dynamic.alpha;
                                                createdynamic.alpha=1;
                        catch
                                           createdynamic.alpha=0;

                        end
                        
                        try
                               alleegs_preprocessed_src_conn{subjIndex}.conn.dynamic.beta;
                                                createdynamic.beta=1;
                        catch
                                           createdynamic.beta=0;
                        end
                        
                        try
                               alleegs_preprocessed_src_conn{subjIndex}.conn.dynamic.gamma;
                                                createdynamic.gamma=1;

                        catch
                                           createdynamic.gamma=0;
                        end
                        
                        try
                               alleegs_preprocessed_src_conn{subjIndex}.conn.dynamic.custom;
                                                createdynamic.custom=1;
                        catch
                                           createdynamic.custom=0;
                        end
                        
                        try
                               alleegs_preprocessed_src_conn{subjIndex}.conn.dynamic.bb;
                                                createdynamic.bb=1;

                        catch
                                           createdynamic.bb=0;
                        end
        catch
            creadynamic=0;
        
       end
        
        end
    
catch
% %             no connectivity node that already exist for this subject
            create=1;
            alleegs_preprocessed_src_conn{subjIndex}.conn=connectivity;
            try
                alleegs_preprocessed_src_conn{subjIndex}.conn.static;
                 creastatic=1;
                        try
                               alleegs_preprocessed_src_conn{subjIndex}.conn.static.delta;
                                                createstatic.delta=1;

                        catch
                                           createstatic.delta=0;

                        end
                        
                        try
                               alleegs_preprocessed_src_conn{subjIndex}.conn.static.theta;
                                                createstatic.theta=1;

                        catch
                                           createstatic.theta=0;
                        end
                        
                        try
                               alleegs_preprocessed_src_conn{subjIndex}.conn.static.alpha;
                                                createstatic.alpha=1;
                        catch
                                           createstatic.alpha=0;

                        end
                        
                        try
                               alleegs_preprocessed_src_conn{subjIndex}.conn.static.beta;
                                                createstatic.beta=1;
                        catch
                                           createstatic.beta=0;
                        end
                        
                        try
                               alleegs_preprocessed_src_conn{subjIndex}.conn.static.gamma;
                                                createstatic.gamma=1;

                        catch
                                           createstatic.gamma=0;
                        end
                        
                        try
                               alleegs_preprocessed_src_conn{subjIndex}.conn.static.custom;
                                                createstatic.custom=1;
                        catch
                                           createstatic.custom=0;
                        end
                        
                        try
                               alleegs_preprocessed_src_conn{subjIndex}.conn.static.bb;
                                                createstatic.bb=1;

                        catch
                                           createstatic.bb=0;
                        end
                                               
                        
            catch
                                 creastatic=0;

            end
            
            
            
            try
                alleegs_preprocessed_src_conn{subjIndex}.conn.dynamic;
                 creadynamic=1;
                        try
                               alleegs_preprocessed_src_conn{subjIndex}.conn.dynamic.delta;
                                                createdynamic.delta=1;

                        catch
                                           createdynamic.delta=0;

                        end
                        
                        try
                               alleegs_preprocessed_src_conn{subjIndex}.conn.dynamic.theta;
                                                createdynamic.theta=1;

                        catch
                                           createdynamic.theta=0;
                        end
                        
                        try
                               alleegs_preprocessed_src_conn{subjIndex}.conn.dynamic.alpha;
                                                createdynamic.alpha=1;
                        catch
                                           createdynamic.alpha=0;

                        end
                        
                        try
                               alleegs_preprocessed_src_conn{subjIndex}.conn.dynamic.beta;
                                                createdynamic.beta=1;
                        catch
                                           createdynamic.beta=0;
                        end
                        
                        try
                               alleegs_preprocessed_src_conn{subjIndex}.conn.dynamic.gamma;
                                                createdynamic.gamma=1;

                        catch
                                           createdynamic.gamma=0;
                        end
                        
                        try
                               alleegs_preprocessed_src_conn{subjIndex}.conn.dynamic.custom;
                                                createdynamic.custom=1;
                        catch
                                           createdynamic.custom=0;
                        end
                        
                        try
                               alleegs_preprocessed_src_conn{subjIndex}.conn.dynamic.bb;
                                                createdynamic.bb=1;

                        catch
                                           createdynamic.bb=0;
                        end
                                               
                        
            catch
                                 creadynamic=0;

            end

end

     
else
             if(strcmp(nodeName(1:32),'Reconstructed Preprocessed Epoch'))
%              subjectParent=node.getParent;
%              subjectParent=subjectParent.getParent; 
%              subjectParent=subjectParent.getParent;  
%              subjectParent=subjectParent.getParent;  
%              subjectname=char(subjectParent.getName);
%              subjectname=subjectname(3:end);
% % %          index of the subject to show its eeg in the figure
%              subjIndex=find(strcmp(allsubjects.names, subjectname));
%              pathfile= allsubjects.paths{subjIndex};
             number=str2num(nodeName(34:end));
             
             try
            allepochs_preprocessed_src_conn{subjIndex,number}.conn;
% %             dont create a node connectivity
            create=0;      
% %             see if static or dynamic
    try 
            allepochs_preprocessed_src_conn{subjIndex,number}.conn.static;
%             dont create a node static
                try
                    connectivity.static;
                    try
                         connectivity.static.delta;
                         try 
                              allepochs_preprocessed_src_conn{subjIndex,number}.conn.static.delta;
                         catch
                             createstatic.delta=1;
                         end
                         
                          allepochs_preprocessed_src_conn{subjIndex,number}.conn.static.delta=connectivity.static.delta;
                          

                    catch
                        
                    end
                    
                                        try
                         connectivity.static.theta;
                         try 
                              allepochs_preprocessed_src_conn{subjIndex,number}.conn.static.theta;
                         catch
                             createstatic.theta=1;
                         end
                         
                          allepochs_preprocessed_src_conn{subjIndex,number}.conn.static.theta=connectivity.static.theta;
                          

                    catch
                        
                                        end
                    
                                                            try
                         connectivity.static.alpha;
                         try 
                              allepochs_preprocessed_src_conn{subjIndex,number}.conn.static.alpha;
                         catch
                             createstatic.alpha=1;
                         end
                         
                          allepochs_preprocessed_src_conn{subjIndex,number}.conn.static.alpha=connectivity.static.alpha;
                          

                    catch
                        
                                                            end
                    
                                                                                try
                         connectivity.static.beta;
                         try 
                              allepochs_preprocessed_src_conn{subjIndex,number}.conn.static.beta;
                         catch
                             createstatic.beta=1;
                         end
                         
                          allepochs_preprocessed_src_conn{subjIndex,number}.conn.static.beta=connectivity.static.beta;
                          

                    catch
                        
                                                                                end
                                        try
                         connectivity.static.gamma;
                         try 
                              allepochs_preprocessed_src_conn{subjIndex,number}.conn.static.gamma;
                         catch
                             createstatic.gamma=1;
                         end
                         
                          allepochs_preprocessed_src_conn{subjIndex,number}.conn.static.gamma=connectivity.static.gamma;
                          

                    catch
                        
                                        end
                                        try
                         connectivity.static.bb;
                         try 
                              allepochs_preprocessed_src_conn{subjIndex,number}.conn.static.bb;
                         catch
                             createstatic.bb=1;
                         end
                         
                          allepochs_preprocessed_src_conn{subjIndex,number}.conn.static.bb=connectivity.static.bb;
                          

                    catch
                        
                                        end
                                        
                                        try
                         connectivity.static.custom;
                         try 
                              allepochs_preprocessed_src_conn{subjIndex,number}.conn.static.custom;
                         catch
                             createstatic.custom=1;
                         end
                         
                          allepochs_preprocessed_src_conn{subjIndex,number}.conn.static.custom=connectivity.static.custom;
                          

                    catch
                        
                                        end
                    
                catch
                    
                end
    catch
        try
            connectivity.static;
            creastatic=1;
            allepochs_preprocessed_src_conn{subjIndex,number}.conn.static=connectivity.static;
              
            try
                               allepochs_preprocessed_src_conn{subjIndex,number}.conn.static.delta;
                                                createstatic.delta=1;

                        catch
                                           createstatic.delta=0;

                                           
                        
            end
                        
                        try
                               allepochs_preprocessed_src_conn{subjIndex,number}.conn.static.theta;
                                                createstatic.theta=1;

                        catch
                                           createstatic.theta=0;
                        end
                        
                        try
                               allepochs_preprocessed_src_conn{subjIndex,number}.conn.static.alpha;
                                                createstatic.alpha=1;
                        catch
                                           createstatic.alpha=0;

                        end
                        
                        try
                               allepochs_preprocessed_src_conn{subjIndex,number}.conn.static.beta;
                                                createstatic.beta=1;
                        catch
                                           createstatic.beta=0;
                        end
                        
                        try
                               allepochs_preprocessed_src_conn{subjIndex,number}.conn.static.gamma;
                                                createstatic.gamma=1;

                        catch
                                           createstatic.gamma=0;
                        end
                        
                        try
                               allepochs_preprocessed_src_conn{subjIndex,number}.conn.static.custom;
                                                createstatic.custom=1;
                        catch
                                           createstatic.custom=0;
                        end
                        
                        try
                               allepochs_preprocessed_src_conn{subjIndex,number}.conn.static.bb;
                                                createstatic.bb=1;

                        catch
                                           createstatic.bb=0;
                        end
        catch
            creastatic=0;
        
       end
        
    end
    
        try 
            allepochs_preprocessed_src_conn{subjIndex,number}.conn.dynamic;
%             dont create a node dynamic
                try
                    connectivity.dynamic;
                    try
                         connectivity.dynamic.delta;
                         try 
                              allepochs_preprocessed_src_conn{subjIndex,number}.conn.dynamic.delta;
                         catch
                             createdynamic.delta=1;
                         end
                         
                          allepochs_preprocessed_src_conn{subjIndex,number}.conn.dynamic.delta=connectivity.dynamic.delta;
                          

                    catch
                        
                    end
                    
                                        try
                         connectivity.dynamic.theta;
                         try 
                              allepochs_preprocessed_src_conn{subjIndex,number}.conn.dynamic.theta;
                         catch
                             createdynamic.theta=1;
                         end
                         
                          allepochs_preprocessed_src_conn{subjIndex,number}.conn.dynamic.theta=connectivity.dynamic.theta;
                          

                    catch
                        
                                        end
                    
                                                            try
                         connectivity.dynamic.alpha;
                         try 
                              allepochs_preprocessed_src_conn{subjIndex,number}.conn.dynamic.alpha;
                         catch
                             createdynamic.alpha=1;
                         end
                         
                          allepochs_preprocessed_src_conn{subjIndex,number}.conn.dynamic.alpha=connectivity.dynamic.alpha;
                          

                    catch
                        
                                                            end
                    
                                                                                try
                         connectivity.dynamic.beta;
                         try 
                              allepochs_preprocessed_src_conn{subjIndex,number}.conn.dynamic.beta;
                         catch
                             createdynamic.beta=1;
                         end
                         
                          allepochs_preprocessed_src_conn{subjIndex,number}.conn.dynamic.beta=connectivity.dynamic.beta;
                          

                    catch
                        
                                                                                end
                                        try
                         connectivity.dynamic.gamma;
                         try 
                              allepochs_preprocessed_src_conn{subjIndex,number}.conn.dynamic.gamma;
                         catch
                             createdynamic.gamma=1;
                         end
                         
                          allepochs_preprocessed_src_conn{subjIndex,number}.conn.dynamic.gamma=connectivity.dynamic.gamma;
                          

                    catch
                        
                                        end
                                        try
                         connectivity.dynamic.bb;
                         try 
                              allepochs_preprocessed_src_conn{subjIndex,number}.conn.dynamic.bb;
                         catch
                             createdynamic.bb=1;
                         end
                         
                          allepochs_preprocessed_src_conn{subjIndex,number}.conn.dynamic.bb=connectivity.dynamic.bb;
                          

                    catch
                        
                                        end
                                        
                                        try
                         connectivity.dynamic.custom;
                         try 
                              allepochs_preprocessed_src_conn{subjIndex,number}.conn.dynamic.custom;
                         catch
                             createdynamic.custom=1;
                         end
                         
                          allepochs_preprocessed_src_conn{subjIndex,number}.conn.dynamic.custom=connectivity.dynamic.custom;
                          

                    catch
                        
                                        end
                    
                catch
                    
                end
    catch
        try
            connectivity.dynamic;
            creadynamic=1;
            allepochs_preprocessed_src_conn{subjIndex,number}.conn.dynamic=connectivity.dynamic;
              
            try
                               allepochs_preprocessed_src_conn{subjIndex,number}.conn.dynamic.delta;
                                                createdynamic.delta=1;

                        catch
                                           createdynamic.delta=0;

                                           
                        
            end
                        
                        try
                               allepochs_preprocessed_src_conn{subjIndex,number}.conn.dynamic.theta;
                                                createdynamic.theta=1;

                        catch
                                           createdynamic.theta=0;
                        end
                        
                        try
                               allepochs_preprocessed_src_conn{subjIndex,number}.conn.dynamic.alpha;
                                                createdynamic.alpha=1;
                        catch
                                           createdynamic.alpha=0;

                        end
                        
                        try
                               allepochs_preprocessed_src_conn{subjIndex,number}.conn.dynamic.beta;
                                                createdynamic.beta=1;
                        catch
                                           createdynamic.beta=0;
                        end
                        
                        try
                               allepochs_preprocessed_src_conn{subjIndex,number}.conn.dynamic.gamma;
                                                createdynamic.gamma=1;

                        catch
                                           createdynamic.gamma=0;
                        end
                        
                        try
                               allepochs_preprocessed_src_conn{subjIndex,number}.conn.dynamic.custom;
                                                createdynamic.custom=1;
                        catch
                                           createdynamic.custom=0;
                        end
                        
                        try
                               allepochs_preprocessed_src_conn{subjIndex,number}.conn.dynamic.bb;
                                                createdynamic.bb=1;

                        catch
                                           createdynamic.bb=0;
                        end
        catch
            creadynamic=0;
        
       end
        
        end
    
catch
% %             no connectivity node that already exist for this subject
            create=1;
            allepochs_preprocessed_src_conn{subjIndex,number}.conn=connectivity;
            try
                allepochs_preprocessed_src_conn{subjIndex,number}.conn.static;
                 creastatic=1;
                        try
                               allepochs_preprocessed_src_conn{subjIndex,number}.conn.static.delta;
                                                createstatic.delta=1;

                        catch
                                           createstatic.delta=0;

                        end
                        
                        try
                               allepochs_preprocessed_src_conn{subjIndex,number}.conn.static.theta;
                                                createstatic.theta=1;

                        catch
                                           createstatic.theta=0;
                        end
                        
                        try
                               allepochs_preprocessed_src_conn{subjIndex,number}.conn.static.alpha;
                                                createstatic.alpha=1;
                        catch
                                           createstatic.alpha=0;

                        end
                        
                        try
                               allepochs_preprocessed_src_conn{subjIndex,number}.conn.static.beta;
                                                createstatic.beta=1;
                        catch
                                           createstatic.beta=0;
                        end
                        
                        try
                               allepochs_preprocessed_src_conn{subjIndex,number}.conn.static.gamma;
                                                createstatic.gamma=1;

                        catch
                                           createstatic.gamma=0;
                        end
                        
                        try
                               allepochs_preprocessed_src_conn{subjIndex,number}.conn.static.custom;
                                                createstatic.custom=1;
                        catch
                                           createstatic.custom=0;
                        end
                        
                        try
                               allepochs_preprocessed_src_conn{subjIndex,number}.conn.static.bb;
                                                createstatic.bb=1;

                        catch
                                           createstatic.bb=0;
                        end
                                               
                        
            catch
                                 creastatic=0;

            end
            
            
            
            try
                allepochs_preprocessed_src_conn{subjIndex,number}.conn.dynamic;
                 creadynamic=1;
                        try
                               allepochs_preprocessed_src_conn{subjIndex,number}.conn.dynamic.delta;
                                                createdynamic.delta=1;

                        catch
                                           createdynamic.delta=0;

                        end
                        
                        try
                               allepochs_preprocessed_src_conn{subjIndex,number}.conn.dynamic.theta;
                                                createdynamic.theta=1;

                        catch
                                           createdynamic.theta=0;
                        end
                        
                        try
                               allepochs_preprocessed_src_conn{subjIndex,number}.conn.dynamic.alpha;
                                                createdynamic.alpha=1;
                        catch
                                           createdynamic.alpha=0;

                        end
                        
                        try
                               allepochs_preprocessed_src_conn{subjIndex,number}.conn.dynamic.beta;
                                                createdynamic.beta=1;
                        catch
                                           createdynamic.beta=0;
                        end
                        
                        try
                               allepochs_preprocessed_src_conn{subjIndex,number}.conn.dynamic.gamma;
                                                createdynamic.gamma=1;

                        catch
                                           createdynamic.gamma=0;
                        end
                        
                        try
                               allepochs_preprocessed_src_conn{subjIndex,number}.conn.dynamic.custom;
                                                createdynamic.custom=1;
                        catch
                                           createdynamic.custom=0;
                        end
                        
                        try
                               allepochs_preprocessed_src_conn{subjIndex,number}.conn.dynamic.bb;
                                                createdynamic.bb=1;

                        catch
                                           createdynamic.bb=0;
                        end
                                               
                        
            catch
                                 creadynamic=0;

            end

end
             end
end
       end
end

% % create node
% % create node
if(create==1)
node_toadd=node;
childNode = uitreenode('v0','dummy', 'Connectivity', [], 0);
[I] = imread('Icons/connectivity_icon.png');
javaImage_eeg = im2java(I);
childNode.setIcon(javaImage_eeg);
treeModel.insertNodeInto(childNode,node_toadd,node_toadd.getChildCount()); 
% expand to show added child
tree.setSelectedNode( childNode );
% insure additional nodes are added to parent
tree.setSelectedNode( node_toadd );
conparentnode=childNode;

if(creastatic)
    statMat=connectivity.static;
    childNode = uitreenode('v0','dummy', 'Static', [], 0);
[I] = imread('Icons/static_icon.png');
    javaImage_eeg = im2java(I);
    childNode.setIcon(javaImage_eeg);
    treeModel.insertNodeInto(childNode,conparentnode,conparentnode.getChildCount()); 
    % expand to show added child
    tree.setSelectedNode( childNode );
    % insure additional nodes are added to parent
    tree.setSelectedNode( conparentnode );
    statparentnode=childNode;
    
    if(createstatic.delta)
           childNode = uitreenode('v0','dummy', 'Delta', [], 0);
[I] = imread('Icons/icon_conn.png');
        javaImage_eeg = im2java(I);
        childNode.setIcon(javaImage_eeg);
        treeModel.insertNodeInto(childNode,statparentnode,statparentnode.getChildCount()); 
        % expand to show added child
        tree.setSelectedNode( childNode );
        % insure additional nodes are added to parent
        tree.setSelectedNode( statparentnode );

    

    end
    
    if(createstatic.theta)
           childNode = uitreenode('v0','dummy', 'Theta', [], 0);
[I] = imread('Icons/icon_conn.png');
        javaImage_eeg = im2java(I);
        childNode.setIcon(javaImage_eeg);
        treeModel.insertNodeInto(childNode,statparentnode,statparentnode.getChildCount()); 
        % expand to show added child
        tree.setSelectedNode( childNode );
        % insure additional nodes are added to parent
        tree.setSelectedNode( statparentnode );

    
    end
if(createstatic.alpha)
           childNode = uitreenode('v0','dummy', 'Alpha', [], 0);
[I] = imread('Icons/icon_conn.png');
        javaImage_eeg = im2java(I);
        childNode.setIcon(javaImage_eeg);
        treeModel.insertNodeInto(childNode,statparentnode,statparentnode.getChildCount()); 
        % expand to show added child
        tree.setSelectedNode( childNode );
        % insure additional nodes are added to parent
        tree.setSelectedNode( statparentnode );

    
end
if(createstatic.beta)
           childNode = uitreenode('v0','dummy', 'Beta', [], 0);
[I] = imread('Icons/icon_conn.png');
        javaImage_eeg = im2java(I);
        childNode.setIcon(javaImage_eeg);
        treeModel.insertNodeInto(childNode,statparentnode,statparentnode.getChildCount()); 
        % expand to show added child
        tree.setSelectedNode( childNode );
        % insure additional nodes are added to parent
        tree.setSelectedNode( statparentnode );

    
end
if(createstatic.gamma)
           childNode = uitreenode('v0','dummy', 'Gamma', [], 0);
[I] = imread('Icons/icon_conn.png');
        javaImage_eeg = im2java(I);
        childNode.setIcon(javaImage_eeg);
        treeModel.insertNodeInto(childNode,statparentnode,statparentnode.getChildCount()); 
        % expand to show added child
        tree.setSelectedNode( childNode );
        % insure additional nodes are added to parent
        tree.setSelectedNode( statparentnode );

    
end
if(createstatic.bb)
           childNode = uitreenode('v0','dummy', 'bb', [], 0);
[I] = imread('Icons/icon_conn.png');
        javaImage_eeg = im2java(I);
        childNode.setIcon(javaImage_eeg);
        treeModel.insertNodeInto(childNode,statparentnode,statparentnode.getChildCount()); 
        % expand to show added child
        tree.setSelectedNode( childNode );
        % insure additional nodes are added to parent
        tree.setSelectedNode( statparentnode );

    
end
if(createstatic.custom)
           childNode = uitreenode('v0','dummy', 'Custom', [], 0);
[I] = imread('Icons/icon_conn.png');
        javaImage_eeg = im2java(I);
        childNode.setIcon(javaImage_eeg);
        treeModel.insertNodeInto(childNode,statparentnode,statparentnode.getChildCount()); 
        % expand to show added child
        tree.setSelectedNode( childNode );
        % insure additional nodes are added to parent
        tree.setSelectedNode( statparentnode );

    
end
else
% %     no need to create statix node but should test if subnodes should be
% created 
    if(createstatic.delta)
 statparentnode=conparentnode;
    count=0;
    while(1)
        statparentnode=statparentnode.getNextNode;
        
        if(strcmp(char(statparentnode.getName),'Static')==1)
        break;
        else
            continue;
        end
    end
    childNode = uitreenode('v0','dummy', 'Delta', [], 0);
[I] = imread('Icons/icon_conn.png');
        javaImage_eeg = im2java(I);
        childNode.setIcon(javaImage_eeg);
        treeModel.insertNodeInto(childNode,statparentnode,statparentnode.getChildCount()); 
        % expand to show added child
        tree.setSelectedNode( childNode );
        % insure additional nodes are added to parent
        tree.setSelectedNode( statparentnode );

    

    end
    
    if(createstatic.theta)
 statparentnode=conparentnode;
    count=0;
    while(1)
        statparentnode=statparentnode.getNextNode;
        
        if(strcmp(char(statparentnode.getName),'Static')==1)
        break;
        else
            continue;
        end
    end  
           childNode = uitreenode('v0','dummy', 'Theta', [], 0);
[I] = imread('Icons/icon_conn.png');
        javaImage_eeg = im2java(I);
        childNode.setIcon(javaImage_eeg);
        treeModel.insertNodeInto(childNode,statparentnode,statparentnode.getChildCount()); 
        % expand to show added child
        tree.setSelectedNode( childNode );
        % insure additional nodes are added to parent
        tree.setSelectedNode( statparentnode );

    
    end
if(createstatic.alpha)
 statparentnode=conparentnode;
    count=0;
    while(1)
        statparentnode=statparentnode.getNextNode;
        
        if(strcmp(char(statparentnode.getName),'Static')==1)
        break;
        else
            continue;
        end
    end  
           childNode = uitreenode('v0','dummy', 'Alpha', [], 0);
[I] = imread('Icons/icon_conn.png');
        javaImage_eeg = im2java(I);
        childNode.setIcon(javaImage_eeg);
        treeModel.insertNodeInto(childNode,statparentnode,statparentnode.getChildCount()); 
        % expand to show added child
        tree.setSelectedNode( childNode );
        % insure additional nodes are added to parent
        tree.setSelectedNode( statparentnode );

    
end
if(createstatic.beta)
 statparentnode=conparentnode;
    count=0;
    while(1)
        statparentnode=statparentnode.getNextNode;
        
        if(strcmp(char(statparentnode.getName),'Static')==1)
        break;
        else
            continue;
        end
    end  
    
           childNode = uitreenode('v0','dummy', 'Beta', [], 0);
[I] = imread('Icons/icon_conn.png');
        javaImage_eeg = im2java(I);
        childNode.setIcon(javaImage_eeg);
        treeModel.insertNodeInto(childNode,statparentnode,statparentnode.getChildCount()); 
        % expand to show added child
        tree.setSelectedNode( childNode );
        % insure additional nodes are added to parent
        tree.setSelectedNode( statparentnode );

    
end
if(createstatic.gamma)
    
     statparentnode=conparentnode;
    count=0;
    while(1)
        statparentnode=statparentnode.getNextNode;
        
        if(strcmp(char(statparentnode.getName),'Static')==1)
        break;
        else
            continue;
        end
    end  
           childNode = uitreenode('v0','dummy', 'Gamma', [], 0);
[I] = imread('Icons/icon_conn.png');
        javaImage_eeg = im2java(I);
        childNode.setIcon(javaImage_eeg);
        treeModel.insertNodeInto(childNode,statparentnode,statparentnode.getChildCount()); 
        % expand to show added child
        tree.setSelectedNode( childNode );
        % insure additional nodes are added to parent
        tree.setSelectedNode( statparentnode );

    
end
if(createstatic.bb)
 statparentnode=conparentnode;
    count=0;
    while(1)
        statparentnode=statparentnode.getNextNode;
        
        if(strcmp(char(statparentnode.getName),'Static')==1)
        break;
        else
            continue;
        end
    end  
    
           childNode = uitreenode('v0','dummy', 'bb', [], 0);
[I] = imread('Icons/icon_conn.png');
        javaImage_eeg = im2java(I);
        childNode.setIcon(javaImage_eeg);
        treeModel.insertNodeInto(childNode,statparentnode,statparentnode.getChildCount()); 
        % expand to show added child
        tree.setSelectedNode( childNode );
        % insure additional nodes are added to parent
        tree.setSelectedNode( statparentnode );

    
end
if(createstatic.custom)
 statparentnode=conparentnode;
    count=0;
    while(1)
        statparentnode=statparentnode.getNextNode;
        
        if(strcmp(char(statparentnode.getName),'Static')==1)
        break;
        else
            continue;
        end
    end  
    
           childNode = uitreenode('v0','dummy', 'Custom', [], 0);
[I] = imread('Icons/icon_conn.png');
        javaImage_eeg = im2java(I);
        childNode.setIcon(javaImage_eeg);
        treeModel.insertNodeInto(childNode,statparentnode,statparentnode.getChildCount()); 
        % expand to show added child
        tree.setSelectedNode( childNode );
        % insure additional nodes are added to parent
        tree.setSelectedNode( statparentnode );

    
end

end

if(creadynamic)
    statMat=connectivity.dynamic;
    childNode = uitreenode('v0','dummy', 'Dynamic', [], 0);
[I] = imread('Icons/dynamic_icon.png');
    javaImage_eeg = im2java(I);
    childNode.setIcon(javaImage_eeg);
    treeModel.insertNodeInto(childNode,conparentnode,conparentnode.getChildCount()); 
    % expand to show added child
    tree.setSelectedNode( childNode );
    % insure additional nodes are added to parent
    tree.setSelectedNode( conparentnode );
    statparentnode=childNode;
    
    if(createdynamic.delta)
           childNode = uitreenode('v0','dummy', 'Delta', [], 0);
[I] = imread('Icons/icon_conn.png');
        javaImage_eeg = im2java(I);
        childNode.setIcon(javaImage_eeg);
        treeModel.insertNodeInto(childNode,statparentnode,statparentnode.getChildCount()); 
        % expand to show added child
        tree.setSelectedNode( childNode );
        % insure additional nodes are added to parent
        tree.setSelectedNode( statparentnode );

    

    end
    
    if(createdynamic.theta)
           childNode = uitreenode('v0','dummy', 'Theta', [], 0);
[I] = imread('Icons/icon_conn.png');
        javaImage_eeg = im2java(I);
        childNode.setIcon(javaImage_eeg);
        treeModel.insertNodeInto(childNode,statparentnode,statparentnode.getChildCount()); 
        % expand to show added child
        tree.setSelectedNode( childNode );
        % insure additional nodes are added to parent
        tree.setSelectedNode( statparentnode );

    
    end
if(createdynamic.alpha)
           childNode = uitreenode('v0','dummy', 'Alpha', [], 0);
[I] = imread('Icons/icon_conn.png');
        javaImage_eeg = im2java(I);
        childNode.setIcon(javaImage_eeg);
        treeModel.insertNodeInto(childNode,statparentnode,statparentnode.getChildCount()); 
        % expand to show added child
        tree.setSelectedNode( childNode );
        % insure additional nodes are added to parent
        tree.setSelectedNode( statparentnode );

    
end
if(createdynamic.beta)
           childNode = uitreenode('v0','dummy', 'Beta', [], 0);
[I] = imread('Icons/icon_conn.png');
        javaImage_eeg = im2java(I);
        childNode.setIcon(javaImage_eeg);
        treeModel.insertNodeInto(childNode,statparentnode,statparentnode.getChildCount()); 
        % expand to show added child
        tree.setSelectedNode( childNode );
        % insure additional nodes are added to parent
        tree.setSelectedNode( statparentnode );

    
end
if(createdynamic.gamma)
           childNode = uitreenode('v0','dummy', 'Gamma', [], 0);
[I] = imread('Icons/icon_conn.png');
        javaImage_eeg = im2java(I);
        childNode.setIcon(javaImage_eeg);
        treeModel.insertNodeInto(childNode,statparentnode,statparentnode.getChildCount()); 
        % expand to show added child
        tree.setSelectedNode( childNode );
        % insure additional nodes are added to parent
        tree.setSelectedNode( statparentnode );

    
end
if(createdynamic.bb)
           childNode = uitreenode('v0','dummy', 'bb', [], 0);
[I] = imread('Icons/icon_conn.png');
        javaImage_eeg = im2java(I);
        childNode.setIcon(javaImage_eeg);
        treeModel.insertNodeInto(childNode,statparentnode,statparentnode.getChildCount()); 
        % expand to show added child
        tree.setSelectedNode( childNode );
        % insure additional nodes are added to parent
        tree.setSelectedNode( statparentnode );

    
end
if(createdynamic.custom)
           childNode = uitreenode('v0','dummy', 'Custom', [], 0);
[I] = imread('Icons/icon_conn.png');
        javaImage_eeg = im2java(I);
        childNode.setIcon(javaImage_eeg);
        treeModel.insertNodeInto(childNode,statparentnode,statparentnode.getChildCount()); 
        % expand to show added child
        tree.setSelectedNode( childNode );
        % insure additional nodes are added to parent
        tree.setSelectedNode( statparentnode );

    
end
else
% %     no need to create dynamic node but should test if subnodes should be
% created 
    if(createdynamic.delta)
        
        dynparentnode=conparentnode;
    count=0;
    while(1)
        dynparentnode=dynparentnode.getNextNode;
        
        if(strcmp(char(dynparentnode.getName),'Dynamic')==1)
        break;
        else
            continue;
        end
    end         
        
           childNode = uitreenode('v0','dummy', 'Delta', [], 0);
[I] = imread('Icons/icon_conn.png');
        javaImage_eeg = im2java(I);
        childNode.setIcon(javaImage_eeg);
        treeModel.insertNodeInto(childNode,dynparentnode,dynparentnode.getChildCount()); 
        % expand to show added child
        tree.setSelectedNode( childNode );
        % insure additional nodes are added to parent
        tree.setSelectedNode( dynparentnode );

    

    end
    
    if(createdynamic.theta)
dynparentnode=conparentnode;
    count=0;
    while(1)
        dynparentnode=dynparentnode.getNextNode;
        
        if(strcmp(char(dynparentnode.getName),'Dynamic')==1)
        break;
        else
            continue;
        end
    end 
           childNode = uitreenode('v0','dummy', 'Theta', [], 0);
[I] = imread('Icons/icon_conn.png');
        javaImage_eeg = im2java(I);
        childNode.setIcon(javaImage_eeg);
        treeModel.insertNodeInto(childNode,dynparentnode,dynparentnode.getChildCount()); 
        % expand to show added child
        tree.setSelectedNode( childNode );
        % insure additional nodes are added to parent
        tree.setSelectedNode( dynparentnode );

    
    end
if(createdynamic.alpha)
dynparentnode=conparentnode;
    count=0;
    while(1)
        dynparentnode=dynparentnode.getNextNode;
        
        if(strcmp(char(dynparentnode.getName),'Dynamic')==1)
        break;
        else
            continue;
        end
    end 
           childNode = uitreenode('v0','dummy', 'Alpha', [], 0);
[I] = imread('Icons/icon_conn.png');
        javaImage_eeg = im2java(I);
        childNode.setIcon(javaImage_eeg);
        treeModel.insertNodeInto(childNode,dynparentnode,dynparentnode.getChildCount()); 
        % expand to show added child
        tree.setSelectedNode( childNode );
        % insure additional nodes are added to parent
        tree.setSelectedNode( dynparentnode );

    
end
if(createdynamic.beta)
dynparentnode=conparentnode;
    count=0;
    while(1)
        dynparentnode=dynparentnode.getNextNode;
        
        if(strcmp(char(dynparentnode.getName),'Dynamic')==1)
        break;
        else
            continue;
        end
    end 
           childNode = uitreenode('v0','dummy', 'Beta', [], 0);
[I] = imread('Icons/icon_conn.png');
        javaImage_eeg = im2java(I);
        childNode.setIcon(javaImage_eeg);
        treeModel.insertNodeInto(childNode,dynparentnode,dynparentnode.getChildCount()); 
        % expand to show added child
        tree.setSelectedNode( childNode );
        % insure additional nodes are added to parent
        tree.setSelectedNode( dynparentnode );

    
end
if(createdynamic.gamma)
dynparentnode=conparentnode;
    count=0;
    while(1)
        dynparentnode=dynparentnode.getNextNode;
        
        if(strcmp(char(dynparentnode.getName),'Dynamic')==1)
        break;
        else
            continue;
        end
    end 
           childNode = uitreenode('v0','dummy', 'Gamma', [], 0);
[I] = imread('Icons/icon_conn.png');
        javaImage_eeg = im2java(I);
        childNode.setIcon(javaImage_eeg);
        treeModel.insertNodeInto(childNode,dynparentnode,dynparentnode.getChildCount()); 
        % expand to show added child
        tree.setSelectedNode( childNode );
        % insure additional nodes are added to parent
        tree.setSelectedNode( dynparentnode );

    
end
if(createdynamic.bb)
dynparentnode=conparentnode;
    count=0;
    while(1)
        dynparentnode=dynparentnode.getNextNode;
        
        if(strcmp(char(dynparentnode.getName),'Dynamic')==1)
        break;
        else
            continue;
        end
    end 
           childNode = uitreenode('v0','dummy', 'bb', [], 0);
[I] = imread('Icons/icon_conn.png');
        javaImage_eeg = im2java(I);
        childNode.setIcon(javaImage_eeg);
        treeModel.insertNodeInto(childNode,dynparentnode,dynparentnode.getChildCount()); 
        % expand to show added child
        tree.setSelectedNode( childNode );
        % insure additional nodes are added to parent
        tree.setSelectedNode( dynparentnode );

    
end
if(createdynamic.custom)
dynparentnode=conparentnode;
    count=0;
    while(1)
        dynparentnode=dynparentnode.getNextNode;
        
        if(strcmp(char(dynparentnode.getName),'Dynamic')==1)
        break;
        else
            continue;
        end
    end 
           childNode = uitreenode('v0','dummy', 'Custom', [], 0);
[I] = imread('Icons/icon_conn.png');
        javaImage_eeg = im2java(I);
        childNode.setIcon(javaImage_eeg);
        treeModel.insertNodeInto(childNode,dynparentnode,dynparentnode.getChildCount()); 
        % expand to show added child
        tree.setSelectedNode( childNode );
        % insure additional nodes are added to parent
        tree.setSelectedNode( dynparentnode );

    
end

end

  
else
% %     no need to create con node but may need to create subnodes
% (static,dynamic)
if(creastatic)
conparentnode=node.getNextNode;
    statMat=connectivity.static;
    childNode = uitreenode('v0','dummy', 'Static', [], 0);
[I] = imread('Icons/static_icon.png');
    javaImage_eeg = im2java(I);
    childNode.setIcon(javaImage_eeg);
    treeModel.insertNodeInto(childNode,conparentnode,conparentnode.getChildCount()); 
    % expand to show added child
    tree.setSelectedNode( childNode );
    % insure additional nodes are added to parent
    tree.setSelectedNode( conparentnode );
    statparentnode=childNode;
    
    if(createstatic.delta)
           childNode = uitreenode('v0','dummy', 'Delta', [], 0);
[I] = imread('Icons/icon_conn.png');
        javaImage_eeg = im2java(I);
        childNode.setIcon(javaImage_eeg);
        treeModel.insertNodeInto(childNode,statparentnode,statparentnode.getChildCount()); 
        % expand to show added child
        tree.setSelectedNode( childNode );
        % insure additional nodes are added to parent
        tree.setSelectedNode( statparentnode );

    

    end
    
    if(createstatic.theta)
           childNode = uitreenode('v0','dummy', 'Theta', [], 0);
[I] = imread('Icons/icon_conn.png');
        javaImage_eeg = im2java(I);
        childNode.setIcon(javaImage_eeg);
        treeModel.insertNodeInto(childNode,statparentnode,statparentnode.getChildCount()); 
        % expand to show added child
        tree.setSelectedNode( childNode );
        % insure additional nodes are added to parent
        tree.setSelectedNode( statparentnode );

    
    end
if(createstatic.alpha)
           childNode = uitreenode('v0','dummy', 'Alpha', [], 0);
[I] = imread('Icons/icon_conn.png');
        javaImage_eeg = im2java(I);
        childNode.setIcon(javaImage_eeg);
        treeModel.insertNodeInto(childNode,statparentnode,statparentnode.getChildCount()); 
        % expand to show added child
        tree.setSelectedNode( childNode );
        % insure additional nodes are added to parent
        tree.setSelectedNode( statparentnode );

    
end
if(createstatic.beta)
           childNode = uitreenode('v0','dummy', 'Beta', [], 0);
[I] = imread('Icons/icon_conn.png');
        javaImage_eeg = im2java(I);
        childNode.setIcon(javaImage_eeg);
        treeModel.insertNodeInto(childNode,statparentnode,statparentnode.getChildCount()); 
        % expand to show added child
        tree.setSelectedNode( childNode );
        % insure additional nodes are added to parent
        tree.setSelectedNode( statparentnode );

    
end
if(createstatic.gamma)
           childNode = uitreenode('v0','dummy', 'Gamma', [], 0);
[I] = imread('Icons/icon_conn.png');
        javaImage_eeg = im2java(I);
        childNode.setIcon(javaImage_eeg);
        treeModel.insertNodeInto(childNode,statparentnode,statparentnode.getChildCount()); 
        % expand to show added child
        tree.setSelectedNode( childNode );
        % insure additional nodes are added to parent
        tree.setSelectedNode( statparentnode );

    
end
if(createstatic.bb)
           childNode = uitreenode('v0','dummy', 'bb', [], 0);
[I] = imread('Icons/icon_conn.png');
        javaImage_eeg = im2java(I);
        childNode.setIcon(javaImage_eeg);
        treeModel.insertNodeInto(childNode,statparentnode,statparentnode.getChildCount()); 
        % expand to show added child
        tree.setSelectedNode( childNode );
        % insure additional nodes are added to parent
        tree.setSelectedNode( statparentnode );

    
end
if(createstatic.custom)
           childNode = uitreenode('v0','dummy', 'Custom', [], 0);
[I] = imread('Icons/icon_conn.png');
        javaImage_eeg = im2java(I);
        childNode.setIcon(javaImage_eeg);
        treeModel.insertNodeInto(childNode,statparentnode,statparentnode.getChildCount()); 
        % expand to show added child
        tree.setSelectedNode( childNode );
        % insure additional nodes are added to parent
        tree.setSelectedNode( statparentnode );

    
end
else
% %     no need to create statix node but should test if subnodes should be
% created 
conparentnode=node.getNextNode;

    if(createstatic.delta)
        statparentnode=conparentnode.getNextNode;
           childNode = uitreenode('v0','dummy', 'Delta', [], 0);
[I] = imread('Icons/icon_conn.png');
        javaImage_eeg = im2java(I);
        childNode.setIcon(javaImage_eeg);
        treeModel.insertNodeInto(childNode,statparentnode,statparentnode.getChildCount()); 
        % expand to show added child
        tree.setSelectedNode( childNode );
        % insure additional nodes are added to parent
        tree.setSelectedNode( statparentnode );

    

    end
    
    if(createstatic.theta)
                statparentnode=conparentnode.getNextNode;

           childNode = uitreenode('v0','dummy', 'Theta', [], 0);
[I] = imread('Icons/icon_conn.png');
        javaImage_eeg = im2java(I);
        childNode.setIcon(javaImage_eeg);
        treeModel.insertNodeInto(childNode,statparentnode,statparentnode.getChildCount()); 
        % expand to show added child
        tree.setSelectedNode( childNode );
        % insure additional nodes are added to parent
        tree.setSelectedNode( statparentnode );

    
    end
if(createstatic.alpha)
            statparentnode=conparentnode.getNextNode;

           childNode = uitreenode('v0','dummy', 'Alpha', [], 0);
[I] = imread('Icons/icon_conn.png');
        javaImage_eeg = im2java(I);
        childNode.setIcon(javaImage_eeg);
        treeModel.insertNodeInto(childNode,statparentnode,statparentnode.getChildCount()); 
        % expand to show added child
        tree.setSelectedNode( childNode );
        % insure additional nodes are added to parent
        tree.setSelectedNode( statparentnode );

    
end
if(createstatic.beta)
            statparentnode=conparentnode.getNextNode;

           childNode = uitreenode('v0','dummy', 'Beta', [], 0);
[I] = imread('Icons/icon_conn.png');
        javaImage_eeg = im2java(I);
        childNode.setIcon(javaImage_eeg);
        treeModel.insertNodeInto(childNode,statparentnode,statparentnode.getChildCount()); 
        % expand to show added child
        tree.setSelectedNode( childNode );
        % insure additional nodes are added to parent
        tree.setSelectedNode( statparentnode );

    
end
if(createstatic.gamma)
                statparentnode=conparentnode.getNextNode;

           childNode = uitreenode('v0','dummy', 'Gamma', [], 0);
[I] = imread('Icons/icon_conn.png');
        javaImage_eeg = im2java(I);
        childNode.setIcon(javaImage_eeg);
        treeModel.insertNodeInto(childNode,statparentnode,statparentnode.getChildCount()); 
        % expand to show added child
        tree.setSelectedNode( childNode );
        % insure additional nodes are added to parent
        tree.setSelectedNode( statparentnode );

    
end
if(createstatic.bb)
            statparentnode=conparentnode.getNextNode;

           childNode = uitreenode('v0','dummy', 'bb', [], 0);
[I] = imread('Icons/icon_conn.png');
        javaImage_eeg = im2java(I);
        childNode.setIcon(javaImage_eeg);
        treeModel.insertNodeInto(childNode,statparentnode,statparentnode.getChildCount()); 
        % expand to show added child
        tree.setSelectedNode( childNode );
        % insure additional nodes are added to parent
        tree.setSelectedNode( statparentnode );

    
end
if(createstatic.custom)
            statparentnode=conparentnode.getNextNode;

           childNode = uitreenode('v0','dummy', 'Custom', [], 0);
[I] = imread('Icons/icon_conn.png');
        javaImage_eeg = im2java(I);
        childNode.setIcon(javaImage_eeg);
        treeModel.insertNodeInto(childNode,statparentnode,statparentnode.getChildCount()); 
        % expand to show added child
        tree.setSelectedNode( childNode );
        % insure additional nodes are added to parent
        tree.setSelectedNode( statparentnode );

    
end

end

if(creadynamic)
    conparentnode=node.getNextNode;

    statMat=connectivity.dynamic;
    childNode = uitreenode('v0','dummy', 'Dynamic', [], 0);
[I] = imread('Icons/dynamic_icon.png');
    javaImage_eeg = im2java(I);
    childNode.setIcon(javaImage_eeg);
    treeModel.insertNodeInto(childNode,conparentnode,conparentnode.getChildCount()); 
    % expand to show added child
    tree.setSelectedNode( childNode );
    % insure additional nodes are added to parent
    tree.setSelectedNode( conparentnode );
    statparentnode=childNode;
    
    if(createdynamic.delta)
           childNode = uitreenode('v0','dummy', 'Delta', [], 0);
[I] = imread('Icons/icon_conn.png');
        javaImage_eeg = im2java(I);
        childNode.setIcon(javaImage_eeg);
        treeModel.insertNodeInto(childNode,statparentnode,statparentnode.getChildCount()); 
        % expand to show added child
        tree.setSelectedNode( childNode );
        % insure additional nodes are added to parent
        tree.setSelectedNode( statparentnode );

    

    end
    
    if(createdynamic.theta)
           childNode = uitreenode('v0','dummy', 'Theta', [], 0);
[I] = imread('Icons/icon_conn.png');
        javaImage_eeg = im2java(I);
        childNode.setIcon(javaImage_eeg);
        treeModel.insertNodeInto(childNode,statparentnode,statparentnode.getChildCount()); 
        % expand to show added child
        tree.setSelectedNode( childNode );
        % insure additional nodes are added to parent
        tree.setSelectedNode( statparentnode );

    
    end
if(createdynamic.alpha)
           childNode = uitreenode('v0','dummy', 'Alpha', [], 0);
[I] = imread('Icons/icon_conn.png');
        javaImage_eeg = im2java(I);
        childNode.setIcon(javaImage_eeg);
        treeModel.insertNodeInto(childNode,statparentnode,statparentnode.getChildCount()); 
        % expand to show added child
        tree.setSelectedNode( childNode );
        % insure additional nodes are added to parent
        tree.setSelectedNode( statparentnode );

    
end
if(createdynamic.beta)
           childNode = uitreenode('v0','dummy', 'Beta', [], 0);
[I] = imread('Icons/icon_conn.png');
        javaImage_eeg = im2java(I);
        childNode.setIcon(javaImage_eeg);
        treeModel.insertNodeInto(childNode,statparentnode,statparentnode.getChildCount()); 
        % expand to show added child
        tree.setSelectedNode( childNode );
        % insure additional nodes are added to parent
        tree.setSelectedNode( statparentnode );

    
end
if(createdynamic.gamma)
           childNode = uitreenode('v0','dummy', 'Gamma', [], 0);
[I] = imread('Icons/icon_conn.png');
        javaImage_eeg = im2java(I);
        childNode.setIcon(javaImage_eeg);
        treeModel.insertNodeInto(childNode,statparentnode,statparentnode.getChildCount()); 
        % expand to show added child
        tree.setSelectedNode( childNode );
        % insure additional nodes are added to parent
        tree.setSelectedNode( statparentnode );

    
end
if(createdynamic.bb)
           childNode = uitreenode('v0','dummy', 'bb', [], 0);
[I] = imread('Icons/icon_conn.png');
        javaImage_eeg = im2java(I);
        childNode.setIcon(javaImage_eeg);
        treeModel.insertNodeInto(childNode,statparentnode,statparentnode.getChildCount()); 
        % expand to show added child
        tree.setSelectedNode( childNode );
        % insure additional nodes are added to parent
        tree.setSelectedNode( statparentnode );

    
end
if(createdynamic.custom)
           childNode = uitreenode('v0','dummy', 'Custom', [], 0);
[I] = imread('Icons/icon_conn.png');
        javaImage_eeg = im2java(I);
        childNode.setIcon(javaImage_eeg);
        treeModel.insertNodeInto(childNode,statparentnode,statparentnode.getChildCount()); 
        % expand to show added child
        tree.setSelectedNode( childNode );
        % insure additional nodes are added to parent
        tree.setSelectedNode( statparentnode );

    
end
else
% %     no need to create dynamic node but should test if subnodes should be
% created 
    if(createdynamic.delta)
        conparentnode=node.getNextNode;

dynparentnode=conparentnode;
    count=0;
    while(1)
        dynparentnode=dynparentnode.getNextNode;
        
        if(strcmp(char(dynparentnode.getName),'Dynamic')==1)
        break;
        else
            continue;
        end
    end         
        
           childNode = uitreenode('v0','dummy', 'Delta', [], 0);
[I] = imread('Icons/icon_conn.png');
        javaImage_eeg = im2java(I);
        childNode.setIcon(javaImage_eeg);
        treeModel.insertNodeInto(childNode,dynparentnode,dynparentnode.getChildCount()); 
        % expand to show added child
        tree.setSelectedNode( childNode );
        % insure additional nodes are added to parent
        tree.setSelectedNode( dynparentnode );

    

    end
    
    if(createdynamic.theta)
        conparentnode=node.getNextNode;

dynparentnode=conparentnode;
    count=0;
    while(1)
        dynparentnode=dynparentnode.getNextNode;
        
        if(strcmp(char(dynparentnode.getName),'Dynamic')==1)
        break;
        else
            continue;
        end
    end 
           childNode = uitreenode('v0','dummy', 'Theta', [], 0);
[I] = imread('Icons/icon_conn.png');
        javaImage_eeg = im2java(I);
        childNode.setIcon(javaImage_eeg);
        treeModel.insertNodeInto(childNode,dynparentnode,dynparentnode.getChildCount()); 
        % expand to show added child
        tree.setSelectedNode( childNode );
        % insure additional nodes are added to parent
        tree.setSelectedNode( dynparentnode );

    
    end
if(createdynamic.alpha)
    conparentnode=node.getNextNode;

dynparentnode=conparentnode;
    count=0;
    while(1)
        dynparentnode=dynparentnode.getNextNode;
        
        if(strcmp(char(dynparentnode.getName),'Dynamic')==1)
        break;
        else
            continue;
        end
    end 
           childNode = uitreenode('v0','dummy', 'Alpha', [], 0);
[I] = imread('Icons/icon_conn.png');
        javaImage_eeg = im2java(I);
        childNode.setIcon(javaImage_eeg);
        treeModel.insertNodeInto(childNode,dynparentnode,dynparentnode.getChildCount()); 
        % expand to show added child
        tree.setSelectedNode( childNode );
        % insure additional nodes are added to parent
        tree.setSelectedNode( dynparentnode );

    
end
if(createdynamic.beta)
     conparentnode=node.getNextNode;

dynparentnode=conparentnode;
    count=0;
    while(1)
        dynparentnode=dynparentnode.getNextNode;
        
        if(strcmp(char(dynparentnode.getName),'Dynamic')==1)
        break;
        else
            continue;
        end
    end 
           childNode = uitreenode('v0','dummy', 'Beta', [], 0);
[I] = imread('Icons/icon_conn.png');
        javaImage_eeg = im2java(I);
        childNode.setIcon(javaImage_eeg);
        treeModel.insertNodeInto(childNode,dynparentnode,dynparentnode.getChildCount()); 
        % expand to show added child
        tree.setSelectedNode( childNode );
        % insure additional nodes are added to parent
        tree.setSelectedNode( dynparentnode );

    
end
if(createdynamic.gamma)
    conparentnode=node.getNextNode;

dynparentnode=conparentnode;
    count=0;
    while(1)
        dynparentnode=dynparentnode.getNextNode;
        
        if(strcmp(char(dynparentnode.getName),'Dynamic')==1)
        break;
        else
            continue;
        end
    end 
           childNode = uitreenode('v0','dummy', 'Gamma', [], 0);
[I] = imread('Icons/icon_conn.png');
        javaImage_eeg = im2java(I);
        childNode.setIcon(javaImage_eeg);
        treeModel.insertNodeInto(childNode,dynparentnode,dynparentnode.getChildCount()); 
        % expand to show added child
        tree.setSelectedNode( childNode );
        % insure additional nodes are added to parent
        tree.setSelectedNode( dynparentnode );

    
end
if(createdynamic.bb)
    conparentnode=node.getNextNode;

dynparentnode=conparentnode;
    count=0;
    while(1)
        dynparentnode=dynparentnode.getNextNode;
        
        if(strcmp(char(dynparentnode.getName),'Dynamic')==1)
        break;
        else
            continue;
        end
    end 
           childNode = uitreenode('v0','dummy', 'bb', [], 0);
[I] = imread('Icons/icon_conn.png');
        javaImage_eeg = im2java(I);
        childNode.setIcon(javaImage_eeg);
        treeModel.insertNodeInto(childNode,dynparentnode,dynparentnode.getChildCount()); 
        % expand to show added child
        tree.setSelectedNode( childNode );
        % insure additional nodes are added to parent
        tree.setSelectedNode( dynparentnode );

    
end
if(createdynamic.custom)
    conparentnode=node.getNextNode;

dynparentnode=conparentnode;
    count=0;
    while(1)
        dynparentnode=dynparentnode.getNextNode;
        
        if(strcmp(char(dynparentnode.getName),'Dynamic')==1)
        break;
        else
            continue;
        end
    end 
           childNode = uitreenode('v0','dummy', 'Custom', [], 0);
[I] = imread('Icons/icon_conn.png');
        javaImage_eeg = im2java(I);
        childNode.setIcon(javaImage_eeg);
        treeModel.insertNodeInto(childNode,dynparentnode,dynparentnode.getChildCount()); 
        % expand to show added child
        tree.setSelectedNode( childNode );
        % insure additional nodes are added to parent
        tree.setSelectedNode( dynparentnode );

    
end

end
 
end


    
end
   end
           
% %         should add connectivity node with all subnodes for the selected
% node
end
% msgbox('Done');
closereq;

% --- Executes on button press in push_cancel.
      %Close the actual GUI

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

% --- Executes on button press in theta_check.
function theta_check_Callback(hObject, eventdata, handles)
% hObject    handle to theta_check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of theta_check


% --- Executes on button press in delta_check.
function delta_check_Callback(hObject, eventdata, handles)
% hObject    handle to delta_check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of delta_check


% --- Executes on button press in alpha_check.
function alpha_check_Callback(hObject, eventdata, handles)
% hObject    handle to alpha_check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of alpha_check


% --- Executes on button press in beta_check.
function beta_check_Callback(hObject, eventdata, handles)
% hObject    handle to beta_check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of beta_check


% --- Executes on button press in gamma_check.
function gamma_check_Callback(hObject, eventdata, handles)
% hObject    handle to gamma_check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of gamma_check


% --- Executes on button press in custom_check.
function custom_check_Callback(hObject, eventdata, handles)
% hObject    handle to custom_check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of custom_check
val= get(handles.custom_check, 'Value');
switch(val)
    case 1
set(handles.minfreq_edit,'Visible','on')
set(handles.maxfreq_edit,'Visible','on')
set(handles.text13,'Visible','on')
    case 0
        set(handles.minfreq_edit,'Visible','off')
set(handles.maxfreq_edit,'Visible','off')
set(handles.text13,'Visible','off')
end



function minfreq_edit_Callback(hObject, eventdata, handles)
% hObject    handle to minfreq_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of minfreq_edit as text
%        str2double(get(hObject,'String')) returns contents of minfreq_edit as a double


% --- Executes during object creation, after setting all properties.
function minfreq_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to minfreq_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function maxfreq_edit_Callback(hObject, eventdata, handles)
% hObject    handle to maxfreq_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of maxfreq_edit as text
%        str2double(get(hObject,'String')) returns contents of maxfreq_edit as a double


% --- Executes during object creation, after setting all properties.
function maxfreq_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maxfreq_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in bb_check.
function bb_check_Callback(hObject, eventdata, handles)
% hObject    handle to bb_check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bb_check


% --- Executes on button press in st_check.
function st_check_Callback(hObject, eventdata, handles)
% hObject    handle to st_check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of st_check


% --- Executes on button press in dyn_check.
function dyn_check_Callback(hObject, eventdata, handles)
% hObject    handle to dyn_check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of dyn_check
val= get(handles.dyn_check, 'Value');
switch(val)
    case 1
set(handles.overlap_edit,'Visible','on')
set(handles.text14,'Visible','on')
    case 0
set(handles.overlap_edit,'Visible','off')
set(handles.text14,'Visible','off')
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

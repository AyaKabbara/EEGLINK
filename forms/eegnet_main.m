function varargout = eegnet_main(varargin)
% eegnet_main MATLAB code for eegnet_main.fig
%      eegnet_main, by `````itself, creates a new eegnet_main or raises the existing
%      singleton*.
%
%      H = eegnet_main returns the handle to a new eegnet_main or the handle to
%      the cexisting singleton*.
%
%      eegnet_main('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in eegnet_main.M with the given input arguments.
%
%      eegnet_main('Property','Value',...) creates a new eegnet_main or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before eegnet_main_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to eegnet_main_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help eegnet_main

% Last Modified by GUIDE v2.5 23-Aug-2021 22:22:23

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @eegnet_main_OpeningFcn, ...
                   'gui_OutputFcn',  @eegnet_main_OutputFcn, ...
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


% --- Executes just before eegnet_main is made visible.
function eegnet_main_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to eegnet_main (see VARARGIN)
import javax.swing.*
import javax.swing.tree.*;
% Choose default command line output for eegnet_main
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
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
global fig1;
global jRangeSlider;
global javaImage_subj;
global tree;
global treeModel;
global rootNode;
global plotting_panel;
global info_panel;
global numberSubjects;
global allsubjects;
global alleegs; 
global alleegs_preprocessed;
global alleegs_preprocessed_interp;
global allepochs;
global allepochs_preprocessed;
global allepochs_preprocessed_interp;
global allmodels;
global allnoise;
global alleegs_src;
global allepochs_src;
global alleegs_preprocessed_src;
global allepochs_preprocessed_src;
global alleegs_src_conn;
global allepochs_src_conn;
global alleegs_preprocessed_src_conn;
global allepochs_preprocessed_src_conn;
global GlobalData;
global label_time;
global opaque;
global handelll;


handelll=handles;
% % alleegs=cell array of EEGlab structures.
opaque=handles.text8;
plotting_panel=handles.plot_panel;
label_time=handles.text_time;
info_panel=handles.info_panel;
fig1=handles.axes1;
numberSubjects=0;
allsubjects=struct();
alleegs={};
alleegs_preprocessed={};
allepochs={};
allepochs_preprocessed={};
alleegs_preprocessed_src={};
allepochs_src={};
allepochs_preprocessed_src={};
alleegs_src={};
alleegs_src_conn={};
allepochs_src_conn={};
alleegs_preprocessed_src_conn={};
allepochs_preprocessed_src_conn={};


set(handles.plot_panel,'Visible','off');
set(info_panel,'Visible','off');
% set(info_panel, 'Units', 'normalized', 'position', [0.02 0.05 0.3 0.3]);


% UIWAIT makes opening_window wait for user response (see UIRESUME)
% uiwait(handles.figure1);
% create an axes that spans the whole gui
% ah = axes('unit', 'normalized', 'position', [0 0 1 1]); 
% % import the background image and show it on the axes
% bg = imread('opening_new/opening_new.006.jpeg'); imagesc(bg);
% % prevent plotting over the background and turn the axis off
% set(ah,'handlevisibility','off','visible','off')
% % making sure the background is behind all the other uicontrols
% uistack(ah, 'bottom');


% create top node

[I] = imread('Icons/database_navy1.png');
javaImage_database = im2java(I);
[I] = imread('Icons/subj_navy.png');

[YourImage, ~, ImageAlpha] = imread('Icons/logo_eegnet_greybkg.png');
axes(handles.axes2);
% imshow(myImage);
imshow(YourImage)
set(handles.figure1, 'Name', 'EEGLink');
uistack(handles.figure1,'top');

[YourImage, ~, ImageAlpha] = imread('Icons/panel_data.png');
axes(handles.axes7);

% imshow(myImage);
imshow(YourImage)

[YourImage, ~, ImageAlpha] = imread('Icons/panel_view.png');
axes(handles.axes8);

% imshow(myImage);
imshow(YourImage)

[YourImage, ~, ImageAlpha] = imread('Icons/panel_info.png');
axes(handles.axes9);
% imshow(myImage);
imshow(YourImage)

javaImage_subj = im2java(I);
rootNode = uitreenode('v0','root', 'Subjects',[], 0);
rootNode.setIcon(javaImage_database);  
% set treeModel
treeModel = DefaultTreeModel( rootNode );
 
% create the tree
parent_tree=handles.uipanel4;
[tree, container] = uitree('v0', 'Root','Subjects', 'Parent',parent_tree); % Parent is ignored
set(container, 'Parent', parent_tree);  
% tree.getTree.setBackground(java.awt.Color(0.94,0.94,0.94));
tree.setModel( treeModel );
% some layout
set(tree,'Units', 'normalized', 'position', [0.04 0.0000001 0.92 0.89]);

drawnow;
% uistack(tree, 'top');
tree.setSelectedNode(rootNode );
% we often rely on the underlying java tree
jtree = handle(tree.getTree,'CallbackProperties');
% set(jtree,'Opaque',0)
set(jtree, 'MousePressedCallback', @mousePressedCallback);
% Prepare the context menu (note the use of HTML labels)
jmenu = javax.swing.JPopupMenu;
% set(jtree,'Background',javax.swing.plaf.ColorUIResource(0.3,0.3,0.3))

drawnow;

set(jtree, 'MousePressedCallback', {@mousePressedCallback,jmenu});
% Set the mouse-press callback
set(jtree, 'MouseClickedCallback', {@mouseClickedCallback,jmenu});
load('data/GlobalData.mat');
uistack(handles.figure1,'top');

function New_callback(jButtonNew, eventData)
    % The following comments refer to the case of Alt-Shift-b
    Form_New();
    
function mousePressedCallback(hTree, eventData, jmenu)
   if eventData.isMetaDown  % right-click is like a Meta-button
      % Get the clicked node 
      clickX = eventData.getX;
      clickY = eventData.getY;
      jtree = eventData.getSource;
      treePath = jtree.getPathForLocation(clickX, clickY);
         
      if(get(jmenu,'ComponentCount')>0)
          for nItems=1:get(jmenu,'ComponentCount')
          jmenu.remove(0);           
          end

      end
          
      try
         % Modify the context menu or some other element
         % based on the clicked node. 
         
% %          start by deleting all items

         node = treePath.getLastPathComponent;
         nodeName = char(node.getName);
         
         if(strcmp(nodeName,'Subjects'))||(strcmp(nodeName,'Database'))
             % %              A menu for a subject
             menuItem1 = javax.swing.JMenuItem('Preprocess');
             menuItem2 = javax.swing.JMenuItem('Reconstruct sources');
             menuItem3 = javax.swing.JMenuItem('Compute connectivity');
             menuItem4 = javax.swing.JMenuItem('Delete');
   
             jmenu.add(menuItem1);
             jmenu.add(menuItem2);
             jmenu.add(menuItem3);
             jmenu.add(menuItem4);

              set(menuItem1,'ActionPerformedCallback',{@Preprocess_manysubjects,node});
              set(menuItem2,'ActionPerformedCallback',{@Reconstruct_manysubjects,node});
              set(menuItem3,'ActionPerformedCallback',{@Connectivity_manysubjects,node});
%              set(menuItem4,'ActionPerformedCallback',{@Connectivity_segments,node});
          end
         
         
         if(strcmp(nodeName(1:2),'S_'))
             % %              A menu for a subject
             menuItem1 = javax.swing.JMenuItem('Import EEG');
             menuItem2 = javax.swing.JMenuItem('Preprocessing');
             menuItem3 = javax.swing.JMenuItem('Reconstruct sources');
            menuItem4 = javax.swing.JMenuItem('Compute connectivity');
             menuItem5 = javax.swing.JMenuItem('Delete subject');
             
             jmenu.add(menuItem1);
             jmenu.add(menuItem2);
             jmenu.add(menuItem3);
             jmenu.add(menuItem4);
jmenu.add(menuItem5);

             set(menuItem1,'ActionPerformedCallback',{@Import_EEG,node,jmenu});
             set(menuItem2,'ActionPerformedCallback',{@Preprocess_segments,node});
             set(menuItem3,'ActionPerformedCallback',{@Reconstruct_segments,node});
             set(menuItem4,'ActionPerformedCallback',{@Connectivity_segments,node});
             set(menuItem5,'ActionPerformedCallback',{@Delete_subject,node});
         end
         
         
          if(strcmp(nodeName,'Noise covariance matrix'))
             % %              A menu for a subject
             menuItem1 = javax.swing.JMenuItem('Plot matrix');
             menuItem2 = javax.swing.JMenuItem('Delete Matrix');
             jmenu.add(menuItem1);
             jmenu.add(menuItem2);
             set(menuItem1,'ActionPerformedCallback',{@Plot_matrix,node});
%              set(menuItem2,'ActionPerformedCallback',{@Plot_network,node});
%              set(menuItem3,'ActionPerformedCallback',{@Reconstruct_segments,node});
            end
      
         
            if((strcmp(nodeName,'Alpha'))||(strcmp(nodeName,'Delta'))||(strcmp(nodeName,'Theta'))||(strcmp(nodeName,'Beta'))||(strcmp(nodeName,'Gamma'))||(strcmp(nodeName,'Broadband'))||(strcmp(nodeName,'Custom')))
             % %              A menu for a subject
             menuItem1 = javax.swing.JMenuItem('Plot matrix');
             menuItem2 = javax.swing.JMenuItem('Visualize network');
             menuItem3 = javax.swing.JMenuItem('Quantify graph');
             menuItem4 = javax.swing.JMenuItem('Save Matrix (.mat)');
%              menuItem5 = javax.swing.JMenuItem('Delete Matrix');
             
             jmenu.add(menuItem1);
             jmenu.add(menuItem2);
             jmenu.add(menuItem3);
             jmenu.add(menuItem4);
%              jmenu.add(menuItem5);

             set(menuItem1,'ActionPerformedCallback',{@Plot_matrix,node});
             set(menuItem2,'ActionPerformedCallback',{@Plot_network,node});
              set(menuItem3,'ActionPerformedCallback',{@Plot_graph,node});
             set(menuItem4,'ActionPerformedCallback',{@save_clicked,node});
%              set(menuItem5,'ActionPerformedCallback',{@delete_clicked,node});

            end
            if(strcmp(nodeName,'Connectivity'))
             % %              A menu for a subject
             menuItem1 = javax.swing.JMenuItem('Delete all connectivity matrices');                        
             jmenu.add(menuItem1);            
             set(menuItem1,'ActionPerformedCallback',{@delete_clicked,node});
            

            end
         if(strcmp(nodeName,'EEG_preprocessed'))
             menuItem1 = javax.swing.JMenuItem('Plot in a new window');
             menuItem2 = javax.swing.JMenuItem('Use this for noise covariance calculation');
             menuItem3 = javax.swing.JMenuItem('Reconstruct sources'); 
             menuItem4 = javax.swing.JMenuItem('Quality of the preprocessing'); 
             
             menuItem5 = javax.swing.JMenuItem('Save preprocessed EEG (.mat)');
             menuItem6 = javax.swing.JMenuItem('Delete preprocessed EEG');

             jmenu.add(menuItem1);
             jmenu.add(menuItem2);
           jmenu.add(menuItem3);
             jmenu.add(menuItem4);
             jmenu.add(menuItem5);
             jmenu.addSeparator;
             jmenu.add(menuItem6);

             set(menuItem1,'ActionPerformedCallback',{@Plot_new_window,node});
             set(menuItem2,'ActionPerformedCallback',{@NoiseCovariance_calculation,node});
             set(menuItem3,'ActionPerformedCallback',{@Reconstruct_sources,node});
             set(menuItem4,'ActionPerformedCallback',{@Info_preprocessing,node});

             set(menuItem5,'ActionPerformedCallback',{@save_clicked,node});
              set(menuItem6,'ActionPerformedCallback',{@Delete_EEG,node});

         end
          if(strcmp(nodeName,'EEG'))
             menuItem1 = javax.swing.JMenuItem('Pre-process EEG');
             menuItem2 = javax.swing.JMenuItem('Plot in a new window');
             menuItem3 = javax.swing.JMenuItem('Divide into epochs');
             menuItem4 = javax.swing.JMenuItem('Use for noise covariance calculation');
             menuItem5 = javax.swing.JMenuItem('Reconstruct sources');  
             menuItem6 = javax.swing.JMenuItem('Delete EEG');
             jmenu.add(menuItem1);
             jmenu.add(menuItem2);
             jmenu.add(menuItem3);
                          jmenu.add(menuItem4);

             jmenu.add(menuItem5);
             jmenu.addSeparator;
             jmenu.add(menuItem6);
             set(menuItem1,'ActionPerformedCallback',{@PreProcess_EEG,node});
             set(menuItem2,'ActionPerformedCallback',{@Plot_new_window,node});
             set(menuItem3,'ActionPerformedCallback',{@Segment_EEG,node});
             set(menuItem4,'ActionPerformedCallback',{@NoiseCovariance_calculation,node});

              set(menuItem5,'ActionPerformedCallback',{@Reconstruct_sources,node});
             set(menuItem6,'ActionPerformedCallback',{@Delete_EEG,node});
% %              A menu for a subject
          else
           
             if(strcmp(nodeName(1:6),'Epoch_'))
             menuItem1 = javax.swing.JMenuItem('Pre-process epoch');
             menuItem2 = javax.swing.JMenuItem('Plot in a new window');
             menuItem3 = javax.swing.JMenuItem('Use for noise covariance calculation');

             menuItem4 = javax.swing.JMenuItem('Reconstruct sources');  
            menuItem5 = javax.swing.JMenuItem('Save epoch (.mat)');  

             menuItem6 = javax.swing.JMenuItem('Delete epoch');
             jmenu.add(menuItem1);
             jmenu.add(menuItem2);
             jmenu.add(menuItem3);
             jmenu.add(menuItem4);
             jmenu.add(menuItem5);

             jmenu.addSeparator;
             jmenu.add(menuItem6);
             set(menuItem1,'ActionPerformedCallback',{@PreProcess_segment,node});
             set(menuItem2,'ActionPerformedCallback',{@Plot_new_window,node});
             set(menuItem3,'ActionPerformedCallback',{@NoiseCovariance_calculation,node});

             set(menuItem4,'ActionPerformedCallback',{@Reconstruct_sources,node});
              set(menuItem5,'ActionPerformedCallback',{@save_clicked,node});

              set(menuItem6,'ActionPerformedCallback',{@Delete_segment,node});
% %              A menu for a subject
             else
      
             if(strcmp(nodeName(1:12),'Preprocessed'))
             menuItem1 = javax.swing.JMenuItem('Plot in a new window');
             menuItem2 = javax.swing.JMenuItem('Use for noise covariance calculation');
             menuItem3 = javax.swing.JMenuItem('Reconstruct sources');  
             menuItem4 = javax.swing.JMenuItem('Quality of the preprocessing');
             menuItem5 = javax.swing.JMenuItem('Save preprocessed epoch (.mat)');

             menuItem6 = javax.swing.JMenuItem('Delete epoch');
             
             jmenu.add(menuItem1);
             jmenu.add(menuItem2);
             jmenu.add(menuItem3);
                          jmenu.add(menuItem4);
                          jmenu.add(menuItem5);

             jmenu.addSeparator;
             jmenu.add(menuItem6);

             set(menuItem1,'ActionPerformedCallback',{@Plot_new_window,node});
             set(menuItem3,'ActionPerformedCallback',{@Reconstruct_sources,node});
             set(menuItem2,'ActionPerformedCallback',{@NoiseCovariance_calculation,node});
              set(menuItem5,'ActionPerformedCallback',{@save_clicked,node});
              set(menuItem4,'ActionPerformedCallback',{@Info_preprocessing,node});


              set(menuItem6,'ActionPerformedCallback',{@Delete_pre_segment,node});
% %              A menu for a subject
             else
                 
                 if(strcmp(nodeName(1:13),'Reconstructed'))
             menuItem1 = javax.swing.JMenuItem('Plot in a new window');
             menuItem2 = javax.swing.JMenuItem('Compute connectivity');
             menuItem3 = javax.swing.JMenuItem('Save reconstructed signals (.mat)');

             menuItem4 = javax.swing.JMenuItem('Delete');
             jmenu.add(menuItem1);
             jmenu.add(menuItem2);
             jmenu.add(menuItem3);
             
             jmenu.addSeparator;
             jmenu.add(menuItem4);

             set(menuItem1,'ActionPerformedCallback',{@Plot_new_window,node});
             set(menuItem2,'ActionPerformedCallback',{@Compute_connectivity,node});
             set(menuItem3,'ActionPerformedCallback',{@save_clicked,node});
             set(menuItem4,'ActionPerformedCallback',{@delete_clicked,node});

             end
             end
             end
          end
   
      catch
         % clicked location is NOT on top of any node
         % Note: can also be tested by isempty(treePath)
      end
      jtree = eventData.getSource;
      treePath = jtree.getPathForLocation(clickX, clickY);
      jmenu.show(jtree, clickX, clickY);
      jmenu.repaint;
   end

function save_clicked(hObject, eventData,node)
   
global alleegs;
global allsubjects;
global alleegs_preprocessed;
global allepochs;
global allepochs_preprocessed;
global alleegs_src;
global allepochs_src;
global alleegs_preprocessed_src;
global allepochs_preprocessed_src;
global alleegs_src_conn;
global allepochs_src_conn;
global alleegs_preprocessed_src_conn;
global allepochs_preprocessed_src_conn;

node_in=node;
nodeName = char(node.getName);

if(strcmp(nodeName,'Delta'))||(strcmp(nodeName,'Theta'))||(strcmp(nodeName,'Alpha'))||(strcmp(nodeName,'Beta'))||(strcmp(nodeName,'Gamma'))||(strcmp(nodeName,'Custom'))||(strcmp(nodeName,'Broadband'))
                 band = char(node.getName);
% % Theta, beta,... etc

                % % parent=static or dynamic
                subjectParent=node.getParent;
                staticordynamic=char(subjectParent.getName);
                % % parent= reconstructed signal
                subjectParent=subjectParent.getParent;
                subjectParent=subjectParent.getParent;

                nodeName=char(subjectParent.getName);
                node=subjectParent;
                
                if(strcmp(nodeName,'Reconstructed EEG'))
                 subjectParent=node.getParent;
                 subjectname=char(subjectParent.getName);
                 subjectname=subjectname(3:end);
                % %          index of the subject to show its eeg in the figure
                 subjIndex=find(strcmp(allsubjects.names, subjectname));
                %              pathfile= allsubjects.paths{subjIndex};
                 data=alleegs_src_conn{subjIndex}; 
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
                 data=allepochs_src_conn{subjIndex,number};  
                 
                else
                          if(strcmp(nodeName,'Reconstructed Preprocessed EEG'))
                     subjectParent=node.getParent;
                     subjectParent=subjectParent.getParent;       
                     subjectname=char(subjectParent.getName);
                     subjectname=subjectname(3:end);
                % %          index of the subject to show its eeg in the figure
                     subjIndex=find(strcmp(allsubjects.names, subjectname));
                %              pathfile= allsubjects.paths{subjIndex};

                     data=alleegs_preprocessed_src_conn{subjIndex};
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
                         data=allepochs_preprocessed_src_conn{subjIndex,number};
                       end
                          end

                end
            end

          
                 if(strcmp(staticordynamic,'Static'))
                 data=data.conn.static;
                 switch (band)
                     case 'Alpha'
                         mat=data.alpha;
                     case 'Theta'
                        mat=data.theta;
                     case 'Gamma'
                        mat=data.gamma;
                     case 'Beta'
                        mat=data.beta;
                     case 'Delta'
                        mat=data.delta;
                      case 'Broadband'
                        mat=data.bb;
                        case 'Custom'
                        mat=data.custom;
                 end
                                   uisave('mat');


                 else
                     
                     
                  data=data.conn.dynamic;
                  switch (band)
                     case 'Alpha'
                         mat=data.alpha;
                     case 'Theta'
                        mat=data.theta;
                     case 'Gamma'
                        mat=data.gamma;
                     case 'Beta'
                        mat=data.beta;
                     case 'Delta'
                        mat=data.delta;
                      case 'Broadband'
                        mat=data.bb;
                        case 'Custom'
                        mat=data.custom;
                  end
                  
% %                   save the matrix
                    uisave('mat');
                  end
         
          else
          node=node_in;
           
          nodeName = char(node.getName);
                
          if(strcmp(nodeName,'EEG_preprocessed'))
             subjectParent=node.getParent;
             subjectname=char(subjectParent.getName);
             subjectname=subjectname(3:end);
% %          index of the subject to show its eeg in the figure
             subjIndex=find(strcmp(allsubjects.names, subjectname));
%              pathfile= allsubjects.paths{subjIndex};
             EEG=alleegs_preprocessed{subjIndex};
             data=EEG.data;
             uisave('data');
           
          else
         
         if(strcmp(nodeName(1:6),'Epoch_'))
             subjectParent=node.getParent;
             subjectParent=subjectParent.getParent;
             subjectname=char(subjectParent.getName);
             subjectname=subjectname(3:end);
% %          index of the subject to show its eeg in the figure
             subjIndex=find(strcmp(allsubjects.names, subjectname));
%              pathfile= allsubjects.paths{subjIndex};
             number=str2double(nodeName(7:end));
             EEG=allepochs{subjIndex,number};
           data=EEG.data;
             uisave('data');
         else
         
             if(strcmp(nodeName(1:12),'Preprocessed'))
             subjectParent=node.getParent;
             subjectParent=subjectParent.getParent;
             subjectParent=subjectParent.getParent;
             subjectname=char(subjectParent.getName);
             subjectname=subjectname(3:end);
% %          index of the subject to show its eeg in the figure
             subjIndex=find(strcmp(allsubjects.names, subjectname));
%              pathfile= allsubjects.paths{subjIndex};
             number=str2num(nodeName(20:end));
             EEG=allepochs_preprocessed{subjIndex,number};
             data=EEG.data;
             uisave('data');
             
             else
                 if(strcmp(nodeName,'Reconstructed EEG'))
                     subjectParent=node.getParent;
                     subjectname=char(subjectParent.getName);
                     subjectname=subjectname(3:end);
                    % %          index of the subject to show its eeg in the figure
                     subjIndex=find(strcmp(allsubjects.names, subjectname));
                    %              pathfile= allsubjects.paths{subjIndex};
                     sigsrc=alleegs_src{subjIndex};
                     uisave('sigsrc');

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
                 sigsrc=allepochs_src{subjIndex,number};  
                 uisave('sigsrc');

                else
                          if(strcmp(nodeName,'Reconstructed Preprocessed EEG'))
                     subjectParent=node.getParent;
                     subjectParent=subjectParent.getParent;       
                     subjectname=char(subjectParent.getName);
                     subjectname=subjectname(3:end);
                % %          index of the subject to show its eeg in the figure
                     subjIndex=find(strcmp(allsubjects.names, subjectname));
                %              pathfile= allsubjects.paths{subjIndex};

                     sigsrc=alleegs_preprocessed_src{subjIndex};
                     uisave('sigsrc');

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
                         sigsrc=allepochs_preprocessed_src{subjIndex,number};
                         uisave('sigsrc');

                       end
                          end
                 end
                          

                 end
             end
         end
          end
end

function delete_clicked(hObject, eventData,node)
% %    delete reconstructed signals, or connectivity matrices

global treeModel;
global alleegs;
global allsubjects;
global alleegs_preprocessed;
global allepochs;
global allepochs_preprocessed;
global alleegs_src;
global allepochs_src;
global alleegs_preprocessed_src;
global allepochs_preprocessed_src;
global alleegs_src_conn;
global allepochs_src_conn;
global alleegs_preprocessed_src_conn;
global allepochs_preprocessed_src_conn;

node_in=node;
nodeName = char(node.getName);

if(strcmp(nodeName,'Delta'))||(strcmp(nodeName,'Theta'))||(strcmp(nodeName,'Alpha'))||(strcmp(nodeName,'Beta'))||(strcmp(nodeName,'Gamma'))||(strcmp(nodeName,'Custom'))||(strcmp(nodeName,'Broadband'))
                 band = char(node.getName);
% % Theta, beta,... etc

                % % parent=static or dynamic
                subjectParent=node.getParent;
                staticordynamic=char(subjectParent.getName);
                % % parent= reconstructed signal
                subjectParent=subjectParent.getParent;
                subjectParent=subjectParent.getParent;

                nodeName=char(subjectParent.getName);
                node=subjectParent;
                
                if(strcmp(nodeName,'Reconstructed EEG'))
                 subjectParent=node.getParent;
                 subjectname=char(subjectParent.getName);
                 subjectname=subjectname(3:end);
                % %          index of the subject to show its eeg in the figure
                 subjIndex=find(strcmp(allsubjects.names, subjectname));
                %              pathfile= allsubjects.paths{subjIndex};
                 data=alleegs_src_conn{subjIndex}; 
                  if(strcmp(staticordynamic,'Static'))
                 switch (band)
                     case 'Alpha'
                         alleegs_src_conn{subjIndex}.conn.static.alpha=[];
                     case 'Theta'
                         alleegs_src_conn{subjIndex}.conn.static.theta=[];
                     case 'Gamma'
                         alleegs_src_conn{subjIndex}.conn.static.gamma=[];
                     case 'Beta'
                         alleegs_src_conn{subjIndex}.conn.static.beta=[];
                     case 'Delta'
                         alleegs_src_conn{subjIndex}.conn.static.delta=[];
                      case 'Broadband'
                         alleegs_src_conn{subjIndex}.conn.static.bb=[];
                        case 'Custom'
                         alleegs_src_conn{subjIndex}.conn.static.custom=[];
                 end


                 else
                     
                     
                  switch (band)
                     case 'Alpha'
                         alleegs_src_conn{subjIndex}.conn.dynamic.alpha=[];
                     case 'Theta'
                         alleegs_src_conn{subjIndex}.conn.dynamic.theta=[];
                     case 'Gamma'
                         alleegs_src_conn{subjIndex}.conn.dynamic.gamma=[];
                     case 'Beta'
                         alleegs_src_conn{subjIndex}.conn.dynamic.beta=[];
                     case 'Delta'
                         alleegs_src_conn{subjIndex}.conn.dynamic.delta=[];
                      case 'Broadband'
                         alleegs_src_conn{subjIndex}.conn.dynamic.bb=[];
                        case 'Custom'
                         alleegs_src_conn{subjIndex}.conn.dynamic.custom=[];
                  end
                  
% %                   save the matrix
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
                 data=allepochs_src_conn{subjIndex,number};  
                   if(strcmp(staticordynamic,'Static'))
                 switch (band)
                     case 'Alpha'
                         allepochs_src_conn{subjIndex,number}.conn.static.alpha=[];
                     case 'Theta'
                         allepochs_src_conn{subjIndex,number}.conn.static.theta=[];
                     case 'Gamma'
                         allepochs_src_conn{subjIndex,number}.conn.static.gamma=[];
                     case 'Beta'
                         allepochs_src_conn{subjIndex,number}.conn.static.beta=[];
                     case 'Delta'
                         allepochs_src_conn{subjIndex,number}.conn.static.delta=[];
                      case 'Broadband'
                         allepochs_src_conn{subjIndex,number}.conn.static.bb=[];
                        case 'Custom'
                         allepochs_src_conn{subjIndex,number}.conn.static.custom=[];
                 end


                 else
                     
                     
                  switch (band)
                     case 'Alpha'
                         allepochs_src_conn{subjIndex,number}.conn.dynamic.alpha=[];
                     case 'Theta'
                         allepochs_src_conn{subjIndex,number}.conn.dynamic.theta=[];
                     case 'Gamma'
                         allepochs_src_conn{subjIndex,number}.conn.dynamic.gamma=[];
                     case 'Beta'
                        allepochs_src_conn{subjIndex,number}.conn.dynamic.beta=[];
                     case 'Delta'
                         allepochs_src_conn{subjIndex,number}.conn.dynamic.delta=[];
                      case 'Broadband'
                         allepochs_src_conn{subjIndex,number}.conn.dynamic.bb=[];
                        case 'Custom'
                         allepochs_src_conn{subjIndex,number}.conn.dynamic.custom=[];
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

                     data=alleegs_preprocessed_src_conn{subjIndex};
                      if(strcmp(staticordynamic,'Static'))
                 switch (band)
                     case 'Alpha'
                         alleegs_preprocessed_src_conn{subjIndex}.conn.static.alpha=[];
                     case 'Theta'
                         alleegs_preprocessed_src_conn{subjIndex}.conn.static.theta=[];
                     case 'Gamma'
                         alleegs_preprocessed_src_conn{subjIndex}.conn.static.gamma=[];
                     case 'Beta'
                         alleegs_preprocessed_src_conn{subjIndex}.conn.static.beta=[];
                     case 'Delta'
                         alleegs_preprocessed_src_conn{subjIndex}.conn.static.delta=[];
                      case 'Broadband'
                         alleegs_preprocessed_src_conn{subjIndex}.conn.static.bb=[];
                        case 'Custom'
                         alleegs_preprocessed_src_conn{subjIndex}.conn.static.custom=[];
                 end


                 else
                     
                     
                  switch (band)
                     case 'Alpha'
                         alleegs_preprocessed_src_conn{subjIndex}.conn.dynamic.alpha=[];
                     case 'Theta'
                         alleegs_preprocessed_src_conn{subjIndex}.conn.dynamic.theta=[];
                     case 'Gamma'
                         alleegs_preprocessed_src_conn{subjIndex}.conn.dynamic.gamma=[];
                     case 'Beta'
                         alleegs_preprocessed_src_conn{subjIndex}.conn.dynamic.beta=[];
                     case 'Delta'
                         alleegs_preprocessed_src_conn{subjIndex}.conn.dynamic.delta=[];
                      case 'Broadband'
                         alleegs_preprocessed_src_conn{subjIndex}.conn.dynamic.bb=[];
                        case 'Custom'
                         alleegs_preprocessed_src_conn{subjIndex}.conn.dynamic.custom=[];
                  end
                  
% %                   save the matrix
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
                         data=allepochs_preprocessed_src_conn{subjIndex,number};
                         
                          if(strcmp(staticordynamic,'Static'))
                 switch (band)
                     case 'Alpha'
                         allepochs_preprocessed_src_conn{subjIndex,number}.conn.static.alpha=[];
                     case 'Theta'
                         allepochs_preprocessed_src_conn{subjIndex,number}.conn.static.theta=[];
                     case 'Gamma'
                         allepochs_preprocessed_src_conn{subjIndex,number}.conn.static.gamma=[];
                     case 'Beta'
                         allepochs_preprocessed_src_conn{subjIndex,number}.conn.static.beta=[];
                     case 'Delta'
                         allepochs_preprocessed_src_conn{subjIndex,number}.conn.static.delta=[];
                      case 'Broadband'
                         allepochs_preprocessed_src_conn{subjIndex,number}.conn.static.bb=[];
                        case 'Custom'
                         allepochs_preprocessed_src_conn{subjIndex,number}.conn.static.custom=[];
                 end


                 else
                     
                     
                  switch (band)
                     case 'Alpha'
                         allepochs_preprocessed_src_conn{subjIndex,number}.conn.dynamic.alpha=[];
                     case 'Theta'
                         allepochs_preprocessed_src_conn{subjIndex,number}.conn.dynamic.theta=[];
                     case 'Gamma'
                         allepochs_preprocessed_src_conn{subjIndex,number}.conn.dynamic.gamma=[];
                     case 'Beta'
                        allepochs_preprocessed_src_conn{subjIndex,number}.conn.dynamic.beta=[];
                     case 'Delta'
                         allepochs_preprocessed_src_conn{subjIndex,number}.conn.dynamic.delta=[];
                      case 'Broadband'
                         allepochs_preprocessed_src_conn{subjIndex,number}.conn.dynamic.bb=[];
                        case 'Custom'
                         allepochs_preprocessed_src_conn{subjIndex,number}.conn.dynamic.custom=[];
                  end
                  
                  end
                       end
                          end

                end
                end 
         
          else
          node=node_in;
           
          nodeName = char(node.getName);
               
                           if(strcmp(nodeName,'Reconstructed EEG'))
                     subjectParent=node.getParent;
                     subjectname=char(subjectParent.getName);
                     subjectname=subjectname(3:end);
                    % %          index of the subject to show its eeg in the figure
                     subjIndex=find(strcmp(allsubjects.names, subjectname));
                    %              pathfile= allsubjects.paths{subjIndex};
                     alleegs_src{subjIndex}=[];
                     alleegs_src_conn{subjIndex}=struct();
                           else
          
                 if(strcmp(nodeName,'Connectivity'))
                     recEpochName=node.getParent;
                     

                    nodeName=char(recEpochName.getName);
                    node=recEpochName;
                
                if(strcmp(nodeName,'Reconstructed EEG'))
                 subjectParent=node.getParent;
                 subjectname=char(subjectParent.getName);
                 subjectname=subjectname(3:end);
                % %          index of the subject to show its eeg in the figure
                 subjIndex=find(strcmp(allsubjects.names, subjectname));
                %              pathfile= allsubjects.paths{subjIndex};
                 alleegs_src_conn{subjIndex}=struct();
                     
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
                 allepochs_src_conn{subjIndex,number}=struct();  
                 
                    else
                         if(strcmp(nodeName,'Reconstructed Preprocessed EEG'))
                     subjectParent=node.getParent;
                     subjectParent=subjectParent.getParent;       
                     subjectname=char(subjectParent.getName);
                     subjectname=subjectname(3:end);
                     subjIndex=find(strcmp(allsubjects.names, subjectname));
                     alleegs_preprocessed_src_conn{subjIndex}=struct();
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
                         allepochs_preprocessed_src_conn{subjIndex,number}=struct(); 
                       end
                         end
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
                 allepochs_src{subjIndex,number}=[];  
                 allepochs_src_conn{subjIndex,number}=struct();

                else
                          if(strcmp(nodeName,'Reconstructed Preprocessed EEG'))
                     subjectParent=node.getParent;
                     subjectParent=subjectParent.getParent;       
                     subjectname=char(subjectParent.getName);
                     subjectname=subjectname(3:end);
                % %          index of the subject to show its eeg in the figure
                     subjIndex=find(strcmp(allsubjects.names, subjectname));
                %              pathfile= allsubjects.paths{subjIndex};

                     alleegs_preprocessed_src{subjIndex}=[];
                     alleegs_preprocessed_src_conn{subjIndex}=struct();

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
                         allepochs_preprocessed_src{subjIndex,number}=[];
                         allepochs_preprocessed_src_conn{subjIndex,number}=struct();

                       end
                          end
                 end
                          

                 end
                           end
end
             
treeModel.removeNodeFromParent( node_in );
         


function Info_preprocessing(hObject, eventData,node)
   
global alleegs;
global allsubjects;
global alleegs_preprocessed;
global allepochs;
global allepochs_preprocessed;
global allepochs_preprocessed_interp;
global alleegs_preprocessed_interp;

node_in=node;
nodeName = char(node.getName);

          if(strcmp(nodeName,'EEG_preprocessed'))
             subjectParent=node.getParent;
             subjectname=char(subjectParent.getName);
             subjectname=subjectname(3:end);
% %          index of the subject to show its eeg in the figure
             subjIndex=find(strcmp(allsubjects.names, subjectname));
%              pathfile= allsubjects.paths{subjIndex};
             percInterp=alleegs_preprocessed_interp{subjIndex};
           
          else
         
   
         
             if(strcmp(nodeName(1:12),'Preprocessed'))
             subjectParent=node.getParent;
             subjectParent=subjectParent.getParent;
             subjectParent=subjectParent.getParent;
             subjectname=char(subjectParent.getName);
             subjectname=subjectname(3:end);
% %          index of the subject to show its eeg in the figure
             subjIndex=find(strcmp(allsubjects.names, subjectname));
%              pathfile= allsubjects.paths{subjIndex};
             number=str2num(nodeName(20:end));
             percInterp=allepochs_preprocessed_interp{subjIndex,number};
             
             end
            
          end 
          
          perc=percInterp*100;
          if(percInterp>0.15)
msgbox(['The percentage of interpolation is greater than 15% (' num2str(perc) '%)']);
          else              
    msgbox(['The percentage of interpolation is lower than 15% (' num2str(perc) '%)']);
          end
  
function mouseClickedCallback(hTree, eventData, jmenu)
   
global fig1;
global info_panel;
global plotting_panel;
global alleegs;
global allsubjects;
global alleegs_preprocessed;
global allepochs;
global allepochs_preprocessed;
global alleegs_src;
global allepochs_src;
global alleegs_preprocessed_src;
global allepochs_preprocessed_src;
global alleegs_src_conn;
global allepochs_src_conn;
global alleegs_preprocessed_src_conn;
global allepochs_preprocessed_src_conn;
global jRangeSlider;
global jSlider;
global label_time;
global opaque;

      clickX = eventData.getX;
      clickY = eventData.getY;
      jtree = eventData.getSource;
      treePath = jtree.getPathForLocation(clickX, clickY);
      set(label_time,'Visible','off');

      try
         % Modify the context menu or some other element
         % based on the clicked node. 
         
% %          start by deleting all items

         node = treePath.getLastPathComponent;
%          prop=get(node);
         nodeName = char(node.getName);
         
          if(strcmp(nodeName,'Delta'))||(strcmp(nodeName,'Theta'))||(strcmp(nodeName,'Alpha'))||(strcmp(nodeName,'Beta'))||(strcmp(nodeName,'Gamma'))||(strcmp(nodeName,'Custom'))||(strcmp(nodeName,'Broadband'))
                 band = char(node.getName);
% % Theta, beta,... etc

                % % parent=static or dynamic
                subjectParent=node.getParent;
                staticordynamic=char(subjectParent.getName);
                % % parent= reconstructed signal
                subjectParent=subjectParent.getParent;
                subjectParent=subjectParent.getParent;

                nodeName=char(subjectParent.getName);
                node=subjectParent;
if(strcmp(nodeName,'Reconstructed EEG'))
 subjectParent=node.getParent;
 subjectname=char(subjectParent.getName);
 subjectname=subjectname(3:end);
% %          index of the subject to show its eeg in the figure
 subjIndex=find(strcmp(allsubjects.names, subjectname));
%              pathfile= allsubjects.paths{subjIndex};
 data=alleegs_src_conn{subjIndex}; 
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
                 data=allepochs_src_conn{subjIndex,number};  
                 
                else
                          if(strcmp(nodeName,'Reconstructed Preprocessed EEG'))
                     subjectParent=node.getParent;
                     subjectParent=subjectParent.getParent;       
                     subjectname=char(subjectParent.getName);
                     subjectname=subjectname(3:end);
                % %          index of the subject to show its eeg in the figure
                     subjIndex=find(strcmp(allsubjects.names, subjectname));
                %              pathfile= allsubjects.paths{subjIndex};

                     data=alleegs_preprocessed_src_conn{subjIndex};
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
                         data=allepochs_preprocessed_src_conn{subjIndex,number};
                       end
                          end

                end
end


                 if(strcmp(staticordynamic,'Static'))
                 data=data.conn.static;
                 switch (band)
                     case 'Alpha'
                         mat=data.alpha;
                     case 'Theta'
                        mat=data.theta;
                     case 'Gamma'
                        mat=data.gamma;
                     case 'Beta'
                        mat=data.beta;
                     case 'Delta'
                        mat=data.delta;
                      case 'Broadband'
                        mat=data.bb;
                        case 'Custom'
                        mat=data.custom;
                 end
                

                imagesc(fig1,mat);
                
                axes(fig1) %select the current axes, the h holds the han

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

% Set TickLabels;

                colorbar
                set(opaque,'Visible','on');
                set(plotting_panel,'Visible','on');
                try
                jRangeSlider.setVisible(false);
                catch
                end
                try
                jSlider.setVisible(false);
                catch
                end
                    set(opaque,'Visible','on');
            
                grid on
                axis tight

                ylabel('ROIs','FontSize', 12);
                xlabel('ROIs','FontSize', 12);
                % % number of samples, pathfile
                set(info_panel,'Visible','on');
                jLabel = javaObjectEDT(javax.swing.JLabel(['<html><body style="background-color:rgb(240, 240, 240); color:rgb(33, 45, 107);"> <div align=left> <u> Subject name: </u></i>' subjectname '<BR>  <u> Type: </i></u>' 'Static connectivity matrix' '<BR>  <u> Number of ROIs: </i></u>' num2str(size(mat,2)) '<BR></body></div>']));
                [hjLabel, hContainer] = javacomponent(jLabel, [0,0,0,0], info_panel);
                set(hContainer, 'Units','norm', 'Pos',[0,0,1,1],'BackgroundColor',javax.swing.plaf.ColorUIResource(0.94,0.94,0.94))
                % Make the label (and its internal container) transparent
                jLabel.setOpaque(false)  % the label control itself
                % Align the label
                jLabel.setVerticalAlignment(jLabel.CENTER);
                jLabel.setHorizontalAlignment(jLabel.LEFT);
                % Add 6-pixel top border padding and repaint the label
                % jLabel.setBorder(javax.swing.BorderFactory.createEmptyBorder(6,0,0,0));
                jLabel.repaint;
                 else
                     
                     
                  data=data.conn.dynamic;
                  switch (band)
                     case 'Alpha'
                         mat=data.alpha;
                     case 'Theta'
                        mat=data.theta;
                     case 'Gamma'
                        mat=data.gamma;
                     case 'Beta'
                        mat=data.beta;
                     case 'Delta'
                        mat=data.delta;
                      case 'Broadband'
                        mat=data.bb;
                        case 'Custom'
                        mat=data.custom;
                  end
                  
                  
                jSlider = javax.swing.JSlider;
                jSlider=javacomponent(jSlider,[200,20,200,80],plotting_panel);
                numberWindows=size(mat,1);
                set(jSlider,'Background',javax.swing.plaf.ColorUIResource(0.94,0.94,0.94));
   
% %                 find initial time
         node = treePath.getLastPathComponent;

                 dynorstat=node.getParent;
                 connecti=dynorstat.getParent;   
                 initialEpoch=connecti.getParent;       

                 rec_epoch_name=char(initialEpoch.getName);
                 nodeName=rec_epoch_name;
                 node=initialEpoch;
                 
                 if(strcmp(nodeName,'Reconstructed EEG'))
                     subjectParent=node.getParent;
                     subjectname=char(subjectParent.getName);
                     subjectname=subjectname(3:end);
                    % %          index of the subject to show its eeg in the figure
                     subjIndex=find(strcmp(allsubjects.names, subjectname));
                    %              pathfile= allsubjects.paths{subjIndex};
                     sigsrc=alleegs_src{subjIndex}; 
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
                 sigsrc=allepochs_src{subjIndex,number};  
                 
                else
                          if(strcmp(nodeName,'Reconstructed Preprocessed EEG'))
                     subjectParent=node.getParent;
                     subjectParent=subjectParent.getParent;       
                     subjectname=char(subjectParent.getName);
                     subjectname=subjectname(3:end);
                % %          index of the subject to show its eeg in the figure
                     subjIndex=find(strcmp(allsubjects.names, subjectname));
                %              pathfile= allsubjects.paths{subjIndex};

                     sigsrc=alleegs_preprocessed_src{subjIndex};
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
                         sigsrc=allepochs_preprocessed_src{subjIndex,number};
                       end
                          end
                 end
                          

                 end
              srate=alleegs{subjIndex}.srate;

                numberInitWindows=size(sigsrc,2);
                All_time=numberInitWindows/srate;
                stepWindow= (All_time/numberWindows);
                beginningTime=0;
                endTime=stepWindow;
                set(label_time,'String',['Corresponding time: [ ' num2str(beginningTime) '     ' num2str(endTime) ']']);
                set(label_time,'Visible','on');

                set(jSlider, 'Value',1,'Maximum',numberWindows,'Minimum',1,'MajorTickSpacing',numberWindows/4, 'MinorTickSpacing',numberWindows/16, 'PaintTicks',true, 'PaintLabels',true,'Background',javax.swing.plaf.ColorUIResource(0.94,0.94,0.94),'MouseReleasedCallback',{@jSlider_change,mat,stepWindow,fig1,jSlider});
                imagesc(fig1,squeeze(mat(1,:,:)));
                axes(fig1) %select the current axes, the h holds the han
                colorbar

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


                set(plotting_panel,'Visible','on');
                grid on
                axis tight

                ylabel('ROIs','FontSize', 12);
                xlabel('ROIs','FontSize', 12);
                
                set(info_panel,'Visible','on');
                jLabel = javaObjectEDT(javax.swing.JLabel(['<html><body style="background-color:rgb(240, 240, 240); color:rgb(33, 45, 107);"> <div align=left> <u> Subject name: </u></i>' subjectname '<BR>  <u> Type: </i></u>' 'Dynamic connectivity matrix' '<BR>  <u> Number of ROIs: </i></u>' num2str(size(mat,2)) '<BR><u> Number of windows: </i></u>' num2str(size(mat,1)) '<BR></body></div>']));
                [hjLabel, hContainer] = javacomponent(jLabel, [0,0,0,0], info_panel);
                set(hContainer, 'Units','norm', 'Pos',[0,0,1,1],'BackgroundColor',javax.swing.plaf.ColorUIResource(0.94,0.94,0.94))
                % Make the label (and its internal container) transparent
                jLabel.setOpaque(false)  % the label control itself
                % Align the label
                jLabel.setVerticalAlignment(jLabel.CENTER);
                jLabel.setHorizontalAlignment(jLabel.LEFT);
                % Add 6-pixel top border padding and repaint the label
                % jLabel.setBorder(javax.swing.BorderFactory.createEmptyBorder(6,0,0,0));
                jLabel.repaint;

                 end
          
         

          end
           node = treePath.getLastPathComponent;
%          prop=get(node);
         nodeName = char(node.getName);
         
         if(strcmp(nodeName,'EEG'))
             subjectParent=node.getParent;
             subjectname=char(subjectParent.getName);
             subjectname=subjectname(3:end);
% %          index of the subject to show its eeg in the figure
             subjIndex=find(strcmp(allsubjects.names, subjectname));
             EEG=alleegs{subjIndex};
              
            ViewSignal(EEG.data,fig1,plotting_panel)
            WriteInfo(EEG.data,EEG.srate,subjectname,info_panel,1)

         end
         if(strcmp(nodeName,'EEG_preprocessed'))
             subjectParent=node.getParent;
             subjectname=char(subjectParent.getName);
             subjectname=subjectname(3:end);
% %          index of the subject to show its eeg in the figure
             subjIndex=find(strcmp(allsubjects.names, subjectname));
%              pathfile= allsubjects.paths{subjIndex};
             EEG=alleegs_preprocessed{subjIndex};
              
            ViewSignal(EEG.data,fig1,plotting_panel)
            WriteInfo(EEG.data,EEG.srate,subjectname,info_panel,1)
         end
         
         if(strcmp(nodeName(1:6),'Epoch_'))
             subjectParent=node.getParent;
             subjectParent=subjectParent.getParent;
             subjectname=char(subjectParent.getName);
             subjectname=subjectname(3:end);
% %          index of the subject to show its eeg in the figure
             subjIndex=find(strcmp(allsubjects.names, subjectname));
%              pathfile= allsubjects.paths{subjIndex};
             number=str2double(nodeName(7:end));
             EEG=allepochs{subjIndex,number};
            ViewSignal(EEG.data,fig1,plotting_panel)
            WriteInfo(EEG.data,EEG.srate,subjectname,info_panel,1)
         else
         
             if(strcmp(nodeName(1:12),'Preprocessed'))
             subjectParent=node.getParent;
             subjectParent=subjectParent.getParent;
             subjectParent=subjectParent.getParent;
             subjectname=char(subjectParent.getName);
             subjectname=subjectname(3:end);
% %          index of the subject to show its eeg in the figure
             subjIndex=find(strcmp(allsubjects.names, subjectname));
%              pathfile= allsubjects.paths{subjIndex};
             number=str2num(nodeName(20:end));
             EEG=allepochs_preprocessed{subjIndex,number};
            ViewSignal(EEG.data,fig1,plotting_panel)
            WriteInfo(EEG.data,EEG.srate,subjectname,info_panel,1)
             else
             
             if(strcmp(nodeName,'Reconstructed EEG'))
             subjectParent=node.getParent;
             subjectname=char(subjectParent.getName);
             subjectname=subjectname(3:end);
% %          index of the subject to show its eeg in the figure
             subjIndex=find(strcmp(allsubjects.names, subjectname));
%              pathfile= allsubjects.paths{subjIndex};
             data=alleegs_src{subjIndex};
            ViewSignal(data,fig1,plotting_panel)
             EEG=alleegs{subjIndex};
            WriteInfo(data,EEG.srate,subjectname,info_panel,2)
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
             data=allepochs_src{subjIndex,number};
             EEG=alleegs{subjIndex};
            ViewSignal(data,fig1,plotting_panel)
            WriteInfo(data,EEG.srate,subjectname,info_panel,2)
              else
             
              if(strcmp(nodeName,'Reconstructed Preprocessed EEG'))
             subjectParent=node.getParent;
             subjectParent=subjectParent.getParent;       
             subjectname=char(subjectParent.getName);
             subjectname=subjectname(3:end);
% %          index of the subject to show its eeg in the figure
             subjIndex=find(strcmp(allsubjects.names, subjectname));
%              pathfile= allsubjects.paths{subjIndex};
             
             data=alleegs_preprocessed_src{subjIndex};
              EEG=alleegs{subjIndex};
            ViewSignal(data,fig1,plotting_panel)
            WriteInfo(data,EEG.srate,subjectname,info_panel,2)
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
             data=allepochs_preprocessed_src{subjIndex,number};
              EEG=alleegs{subjIndex};
            ViewSignal(data,fig1,plotting_panel)
            WriteInfo(data,EEG.srate,subjectname,info_panel,2)
% %              here
      
             end
             end
              end
              end
             end
             end
         end 
         
 function jSlider_change(hObj, EventData,mat,step,fig1,jSlider)
global label_time;
% Prop=get(jRangeSlider);
% Define the window to plot, first, window= all the nb of samples
win = get(jSlider, 'Value');
% Plot the signal for the window chosen
imagesc(fig1,squeeze(mat(win,:,:)));
grid on
axis tight
ylabel('ROIs','FontSize', 12);
xlabel('ROIs','FontSize', 12);
colorbar;
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

beginningTime=step*(win-1);
endTime=step*(win);
set(label_time,'String',['Corresponding time: [ ' num2str(beginningTime) '     ' num2str(endTime) ']']);
set(label_time,'Visible','on');
 
function Plot_new_window(hObject, eventData,node)
     global allsubjects;       
     global alleegs;
     global alleegs_preprocessed;
     global allepochs;
     global allepochs_preprocessed;
     global alleegs_src;
global allepochs_src;
global alleegs_preprocessed_src;
global allepochs_preprocessed_src;

         nodeName = char(node.getName);
         if(strcmp(nodeName,'EEG'))
% %              Plot EEG in a new window
             subjectParent=node.getParent;
             subjectname=char(subjectParent.getName);
             subjectname=subjectname(3:end);
% %              index of the subject to show its eeg in the figure
             subjIndex=find(strcmp(allsubjects.names, subjectname));
              EEG=alleegs{subjIndex};
              
            f2=figure('Name',['View EEG for subject ' subjectname],'NumberTitle','off');
            % Plot the signal
            numberSamples=size(EEG.data,2);
            numberElectrodes=size(EEG.data,1);
            plot(EEG.data(:,1:numberSamples)','color','k','linewidth',0.01);
            grid on
            axis tight
            
            ylabel('Averaged Value (uV)');
            xlabel('Number of samples ');

%             WriteInfo(eegS,pathfile,subjectname,info_panel)

         else
         
         if(strcmp(nodeName,'EEG_preprocessed'))
% %              Plot EEG in a new window
             subjectParent=node.getParent;
             subjectname=char(subjectParent.getName);
             subjectname=subjectname(3:end);
% %              index of the subject to show its eeg in the figure
             subjIndex=find(strcmp(allsubjects.names, subjectname));
%              pathfile= allsubjects.paths{subjIndex};
              EEG=alleegs_preprocessed{subjIndex};
             
            f2=figure('Name',['View preprocessed signals for subject ' subjectname],'NumberTitle','off');
            % Plot the signal
            numberSamples=size(EEG.data,2);
            numberElectrodes=size(EEG.data,1);
            plot(EEG.data(:,1:numberSamples)','color','k','linewidth',0.01);
            grid on
            axis tight
            
            ylabel('Averaged Value (uV)');
            xlabel('Number of samples ');

%             WriteInfo(eegS,pathfile,subjectname,info_panel)

         else
        if(strcmp(nodeName(1:6),'Epoch_'))
% %              Plot EEG in a new window
             subjectParent=node.getParent;
            subjectParent=subjectParent.getParent;
             subjectname=char(subjectParent.getName);
             subjectname=subjectname(3:end);
% %              index of the subject to show its eeg in the figure
             subjIndex=find(strcmp(allsubjects.names, subjectname));
             number=str2double(nodeName(7:end));
              EEG=allepochs{subjIndex,number};   
            f2=figure('Name',['View' nodeName 'for subject ' subjectname],'NumberTitle','off');
            % Plot the signal
            numberSamples=size(EEG.data,2);
            plot(EEG.data(:,1:numberSamples)','color','k','linewidth',0.01);
            grid on
            axis tight
            
            ylabel('Averaged Value (uV)');
            xlabel('Number of samples ');

%             WriteInfo(eegS,pathfile,subjectname,info_panel)

        else 
        
        if(strcmp(nodeName(1:12),'Preprocessed'))
             subjectParent=node.getParent;
             subjectParent=subjectParent.getParent;
             subjectParent=subjectParent.getParent;
             subjectname=char(subjectParent.getName);
             subjectname=subjectname(3:end);
% %          index of the subject to show its eeg in the figure
             subjIndex=find(strcmp(allsubjects.names, subjectname));
%              pathfile= allsubjects.paths{subjIndex};
             number=str2double(nodeName(20:end));
             EEG=allepochs_preprocessed{subjIndex,number};
            f2=figure('Name',['View' nodeName 'for subject ' subjectname],'NumberTitle','off');
            % Plot the signal
            numberSamples=size(EEG.data,2);
            plot(EEG.data(:,1:numberSamples)','color','k','linewidth',0.01);
            grid on
            axis tight
            
            ylabel('Averaged Value (uV)');
            xlabel('Number of samples ');
        else
            if(strcmp(nodeName,'Reconstructed EEG'))
             subjectParent=node.getParent;
             subjectname=char(subjectParent.getName);
             subjectname=subjectname(3:end);
% %          index of the subject to show its eeg in the figure
             subjIndex=find(strcmp(allsubjects.names, subjectname));
%              pathfile= allsubjects.paths{subjIndex};
             data=alleegs_src{subjIndex};
            f2=figure('Name',['View' nodeName 'for subject ' subjectname],'NumberTitle','off');
            % Plot the signal
           
            plot(data','color','k','linewidth',0.01);
            grid on
            axis tight
            
            ylabel('Averaged Value (uV)');
            xlabel('Number of samples ');

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
             data=allepochs_src{subjIndex,number};
             f2=figure('Name',['View' nodeName 'for subject ' subjectname],'NumberTitle','off');
            % Plot the signal
           
            plot(data','color','k','linewidth',0.01);
            grid on
            axis tight
            
            ylabel('Averaged Value (uV)');
            xlabel('Number of samples ');
              else
             
              if(strcmp(nodeName,'Reconstructed Preprocessed EEG'))
             subjectParent=node.getParent;
             subjectParent=subjectParent.getParent;       
             subjectname=char(subjectParent.getName);
             subjectname=subjectname(3:end);
% %          index of the subject to show its eeg in the figure
             subjIndex=find(strcmp(allsubjects.names, subjectname));
%              pathfile= allsubjects.paths{subjIndex};
             
             data=alleegs_preprocessed_src{subjIndex};
              f2=figure('Name',['View' nodeName 'for subject ' subjectname],'NumberTitle','off');
            % Plot the signal
           
            plot(data','color','k','linewidth',0.01);
            grid on
            axis tight
            
            ylabel('Averaged Value (uV)');
            xlabel('Number of samples ');
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
             data=allepochs_preprocessed_src{subjIndex,number};
              f2=figure('Name',['View' nodeName 'for subject ' subjectname],'NumberTitle','off');
            % Plot the signal
           
            plot(data','color','k','linewidth',0.01);
            grid on
            axis tight
            
            ylabel('Averaged Value (uV)');
            xlabel('Number of samples ');
             end
              end
              end
        end
        end
         end
         end
         end

function Plot_matrix(hObject, eventData,node)
global allsubjects;       
global alleegs;
global alleegs_src_conn;
global allepochs_src_conn;
global alleegs_preprocessed_src_conn;
global allepochs_preprocessed_src_conn;
global allnoise;
global alleegs_preprocessed;
global allepochs;
global allepochs_preprocessed;
global alleegs_src;
global allepochs_src;
global alleegs_preprocessed_src;
global allepochs_preprocessed_src;
global alleegs_src_conn;
global allepochs_src_conn;
global alleegs_preprocessed_src_conn;
global allepochs_preprocessed_src_conn;

node_in=node;
       if(strcmp(char(node.getName),'Noise covariance matrix'))
           subjectParent=node.getParent;
         subjectname=char(subjectParent.getName);
         subjectname=subjectname(3:end);
        % %          index of the subject to show its eeg in the figure
         subjIndex=find(strcmp(allsubjects.names, subjectname));

            matt=allnoise{subjIndex};
            figure;
            imagesc(matt);
            colorbar
            grid on
            axis tight
            ylabel('ROIs','FontSize', 12);
            xlabel('ROIs','FontSize', 12);

       else
       
band = char(node.getName);
% % Theta, beta,... etc

% % parent=static or dynamic
subjectParent=node.getParent;
staticordynamic=char(subjectParent.getName);
% % parent= reconstructed signal
subjectParent=subjectParent.getParent;
subjectParent=subjectParent.getParent;

nodeName=char(subjectParent.getName);
node=subjectParent;
if(strcmp(nodeName,'Reconstructed EEG'))
 subjectParent=node.getParent;
 subjectname=char(subjectParent.getName);
 subjectname=subjectname(3:end);
% %          index of the subject to show its eeg in the figure
 subjIndex=find(strcmp(allsubjects.names, subjectname));
%              pathfile= allsubjects.paths{subjIndex};
 data=alleegs_src_conn{subjIndex};  
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
 data=allepochs_src_conn{subjIndex,number};    
else
          if(strcmp(nodeName,'Reconstructed Preprocessed EEG'))
     subjectParent=node.getParent;
     subjectParent=subjectParent.getParent;       
     subjectname=char(subjectParent.getName);
     subjectname=subjectname(3:end);
% %          index of the subject to show its eeg in the figure
     subjIndex=find(strcmp(allsubjects.names, subjectname));
%              pathfile= allsubjects.paths{subjIndex};

     data=alleegs_preprocessed_src_conn{subjIndex};
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
         data=allepochs_preprocessed_src_conn{subjIndex,number};
       end
          end
              
end
end
 
 if(strcmp(staticordynamic,'Static'))
 data=data.conn.static;
 switch (band)
     case 'Alpha'
         mat=data.alpha;
     case 'Theta'
        mat=data.theta;
     case 'Gamma'
        mat=data.gamma;
     case 'Beta'
        mat=data.beta;
     case 'Delta'
        mat=data.delta;
      case 'Broadband'
        mat=data.bb;
        case 'Custom'
        mat=data.custom;
 end
f2=figure('Name',['View matrix']);
% Plot the signal

imagesc(mat);
% axes(fig1) %select the current axes, the h holds the han
colorbar

grid on
axis tight

ylabel('ROIs','FontSize', 12);
xlabel('ROIs','FontSize', 12);
% Set where ticks will be
xticks(1:size(mat,1));
yticks(1:size(mat,1));
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


 else
  data=data.conn.dynamic;
  switch (band)
     case 'Alpha'
         mat=data.alpha;
     case 'Theta'
        mat=data.theta;
     case 'Gamma'
        mat=data.gamma;
     case 'Beta'
        mat=data.beta;
     case 'Delta'
        mat=data.delta;
      case 'Broadband'
        mat=data.bb;
        case 'Custom'
        mat=data.custom;
  end
  
                  numberWindows=size(mat,1);
                
% %                 find initial time
                node=node_in;

                 dynorstat=node.getParent;
                 connecti=dynorstat.getParent;   
                 initialEpoch=connecti.getParent;       

                 rec_epoch_name=char(initialEpoch.getName);
                 nodeName=rec_epoch_name;
                 node=initialEpoch;
                 
                 if(strcmp(nodeName,'Reconstructed EEG'))
                     subjectParent=node.getParent;
                     subjectname=char(subjectParent.getName);
                     subjectname=subjectname(3:end);
                    % %          index of the subject to show its eeg in the figure
                     subjIndex=find(strcmp(allsubjects.names, subjectname));
                    %              pathfile= allsubjects.paths{subjIndex};
                     sigsrc=alleegs_src{subjIndex}; 
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
                 sigsrc=allepochs_src{subjIndex,number};  
                 
                else
                          if(strcmp(nodeName,'Reconstructed Preprocessed EEG'))
                     subjectParent=node.getParent;
                     subjectParent=subjectParent.getParent;       
                     subjectname=char(subjectParent.getName);
                     subjectname=subjectname(3:end);
                % %          index of the subject to show its eeg in the figure
                     subjIndex=find(strcmp(allsubjects.names, subjectname));
                %              pathfile= allsubjects.paths{subjIndex};

                     sigsrc=alleegs_preprocessed_src{subjIndex};
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
                         sigsrc=allepochs_preprocessed_src{subjIndex,number};
                       end
                          end
                 end
                          

                 end
              srate=alleegs{subjIndex}.srate;

                numberInitWindows=size(sigsrc,2);
                All_time=numberInitWindows/srate;
                stepWindow= (All_time/numberWindows);
                

  
 dynamic_view(mat,stepWindow);
 end
       end

function Plot_network(hObject, eventData,node)
global allsubjects;       
global alleegs;
global alleegs_src_conn;
global allepochs_src_conn;
global alleegs_preprocessed_src_conn;
global allepochs_preprocessed_src_conn;

band = char(node.getName);
% % Theta, beta,... etc

% % parent=static or dynamic
subjectParent=node.getParent;
staticordynamic=char(subjectParent.getName);
% % parent= reconstructed signal
subjectParent=subjectParent.getParent;
subjectParent=subjectParent.getParent;

nodeName=char(subjectParent.getName);
node=subjectParent;
if(strcmp(nodeName,'Reconstructed EEG'))
 subjectParent=node.getParent;
 subjectname=char(subjectParent.getName);
 subjectname=subjectname(3:end);
% %          index of the subject to show its eeg in the figure
 subjIndex=find(strcmp(allsubjects.names, subjectname));
%              pathfile= allsubjects.paths{subjIndex};
 data=alleegs_src_conn{subjIndex};  
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
 data=allepochs_src_conn{subjIndex,number};    
else
          if(strcmp(nodeName,'Reconstructed Preprocessed EEG'))
     subjectParent=node.getParent;
     subjectParent=subjectParent.getParent;       
     subjectname=char(subjectParent.getName);
     subjectname=subjectname(3:end);
% %          index of the subject to show its eeg in the figure
     subjIndex=find(strcmp(allsubjects.names, subjectname));
%              pathfile= allsubjects.paths{subjIndex};

     data=alleegs_preprocessed_src_conn{subjIndex};
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
         data=allepochs_preprocessed_src_conn{subjIndex,number};
       end
          end
              
end
end
 
 if(strcmp(staticordynamic,'Static'))
 data=data.conn.static;

 else
  data=data.conn.dynamic;
 end
  switch (band)
     case 'Alpha'
         mat=data.alpha;
     case 'Theta'
        mat=data.theta;
     case 'Gamma'
        mat=data.gamma;
     case 'Beta'
        mat=data.beta;
     case 'Delta'
        mat=data.delta;
      case 'Broadband'
        mat=data.bb;
        case 'Custom'
        mat=data.custom;
  end
  visualize_network(mat);

function Plot_graph(hObject, eventData,node)
global allsubjects;       
global alleegs;
global alleegs_src_conn;
global allepochs_src_conn;
global alleegs_preprocessed_src_conn;
global allepochs_preprocessed_src_conn;

band = char(node.getName);
% % Theta, beta,... etc

% % parent=static or dynamic
subjectParent=node.getParent;
staticordynamic=char(subjectParent.getName);
% % parent= reconstructed signal
subjectParent=subjectParent.getParent;
subjectParent=subjectParent.getParent;

nodeName=char(subjectParent.getName);
node=subjectParent;
if(strcmp(nodeName,'Reconstructed EEG'))
 subjectParent=node.getParent;
 subjectname=char(subjectParent.getName);
 subjectname=subjectname(3:end);
% %          index of the subject to show its eeg in the figure
 subjIndex=find(strcmp(allsubjects.names, subjectname));
%              pathfile= allsubjects.paths{subjIndex};
 data=alleegs_src_conn{subjIndex};  
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
 data=allepochs_src_conn{subjIndex,number};    
else
          if(strcmp(nodeName,'Reconstructed Preprocessed EEG'))
     subjectParent=node.getParent;
     subjectParent=subjectParent.getParent;       
     subjectname=char(subjectParent.getName);
     subjectname=subjectname(3:end);
% %          index of the subject to show its eeg in the figure
     subjIndex=find(strcmp(allsubjects.names, subjectname));
%              pathfile= allsubjects.paths{subjIndex};

     data=alleegs_preprocessed_src_conn{subjIndex};
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
         data=allepochs_preprocessed_src_conn{subjIndex,number};
       end
          end
              
end
end
 
 if(strcmp(staticordynamic,'Static'))
 data=data.conn.static;

 else
  data=data.conn.dynamic;
 end
  switch (band)
     case 'Alpha'
         mat=data.alpha;
     case 'Theta'
        mat=data.theta;
     case 'Gamma'
        mat=data.gamma;
     case 'Beta'
        mat=data.beta;
     case 'Delta'
        mat=data.delta;
      case 'Broadband'
        mat=data.bb;
        case 'Custom'
        mat=data.custom;
  end
  visualize_graph(mat);


function Compute_connectivity(hObject, eventData,node)
    global alleegs;
global alleegs_src;
global allepochs_src;
global alleegs_preprocessed_src;
global allepochs_preprocessed_src;
global allsubjects;

nodeName = char(node.getName);
        
if(strcmp(nodeName,'Reconstructed EEG'))
 subjectParent=node.getParent;
 subjectname=char(subjectParent.getName);
 subjectname=subjectname(3:end);
% %          index of the subject to show its eeg in the figure
 subjIndex=find(strcmp(allsubjects.names, subjectname));
 EEG=alleegs{subjIndex};
%              pathfile= allsubjects.paths{subjIndex};
 data=alleegs_src{subjIndex};
 srate=EEG.srate;
 EEG={};
 EEG{1}=data;
Form_connectivity(EEG,srate,node,0);

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
 data=allepochs_src{subjIndex,number};
 
  EEG=alleegs{subjIndex};
%              pathfile= allsubjects.paths{subjIndex};
 srate=EEG.srate;
  EEG={};
 EEG{1}=data;
Form_connectivity(EEG,srate,node,0);

              else
             
              if(strcmp(nodeName,'Reconstructed Preprocessed EEG'))
             subjectParent=node.getParent;
             subjectParent=subjectParent.getParent;       
             subjectname=char(subjectParent.getName);
             subjectname=subjectname(3:end);
% %          index of the subject to show its eeg in the figure
             subjIndex=find(strcmp(allsubjects.names, subjectname));
%              pathfile= allsubjects.paths{subjIndex};
             
             data=alleegs_preprocessed_src{subjIndex};
  EEG=alleegs{subjIndex};
%              pathfile= allsubjects.paths{subjIndex};
 srate=EEG.srate;
  EEG={};
 EEG{1}=data;
Form_connectivity(EEG,srate,node,0);

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
             data=allepochs_preprocessed_src{subjIndex,number};
  EEG=alleegs{subjIndex};
%              pathfile= allsubjects.paths{subjIndex};
 srate=EEG.srate;
 EEG={};
 EEG{1}=data;
Form_connectivity(EEG,srate,node,0);

            
       
         end
              end
  end
end
             
function NoiseCovariance_calculation(hObject, eventData,node)
     global allsubjects;       
     global alleegs;
     global alleegs_preprocessed;
     global allepochs;
     global allepochs_preprocessed;
     
         nodeName = char(node.getName);
         if(strcmp(nodeName,'EEG'))
% %              Plot EEG in a new window
             subjectParent=node.getParent;
             subjectname=char(subjectParent.getName);
             subjectname=subjectname(3:end);
% %              index of the subject to show its eeg in the figure
             subjIndex=find(strcmp(allsubjects.names, subjectname));
              EEG=alleegs{subjIndex};
            numberSamples=size(EEG.data,2);
            numberElectrodes=size(EEG.data,1);
%             WriteInfo(eegS,pathfile,subjectname,info_panel)
         else
         
         if(strcmp(nodeName,'EEG_preprocessed'))
% %              Plot EEG in a new window
             subjectParent=node.getParent;
             subjectname=char(subjectParent.getName);
             subjectname=subjectname(3:end);
% %              index of the subject to show its eeg in the figure
             subjIndex=find(strcmp(allsubjects.names, subjectname));
             pathfile= allsubjects.paths{subjIndex};
              EEG=alleegs_preprocessed{subjIndex};
 
            numberSamples=size(EEG.data,2);
            numberElectrodes=size(EEG.data,1);
           

%             WriteInfo(eegS,pathfile,subjectname,info_panel)

         else
        if(strcmp(nodeName(1:6),'Epoch_'))
% %              Plot EEG in a new window
             subjectParent=node.getParent;
            subjectParent=subjectParent.getParent;
             subjectname=char(subjectParent.getName);
             subjectname=subjectname(3:end);
% %              index of the subject to show its eeg in the figure
             subjIndex=find(strcmp(allsubjects.names, subjectname));
             number=str2double(nodeName(7:end));
              EEG=allepochs{subjIndex,number};   
            
            numberSamples=size(EEG.data,2);
            
            
           

%             WriteInfo(eegS,pathfile,subjectname,info_panel)

        else 
        
        if(strcmp(nodeName(1:12),'Preprocessed'))
             subjectParent=node.getParent;
             subjectParent=subjectParent.getParent;
             subjectParent=subjectParent.getParent;
             subjectname=char(subjectParent.getName);
             subjectname=subjectname(3:end);
% %          index of the subject to show its eeg in the figure
             subjIndex=find(strcmp(allsubjects.names, subjectname));
%              pathfile= allsubjects.paths{subjIndex};
             number=str2double(nodeName(20:end));
             EEG=allepochs_preprocessed{subjIndex,number};
            
            numberSamples=size(EEG.data,2);
            
        end
        end
         end
         end
    Form_calculateNoiseCov(EEG,subjIndex,subjectParent);         

function Reconstruct_sources(hObject, eventData,node)
     global allsubjects;  
     global alleegs;
     global allepochs;
     global alleegs_preprocessed;
     global allepochs_preprocessed;
     nodeName = char(node.getName);
     if(strcmp(nodeName,'EEG'))
% %              Plot EEG in a new window
             subjectParent=node.getParent;
             subjectname=char(subjectParent.getName);
             subjectname=subjectname(3:end);
% %              index of the subject to show its eeg in the figure
             subjIndex=find(strcmp(allsubjects.names, subjectname));
              EEG=alleegs{subjIndex};
              
            
            numberSamples=size(EEG.data,2);
            numberElectrodes=size(EEG.data,1);
            

%             WriteInfo(eegS,pathfile,subjectname,info_panel)

         else
         
         if(strcmp(nodeName,'EEG_preprocessed'))
% %              Plot EEG in a new window
             subjectParent=node.getParent;
             subjectname=char(subjectParent.getName);
             subjectname=subjectname(3:end);
% %              index of the subject to show its eeg in the figure
             subjIndex=find(strcmp(allsubjects.names, subjectname));
%              pathfile= allsubjects.paths{subjIndex};
              EEG=alleegs_preprocessed{subjIndex};
 
            numberSamples=size(EEG.data,2);
            numberElectrodes=size(EEG.data,1);
           

%             WriteInfo(eegS,pathfile,subjectname,info_panel)

         else
        if(strcmp(nodeName(1:6),'Epoch_'))
% %              Plot EEG in a new window
             subjectParent=node.getParent;
            subjectParent=subjectParent.getParent;
             subjectname=char(subjectParent.getName);
             subjectname=subjectname(3:end);
% %              index of the subject to show its eeg in the figure
             subjIndex=find(strcmp(allsubjects.names, subjectname));
             number=str2double(nodeName(7:end));
              EEG=allepochs{subjIndex,number};   
            
            numberSamples=size(EEG.data,2);
            
            
           

%             WriteInfo(eegS,pathfile,subjectname,info_panel)

        else 
        
        if(strcmp(nodeName(1:12),'Preprocessed'))
             subjectParent=node.getParent;
             subjectParent=subjectParent.getParent;
             subjectParent=subjectParent.getParent;
             subjectname=char(subjectParent.getName);
             subjectname=subjectname(3:end);
% %          index of the subject to show its eeg in the figure
             subjIndex=find(strcmp(allsubjects.names, subjectname));
%              pathfile= allsubjects.paths{subjIndex};
             number=str2double(nodeName(20:end));
             EEG=allepochs_preprocessed{subjIndex,number};
            
            numberSamples=size(EEG.data,2);
            
        end
        end
         end
     end
    
    % %  get eegS as EEGLAB STRUCT
    
    Form_inverseMethod(EEG,node,subjIndex);  
        
  function PreProcess_EEG(hObject, eventData,node)
     global allsubjects;  
     global alleegs;
     global paramss;
     nodeName = char(node.getName);
     subjectParent=node.getParent;
     subjectname=char(subjectParent.getName);
     subjectname=subjectname(3:end);
% %              index of the subject to show its eeg in the figure
     subjIndex=find(strcmp(allsubjects.names, subjectname));
    % %  get eegS as EEGLAB STRUCT
     EEG=alleegs{subjIndex};
%     remove cmnts
% %     if(strcmp(EEG.setname, subjectname))
% % To ensure that it is the same subject in the eeglab structure
% 1: set Default parameters for autpomagic, 2: run Automagic and get user parameters, 3: preprocess            
% addpath(genpath('automagic-master'));   
[params, Visparams, CVG]=tryDefaults();
addpath(genpath('external/automagic-master'));
settingsGUI(params, Visparams, CVG,EEG,subjectParent,subjIndex);  
    
function PreProcess_segment(hObject, eventData,node)
     global allsubjects;  
     global allepochs;
     nodeName = char(node.getName);
     
     subjectParent=node.getParent;
     subjectParent=subjectParent.getParent;
     subjectname=char(subjectParent.getName);
     subjectname=subjectname(3:end);
% %              index of the subject to show its eeg in the figure
     subjIndex=find(strcmp(allsubjects.names, subjectname));
    % %  get eegS as EEGLAB STRUCT
    
    EEG=allepochs{subjIndex,str2double(nodeName(7:end))};
%     remove cmnts
% %     if(strcmp(EEG.setname, subjectname))
% % To ensure that it is the same subject in the eeglab structure
% 1: set Default parameters for autpomagic, 2: run Automagic and get user parameters, 3: preprocess            
    [params, Visparams, CVG]=tryDefaults();
    addpath(genpath('automagic-master'));

    settingsGUI(params, Visparams, CVG,EEG,node,subjIndex);        

function Segment_EEG(hObject, eventData,node)
     global allsubjects;  
     global alleegs;
     nodeName = char(node.getName);
     subjectParent=node.getParent;
     subjectname=char(subjectParent.getName);
     subjectname=subjectname(3:end);
% %              index of the subject to show its eeg in the figure
     subjIndex=find(strcmp(allsubjects.names, subjectname));
    % %  get eegS as EEGLAB STRUCT
    EEG=alleegs{subjIndex};
    Form_segment(EEG,node,subjIndex);

function Import_EEG(hObject, eventData,node,jmenu)
% % SHould open a form to import EEG then create a node in the tree named
% EEG

global tree;
global treeModel;
global fig1;
global plotting_panel;
global fpath;
global info_panel;
global subjname;
global allsubjects;
global numberSubjects;
global alleegs; 

% % Import EEG
try
if(strcmp(node.getFirstChild.getName,'EEG'))
% %     There is a previous EEG so we tell the user that the previous EEG
% will be replaced by the new one
   myicon = imread('Icons/logo_new_eegnet.png');
   msgfig=msgbox('You have already imported EEGs. The previous signals will be replaced by the new ones','Warning','custom',myicon);     
   uiwait(msgfig);
end
end
% % % % [filename,pathname]=uigetfile({'*.mat','Import EEG Signal File (*.mat)'});
% % % % if isequal(filename,0)||isequal(pathname,0)
% % % %     return
% % % % else
% % % %     fpath=fullfile(pathname,filename);
% % % % end
% % % %  cellOut=struct2cell(load(fpath));
% % % %  eegS=(cellOut{1}); 
% % % %  
% % % % nodeName = char(node.getName);
% % % % subjectname=nodeName;
% % % % subjectname=subjectname(3:end);
% % % % % %              index of the subject to show its eeg in the figure
% % % % subjIndex=find(strcmp(allsubjects.names, subjectname));
% % % % allsubjects.paths{subjIndex}=fpath;
% % % % 
% % % % ViewSignal(eegS,fig1,plotting_panel);
% % % % WriteInfo(eegS,fpath,subjname,info_panel);
% % % % EEG=writeEEGLAB_struct(eegS,128,subjectname,filename,pathname,'data/standard-10-5-cap385.elp');
% % % % 
% % % % 
% % % % if(node.getChildCount==0)
% % % % % % Add EEG in tree
% % % % parent = node;
% % % % childNode = uitreenode('v0','dummy', 'EEG', [], 0);
% % % % [I] = imread('Icons/javaImage_eeg.png');
% % % % javaImage_eeg = im2java(I);
% % % % 
% % % % childNode.setIcon(javaImage_eeg);
% % % % treeModel.insertNodeInto(childNode,parent,parent.getChildCount()); 
% % % % % expand to show added child
% % % % tree.setSelectedNode( childNode );
% % % % % insure additional nodes are added to parent
% % % % tree.setSelectedNode( parent );
% % % % % end
Form_loadfiles(node);

function Preprocess_manysubjects(hObject, eventData,node,jmenu)

preprocess_many_subjects(node);

function Reconstruct_manysubjects(hObject, eventData,node,jmenu)

Form_reconstruct_many_subjects(node);

function Connectivity_manysubjects(hObject, eventData,node,jmenu)

Form_conn_many_subjects(node);

function Preprocess_segments(hObject, eventData,node,jmenu)
% % SHould open a form to import EEG then create a node in the tree named
% EEG
global allsubjects;
nodeName = char(node.getName);
subjectname=nodeName;
subjectname=subjectname(3:end);
subjIndex=find(strcmp(allsubjects.names, subjectname));
addpath(genpath('automagic-master'));
Form_preprocessSegments(subjIndex,node)

function Reconstruct_segments(hObject, eventData,node,jmenu)
% % SHould open a form to import EEG then create a node in the tree named
% EEG
global allsubjects;
nodeName = char(node.getName);
subjectname=nodeName;
subjectname=subjectname(3:end);
subjIndex=find(strcmp(allsubjects.names, subjectname));
Form_recSrcSegments(subjIndex,node)

function Connectivity_segments(hObject, eventData,node,jmenu)
% % SHould open a form to import EEG then create a node in the tree named
% EEG
global allsubjects;
nodeName = char(node.getName);
subjectname=nodeName;
subjectname=subjectname(3:end);
subjIndex=find(strcmp(allsubjects.names, subjectname));
Form_connectivityAll(subjIndex,node)


function Delete_subject(hObject, eventData,node)

global treeModel;
global allsubjects;  
global alleegs;
global alleegs_preprocessed;
global allepochs;
global plotting_panel;
global info_panel;
global alleegs_preprocessed_interp;
global allepochs_preprocessed;
global allepochs_preprocessed_interp;
global allmodels;
global allnoise;
global alleegs_src;
global allepochs_src;
global alleegs_preprocessed_src;
global allepochs_preprocessed_src;
global alleegs_src_conn;
global allepochs_src_conn;
global alleegs_preprocessed_src_conn;
global allepochs_preprocessed_src_conn;

% childNode.setIcon(javaImage_subj);
treeModel.removeNodeFromParent( node );
% % We should remove the subject from the array
nodeName = char(node.getName);
subjectname=nodeName;
subjectname=subjectname(3:end);
subjIndex=find(strcmp(allsubjects.names, subjectname));
allsubjects.names{subjIndex}='';
allsubjects.paths{subjIndex}='';
alleegs{subjIndex}=struct();
alleegs_preprocessed{subjIndex}=struct();
alleegs_preprocessed_interp{subjIndex}=[];
alleegs_src{subjIndex}=[];
allmodels{subjIndex}=[];
allnoise{subjIndex}=[];
alleegs_preprocessed_src{subjIndex}=[];
alleegs_preprocessed_src_conn{subjIndex}=struct();
alleegs_src_conn{subjIndex}=struct();

for i=1:size(allepochs,2)
allepochs{subjIndex,i}=struct();
end
for i=1:size(allepochs_preprocessed,2)
allepochs_preprocessed{subjIndex,i}=struct();
allepochs_preprocessed_interp{subjIndex,i}=[];
end
for i=1:size(allepochs_src,2)
allepochs_src{subjIndex,i}=[];
end

for i=1:size(allepochs_preprocessed_src,2)
allepochs_preprocessed_src{subjIndex,i}=[];
end

for i=1:size(allepochs_src_conn,2)
allepochs_src_conn{subjIndex,i}=struct();
end


for i=1:size(allepochs_preprocessed_src_conn,2)
allepochs_preprocessed_src_conn{subjIndex,i}=struct();
end

set(plotting_panel,'Visible','off');
set(info_panel,'Visible','off');


function Delete_segment(hObject, eventData,node)
global plotting_panel;
global info_panel;
global treeModel;
global allsubjects;  
global allepochs;
global allepochs_src;
global allepochs_src_conn;
global allepochs_preprocessed;
global allepochs_preprocessed_interp;
global allepochs_preprocessed_src;
global allepochs_preprocessed_src_conn;
% childNode.setIcon(javaImage_subj);
 nodeName = char(node.getName);
 subjectParent=node.getParent;
 subjectParent=subjectParent.getParent;
 subjectname=char(subjectParent.getName);
 subjectname=subjectname(3:end);
% %              index of the subject to delete its eeg path
 subjIndex=find(strcmp(allsubjects.names, subjectname));
 i=str2double(nodeName(7:end));
allepochs{subjIndex,str2double(nodeName(7:end))}=struct();
allepochs_src{subjIndex,str2double(nodeName(7:end))}=[];
allepochs_src_conn{subjIndex,str2double(nodeName(7:end))}=struct();
allepochs_preprocessed{subjIndex,i}=struct();
allepochs_preprocessed_interp{subjIndex,i}=[];
allepochs_preprocessed_src{subjIndex,str2double(nodeName(7:end))}=[];
allepochs_preprocessed_src_conn{subjIndex,str2double(nodeName(7:end))}=struct();

treeModel.removeNodeFromParent( node );

set(plotting_panel,'Visible','off');
set(info_panel,'Visible','off');

function Delete_pre_segment(hObject, eventData,node)
global plotting_panel;
global info_panel;
global treeModel;
global allsubjects;  
global allepochs_preprocessed;
global allepochs_preprocessed_interp;
global allepochs_preprocessed_src;
global allepochs_preprocessed_src_conn;

% childNode.setIcon(javaImage_subj);
 nodeName = char(node.getName);
 subjectParent=node.getParent;
 subjectParent=subjectParent.getParent;
  subjectParent=subjectParent.getParent;
 subjectname=char(subjectParent.getName);
 subjectname=subjectname(3:end);
% %              index of the subject to delete its eeg path
 subjIndex=find(strcmp(allsubjects.names, subjectname));
 i=nodeName(19:end);
allepochs_preprocessed{subjIndex,str2double(nodeName(19:end))}=struct();
allepochs_preprocessed_interp{subjIndex,i}=[];
allepochs_preprocessed_src{subjIndex,i}=[];
allepochs_preprocessed_src_conn{subjIndex,i}=struct();


treeModel.removeNodeFromParent( node );

set(plotting_panel,'Visible','off');
set(info_panel,'Visible','off');

function Delete_EEG(hObject, eventData,node)
global plotting_panel;
global info_panel;
global treeModel;
global allsubjects; 
global allepochs;
global alleegs_preprocessed;
global alleegs;
global alleegs_preprocessed_interp;
global alleegs_src;
global allepochs_src;
global alleegs_preprocessed_src;
global alleegs_src_conn;
global allepochs_src_conn;
global alleegs_preprocessed_src_conn;
global allepochs_preprocessed;
global allepochs_preprocessed_interp;
global allepochs_preprocessed_src;
global allepochs_preprocessed_src_conn;

% childNode.setIcon(javaImage_subj);
% % We should remove the EEG path from the array
 nodeName = char(node.getName);
 subjectParent=node.getParent;
 subjectname=char(subjectParent.getName);
 subjectname=subjectname(3:end);
% %              index of the subject to delete its eeg path
 subjIndex=find(strcmp(allsubjects.names, subjectname));
allsubjects.paths{subjIndex}='';
if(strcmp(nodeName,'EEG_preprocessed'))
    alleegs_preprocessed{subjIndex}=struct();
    alleegs_preprocessed_interp{subjIndex}=[];
    alleegs_preprocessed_src{subjIndex}=[];
    alleegs_preprocessed_src_conn{subjIndex}=struct();
else
     if(strcmp(nodeName,'EEG'))
         alleegs{subjIndex}=struct();
         alleegs_src{subjIndex}=[];
         alleegs_src_conn{subjIndex}=struct();

        for i=1:size(allepochs,2)
        allepochs{subjIndex,i}=struct();
        end
        for i=1:size(allepochs_src,2)
        allepochs_src{subjIndex,i}=[];
        end
         for i=1:size(allepochs_src_conn,2)
        allepochs_src_conn{subjIndex,i}=struct();
         end
        for i=1:size(allepochs_preprocessed_src,2)
        allepochs_preprocessed_src{subjIndex,i}=[];
        end
        for i=1:size(allepochs_preprocessed,2)
        allepochs_preprocessed{subjIndex,i}=struct();
        allepochs_preprocessed_interp{subjIndex,i}=[];
        end
        for i=1:size(allepochs_preprocessed_src_conn,2)
        allepochs_preprocessed_src_conn{subjIndex,i}=struct();
        end


     end
end
treeModel.removeNodeFromParent( node );
set(plotting_panel,'Visible','off');
set(info_panel,'Visible','off');


% --- Outputs from this function are returned to the command line.
function varargout = eegnet_main_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function file_mb_Callback(hObject, eventdata, handles)
% hObject    handle to file_mb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function study_mb_Callback(hObject, eventdata, handles)
% hObject    handle to study_mb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function help_mb_Callback(hObject, eventdata, handles)
% hObject    handle to help_mb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function ss_mb_Callback(hObject, eventdata, handles)
% hObject    handle to ss_mb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function GA_mb_Callback(hObject, eventdata, handles)
% hObject    handle to ss_mb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Form_GroupAnalysis

% --------------------------------------------------------------------
function new_mb_Callback(hObject, eventdata, handles)
% hObject    handle to new_mb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    Form_New();


% --------------------------------------------------------------------
function open_mb_Callback(hObject, eventdata, handles)
% hObject    handle to open_mb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename,pathname]=uigetfile({'*.mat','Import EEGLink dataset (*.mat)'});
if isequal(filename,0)||isequal(pathname,0)
    return
else
    fpath=fullfile(pathname,filename);
  cellOut=struct2cell(load(fpath));
  f = waitbar(0,'Please wait...');

 EEGNET=(cellOut{1});
end
import javax.swing.*
import javax.swing.tree.*;

global tree;
global treeModel;
global rootNode;
global numberSubjects;
global allsubjects;
global alleegs; 
global alleegs_preprocessed;
global alleegs_preprocessed_interp;
global allepochs;
global allepochs_preprocessed;
global allepochs_preprocessed_interp;
global allmodels;
global allnoise;
global alleegs_src;
global allepochs_src;
global alleegs_preprocessed_src;
global allepochs_preprocessed_src;
global alleegs_src_conn;
global allepochs_src_conn;
global alleegs_preprocessed_src_conn;
global allepochs_preprocessed_src_conn;

% tree=EEGNET.tree;
% treeModel=EEGNET.treeModel;
% rootNode=EEGNET.rootNode;
numberSubjects=EEGNET.numberSubjects;
allsubjects=EEGNET.allsubjects;
alleegs=EEGNET.alleegs; 
alleegs_preprocessed=EEGNET.alleegs_preprocessed;
alleegs_preprocessed_interp=EEGNET.alleegs_preprocessed_interp;
allepochs=EEGNET.allepochs;
allepochs_preprocessed=EEGNET.allepochs_preprocessed;
allepochs_preprocessed_interp=EEGNET.allepochs_preprocessed_interp;
allmodels=EEGNET.allmodels;
allnoise=EEGNET.allnoise;
alleegs_src=EEGNET.alleegs_src;
allepochs_src=EEGNET.allepochs_src;
alleegs_preprocessed_src=EEGNET.alleegs_preprocessed_src;
allepochs_preprocessed_src=EEGNET.allepochs_preprocessed_src;
alleegs_src_conn=EEGNET.alleegs_src_conn;
allepochs_src_conn=EEGNET.allepochs_src_conn;
alleegs_preprocessed_src_conn=EEGNET.alleegs_preprocessed_src_conn;
allepochs_preprocessed_src_conn=EEGNET.allepochs_preprocessed_src_conn;


[I] = imread('Icons/database_navy1.png');
javaImage_database = im2java(I);
[I] = imread('Icons/subj_navy.png');

[YourImage, ~, ImageAlpha] = imread('Icons/logo_eegnet_greybkg.png');
axes(handles.axes2);
% imshow(myImage);
imshow(YourImage)
set(handles.figure1, 'Name', 'EEGLink');

javaImage_subj = im2java(I);
rootNode = uitreenode('v0','root', 'Database',[], 0);
rootNode.setIcon(javaImage_database);  
% set treeModel
treeModel = DefaultTreeModel( rootNode );
%  
% % create the tree
parent_tree=handles.uipanel4;
[tree, container] = uitree('v0', 'Root','Database', 'Parent',parent_tree); % Parent is ignored
set(container, 'Parent',handles.uipanel4);  
% tree.getTree.setBackground(java.awt.Color(0.94,0.94,0.94));
tree.setModel( treeModel );
% some layout
set(tree,'Units', 'normalized', 'position', [0.04 0.0000001 0.92 0.89]);
tree.setSelectedNode(rootNode );
drawnow;
jmenu = javax.swing.JPopupMenu;

jtree = handle(tree.getTree,'CallbackProperties');
set(jtree, 'MousePressedCallback', @mousePressedCallback);
% Prepare the context menu (note the use of HTML labels)
set(jtree, 'MousePressedCallback', {@mousePressedCallback,jmenu});
% Set the mouse-press callback
set(jtree, 'MouseClickedCallback', {@mouseClickedCallback,jmenu});

% % create subjects, in each subject create eeg and preprocessed eeg, in each eeg create rec eeg, epochs
% nodes, in each epoch create preprocessed epochs, in each preprocessed
% epoch 
jmenu = javax.swing.JPopupMenu;

for i=1:numberSubjects
       
% %             create subjects nodes
        parent = rootNode;
        childNode = uitreenode('v0','dummy', ['S_' allsubjects.names{i}], [], 0);
        childNodeS=childNode;
        childNode.setIcon(javaImage_subj);
        treeModel.insertNodeInto(childNode,parent,parent.getChildCount()); 
        % expand to show added child
        tree.setSelectedNode( childNode );
        % insure additional nodes are added to parent
        tree.setSelectedNode( parent ); 
        
% %         create eegs
 try
            alleegs{i};
        parent = childNodeS;
        childNode = uitreenode('v0','dummy', 'EEG', [], 0);
        childNodeE=childNode;
        [I] = imread('Icons/javaImage_eeg.png');
        javaImage_eeg = im2java(I);
        childNode.setIcon(javaImage_eeg);
        treeModel.insertNodeInto(childNode,parent,parent.getChildCount()); 
        % expand to show added child
        tree.setSelectedNode( childNode );
        % insure additional nodes are added to parent
        tree.setSelectedNode( parent );
        
        try 
            allepochs{i,1}.data;
            for nbepochs=1:size(allepochs,2)
                try
                    allepochs{i,nbepochs}.data;
                            parent = childNodeE;
                            childNode = uitreenode('v0','dummy', ['Epoch_' num2str(nbepochs)], [], 0);
                            childNodeEpoch=childNode;
                            [I] = imread('Icons/javaImage_eeg.png');
                            javaImage_eeg = im2java(I);
                            childNode.setIcon(javaImage_eeg);
                            treeModel.insertNodeInto(childNode,parent,parent.getChildCount()); 
                            % expand to show added child
                            tree.setSelectedNode( childNode );
                            % insure additional nodes are added to parent
                            tree.setSelectedNode( parent );
                    try
                        allepochs_preprocessed{i,nbepochs}.data;
                            parent = childNodeEpoch;
                            childNode = uitreenode('v0','dummy', ['Preprocessed Epoch_' num2str(nbepochs)], [], 0);
                            childNodePreEpoch=childNode;
                            [I] = imread('Icons/javaImage_eeg.png');
                            javaImage_eeg = im2java(I);
                            childNode.setIcon(javaImage_eeg);
                            treeModel.insertNodeInto(childNode,parent,parent.getChildCount()); 
                            % expand to show added child
                            tree.setSelectedNode( childNode );
                            % insure additional nodes are added to parent
                            tree.setSelectedNode( parent );
                            
                                if(size(allepochs_preprocessed_src{i,nbepochs},2))
                                     parent = childNodePreEpoch;
                            childNode = uitreenode('v0','dummy', ['Reconstructed Preprocessed Epoch_' num2str(nbepochs)], [], 0);
                            childNodeRecPreEpoch=childNode;
                            [I] = imread('Icons/javaImage_eeg.png');
                            javaImage_eeg = im2java(I);
                            childNode.setIcon(javaImage_eeg);
                            treeModel.insertNodeInto(childNode,parent,parent.getChildCount()); 
                            % expand to show added child
                            tree.setSelectedNode( childNode );
                            % insure additional nodes are added to parent
                            tree.setSelectedNode( parent );
                            
                                                        try
                                allepochs_preprocessed_src_conn{i,nbepochs}.conn;
                                 parent = childNodeRecPreEpoch;
                            childNode = uitreenode('v0','dummy', ['Connectivity'], [], 0);
                            childNodeConnectivity=childNode;
                            [I] = imread('Icons/connectivity_icon.png');
                            javaImage_eeg = im2java(I);
                            childNode.setIcon(javaImage_eeg);
                            treeModel.insertNodeInto(childNode,parent,parent.getChildCount()); 
                            % expand to show added child
                            tree.setSelectedNode( childNode );
                            % insure additional nodes are added to parent
                            tree.setSelectedNode( parent );
                            
                            try
                                allepochs_preprocessed_src_conn{i,nbepochs}.conn.static;
                                parent = childNodeConnectivity;
                            childNode = uitreenode('v0','dummy', ['Static'], [], 0);
                            childNodeStat=childNode;
                            [I] = imread('Icons/static_icon.png');
                            javaImage_eeg = im2java(I);
                            childNode.setIcon(javaImage_eeg);
                            treeModel.insertNodeInto(childNode,parent,parent.getChildCount()); 
                            % expand to show added child
                            tree.setSelectedNode( childNode );
                            % insure additional nodes are added to parent
                            tree.setSelectedNode( parent );
% %                             delta
                            try
                                allepochs_preprocessed_src_conn{i,nbepochs}.conn.static.delta;
                                parent = childNodeStat;
                            childNode = uitreenode('v0','dummy', ['Delta'], [], 0);
                            [I] = imread('Icons/icon_conn.png');
                            javaImage_eeg = im2java(I);
                            childNode.setIcon(javaImage_eeg);
                            treeModel.insertNodeInto(childNode,parent,parent.getChildCount()); 
                            % expand to show added child
                            tree.setSelectedNode( childNode );
                            % insure additional nodes are added to parent
                            tree.setSelectedNode( parent );
                            catch
                            end
 % %                             theta
                            try
                                allepochs_preprocessed_src_conn{i,nbepochs}.conn.static.theta;
                                parent = childNodeStat;
                            childNode = uitreenode('v0','dummy', ['Theta'], [], 0);
                            [I] = imread('Icons/icon_conn.png');
                            javaImage_eeg = im2java(I);
                            childNode.setIcon(javaImage_eeg);
                            treeModel.insertNodeInto(childNode,parent,parent.getChildCount()); 
                            % expand to show added child
                            tree.setSelectedNode( childNode );
                            % insure additional nodes are added to parent
                            tree.setSelectedNode( parent );
                            catch
                            end
   % %                             alpha
                            try
                                allepochs_preprocessed_src_conn{i,nbepochs}.conn.static.alpha;
                                parent = childNodeStat;
                            childNode = uitreenode('v0','dummy', ['Alpha'], [], 0);
                            [I] = imread('Icons/icon_conn.png');
                            javaImage_eeg = im2java(I);
                            childNode.setIcon(javaImage_eeg);
                            treeModel.insertNodeInto(childNode,parent,parent.getChildCount()); 
                            % expand to show added child
                            tree.setSelectedNode( childNode );
                            % insure additional nodes are added to parent
                            tree.setSelectedNode( parent );
                            catch
                            end
% %                             beta
                            try
                                allepochs_preprocessed_src_conn{i,nbepochs}.conn.static.beta;
                                parent = childNodeStat;
                            childNode = uitreenode('v0','dummy', ['Beta'], [], 0);
                            [I] = imread('Icons/icon_conn.png');
                            javaImage_eeg = im2java(I);
                            childNode.setIcon(javaImage_eeg);
                            treeModel.insertNodeInto(childNode,parent,parent.getChildCount()); 
                            % expand to show added child
                            tree.setSelectedNode( childNode );
                            % insure additional nodes are added to parent
                            tree.setSelectedNode( parent );
                            catch
                            end
  % %                             Gamma
                            try
                                allepochs_preprocessed_src_conn{i,nbepochs}.conn.static.gamma;
                                parent = childNodeStat;
                            childNode = uitreenode('v0','dummy', ['Gamma'], [], 0);
                            [I] = imread('Icons/icon_conn.png');
                            javaImage_eeg = im2java(I);
                            childNode.setIcon(javaImage_eeg);
                            treeModel.insertNodeInto(childNode,parent,parent.getChildCount()); 
                            % expand to show added child
                            tree.setSelectedNode( childNode );
                            % insure additional nodes are added to parent
                            tree.setSelectedNode( parent );
                            catch
                            end
 % %                             BB
                            try
                                allepochs_preprocessed_src_conn{i,nbepochs}.conn.static.bb;
                                parent = childNodeStat;
                            childNode = uitreenode('v0','dummy', ['Broadband'], [], 0);
                            [I] = imread('Icons/icon_conn.png');
                            javaImage_eeg = im2java(I);
                            childNode.setIcon(javaImage_eeg);
                            treeModel.insertNodeInto(childNode,parent,parent.getChildCount()); 
                            % expand to show added child
                            tree.setSelectedNode( childNode );
                            % insure additional nodes are added to parent
                            tree.setSelectedNode( parent );
                            catch
                            end
   % %                             delta
                            try
                                allepochs_preprocessed_src_conn{i,nbepochs}.conn.static.custom;
                                parent = childNodeStat;
                            childNode = uitreenode('v0','dummy', ['Custom'], [], 0);
                            [I] = imread('Icons/icon_conn.png');
                            javaImage_eeg = im2java(I);
                            childNode.setIcon(javaImage_eeg);
                            treeModel.insertNodeInto(childNode,parent,parent.getChildCount()); 
                            % expand to show added child
                            tree.setSelectedNode( childNode );
                            % insure additional nodes are added to parent
                            tree.setSelectedNode( parent );
                            catch
                            end
                  
                            
                            catch
                            end
                            
                            
                             try
                                allepochs_preprocessed_src_conn{i,nbepochs}.conn.dynamic;
                                parent = childNodeConnectivity;
                            childNode = uitreenode('v0','dummy', ['Dynamic'], [], 0);
                            childNodeDyn=childNode;
                            [I] = imread('Icons/dynamic_icon.png');
                            javaImage_eeg = im2java(I);
                            childNode.setIcon(javaImage_eeg);
                            treeModel.insertNodeInto(childNode,parent,parent.getChildCount()); 
                            % expand to show added child
                            tree.setSelectedNode( childNode );
                            % insure additional nodes are added to parent
                            tree.setSelectedNode( parent );
                            
                            % %                             delta
                            try
                                allepochs_preprocessed_src_conn{i,nbepochs}.conn.dynamic.delta;
                                parent = childNodeDyn;
                            childNode = uitreenode('v0','dummy', ['Delta'], [], 0);
                            [I] = imread('Icons/icon_conn.png');
                            javaImage_eeg = im2java(I);
                            childNode.setIcon(javaImage_eeg);
                            treeModel.insertNodeInto(childNode,parent,parent.getChildCount()); 
                            % expand to show added child
                            tree.setSelectedNode( childNode );
                            % insure additional nodes are added to parent
                            tree.setSelectedNode( parent );
                            catch
                            end
 % %                             theta
                            try
                                allepochs_preprocessed_src_conn{i,nbepochs}.conn.dynamic.theta;
                                parent = childNodeDyn;
                            childNode = uitreenode('v0','dummy', ['Theta'], [], 0);
                            [I] = imread('Icons/icon_conn.png');
                            javaImage_eeg = im2java(I);
                            childNode.setIcon(javaImage_eeg);
                            treeModel.insertNodeInto(childNode,parent,parent.getChildCount()); 
                            % expand to show added child
                            tree.setSelectedNode( childNode );
                            % insure additional nodes are added to parent
                            tree.setSelectedNode( parent );
                            catch
                            end
   % %                             alpha
                            try
                                allepochs_preprocessed_src_conn{i,nbepochs}.conn.dynamic.alpha;
                                parent = childNodeDyn;
                            childNode = uitreenode('v0','dummy', ['Alpha'], [], 0);
                            [I] = imread('Icons/icon_conn.png');
                            javaImage_eeg = im2java(I);
                            childNode.setIcon(javaImage_eeg);
                            treeModel.insertNodeInto(childNode,parent,parent.getChildCount()); 
                            % expand to show added child
                            tree.setSelectedNode( childNode );
                            % insure additional nodes are added to parent
                            tree.setSelectedNode( parent );
                            catch
                            end
% %                             beta
                            try
                                allepochs_preprocessed_src_conn{i,nbepochs}.conn.dynamic.beta;
                                parent = childNodeDyn;
                            childNode = uitreenode('v0','dummy', ['Beta'], [], 0);
                            [I] = imread('Icons/icon_conn.png');
                            javaImage_eeg = im2java(I);
                            childNode.setIcon(javaImage_eeg);
                            treeModel.insertNodeInto(childNode,parent,parent.getChildCount()); 
                            % expand to show added child
                            tree.setSelectedNode( childNode );
                            % insure additional nodes are added to parent
                            tree.setSelectedNode( parent );
                            catch
                            end
  % %                             Gamma
                            try
                                allepochs_preprocessed_src_conn{i,nbepochs}.conn.dynamic.gamma;
                                parent = childNodeDyn;
                            childNode = uitreenode('v0','dummy', ['Gamma'], [], 0);
                            [I] = imread('Icons/icon_conn.png');
                            javaImage_eeg = im2java(I);
                            childNode.setIcon(javaImage_eeg);
                            treeModel.insertNodeInto(childNode,parent,parent.getChildCount()); 
                            % expand to show added child
                            tree.setSelectedNode( childNode );
                            % insure additional nodes are added to parent
                            tree.setSelectedNode( parent );
                            catch
                            end
 % %                             BB
                            try
                                allepochs_preprocessed_src_conn{i,nbepochs}.conn.dynamic.bb;
                                parent = childNodeDyn;
                            childNode = uitreenode('v0','dummy', ['Broadband'], [], 0);
                            [I] = imread('Icons/icon_conn.png');
                            javaImage_eeg = im2java(I);
                            childNode.setIcon(javaImage_eeg);
                            treeModel.insertNodeInto(childNode,parent,parent.getChildCount()); 
                            % expand to show added child
                            tree.setSelectedNode( childNode );
                            % insure additional nodes are added to parent
                            tree.setSelectedNode( parent );
                            catch
                            end
   % %                             delta
                            try
                                allepochs_preprocessed_src_conn{i,nbepochs}.conn.dynamic.custom;
                                parent = childNodeDyn;
                            childNode = uitreenode('v0','dummy', ['Custom'], [], 0);
                            [I] = imread('Icons/icon_conn.png');
                            javaImage_eeg = im2java(I);
                            childNode.setIcon(javaImage_eeg);
                            treeModel.insertNodeInto(childNode,parent,parent.getChildCount()); 
                            % expand to show added child
                            tree.setSelectedNode( childNode );
                            % insure additional nodes are added to parent
                            tree.setSelectedNode( parent );
                            catch
                            end
                            
                            catch
                            end
                            
                            catch
                            end

                                end
                    catch
                    end
                    
                    try
                        allepochs_src{i,nbepochs};
                        
                        if(size(allepochs_src{i,nbepochs},2>0))
                           parent = childNodeEpoch;
                            childNode = uitreenode('v0','dummy', ['Reconstructed Epoch_' num2str(nbepochs)], [], 0);
                            childNodeSrcEpoch=childNode;
                            [I] = imread('Icons/javaImage_eeg.png');
                            javaImage_eeg = im2java(I);
                            childNode.setIcon(javaImage_eeg);
                            treeModel.insertNodeInto(childNode,parent,parent.getChildCount()); 
                            % expand to show added child
                            tree.setSelectedNode( childNode );
                            % insure additional nodes are added to parent
                            tree.setSelectedNode( parent );

                            try
                                allepochs_src_conn{i,nbepochs}.conn;
                                 parent = childNodeSrcEpoch;
                            childNode = uitreenode('v0','dummy', ['Connectivity'], [], 0);
                            childNodeConnectivity=childNode;
                            [I] = imread('Icons/connectivity_icon.png');
                            javaImage_eeg = im2java(I);
                            childNode.setIcon(javaImage_eeg);
                            treeModel.insertNodeInto(childNode,parent,parent.getChildCount()); 
                            % expand to show added child
                            tree.setSelectedNode( childNode );
                            % insure additional nodes are added to parent
                            tree.setSelectedNode( parent );
                            
                            try
                                allepochs_src_conn{i,nbepochs}.conn.static;
                                parent = childNodeConnectivity;
                            childNode = uitreenode('v0','dummy', ['Static'], [], 0);
                            childNodeStat=childNode;
                            [I] = imread('Icons/static_icon.png');
                            javaImage_eeg = im2java(I);
                            childNode.setIcon(javaImage_eeg);
                            treeModel.insertNodeInto(childNode,parent,parent.getChildCount()); 
                            % expand to show added child
                            tree.setSelectedNode( childNode );
                            % insure additional nodes are added to parent
                            tree.setSelectedNode( parent );
% %                             delta
                            try
                                allepochs_src_conn{i,nbepochs}.conn.static.delta;
                                parent = childNodeStat;
                            childNode = uitreenode('v0','dummy', ['Delta'], [], 0);
                            [I] = imread('Icons/icon_conn.png');
                            javaImage_eeg = im2java(I);
                            childNode.setIcon(javaImage_eeg);
                            treeModel.insertNodeInto(childNode,parent,parent.getChildCount()); 
                            % expand to show added child
                            tree.setSelectedNode( childNode );
                            % insure additional nodes are added to parent
                            tree.setSelectedNode( parent );
                            catch
                            end
 % %                             theta
                            try
                                allepochs_src_conn{i,nbepochs}.conn.static.theta;
                                parent = childNodeStat;
                            childNode = uitreenode('v0','dummy', ['Theta'], [], 0);
                            [I] = imread('Icons/icon_conn.png');
                            javaImage_eeg = im2java(I);
                            childNode.setIcon(javaImage_eeg);
                            treeModel.insertNodeInto(childNode,parent,parent.getChildCount()); 
                            % expand to show added child
                            tree.setSelectedNode( childNode );
                            % insure additional nodes are added to parent
                            tree.setSelectedNode( parent );
                            catch
                            end
   % %                             alpha
                            try
                                allepochs_src_conn{i,nbepochs}.conn.static.alpha;
                                parent = childNodeStat;
                            childNode = uitreenode('v0','dummy', ['Alpha'], [], 0);
                            [I] = imread('Icons/icon_conn.png');
                            javaImage_eeg = im2java(I);
                            childNode.setIcon(javaImage_eeg);
                            treeModel.insertNodeInto(childNode,parent,parent.getChildCount()); 
                            % expand to show added child
                            tree.setSelectedNode( childNode );
                            % insure additional nodes are added to parent
                            tree.setSelectedNode( parent );
                            catch
                            end
% %                             beta
                            try
                                allepochs_src_conn{i,nbepochs}.conn.static.beta;
                                parent = childNodeStat;
                            childNode = uitreenode('v0','dummy', ['Beta'], [], 0);
                            [I] = imread('Icons/icon_conn.png');
                            javaImage_eeg = im2java(I);
                            childNode.setIcon(javaImage_eeg);
                            treeModel.insertNodeInto(childNode,parent,parent.getChildCount()); 
                            % expand to show added child
                            tree.setSelectedNode( childNode );
                            % insure additional nodes are added to parent
                            tree.setSelectedNode( parent );
                            catch
                            end
  % %                             Gamma
                            try
                                allepochs_src_conn{i,nbepochs}.conn.static.gamma;
                                parent = childNodeStat;
                            childNode = uitreenode('v0','dummy', ['Gamma'], [], 0);
                            [I] = imread('Icons/icon_conn.png');
                            javaImage_eeg = im2java(I);
                            childNode.setIcon(javaImage_eeg);
                            treeModel.insertNodeInto(childNode,parent,parent.getChildCount()); 
                            % expand to show added child
                            tree.setSelectedNode( childNode );
                            % insure additional nodes are added to parent
                            tree.setSelectedNode( parent );
                            catch
                            end
 % %                             BB
                            try
                                allepochs_src_conn{i,nbepochs}.conn.static.bb;
                                parent = childNodeStat;
                            childNode = uitreenode('v0','dummy', ['Broadband'], [], 0);
                            [I] = imread('Icons/icon_conn.png');
                            javaImage_eeg = im2java(I);
                            childNode.setIcon(javaImage_eeg);
                            treeModel.insertNodeInto(childNode,parent,parent.getChildCount()); 
                            % expand to show added child
                            tree.setSelectedNode( childNode );
                            % insure additional nodes are added to parent
                            tree.setSelectedNode( parent );
                            catch
                            end
   % %                             delta
                            try
                                allepochs_src_conn{i,nbepochs}.conn.static.custom;
                                parent = childNodeStat;
                            childNode = uitreenode('v0','dummy', ['Custom'], [], 0);
                            [I] = imread('Icons/icon_conn.png');
                            javaImage_eeg = im2java(I);
                            childNode.setIcon(javaImage_eeg);
                            treeModel.insertNodeInto(childNode,parent,parent.getChildCount()); 
                            % expand to show added child
                            tree.setSelectedNode( childNode );
                            % insure additional nodes are added to parent
                            tree.setSelectedNode( parent );
                            catch
                            end
                  
                            
                            catch
                            end
                            
                            
                             try
                                allepochs_src_conn{i,nbepochs}.conn.dynamic;
                                parent = childNodeConnectivity;
                            childNode = uitreenode('v0','dummy', ['Dynamic'], [], 0);
                            childNodeDyn=childNode;
                            [I] = imread('Icons/dynamic_icon.png');
                            javaImage_eeg = im2java(I);
                            childNode.setIcon(javaImage_eeg);
                            treeModel.insertNodeInto(childNode,parent,parent.getChildCount()); 
                            % expand to show added child
                            tree.setSelectedNode( childNode );
                            % insure additional nodes are added to parent
                            tree.setSelectedNode( parent );
                            
                            % %                             delta
                            try
                                allepochs_src_conn{i,nbepochs}.conn.dynamic.delta;
                                parent = childNodeDyn;
                            childNode = uitreenode('v0','dummy', ['Delta'], [], 0);
                            [I] = imread('Icons/icon_conn.png');
                            javaImage_eeg = im2java(I);
                            childNode.setIcon(javaImage_eeg);
                            treeModel.insertNodeInto(childNode,parent,parent.getChildCount()); 
                            % expand to show added child
                            tree.setSelectedNode( childNode );
                            % insure additional nodes are added to parent
                            tree.setSelectedNode( parent );
                            catch
                            end
 % %                             theta
                            try
                                allepochs_src_conn{i,nbepochs}.conn.dynamic.theta;
                                parent = childNodeDyn;
                            childNode = uitreenode('v0','dummy', ['Theta'], [], 0);
                            [I] = imread('Icons/icon_conn.png');
                            javaImage_eeg = im2java(I);
                            childNode.setIcon(javaImage_eeg);
                            treeModel.insertNodeInto(childNode,parent,parent.getChildCount()); 
                            % expand to show added child
                            tree.setSelectedNode( childNode );
                            % insure additional nodes are added to parent
                            tree.setSelectedNode( parent );
                            catch
                            end
   % %                             alpha
                            try
                                allepochs_src_conn{i,nbepochs}.conn.dynamic.alpha;
                                parent = childNodeDyn;
                            childNode = uitreenode('v0','dummy', ['Alpha'], [], 0);
                            [I] = imread('Icons/icon_conn.png');
                            javaImage_eeg = im2java(I);
                            childNode.setIcon(javaImage_eeg);
                            treeModel.insertNodeInto(childNode,parent,parent.getChildCount()); 
                            % expand to show added child
                            tree.setSelectedNode( childNode );
                            % insure additional nodes are added to parent
                            tree.setSelectedNode( parent );
                            catch
                            end
% %                             beta
                            try
                                allepochs_src_conn{i,nbepochs}.conn.dynamic.beta;
                                parent = childNodeDyn;
                            childNode = uitreenode('v0','dummy', ['Beta'], [], 0);
                            [I] = imread('Icons/icon_conn.png');
                            javaImage_eeg = im2java(I);
                            childNode.setIcon(javaImage_eeg);
                            treeModel.insertNodeInto(childNode,parent,parent.getChildCount()); 
                            % expand to show added child
                            tree.setSelectedNode( childNode );
                            % insure additional nodes are added to parent
                            tree.setSelectedNode( parent );
                            catch
                            end
  % %                             Gamma
                            try
                                allepochs_src_conn{i,nbepochs}.conn.dynamic.gamma;
                                parent = childNodeDyn;
                            childNode = uitreenode('v0','dummy', ['Gamma'], [], 0);
                            [I] = imread('Icons/icon_conn.png');
                            javaImage_eeg = im2java(I);
                            childNode.setIcon(javaImage_eeg);
                            treeModel.insertNodeInto(childNode,parent,parent.getChildCount()); 
                            % expand to show added child
                            tree.setSelectedNode( childNode );
                            % insure additional nodes are added to parent
                            tree.setSelectedNode( parent );
                            catch
                            end
 % %                             BB
                            try
                                allepochs_src_conn{i,nbepochs}.conn.dynamic.bb;
                                parent = childNodeDyn;
                            childNode = uitreenode('v0','dummy', ['Broadband'], [], 0);
                            [I] = imread('Icons/icon_conn.png');
                            javaImage_eeg = im2java(I);
                            childNode.setIcon(javaImage_eeg);
                            treeModel.insertNodeInto(childNode,parent,parent.getChildCount()); 
                            % expand to show added child
                            tree.setSelectedNode( childNode );
                            % insure additional nodes are added to parent
                            tree.setSelectedNode( parent );
                            catch
                            end
   % %                             delta
                            try
                                allepochs_src_conn{i,nbepochs}.conn.dynamic.custom;
                                parent = childNodeDyn;
                            childNode = uitreenode('v0','dummy', ['Custom'], [], 0);
                            [I] = imread('Icons/icon_conn.png');
                            javaImage_eeg = im2java(I);
                            childNode.setIcon(javaImage_eeg);
                            treeModel.insertNodeInto(childNode,parent,parent.getChildCount()); 
                            % expand to show added child
                            tree.setSelectedNode( childNode );
                            % insure additional nodes are added to parent
                            tree.setSelectedNode( parent );
                            catch
                            end
                            
                            catch
                            end
                            
                            catch
                            end
                        end
                    catch
                    end
                catch
                end
            end
        catch
        end
 catch
 end
 
 try
        alleegs_preprocessed{i};
        parent = childNodeS;
        childNode = uitreenode('v0','dummy', 'EEG_preprocessed', [], 0);
        childNodepre=childNode;
        [I] = imread('Icons/javaImage_eeg.png');
        javaImage_eeg = im2java(I);
        childNode.setIcon(javaImage_eeg);
        treeModel.insertNodeInto(childNode,parent,parent.getChildCount()); 
        % expand to show added child
        tree.setSelectedNode( childNode );
        % insure additional nodes are added to parent
        tree.setSelectedNode( parent );
        
        try
        alleegs_preprocessed_src{i};
        parent = childNodepre;
        childNode = uitreenode('v0','dummy', 'Reconstructed Preprocessed EEG', [], 0);
        childRecPre=childNode;
        
        [I] = imread('Icons/javaImage_eeg.png');
        javaImage_eeg = im2java(I);
        childNode.setIcon(javaImage_eeg);
        treeModel.insertNodeInto(childNode,parent,parent.getChildCount()); 
        % expand to show added child
        tree.setSelectedNode( childNode );
        % insure additional nodes are added to parent
        tree.setSelectedNode(parent);
        
        try
                                alleegs_preprocessed_src_conn{i}.conn;
                                 parent = childRecPre;
                            childNode = uitreenode('v0','dummy', ['Connectivity'], [], 0);
                            childNodeConnectivity=childNode;
                            [I] = imread('Icons/connectivity_icon.png');
                            javaImage_eeg = im2java(I);
                            childNode.setIcon(javaImage_eeg);
                            treeModel.insertNodeInto(childNode,parent,parent.getChildCount()); 
                            % expand to show added child
                            tree.setSelectedNode( childNode );
                            % insure additional nodes are added to parent
                            tree.setSelectedNode( parent );
                            
                            try
                                
                                alleegs_preprocessed_src_conn{i}.conn.static;
                                parent = childNodeConnectivity;
                            childNode = uitreenode('v0','dummy', ['Static'], [], 0);
                            childNodeStat=childNode;
                            [I] = imread('Icons/static_icon.png');
                            javaImage_eeg = im2java(I);
                            childNode.setIcon(javaImage_eeg);
                            treeModel.insertNodeInto(childNode,parent,parent.getChildCount()); 
                            % expand to show added child
                            tree.setSelectedNode( childNode );
                            % insure additional nodes are added to parent
                            tree.setSelectedNode( parent );
% %                             delta
                            try
                                alleegs_preprocessed_src_conn{i}.conn.delta;
                                parent = childNodeStat;
                            childNode = uitreenode('v0','dummy', ['Delta'], [], 0);
                            [I] = imread('Icons/icon_conn.png');
                            javaImage_eeg = im2java(I);
                            childNode.setIcon(javaImage_eeg);
                            treeModel.insertNodeInto(childNode,parent,parent.getChildCount()); 
                            % expand to show added child
                            tree.setSelectedNode( childNode );
                            % insure additional nodes are added to parent
                            tree.setSelectedNode( parent );
                            catch
                            end
 % %                             theta
                            try
                                alleegs_preprocessed_src_conn{i}.conn.static.theta;
                                parent = childNodeStat;
                            childNode = uitreenode('v0','dummy', ['Theta'], [], 0);
                            [I] = imread('Icons/icon_conn.png');
                            javaImage_eeg = im2java(I);
                            childNode.setIcon(javaImage_eeg);
                            treeModel.insertNodeInto(childNode,parent,parent.getChildCount()); 
                            % expand to show added child
                            tree.setSelectedNode( childNode );
                            % insure additional nodes are added to parent
                            tree.setSelectedNode( parent );
                            catch
                            end
   % %                             alpha
                            try
                                alleegs_preprocessed_src_conn{i}.conn.static.alpha;
                                parent = childNodeStat;
                            childNode = uitreenode('v0','dummy', ['Alpha'], [], 0);
                            [I] = imread('Icons/icon_conn.png');
                            javaImage_eeg = im2java(I);
                            childNode.setIcon(javaImage_eeg);
                            treeModel.insertNodeInto(childNode,parent,parent.getChildCount()); 
                            % expand to show added child
                            tree.setSelectedNode( childNode );
                            % insure additional nodes are added to parent
                            tree.setSelectedNode( parent );
                            catch
                            end
% %                             beta
                            try
                                alleegs_preprocessed_src_conn{i}.conn.static.beta;
                                parent = childNodeStat;
                            childNode = uitreenode('v0','dummy', ['Beta'], [], 0);
                            [I] = imread('Icons/icon_conn.png');
                            javaImage_eeg = im2java(I);
                            childNode.setIcon(javaImage_eeg);
                            treeModel.insertNodeInto(childNode,parent,parent.getChildCount()); 
                            % expand to show added child
                            tree.setSelectedNode( childNode );
                            % insure additional nodes are added to parent
                            tree.setSelectedNode( parent );
                            catch
                            end
  % %                             Gamma
                            try
                                alleegs_preprocessed_src_conn{i}.conn.static.gamma;
                                parent = childNodeStat;
                            childNode = uitreenode('v0','dummy', ['Gamma'], [], 0);
                            [I] = imread('Icons/icon_conn.png');
                            javaImage_eeg = im2java(I);
                            childNode.setIcon(javaImage_eeg);
                            treeModel.insertNodeInto(childNode,parent,parent.getChildCount()); 
                            % expand to show added child
                            tree.setSelectedNode( childNode );
                            % insure additional nodes are added to parent
                            tree.setSelectedNode( parent );
                            catch
                            end
 % %                             BB
                            try
                                alleegs_preprocessed_src_conn{i}.conn.static.bb;
                                parent = childNodeStat;
                            childNode = uitreenode('v0','dummy', ['Broadband'], [], 0);
                            [I] = imread('Icons/icon_conn.png');
                            javaImage_eeg = im2java(I);
                            childNode.setIcon(javaImage_eeg);
                            treeModel.insertNodeInto(childNode,parent,parent.getChildCount()); 
                            % expand to show added child
                            tree.setSelectedNode( childNode );
                            % insure additional nodes are added to parent
                            tree.setSelectedNode( parent );
                            catch
                            end
   % %                             delta
                            try
                                alleegs_preprocessed_src_conn{i}.conn.static.custom;
                                parent = childNodeStat;
                            childNode = uitreenode('v0','dummy', ['Custom'], [], 0);
                            [I] = imread('Icons/icon_conn.png');
                            javaImage_eeg = im2java(I);
                            childNode.setIcon(javaImage_eeg);
                            treeModel.insertNodeInto(childNode,parent,parent.getChildCount()); 
                            % expand to show added child
                            tree.setSelectedNode( childNode );
                            % insure additional nodes are added to parent
                            tree.setSelectedNode( parent );
                            catch
                            end
                  
                            
                            catch
                            end
                            
                            
                             try
                                alleegs_preprocessed_src_conn{i}.conn.dynamic;
                                parent = childNodeConnectivity;
                            childNode = uitreenode('v0','dummy', ['Dynamic'], [], 0);
                            childNodeDyn=childNode;
                            [I] = imread('Icons/dynamic_icon.png');
                            javaImage_eeg = im2java(I);
                            childNode.setIcon(javaImage_eeg);
                            treeModel.insertNodeInto(childNode,parent,parent.getChildCount()); 
                            % expand to show added child
                            tree.setSelectedNode( childNode );
                            % insure additional nodes are added to parent
                            tree.setSelectedNode( parent );
                            
                            % %                             delta
                            try
                                alleegs_preprocessed_src_conn{i}.conn.dynamic.delta;
                                parent = childNodeDyn;
                            childNode = uitreenode('v0','dummy', ['Delta'], [], 0);
                            [I] = imread('Icons/icon_conn.png');
                            javaImage_eeg = im2java(I);
                            childNode.setIcon(javaImage_eeg);
                            treeModel.insertNodeInto(childNode,parent,parent.getChildCount()); 
                            % expand to show added child
                            tree.setSelectedNode( childNode );
                            % insure additional nodes are added to parent
                            tree.setSelectedNode( parent );
                            catch
                            end
 % %                             theta
                            try
                                alleegs_preprocessed_src_conn{i}.conn.dynamic.theta;
                                parent = childNodeDyn;
                            childNode = uitreenode('v0','dummy', ['Theta'], [], 0);
                            [I] = imread('Icons/icon_conn.png');
                            javaImage_eeg = im2java(I);
                            childNode.setIcon(javaImage_eeg);
                            treeModel.insertNodeInto(childNode,parent,parent.getChildCount()); 
                            % expand to show added child
                            tree.setSelectedNode( childNode );
                            % insure additional nodes are added to parent
                            tree.setSelectedNode( parent );
                            catch
                            end
   % %                             alpha
                            try
                                alleegs_preprocessed_src_conn{i}.conn.dynamic.alpha;
                                parent = childNodeDyn;
                            childNode = uitreenode('v0','dummy', ['Alpha'], [], 0);
                            [I] = imread('Icons/icon_conn.png');
                            javaImage_eeg = im2java(I);
                            childNode.setIcon(javaImage_eeg);
                            treeModel.insertNodeInto(childNode,parent,parent.getChildCount()); 
                            % expand to show added child
                            tree.setSelectedNode( childNode );
                            % insure additional nodes are added to parent
                            tree.setSelectedNode( parent );
                            catch
                            end
% %                             beta
                            try
                                alleegs_preprocessed_src_conn{i}.conn.dynamic.beta;
                                parent = childNodeDyn;
                            childNode = uitreenode('v0','dummy', ['Beta'], [], 0);
                            [I] = imread('Icons/icon_conn.png');
                            javaImage_eeg = im2java(I);
                            childNode.setIcon(javaImage_eeg);
                            treeModel.insertNodeInto(childNode,parent,parent.getChildCount()); 
                            % expand to show added child
                            tree.setSelectedNode( childNode );
                            % insure additional nodes are added to parent
                            tree.setSelectedNode( parent );
                            catch
                            end
  % %                             Gamma
                            try
                                alleegs_preprocessed_src_conn{i}.conn.dynamic.gamma;
                                parent = childNodeDyn;
                            childNode = uitreenode('v0','dummy', ['Gamma'], [], 0);
                            [I] = imread('Icons/icon_conn.png');
                            javaImage_eeg = im2java(I);
                            childNode.setIcon(javaImage_eeg);
                            treeModel.insertNodeInto(childNode,parent,parent.getChildCount()); 
                            % expand to show added child
                            tree.setSelectedNode( childNode );
                            % insure additional nodes are added to parent
                            tree.setSelectedNode( parent );
                            catch
                            end
 % %                             BB
                            try
                                alleegs_preprocessed_src_conn{i}.conn.dynamic.bb;
                                parent = childNodeDyn;
                            childNode = uitreenode('v0','dummy', ['Broadband'], [], 0);
                            [I] = imread('Icons/icon_conn.png');
                            javaImage_eeg = im2java(I);
                            childNode.setIcon(javaImage_eeg);
                            treeModel.insertNodeInto(childNode,parent,parent.getChildCount()); 
                            % expand to show added child
                            tree.setSelectedNode( childNode );
                            % insure additional nodes are added to parent
                            tree.setSelectedNode( parent );
                            catch
                            end
   % %                             delta
                            try
                                alleegs_preprocessed_src_conn{i}.conn.dynamic.custom;
                                parent = childNodeDyn;
                            childNode = uitreenode('v0','dummy', ['Custom'], [], 0);
                            [I] = imread('Icons/icon_conn.png');
                            javaImage_eeg = im2java(I);
                            childNode.setIcon(javaImage_eeg);
                            treeModel.insertNodeInto(childNode,parent,parent.getChildCount()); 
                            % expand to show added child
                            tree.setSelectedNode( childNode );
                            % insure additional nodes are added to parent
                            tree.setSelectedNode( parent );
                            catch
                            end
                            
                            catch
                            end
                            
                            catch
                            end
        catch
        end
        
 catch
 end
 
 
 try
    alleegs_src{i};
            if( size(alleegs_src{i},2))
        parent = childNodeS;
        childNode = uitreenode('v0','dummy', 'Reconstructed EEG', [], 0);
        childNodeRec=childNode;
        [I] = imread('Icons/javaImage_eeg.png');
        javaImage_eeg = im2java(I);
        childNode.setIcon(javaImage_eeg);
        treeModel.insertNodeInto(childNode,parent,parent.getChildCount()); 
        % expand to show added child
        tree.setSelectedNode( childNode );
        % insure additional nodes are added to parent
        tree.setSelectedNode( parent );

                                    try
                                alleegs_src_conn{i}.conn;
                                 parent = childNodeRec;
                            childNode = uitreenode('v0','dummy', ['Connectivity'], [], 0);
                            childNodeConnectivity=childNode;
                            [I] = imread('Icons/connectivity_icon.png');
                            javaImage_eeg = im2java(I);
                            childNode.setIcon(javaImage_eeg);
                            treeModel.insertNodeInto(childNode,parent,parent.getChildCount()); 
                            % expand to show added child
                            tree.setSelectedNode( childNode );
                            % insure additional nodes are added to parent
                            tree.setSelectedNode( parent );
                            
                            try
                                alleegs_src_conn{subjIndex}.conn.static;
                                parent = childNodeConnectivity;
                            childNode = uitreenode('v0','dummy', ['Static'], [], 0);
                            childNodeStat=childNode;
                            [I] = imread('Icons/static_icon.png');
                            javaImage_eeg = im2java(I);
                            childNode.setIcon(javaImage_eeg);
                            treeModel.insertNodeInto(childNode,parent,parent.getChildCount()); 
                            % expand to show added child
                            tree.setSelectedNode( childNode );
                            % insure additional nodes are added to parent
                            tree.setSelectedNode( parent );
% %                             delta
                            try
                                alleegs_src_conn{subjIndex}.conn.static.delta;
                                parent = childNodeStat;
                            childNode = uitreenode('v0','dummy', ['Delta'], [], 0);
                            [I] = imread('Icons/icon_conn.png');
                            javaImage_eeg = im2java(I);
                            childNode.setIcon(javaImage_eeg);
                            treeModel.insertNodeInto(childNode,parent,parent.getChildCount()); 
                            % expand to show added child
                            tree.setSelectedNode( childNode );
                            % insure additional nodes are added to parent
                            tree.setSelectedNode( parent );
                            catch
                            end
 % %                             theta
                            try
                                alleegs_src_conn{subjIndex}.conn.static.theta;
                                parent = childNodeStat;
                            childNode = uitreenode('v0','dummy', ['Theta'], [], 0);
                            [I] = imread('Icons/icon_conn.png');
                            javaImage_eeg = im2java(I);
                            childNode.setIcon(javaImage_eeg);
                            treeModel.insertNodeInto(childNode,parent,parent.getChildCount()); 
                            % expand to show added child
                            tree.setSelectedNode( childNode );
                            % insure additional nodes are added to parent
                            tree.setSelectedNode( parent );
                            catch
                            end
   % %                             alpha
                            try
                                alleegs_src_conn{subjIndex}.conn.static.alpha;
                                parent = childNodeStat;
                            childNode = uitreenode('v0','dummy', ['Alpha'], [], 0);
                            [I] = imread('Icons/icon_conn.png');
                            javaImage_eeg = im2java(I);
                            childNode.setIcon(javaImage_eeg);
                            treeModel.insertNodeInto(childNode,parent,parent.getChildCount()); 
                            % expand to show added child
                            tree.setSelectedNode( childNode );
                            % insure additional nodes are added to parent
                            tree.setSelectedNode( parent );
                            catch
                            end
% %                             beta
                            try
                                alleegs_src_conn{subjIndex}.conn.static.beta;
                                parent = childNodeStat;
                            childNode = uitreenode('v0','dummy', ['Beta'], [], 0);
                            [I] = imread('Icons/icon_conn.png');
                            javaImage_eeg = im2java(I);
                            childNode.setIcon(javaImage_eeg);
                            treeModel.insertNodeInto(childNode,parent,parent.getChildCount()); 
                            % expand to show added child
                            tree.setSelectedNode( childNode );
                            % insure additional nodes are added to parent
                            tree.setSelectedNode( parent );
                            catch
                            end
  % %                             Gamma
                            try
                                alleegs_src_conn{subjIndex}.conn.static.gamma;
                                parent = childNodeStat;
                            childNode = uitreenode('v0','dummy', ['Gamma'], [], 0);
                            [I] = imread('Icons/icon_conn.png');
                            javaImage_eeg = im2java(I);
                            childNode.setIcon(javaImage_eeg);
                            treeModel.insertNodeInto(childNode,parent,parent.getChildCount()); 
                            % expand to show added child
                            tree.setSelectedNode( childNode );
                            % insure additional nodes are added to parent
                            tree.setSelectedNode( parent );
                            catch
                            end
 % %                             BB
                            try
                                alleegs_src_conn{subjIndex}.conn.static.bb;
                                parent = childNodeStat;
                            childNode = uitreenode('v0','dummy', ['Broadband'], [], 0);
                            [I] = imread('Icons/icon_conn.png');
                            javaImage_eeg = im2java(I);
                            childNode.setIcon(javaImage_eeg);
                            treeModel.insertNodeInto(childNode,parent,parent.getChildCount()); 
                            % expand to show added child
                            tree.setSelectedNode( childNode );
                            % insure additional nodes are added to parent
                            tree.setSelectedNode( parent );
                            catch
                            end
   % %                             delta
                            try
                                alleegs_src_conn{subjIndex}.conn.static.custom;
                                parent = childNodeStat;
                            childNode = uitreenode('v0','dummy', ['Custom'], [], 0);
                            [I] = imread('Icons/icon_conn.png');
                            javaImage_eeg = im2java(I);
                            childNode.setIcon(javaImage_eeg);
                            treeModel.insertNodeInto(childNode,parent,parent.getChildCount()); 
                            % expand to show added child
                            tree.setSelectedNode( childNode );
                            % insure additional nodes are added to parent
                            tree.setSelectedNode( parent );
                            catch
                            end
                  
                            
                            catch
                            end
                            
                            
                             try
                                alleegs_src_conn{subjIndex}.conn.dynamic;
                                parent = childNodeConnectivity;
                            childNode = uitreenode('v0','dummy', ['Dynamic'], [], 0);
                            childNodeDyn=childNode;
                            [I] = imread('Icons/dynamic_icon.png');
                            javaImage_eeg = im2java(I);
                            childNode.setIcon(javaImage_eeg);
                            treeModel.insertNodeInto(childNode,parent,parent.getChildCount()); 
                            % expand to show added child
                            tree.setSelectedNode( childNode );
                            % insure additional nodes are added to parent
                            tree.setSelectedNode( parent );
                            
                            % %                             delta
                            try
                                alleegs_src_conn{subjIndex}.conn.dynamic.delta;
                                parent = childNodeDyn;
                            childNode = uitreenode('v0','dummy', ['Delta'], [], 0);
                            [I] = imread('Icons/icon_conn.png');
                            javaImage_eeg = im2java(I);
                            childNode.setIcon(javaImage_eeg);
                            treeModel.insertNodeInto(childNode,parent,parent.getChildCount()); 
                            % expand to show added child
                            tree.setSelectedNode( childNode );
                            % insure additional nodes are added to parent
                            tree.setSelectedNode( parent );
                            catch
                            end
 % %                             theta
                            try
                                alleegs_src_conn{subjIndex}.conn.dynamic.theta;
                                parent = childNodeDyn;
                            childNode = uitreenode('v0','dummy', ['Theta'], [], 0);
                            [I] = imread('Icons/icon_conn.png');
                            javaImage_eeg = im2java(I);
                            childNode.setIcon(javaImage_eeg);
                            treeModel.insertNodeInto(childNode,parent,parent.getChildCount()); 
                            % expand to show added child
                            tree.setSelectedNode( childNode );
                            % insure additional nodes are added to parent
                            tree.setSelectedNode( parent );
                            catch
                            end
   % %                             alpha
                            try
                                alleegs_src_conn{subjIndex}.conn.dynamic.alpha;
                                parent = childNodeDyn;
                            childNode = uitreenode('v0','dummy', ['Alpha'], [], 0);
                            [I] = imread('Icons/icon_conn.png');
                            javaImage_eeg = im2java(I);
                            childNode.setIcon(javaImage_eeg);
                            treeModel.insertNodeInto(childNode,parent,parent.getChildCount()); 
                            % expand to show added child
                            tree.setSelectedNode( childNode );
                            % insure additional nodes are added to parent
                            tree.setSelectedNode( parent );
                            catch
                            end
% %                             beta
                            try
                                alleegs_src_conn{subjIndex}.conn.dynamic.beta;
                                parent = childNodeDyn;
                            childNode = uitreenode('v0','dummy', ['Beta'], [], 0);
                            [I] = imread('Icons/icon_conn.png');
                            javaImage_eeg = im2java(I);
                            childNode.setIcon(javaImage_eeg);
                            treeModel.insertNodeInto(childNode,parent,parent.getChildCount()); 
                            % expand to show added child
                            tree.setSelectedNode( childNode );
                            % insure additional nodes are added to parent
                            tree.setSelectedNode( parent );
                            catch
                            end
  % %                             Gamma
                            try
                                alleegs_src_conn{subjIndex}.conn.dynamic.gamma;
                                parent = childNodeDyn;
                            childNode = uitreenode('v0','dummy', ['Gamma'], [], 0);
                            [I] = imread('Icons/icon_conn.png');
                            javaImage_eeg = im2java(I);
                            childNode.setIcon(javaImage_eeg);
                            treeModel.insertNodeInto(childNode,parent,parent.getChildCount()); 
                            % expand to show added child
                            tree.setSelectedNode( childNode );
                            % insure additional nodes are added to parent
                            tree.setSelectedNode( parent );
                            catch
                            end
 % %                             BB
                            try
                                alleegs_src_conn{subjIndex}.conn.dynamic.bb;
                                parent = childNodeDyn;
                            childNode = uitreenode('v0','dummy', ['Broadband'], [], 0);
                            [I] = imread('Icons/icon_conn.png');
                            javaImage_eeg = im2java(I);
                            childNode.setIcon(javaImage_eeg);
                            treeModel.insertNodeInto(childNode,parent,parent.getChildCount()); 
                            % expand to show added child
                            tree.setSelectedNode( childNode );
                            % insure additional nodes are added to parent
                            tree.setSelectedNode( parent );
                            catch
                            end
   % %                             delta
                            try
                                alleegs_src_conn{subjIndex}.conn.dynamic.custom;
                                parent = childNodeDyn;
                            childNode = uitreenode('v0','dummy', ['Custom'], [], 0);
                            [I] = imread('Icons/icon_conn.png');
                            javaImage_eeg = im2java(I);
                            childNode.setIcon(javaImage_eeg);
                            treeModel.insertNodeInto(childNode,parent,parent.getChildCount()); 
                            % expand to show added child
                            tree.setSelectedNode( childNode );
                            % insure additional nodes are added to parent
                            tree.setSelectedNode( parent );
                            catch
                            end
                            
                            catch
                            end
                            
                            catch
                            end

            end
 catch
            end
end
waitbar(1,f,'Completed');
close(f);

% --------------------------------------------------------------------
function save_mb_Callback(hObject, eventdata, handles)
% hObject    handle to save_mb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global numberSubjects;
global allsubjects;
global alleegs; 
global alleegs_preprocessed;
global alleegs_preprocessed_interp;
global allepochs;
global allepochs_preprocessed;
global allepochs_preprocessed_interp;
global allmodels;
global allnoise;
global alleegs_src;
global allepochs_src;
global alleegs_preprocessed_src;
global allepochs_preprocessed_src;
global alleegs_src_conn;
global allepochs_src_conn;
global alleegs_preprocessed_src_conn;
global allepochs_preprocessed_src_conn;

EEGNET.numberSubjects=numberSubjects;
EEGNET.allsubjects=allsubjects;
EEGNET.alleegs=alleegs; 
EEGNET.alleegs_preprocessed=alleegs_preprocessed;
EEGNET.alleegs_preprocessed_interp=alleegs_preprocessed_interp;
EEGNET.allepochs=allepochs;
EEGNET.allepochs_preprocessed=allepochs_preprocessed;
EEGNET.allepochs_preprocessed_interp=allepochs_preprocessed_interp;
EEGNET.allmodels=allmodels;
EEGNET.allnoise=allnoise;
EEGNET.alleegs_src=alleegs_src;
EEGNET.allepochs_src=allepochs_src;
EEGNET.alleegs_preprocessed_src=alleegs_preprocessed_src;
EEGNET.allepochs_preprocessed_src=allepochs_preprocessed_src;
EEGNET.alleegs_src_conn=alleegs_src_conn;
EEGNET.allepochs_src_conn=allepochs_src_conn;
EEGNET.alleegs_preprocessed_src_conn=alleegs_preprocessed_src_conn;
EEGNET.allepochs_preprocessed_src_conn=allepochs_preprocessed_src_conn;

[filename, filepath] = uiputfile('*.mat', 'Save the database:');
if isequal(filename,0)||isequal(filepath,0)
    return
else
    FileName = fullfile(filepath, filename);
save(FileName, 'EEGNET', '-v7.3');
end
% --------------------------------------------------------------------
function quit_mb_Callback(hObject, eventdata, handles)
% hObject    handle to quit_mb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: delete(hObject) closes the figure
  selection = questdlg('Are you sure you want to quit EEGLink?',...
       'Close Request',...
       'Yes','No','Save and quit','Save and quit');
    switch selection
       case 'Yes'
           global numberSubjects;
         global allsubjects;
         global alleegs;
         global alleegs_preprocessed;
         global alleegs_preprocessed_interp;

         global allepochs;
         global allepochs_preprocessed;
         global allepochs_preprocessed_interp;

         global allmodels;
         global allnoise;
         global alleegs_src;
         global allepochs_src;
         global alleegs_preprocessed_src;
         global allepochs_preprocessed_src;
         global alleegs_src_conn;
         global allepochs_src_conn;
         global alleegs_preprocessed_src_conn;
         global allepochs_preprocessed_src_conn;

         % load('data/GlobalData.mat');
         % % alleegs=cell array of EEGlab structures.
         numberSubjects=0;
         allepochs_preprocessed_interp={};
         allsubjects=struct();
         alleegs={};
         alleegs_preprocessed={};
         allepochs={};
         allepochs_preprocessed={};
         alleegs_preprocessed_src={};
         allepochs_src={};
         allepochs_preprocessed_src={};
         alleegs_src={};
         alleegs_src_conn={};
         allepochs_src_conn={};
         alleegs_preprocessed_src_conn={};
         allepochs_preprocessed_src_conn={};
         allmodels={};
         allnoise={};
         clear all;
          delete(gcf)
       case 'No'
       return
        case 'Save and quit'
            global numberSubjects;
 global allsubjects;
 global alleegs;
 global alleegs_preprocessed;
 global alleegs_preprocessed_interp;
 global allepochs;
 global allepochs_preprocessed;
 global allepochs_preprocessed_interp;
 global allmodels;
 global allnoise;
 global alleegs_src;
 global allepochs_src;
 global alleegs_preprocessed_src;
 global allepochs_preprocessed_src;
 global alleegs_src_conn;
 global allepochs_src_conn;
 global alleegs_preprocessed_src_conn;
 global allepochs_preprocessed_src_conn;

 EEGNET.numberSubjects=numberSubjects;
 EEGNET.allsubjects=allsubjects;
 EEGNET.alleegs=alleegs;
 EEGNET.alleegs_preprocessed=alleegs_preprocessed;
 EEGNET.alleegs_preprocessed_interp=alleegs_preprocessed_interp;
 EEGNET.allepochs=allepochs;
 EEGNET.allepochs_preprocessed=allepochs_preprocessed;
 EEGNET.allepochs_preprocessed_interp=allepochs_preprocessed_interp;
 EEGNET.allmodels=allmodels;
 EEGNET.allnoise=allnoise;
 EEGNET.alleegs_src=alleegs_src;
 EEGNET.allepochs_src=allepochs_src;
 EEGNET.alleegs_preprocessed_src=alleegs_preprocessed_src;
 EEGNET.allepochs_preprocessed_src=allepochs_preprocessed_src;
 EEGNET.alleegs_src_conn=alleegs_src_conn;
 EEGNET.allepochs_src_conn=allepochs_src_conn;
 EEGNET.alleegs_preprocessed_src_conn=alleegs_preprocessed_src_conn;
 EEGNET.allepochs_preprocessed_src_conn=allepochs_preprocessed_src_conn;

 [filename, filepath] = uiputfile('*.mat', 'Save the database:');
 FileName = fullfile(filepath, filename);
 save(FileName, 'EEGNET', '-v7.3');
         clear all;
          delete(gcf)

    end
 % delete(hObject);



% --------------------------------------------------------------------
function eeg_mb_Callback(hObject, eventdata, handles)
% hObject    handle to eeg_mb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function elec_mb_Callback(hObject, eventdata, handles)
% hObject    handle to elec_mb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on slider movement.
function sWindow_Callback(hObject, eventdata, handles)
% hObject    handle to sWindow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --------------------------------------------------------------------
function team_mb_Callback(hObject, eventdata, handles)
% hObject    handle to team_mb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Form_team

% --------------------------------------------------------------------
function site_mb_Callback(hObject, eventdata, handles)
% hObject    handle to site_mb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
web('https://sites.google.com/site/eegnetworks/home', '-browser')


% --------------------------------------------------------------------
function subjectset_mb_Callback(hObject, eventdata, handles)
% hObject    handle to subjectset_mb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global allsubjects;
global alleegs;
global numberSubjects;
global tree;
global treeModel;
global rootNode;
global javaImage_subj;
import javax.swing.*
import javax.swing.tree.*;

% % The user should load an array cell.mat containing the subjects structures
% each struct has: sname, srate, data (channels x samples), channelfile
% file
addpath(genpath('external/eeglab13_1_1b'));   

[filename,pathname]=uigetfile({'*.mat','Import subject set (*.mat)'});
if isequal(filename,0)||isequal(pathname,0)
    return
else
    fpath=fullfile(pathname,filename);
    cellOut=struct2cell(load(fpath));
    subjectset=(cellOut{1})
end
nbsubjects=length(subjectset);
numberSubjects=length(allsubjects);
for s=1:nbsubjects
    try
        EEG=writeEEGLAB_struct(subjectset{s}.data,subjectset{s}.srate,subjectset{s}.sname,filename,pathname,subjectset{s}.channelfile);
        numberSubjects=numberSubjects+1;
        allsubjects.names{numberSubjects}=subjectset{s}.sname;
        alleegs{numberSubjects}=EEG;
        parent = rootNode;
        childNode = uitreenode('v0','dummy', ['S_' subjectset{s}.sname], [], 0);
        childNode.setIcon(javaImage_subj);
        treeModel.insertNodeInto(childNode,parent,parent.getChildCount()); 
        % expand to show added child
        tree.setSelectedNode( childNode );
        % insure additional nodes are added to parent
        tree.setSelectedNode( parent );
        
         parent = childNode;
        childNode = uitreenode('v0','dummy', 'EEG', [], 0);
        [I] = imread('Icons/javaImage_eeg.png');
        javaImage_eeg = im2java(I);
        childNode.setIcon(javaImage_eeg);
        treeModel.insertNodeInto(childNode,parent,parent.getChildCount()); 
        % expand to show added child
        tree.setSelectedNode( childNode );
        % insure additional nodes are added to parent
        tree.setSelectedNode( parent );
    catch
        msgbox('Please check the format of the subject set ');
    end
end


% --------------------------------------------------------------------
function bids_mb_Callback(hObject, eventdata, handles)
% hObject    handle to bids_mb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global allsubjects;
global numberSubjects;
global alleegs;
global tree;
global treeModel;
global rootNode;
global javaImage_subj;
import javax.swing.*
import javax.swing.tree.*;


directoryBIDS=uigetdir(matlabroot,'Select BIDS folder');

if isequal(directoryBIDS,0)
    return
else

addpath(genpath('bids-matlab-tools-master')); 
addpath(genpath('external/eeglab13_1_1b')); 
[MyAllEEGs,Mynames] = pop_importbids_AK(directoryBIDS);

if (numberSubjects>0)
    for i=1:length(Mynames)   
        

        subjname = Mynames{i};
        if(find(strcmp(allsubjects.names, subjname)))
       myicon = imread('Icons/logo_new_eegnet.png');
       msgbox(['The subject  ' subjname 'cannot be imported as the same name already exists'],'Warning','custom',myicon);  
        else
        numberSubjects=numberSubjects+1;
        alleegs{numberSubjects}=MyAllEEGs{i};
        allsubjects.names{numberSubjects}=subjname;
        parent = rootNode;
        childNode = uitreenode('v0','dummy', ['S_' subjname], [], 0);
        childNode.setIcon(javaImage_subj);
        treeModel.insertNodeInto(childNode,parent,parent.getChildCount()); 
        % expand to show added child
        tree.setSelectedNode( childNode );
        % insure additional nodes are added to parent
        tree.setSelectedNode( parent );
        
        parent = childNode;
        childNode = uitreenode('v0','dummy', 'EEG', [], 0);
        [I] = imread('Icons/javaImage_eeg.png');
        javaImage_eeg = im2java(I);
        childNode.setIcon(javaImage_eeg);
        treeModel.insertNodeInto(childNode,parent,parent.getChildCount()); 
        % expand to show added child
        tree.setSelectedNode( childNode );
        % insure additional nodes are added to parent
        tree.setSelectedNode( parent );

            end
    end

    else
        alleegs=MyAllEEGs;
        allsubjects.names=Mynames;
        numberSubjects=length(Mynames);
            for i=1:length(Mynames)    
         parent = rootNode;
        childNode = uitreenode('v0','dummy', ['S_' Mynames{i}], [], 0);
        childNode.setIcon(javaImage_subj);
        treeModel.insertNodeInto(childNode,parent,parent.getChildCount()); 
        % expand to show added child
        tree.setSelectedNode( childNode );
        % insure additional nodes are added to parent
        tree.setSelectedNode( parent );
        
        parent = childNode;
        childNode = uitreenode('v0','dummy', 'EEG', [], 0);
        [I] = imread('Icons/javaImage_eeg.png');
        javaImage_eeg = im2java(I);
        childNode.setIcon(javaImage_eeg);
        treeModel.insertNodeInto(childNode,parent,parent.getChildCount()); 
        % expand to show added child
        tree.setSelectedNode( childNode );
        % insure additional nodes are added to parent
        tree.setSelectedNode( parent );

            end
end
end

% --------------------------------------------------------------------
function dyn_SL_mb_Callback(hObject, eventdata, handles)
% hObject    handle to dyn_SL_mb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
dyn_SL1

% --------------------------------------------------------------------
function dyn_GL_mb_Callback(hObject, eventdata, handles)
% hObject    handle to dyn_GL_mb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Form_DA_GA


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: delete(hObject) closes the figure
  selection = questdlg('Are you sure you want to quit EEGLink?',...
       'Close Request',...
       'Yes','No','Save and quit','Save and quit');
    switch selection
       case 'Yes'
           global numberSubjects;
         global allsubjects;
         global alleegs;
         global alleegs_preprocessed;
         global alleegs_preprocessed_interp;

         global allepochs;
         global allepochs_preprocessed;
         global allepochs_preprocessed_interp;

         global allmodels;
         global allnoise;
         global alleegs_src;
         global allepochs_src;
         global alleegs_preprocessed_src;
         global allepochs_preprocessed_src;
         global alleegs_src_conn;
         global allepochs_src_conn;
         global alleegs_preprocessed_src_conn;
         global allepochs_preprocessed_src_conn;

         % load('data/GlobalData.mat');
         % % alleegs=cell array of EEGlab structures.
         numberSubjects=0;
         allepochs_preprocessed_interp={};
         allsubjects=struct();
         alleegs={};
         alleegs_preprocessed={};
         allepochs={};
         allepochs_preprocessed={};
         alleegs_preprocessed_src={};
         allepochs_src={};
         allepochs_preprocessed_src={};
         alleegs_src={};
         alleegs_src_conn={};
         allepochs_src_conn={};
         alleegs_preprocessed_src_conn={};
         allepochs_preprocessed_src_conn={};
         allmodels={};
         allnoise={};
         clear all;
          delete(gcf)
       case 'No'
       return
        case 'Save and quit'
            global numberSubjects;
 global allsubjects;
 global alleegs;
 global alleegs_preprocessed;
 global alleegs_preprocessed_interp;
 global allepochs;
 global allepochs_preprocessed;
 global allepochs_preprocessed_interp;
 global allmodels;
 global allnoise;
 global alleegs_src;
 global allepochs_src;
 global alleegs_preprocessed_src;
 global allepochs_preprocessed_src;
 global alleegs_src_conn;
 global allepochs_src_conn;
 global alleegs_preprocessed_src_conn;
 global allepochs_preprocessed_src_conn;

 EEGNET.numberSubjects=numberSubjects;
 EEGNET.allsubjects=allsubjects;
 EEGNET.alleegs=alleegs;
 EEGNET.alleegs_preprocessed=alleegs_preprocessed;
 EEGNET.alleegs_preprocessed_interp=alleegs_preprocessed_interp;
 EEGNET.allepochs=allepochs;
 EEGNET.allepochs_preprocessed=allepochs_preprocessed;
 EEGNET.allepochs_preprocessed_interp=allepochs_preprocessed_interp;
 EEGNET.allmodels=allmodels;
 EEGNET.allnoise=allnoise;
 EEGNET.alleegs_src=alleegs_src;
 EEGNET.allepochs_src=allepochs_src;
 EEGNET.alleegs_preprocessed_src=alleegs_preprocessed_src;
 EEGNET.allepochs_preprocessed_src=allepochs_preprocessed_src;
 EEGNET.alleegs_src_conn=alleegs_src_conn;
 EEGNET.allepochs_src_conn=allepochs_src_conn;
 EEGNET.alleegs_preprocessed_src_conn=alleegs_preprocessed_src_conn;
 EEGNET.allepochs_preprocessed_src_conn=allepochs_preprocessed_src_conn;

 [filename, filepath] = uiputfile('*.mat', 'Save the database:');
 FileName = fullfile(filepath, filename);
 save(FileName, 'EEGNET', '-v7.3');
         clear all;
          delete(gcf)

    end
 % delete(hObject);

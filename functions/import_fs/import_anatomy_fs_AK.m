function  [FileHead,FileInner,FileOuter,FileCortex] = import_anatomy_fs_AK(FsDir, nVertices, isInteractive, sFid, isExtraMaps, isVolumeAtlas)
% IMPORT_ANATOMY_FS: Import a full FreeSurfer folder as the subject's anatomy.
%
% USAGE:  errorMsg = import_anatomy_fs(iSubject, FsDir=[ask], nVertices=[ask], isInteractive=1, sFid=[], isExtraMaps=0, isVolumeAtlas=1)
%
% INPUT:
%    -
%    - FsDir         : Full filename of the FreeSurfer folder to import
%    - nVertices     : Number of vertices in the file cortex surface
%    - isInteractive : If 0, no input or user interaction
%    - sFid          : Structure with the fiducials coordinates
%    - isExtraMaps   : If 1, create an extra folder "FreeSurfer" to save some of the
%                      FreeSurfer cortical maps (thickness, ...)
%    - isVolumeAtlas : If 1, imports all the volume atlases available
% OUTPUT:
%    - errorMsg : String: error message if an error occurs

% @=============================================================================
% This function is part of the Brainstorm software:
% https://neuroimage.usc.edu/brainstorm
% 
% Copyright (c)2000-2020 University of Southern California & McGill University
% This software is distributed under the terms of the GNU General Public License
% as published by the Free Software Foundation. Further details on the GPLv3
% license can be found at http://www.gnu.org/copyleft/gpl.html.
% 
% FOR RESEARCH PURPOSES ONLY. THE SOFTWARE IS PROVIDED "AS IS," AND THE
% UNIVERSITY OF SOUTHERN CALIFORNIA AND ITS COLLABORATORS DO NOT MAKE ANY
% WARRANTY, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO WARRANTIES OF
% MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE, NOR DO THEY ASSUME ANY
% LIABILITY OR RESPONSIBILITY FOR THE USE OF THIS SOFTWARE.
%
% For more information type "brainstorm license" at command prompt.
% =============================================================================@
%
% Authors: Francois Tadel, 2012-2020

%% ===== PARSE INPUTS =====
% Import ASEG atlases
if (nargin < 6) || isempty(isVolumeAtlas)
    isVolumeAtlas = 1;
end
% Extract cortical maps
if (nargin < 5) || isempty(isExtraMaps)
    isExtraMaps = 0;
end
% Fiducials
if (nargin < 4) || isempty(sFid)
    sFid = [];
end
% Interactive / silent
if (nargin < 3) || isempty(isInteractive)
    isInteractive = 1;
end
% Ask number of vertices for the cortex surface
if (nargin < 2) || isempty(nVertices)
    nVertices = [];
end
% Initialize returned variable
errorMsg = [];

%% ===== ASK NB VERTICES =====
if isempty(nVertices)
    nVertices = java_dialog('input', 'Number of vertices on the cortex surface:', 'Import FreeSurfer folder', [], '15000');
    if isempty(nVertices)
        return
    end
    nVertices = str2double(nVertices);
end
% Number for each hemisphere
nVertHemi = round(nVertices / 2);


%% ===== PARSE FREESURFER FOLDER =====
% % %bst_progress('start', 'Import FreeSurfer folder', 'Parsing folder...');
% Find MRI
T1File = file_find(FsDir, 'T1.mgz', 2);
T2File = file_find(FsDir, 'T2.mgz', 2);
if isempty(T1File)
    errorMsg = [errorMsg 'MRI file was not found: T1.mgz' 10];
elseif ~isempty(T1File) && ~isempty(T2File)
    T1Comment = 'MRI T1';
    T2Comment = 'MRI T2';
else
    T1Comment = 'MRI';
end
% Find surface: lh.pial (or lh.pial.T1)
TessLhFile = file_find(FsDir, 'lh.pial', 2);
if ~isempty(TessLhFile)
    d = dir(TessLhFile);
    if (length(d) == 1) && (d.bytes < 256)
        TessLhFile = [];
    end
end
if isempty(TessLhFile)
    TessLhFile = file_find(FsDir, 'lh.pial.T1', 2);
    if isempty(TessLhFile)
        errorMsg = [errorMsg 'Surface file was not found: lh.pial/lh.pial.T1' 10];
    end
end
% Find surface: rh.pial (or rh.pial.T1)
TessRhFile = file_find(FsDir, 'rh.pial', 2);
if ~isempty(TessRhFile)
    d = dir(TessRhFile);
    if (length(d) == 1) && (d.bytes < 256)
        TessRhFile = [];
    end
end
if isempty(TessRhFile)
    TessRhFile = file_find(FsDir, 'rh.pial.T1', 2);
    if isempty(TessRhFile)
        errorMsg = [errorMsg 'Surface file was not found: rh.pial/rh.pial.T1' 10];
    end
end
% Find other surfaces
TessLwFile = file_find(FsDir, 'lh.white', 2);
TessRwFile = file_find(FsDir, 'rh.white', 2);
TessLsphFile = file_find(FsDir, 'lh.sphere.reg', 2);
TessRsphFile = file_find(FsDir, 'rh.sphere.reg', 2);
TessInnerFile = file_find(FsDir, 'inner_skull-*.surf', 2);
TessOuterFile = file_find(FsDir, 'outer_skull-*.surf', 2);
% Find volume segmentation
AsegFile = file_find(FsDir, 'aseg.mgz', 2);
OtherAsegFiles = file_find(FsDir, '*+aseg.mgz', 2, 0);
% Find labels
AnnotLhFiles = file_find(FsDir, 'lh.*.annot', 2, 0);
AnnotRhFiles = file_find(FsDir, 'rh.*.annot', 2, 0);
% Remove old labels
if ~isempty(AnnotLhFiles) && ~isempty(AnnotRhFiles)
    % Freesurfer 5.3 creates "BA.annot", Freesurfer 6 creates "BA_exvivo.annot" 
	% If the two are available in the same folder, both versions were executed, and the old "BA.annot" is outdated but not replaced: ignore it
    % Left
    iBAold = find(~cellfun(@(c)isempty(strfind(c, 'BA.annot')), AnnotLhFiles));
    iBAnew = find(~cellfun(@(c)isempty(strfind(c, 'BA_exvivo.annot')), AnnotLhFiles));
    if ~isempty(iBAold) && ~isempty(iBAnew)
        AnnotLhFiles(iBAold) = [];
    end
    % Right
    iBAold = find(~cellfun(@(c)isempty(strfind(c, 'BA.annot')), AnnotRhFiles));
    iBAnew = find(~cellfun(@(c)isempty(strfind(c, 'BA_exvivo.annot')), AnnotRhFiles));
    if ~isempty(iBAold) && ~isempty(iBAnew)
        AnnotRhFiles(iBAold) = [];
    end
end
% Find thickness maps
if isExtraMaps
    ThickLhFile = file_find(FsDir, 'lh.thickness', 2);
    ThickRhFile = file_find(FsDir, 'rh.thickness', 2);
end
% Find fiducials definitions
FidFile = file_find(FsDir, 'fiducials.m');
% Report errors
if ~isempty(errorMsg)
    if isInteractive
        bst_error(['Could not import FreeSurfer folder: ' 10 10 errorMsg], 'Import FreeSurfer folder', 0);        
    end
    return;
end


%% ===== IMPORT T1 =====
% Read T1 MRI
[BstT1File, sMri] = import_mri_AK(T1File, 'ALL', 0, [],T1Comment);
if isempty(BstT1File)
    errorMsg = 'Could not import FreeSurfer folder: MRI was not imported properly';
    if isInteractive
        bst_error(errorMsg, 'Import FreeSurfer folder', 0);
    end
    return;
end

%% ===== DEFINE FIDUCIALS =====
% If fiducials file exist: read it
isComputeMni = 0;
if ~isempty(FidFile)
    % Execute script
    fid = fopen(FidFile, 'rt');
    FidScript = fread(fid, [1 Inf], '*char');
    fclose(fid);
    % Execute script
    eval(FidScript);    
    % If not all the fiducials were loaded: ignore the file
    if ~exist('NAS', 'var') || ~exist('LPA', 'var') || ~exist('RPA', 'var') || isempty(NAS) || isempty(LPA) || isempty(RPA)
        FidFile = [];
    end
    % If the normalized points were not defined: too bad...
    if ~exist('AC', 'var')
        AC = [];
    end
    if ~exist('PC', 'var')
        PC = [];
    end
    if ~exist('IH', 'var')
        IH = [];
    end
    % NOTE THAT THIS FIDUCIALS FILE CAN CONTAIN A LINE: "isComputeMni = 1;"
end
% Random or predefined points
if ~isInteractive || ~isempty(FidFile)
    % Use fiducials from file
    if ~isempty(FidFile)
        % Already loaded
    % Compute them from MNI transformation
    elseif isempty(sFid)
              
        NAS = [];  LPA = [];  RPA = [];
        AC  = [];  PC  = [];  IH  = [];
        isComputeMni = 1;
                disp(['BST> Import anatomy: Anatomical fiducials were not defined, using standard MNI positions for NAS/LPA/RPA.' 10]);

% %         Show a dialog to insert sFid structure
        [filename,pathname]=uigetfile('*.mat','Import fiducial structure (*.mat)');
            if isequal(filename,0)||isequal(pathname,0)
                return
            else
                fpath=fullfile(pathname,filename);
              cellOut=struct2cell(load(fpath));
             sFid=(cellOut{1})
            end
    % Else: use the defined ones
        NAS = sFid.NAS;
        LPA = sFid.LPA;
        RPA = sFid.RPA;
        AC = sFid.AC;
        PC = sFid.PC;
        IH = sFid.IH;
        sMri.SCS.NAS=NAS;
        sMri.SCS.LPA=LPA;
        sMri.SCS.RPA=RPA;
        sMri.NCS.AC=AC;
        sMri.NCS.PC=PC;
        sMri.NCS.IH=IH;
        sMri = out_mri_bst(sMri, BstT1File);

        % If the NAS/LPA/RPA are defined, but not the others: Compute them
        if ~isempty(NAS) && ~isempty(LPA) && ~isempty(RPA) && isempty(AC) && isempty(PC) && isempty(IH)
            isComputeMni = 1;
        end
    end
%     if ~isempty(NAS) || ~isempty(LPA) || ~isempty(RPA) || ~isempty(AC) || ~isempty(PC) || ~isempty(IH)
%         figure_mri('SetSubjectFiducials', iSubject, NAS, LPA, RPA, AC, PC, IH);
%     end

% Define with the MRI Viewer
% else
%     % Open MRI Viewer for the user to select NAS/LPA/RPA fiducials
%     hFig = view_mri(BstT1File, 'EditFiducials');
%     drawnow;
%     %bst_progress('stop');
%     % Wait for the MRI Viewer to be closed
%     waitfor(hFig);
end
% % Load SCS and NCS field to make sure that all the points were defined
% warning('off','MATLAB:load:variableNotFound');
% sMri = load(BstT1File, 'SCS', 'NCS');
% warning('on','MATLAB:load:variableNotFound');
% if ~isComputeMni && (~isfield(sMri, 'SCS') || isempty(sMri.SCS) || isempty(sMri.SCS.NAS) || isempty(sMri.SCS.LPA) || isempty(sMri.SCS.RPA) || isempty(sMri.SCS.R))
%     errorMsg = ['Could not import FreeSurfer folder: ' 10 10 'Some fiducial points were not defined properly in the MRI.'];
%     if isInteractive
%         bst_error(errorMsg, 'Import FreeSurfer folder', 0);
%     end
%     return;


% %% ===== MNI NORMALIZATION =====
% if isComputeMni
%     % Call normalize function
%     [sMri, errCall] = bst_normalize_mni_AK(BstT1File);
%     % Error handling
%     errorMsg = [errorMsg errCall];
% end

% %% ===== IMPORT T2 =====
% % Read T2 MRI (optional)
% if ~isempty(T2File)
%     [BstT2File, sMri] = import_mri_AK(T2File, 'ALL', 0, [], 'T2');
%     if isempty(BstT2File)
%         disp('BST> Could not import T2.mgz.');
%     end
% end


%% ===== IMPORT SURFACES =====
% Left pial
if ~isempty(TessLhFile)
    % Import file
    [iLh, BstTessLhFile, nVertOrigL] = import_surfaces_AK(TessLhFile, 'FS', 0,BstT1File);
    BstTessLhFile = BstTessLhFile{1};
    % Load sphere
    if ~isempty(TessLsphFile)
        %bst_progress('start', 'Import FreeSurfer folder', 'Loading registered sphere: left pial...');
        [TessMat, err] = tess_addsphere_AK(BstTessLhFile, TessLsphFile, 'FS');
        if ~isempty(err)
            errorMsg = [errorMsg err];
        end
    end
    % Downsample
    %bst_progress('start', 'Import FreeSurfer folder', 'Downsampling: left pial...');
    [BstTessLhLowFile, iLhLow, xLhLow] = tess_downsize_AK(BstTessLhFile, nVertHemi, 'reducepatch');
end
% Right pial
if ~isempty(TessRhFile)
    % Import file
    [iRh, BstTessRhFile, nVertOrigR] = import_surfaces_AK(TessRhFile, 'FS', 0,BstT1File);
    BstTessRhFile = BstTessRhFile{1};
   
    % Load sphere
    if ~isempty(TessRsphFile)
        %bst_progress('start', 'Import FreeSurfer folder', 'Loading registered sphere: right pial...');
        [TessMat, err] = tess_addsphere_AK(BstTessRhFile, TessRsphFile, 'FS');
        if ~isempty(err)
            errorMsg = [errorMsg err];
        end
    end
    % Downsample
    %bst_progress('start', 'Import FreeSurfer folder', 'Downsampling: right pial...');
    [BstTessRhLowFile, iRhLow, xRhLow] = tess_downsize_AK(BstTessRhFile, nVertHemi, 'reducepatch');
end
% Left white matter
if ~isempty(TessLwFile)
    % Import file
    [iLw, BstTessLwFile] = import_surfaces_AK(TessLwFile, 'FS', 0,BstT1File);
    BstTessLwFile = BstTessLwFile{1};
   
    if ~isempty(TessLsphFile)
        %bst_progress('start', 'Import FreeSurfer folder', 'Loading registered sphere: left pial...');
        [TessMat, err] = tess_addsphere_AK(BstTessLwFile, TessLsphFile, 'FS');
        if ~isempty(err)
            errorMsg = [errorMsg err];
        end
    end
    % Downsample
    %bst_progress('start', 'Import FreeSurfer folder', 'Downsampling: left white...');
    [BstTessLwLowFile, iLwLow, xLwLow] = tess_downsize_AK(BstTessLwFile, nVertHemi, 'reducepatch');
end
% Right white matter
if ~isempty(TessRwFile)
    % Import file
    [iRw, BstTessRwFile] = import_surfaces_AK(TessRwFile, 'FS', 0,BstT1File);
    BstTessRwFile = BstTessRwFile{1};
    
    % Load sphere
    if ~isempty(TessRsphFile)
        %bst_progress('start', 'Import FreeSurfer folder', 'Loading registered sphere: right pial...');
        [TessMat, err] = tess_addsphere_AK(BstTessRwFile, TessRsphFile, 'FS');
        if ~isempty(err)
            errorMsg = [errorMsg err];
        end
    end
    % Downsample
    %bst_progress('start', 'Import FreeSurfer folder', 'Downsampling: right white...');
    [BstTessRwLowFile, iRwLow, xRwLow] = tess_downsize_AK(BstTessRwFile, nVertHemi, 'reducepatch');
end
% Process error messages
if ~isempty(errorMsg)
    if isInteractive
        bst_error(errorMsg, 'Import FreeSurfer folder', 0);
    else
        disp(['ERROR: ' errorMsg]);
    end
    return;
end
% Inner skull
if ~isempty(TessInnerFile)
    [oo, BstTessInner] = import_surfaces_AK(TessRwFile, 'FS', 0,BstT1File);import_surfaces_AK(BstTessLhFile, TessInnerFile, 'FS', 0);
end
% Outer skull
if ~isempty(TessOuterFile)
    [oo, BstTessOuter] = import_surfaces_AK(TessRwFile, 'FS', 0,BstT1File);import_surfaces_AK(BstTessLhFile, TessOuterFile, 'FS', 0);
end


%% ===== GENERATE MID-SURFACE =====
% Do not compute without volume atlases, to make a very light default import
if isVolumeAtlas && ~isempty(TessLhFile) && ~isempty(TessRhFile) && ~isempty(TessLwFile) && ~isempty(TessRwFile)
    %bst_progress('start', 'Import FreeSurfer folder', 'Generating mid-surface...');
    % Average pial and white surfaces
    BstTessLmFile = tess_average_AK({BstTessLhFile, BstTessLwFile});
    BstTessRmFile = tess_average_AK({BstTessRhFile, BstTessRwFile});
    % Downsample
    %bst_progress('start', 'Import FreeSurfer folder', 'Downsampling: mid-surface...');
    [BstTessLmLowFile, iLmLow, xLmLow] = tess_downsize_AK(BstTessLmFile, nVertHemi, 'reducepatch');
    [BstTessRmLowFile, iRmLow, xRmLow] = tess_downsize_AK(BstTessRmFile, nVertHemi, 'reducepatch');
end


%% ===== MERGE SURFACES =====
rmFiles = {};
% Merge hemispheres: pial
if ~isempty(TessLhFile) && ~isempty(TessRhFile)
    % Hi-resolution surface
    CortexHiFile  = tess_concatenate_AK({BstTessLhFile,    BstTessRhFile},    sprintf('cortex_%dV', nVertOrigL + nVertOrigR), 'Cortex');
    CortexLowFile = tess_concatenate_AK({BstTessLhLowFile, BstTessRhLowFile}, sprintf('cortex_%dV', length(xLhLow) + length(xRhLow)), 'Cortex');
    % Delete separate hemispheres
    rmFiles = cat(2, rmFiles, {BstTessLhFile, BstTessRhFile, BstTessLhLowFile, BstTessRhLowFile});
    % Rename high-res file
    oldCortexHiFile = (CortexHiFile);
    CortexHiFile    = 'data/Inverse/Customized/tess_cortex_pial_high.mat';
    file_move(oldCortexHiFile, CortexHiFile);
    % Rename high-res file
    oldCortexLowFile = (CortexLowFile);
    CortexLowFile    = 'data/Inverse/Customized/tess_cortex_pial_low.mat';
    file_move(oldCortexLowFile, CortexLowFile);
else
    CortexHiFile = [];
    CortexLowFile = [];
end
% Merge hemispheres: white
if ~isempty(TessLwFile) && ~isempty(TessRwFile)
    % Hi-resolution surface
    WhiteHiFile  = tess_concatenate_AK({BstTessLwFile,    BstTessRwFile},    sprintf('white_%dV', nVertOrigL + nVertOrigR), 'Cortex');
    WhiteLowFile = tess_concatenate_AK({BstTessLwLowFile, BstTessRwLowFile}, sprintf('white_%dV', length(xLwLow) + length(xRwLow)), 'Cortex');
    % Delete separate hemispheres
    rmFiles = cat(2, rmFiles, {BstTessLwFile, BstTessRwFile, BstTessLwLowFile, BstTessRwLowFile});
    % Rename high-res file
    oldWhiteHiFile = (WhiteHiFile);
    WhiteHiFile    =  'data/Inverse/Customized/tess_cortex_white_high.mat';
    file_move(oldWhiteHiFile, WhiteHiFile);
    % Rename high-res file
    oldWhiteLowFile = (WhiteLowFile);
    WhiteLowFile    = 'data/Inverse/Customized/tess_cortex_white_low.mat';
    file_move(oldWhiteLowFile, WhiteLowFile);
end
% Merge hemispheres: mid-surface (do not compute without volume atlases, to make a very light default import)
if isVolumeAtlas && ~isempty(TessLhFile) && ~isempty(TessRhFile) && ~isempty(TessLwFile) && ~isempty(TessRwFile)
    % Hi-resolution surface
    MidHiFile  = tess_concatenate_AK({BstTessLmFile,    BstTessRmFile},    sprintf('mid_%dV', nVertOrigL + nVertOrigR), 'Cortex');
    MidLowFile = tess_concatenate_AK({BstTessLmLowFile, BstTessRmLowFile}, sprintf('mid_%dV', length(xLmLow) + length(xRmLow)), 'Cortex');
    % Delete separate hemispheres
    rmFiles = cat(2, rmFiles, {BstTessLmFile, BstTessRmFile, BstTessLmLowFile, BstTessRmLowFile});
    % Rename high-res file
    oldMidHiFile = (MidHiFile);
    MidHiFile    = 'data/Inverse/Customized/tess_cortex_mid_high.mat';
    file_move(oldMidHiFile, MidHiFile);
    % Rename high-res file
    oldMidLowFile = (MidLowFile);
    MidLowFile    =  'data/Inverse/Customized/tess_cortex_mid_low.mat';
    file_move(oldMidLowFile, MidLowFile);
end

%% ===== DELETE INTERMEDIATE FILES =====
if ~isempty(rmFiles)
    % Delete files
    file_delete((rmFiles), 1);
    % Reload subject
%     db_reload_subjects(iSubject);
end
MriMat = in_mri_bst_AK( BstT1File );
%% ===== GENERATE HEAD =====
% Generate head surface
HeadFile = tess_isohead_AK(10000, 0, 2,[],BstT1File);

try
FileHead=HeadFile;
catch
    FileHead='';
end
try
FileCortex=CortexHiFile;
catch
    FileCortex='';
end
try
FileInner=BstTessInner;
catch
    FileInner='';
end
try
FileOuter=BstTessOuter;
catch
    FileOuter='';
end
    
% % %% ===== IMPORT ASEG ATLAS =====
% % if isVolumeAtlas && ~isempty(AsegFile)
% %     % Import atlas as volume
% %     import_mri(iSubject, AsegFile);
% %     % Import other ASEG volumes
% %     for iFile = 1:length(OtherAsegFiles)
% %         import_mri(iSubject, OtherAsegFiles{iFile});
% %     end
% %     % Import atlas as surfaces
% %     SelLabels = {...
% %         'Cerebellum L', 'Accumbens L', 'Amygdala L', 'Caudate L', 'Hippocampus L', 'Pallidum L', 'Putamen L', 'Thalamus L', 'Thalamus R', ...
% %         'Cerebellum R', 'Accumbens R', 'Amygdala R', 'Caudate R', 'Hippocampus R', 'Pallidum R', 'Putamen R', 'Thalamus L', 'Thalamus R', ...
% %         'Brainstem'};
% %     [iAseg, BstAsegFile] = import_surfaces(iSubject, AsegFile, 'MRI-MASK', 0, [], SelLabels, 'subcortical');
% %     % Extract cerebellum only
% %     try
% %         BstCerebFile = tess_extract_struct(BstAsegFile{1}, {'Cerebellum L', 'Cerebellum R'}, 'aseg | cerebellum');
% %     catch
% %         BstCerebFile = [];
% %     end
% %     % If the cerebellum surface can be reconstructed
% %     if ~isempty(BstCerebFile)
% %         % Downsample cerebllum
% %         [BstCerebLowFile, iCerLow, xCerLow] = tess_downsize(BstCerebFile, 2000, 'reducepatch');
% %         % Merge with low-resolution pial
% %         BstMixedLowFile = tess_concatenate({CortexLowFile, BstCerebLowFile}, sprintf('cortex_cereb_%dV', length(xLhLow) + length(xRhLow) + length(xCerLow)), 'Cortex');
% %         % Rename mixed file
% %         oldBstMixedLowFile = file_fullpath(BstMixedLowFile);
% %         BstMixedLowFile    = bst_fullfile(bst_fileparts(oldBstMixedLowFile), 'tess_cortex_pialcereb_low.mat');
% %         file_move(oldBstMixedLowFile, BstMixedLowFile);
% %         % Delete intermediate files
% %         file_delete({file_fullpath(BstCerebFile), file_fullpath(BstCerebLowFile)}, 1);
% %         db_reload_subjects(iSubject);
% %     end
% % end
% % 
% % 
% % %% ===== IMPORT THICKNESS MAPS =====
% % if isExtraMaps && ~isempty(CortexHiFile) && ~isempty(ThickLhFile) && ~isempty(ThickLhFile)
% %     % Create a condition "FreeSurfer"
% %     iStudy = db_add_condition(iSubject, 'FreeSurfer');
% %     % Import cortical thickness
% %     ThickFile = import_sources(iStudy, CortexHiFile, ThickLhFile, ThickRhFile, 'FS');
% % end
% % 
% % 
% % % Close progress bar
% % %bst_progress('stop');
% % 
% % 
% % 

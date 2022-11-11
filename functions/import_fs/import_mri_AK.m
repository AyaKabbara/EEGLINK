function [BstMriFile, sMri] = import_mri_AK(MriFile, FileFormat, isInteractive, isAutoAdjust, Comment)
% IMPORT_MRI: Import a MRI file in a subject of the Brainstorm database
% 
% USAGE: [BstMriFile, sMri] = import_mri(iSubject, MriFile, FileFormat='ALL', isInteractive=0, isAutoAdjust=1, Comment=[])
%               BstMriFiles = import_mri(iSubject, MriFiles, ...)   % Import multiple volumes at once
%
% INPUT:
%    - iSubject  : Indice of the subject where to import the MRI
%                  If iSubject=0 : import MRI in default subject
%    - MriFile   : Full filename of the MRI to import (format is autodetected)
%                  => if not specified : file to import is asked to the user
%    - FileFormat : String, one on the file formats in in_mri
%    - isInteractive : If 1, importation will be interactive (MRI is displayed after loading)
%    - isAutoAdjust  : If isInteractive=0 and isAutoAdjust=1, relice/resample automatically without user confirmation
%    - Comment       : Comment of the output file
% OUTPUT:
%    - BstMriFile : Full path to the new file if success, [] if error

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
% Authors: Francois Tadel, 2008-2020

% ===== Parse inputs =====
if (nargin < 3) || isempty(FileFormat)
    FileFormat = 'ALL';
end
if (nargin < 4) || isempty(isInteractive)
    isInteractive = 0;
end
if (nargin < 5) || isempty(isAutoAdjust)
    isAutoAdjust = 1;
end
if (nargin < 6) || isempty(Comment)
    Comment = [];
end
% Initialize returned variables
BstMriFile = [];
sMri = [];  
    
%% ===== LOAD MRI FILE =====
bst_progress('start', 'Import MRI', ['Loading file "' MriFile '"...']);
% Load MRI
isNormalize = 0;
sMri = in_mri(MriFile, FileFormat, isInteractive, isNormalize);
if isempty(sMri)
    bst_progress('stop');
    return
end

%% ===== SAVE MRI IN BRAINSTORM FORMAT =====
% Add a Comment field in MRI structure, if it does not exist yet
if ~isempty(Comment)
    sMri.Comment = Comment;
    importedBaseName = file_standardize(Comment);
else
    if ~isfield(sMri, 'Comment') || isempty(sMri.Comment)
        sMri.Comment = 'MRI';
    end
            % Get imported base name
    [tmp__, importedBaseName] = bst_fileparts(MriFile);
    importedBaseName = strrep(importedBaseName, 'subjectimage_', '');
    importedBaseName = strrep(importedBaseName, '_subjectimage', '');
    importedBaseName = strrep(importedBaseName, '.nii', '');
end
% Get subject subdirectory
BstMriFile = ['data/Inverse/Customized/subjectimage_' importedBaseName '.mat'];
% Make this filename unique
% Save new MRI in Brainstorm format
sMri = out_mri_bst(sMri, BstMriFile);



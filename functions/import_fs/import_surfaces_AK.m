function [iNewSurfaces, OutputSurfacesFiles, nVertices] = import_surfaces_AK(SurfaceFiles, FileFormat, isApplyMriOrient, MriFile)
% IMPORT_SURFACES: Import a set of surfaces in a Subject of Brainstorm database.
% 
% USAGE: iNewSurfaces = import_surfaces(iSubject, SurfaceFiles, FileFormat, offset=[], SelLabels=[all], Comment=[])
%        iNewSurfaces = import_surfaces(iSubject)   : Ask user the files to import
%
% INPUT:
%    - iSubject     : Indice of the subject where to import the surfaces
%                     If iSubject=0 : import surfaces in default subject
%    - SurfaceFiles : Cell array of full filenames of the surfaces to import (format is autodetected)
%                     => if not specified : files to import are asked to the user
%    - FileFormat   : String representing the file format to import.
%                     Please see in_tess.m to get the list of supported file formats
%    - isApplyMriOrient: {0,1}
%    - OffsetMri    : (x,y,z) values to add to the coordinates of the surface before converting it to SCS
%    - SelLabels    : Cell-array of labels, when importing atlases
%    - Comment      : Comment of the output file
%
% OUTPUT:
%    - iNewSurfaces : Indices of the surfaces added in database

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

%% ===== PARSE INPUTS =====
% Check command line
if (nargin < 3) || isempty(SurfaceFiles)
    SurfaceFiles = {};
    FileFormat = [];
else
    if ischar(SurfaceFiles)
        SurfaceFiles = {SurfaceFiles};
    end
    if (nargin == 2) || ((nargin >= 3) && isempty(FileFormat))
        error('When you pass a SurfaceFiles argument, FileFormat must be defined too.');
    end
end
if (nargin < 4) || isempty(isApplyMriOrient)
    isApplyMriOrient = [];
end
    OffsetMri = [];
    SelLabels = [];
    Comment = [];
iNewSurfaces = [];
OutputSurfacesFiles = {};
nVertices = [];
   

%% ===== APPLY MRI TRANSFORM =====
% Load MRI
    sMri = load(MriFile);

%% ===== LOAD EACH SURFACE =====
% Process all the selected surfaces
for iFile = 1:length(SurfaceFiles)
    TessFile = SurfaceFiles{iFile};
    
    % ===== LOAD SURFACE FILE =====
    bst_progress('start', 'Importing tesselation', ['Loading file "' TessFile '"...']);
    % Load surfaces(s)
    Tess = in_tess_AK(TessFile, FileFormat, sMri, OffsetMri, SelLabels);
    if isempty(Tess)
        bst_progress('stop');
        return
    end
    
% %     ana honeee

    % ===== INITIALIZE NEW SURFACE =====
    % Get imported base name
    if strcmpi(FileFormat, 'FS')
        [tmp__, fBase, fExt] = bst_fileparts(TessFile);
        importedBaseName = [fBase, strrep(fExt, '.', '_')];
    else
        [tmp__, importedBaseName] = bst_fileparts(TessFile);
    end
    importedBaseName = strrep(importedBaseName, 'tess_', '');
    importedBaseName = strrep(importedBaseName, '_tess', '');
    % Only one surface
    if (length(Tess) == 1)
        % Surface mesh
        if isfield(Tess, 'Faces')
            NewTess = db_template('surfacemat');
            NewTess.Comment  = Tess(1).Comment;
            NewTess.Vertices = Tess(1).Vertices;
            if isfield(Tess, 'Faces')   % Volume meshes do not have Faces field
                NewTess.Faces = Tess(1).Faces;
            end
        % Volume FEM mesh
        else
            NewTess = Tess;
        end
    % Multiple surfaces
    else
        [Tess(:).Atlas] = deal(db_template('Atlas'));
        NewTess = tess_concatenate(Tess);
        NewTess.iAtlas  = find(strcmpi({NewTess.Atlas.Name}, 'Structures'));
        NewTess.Comment = importedBaseName;
    end
    % Comment
    if ~isempty(Comment)
        NewTess.Comment = Comment;
    elseif isempty(NewTess.Comment)
        NewTess.Comment = importedBaseName;
    end
  

    % ===== SAVE BST FILE =====
    % History: File name
%     NewTess = bst_history('add', NewTess, 'import', ['Import from: ' TessFile]);
    % Produce a default surface filename (surface of volume mesh)
    if isfield(NewTess, 'Faces')
        BstTessFile = ['data/Inverse/Customized/tess_' importedBaseName '.mat'];
    else
        BstTessFile = ['data/Inverse/Customized/tess_fem_' importedBaseName '.mat'];
    end
    % Make this filename unique
    BstTessFile = file_unique(BstTessFile);
    % Save new surface in Brainstorm format
    bst_save(BstTessFile, NewTess, 'v7');

    % Save output filename
    OutputSurfacesFiles{end+1} = BstTessFile;
    % Return number of vertices
    nVertices(end+1) = length(NewTess.Vertices);
end

% Save database
bst_progress('stop');
end   


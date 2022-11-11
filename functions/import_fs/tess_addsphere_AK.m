function [TessMat, errMsg] = tess_addsphere_AK(TessFile, SphereFile, FileFormat)
% TESS_ADD: Add a FreeSurfer registered sphere to an existing surface.
%
% USAGE:  TessMat = tess_addsphere(TessFile, SphereFile=select, FileFormat=select)

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
% Authors: Francois Tadel, 2013-2019

% Initialize returned variables
TessMat = [];
errMsg = [];

% Progress bar
% isProgressBar = ~bst_progress('isVisible');
% if isProgressBar
%     bst_progress('start', 'Load registration', 'Loading FreeSurfer sphere...');
% end
  
% Load target surface file
TessMat = load(TessFile);

% Load the sphere surface
SphereVertices = mne_read_surface(SphereFile);
        

% Check that the number of vertices match
if (length(SphereVertices) ~= length(TessMat.Vertices))
    errMsg = sprintf('The number of vertices in the surface (%d) and the sphere (%d) do not match.', length(TessMat.Vertices), length(SphereVertices));
    TessMat = [];
    return;
end
% Add the sphere vertex information to the surface matrix
TessMat.Reg.Sphere.Vertices = SphereVertices;
% Save modifications to input file
bst_save(TessFile, TessMat, 'v7');






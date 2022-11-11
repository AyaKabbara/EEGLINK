function [ftHeadmodel] = Headmodel_BS_to_FT(Channel,SurfaceFiles,Cond)

% SurfaceFiles = {'surfaces/tess_head.mat',...
%     'surfaces/tess_outerskull.mat',...
%     'surfaces/tess_innerskull.mat'};

% ===== CREATE FIELDTRIP HEADMODEL =====
ftHeadmodel = [];
ftHeadmodel.type = 'openmeeg';
ftSurf = repmat(struct('pos', [], 'tri', [], 'unit', []), 1, length(SurfaceFiles));
for i = 1:length(SurfaceFiles)
    sSurf = load(SurfaceFiles{i},'Vertices','Faces');
    ftSurf(i).pos  = sSurf.Vertices;
    ftSurf(i).tri  = sSurf.Faces;
    ftSurf(i).unit = 'm';
end
ftHeadmodel.bnd = ftSurf;
ftHeadmodel.cond = Cond;
ftHeadmodel.skin_surface = 1;
ftHeadmodel.source = 3;
ftHeadmodel.unit = 'm';
ftHeadmodel.label = {Channel.Name}';
ftHeadmodel.mat = [];
end
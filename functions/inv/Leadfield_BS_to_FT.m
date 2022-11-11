function [ftLeadfield] = Leadfield_BS_to_FT(Vertices,Gain,Channel)

% ===== CREATE FIELDTRIP LEADFIELD =====
ftLeadfield = [];
nSources = size(Vertices,1);
ftLeadfield.pos = Vertices;
ftLeadfield.unit = 'm';
ftLeadfield.inside = true(nSources, 1);
ftLeadfield.leadfielddimord = '{pos}_chan_ori';
ftLeadfield.label = {Channel.Name};
ftLeadfield.leadfield = cell(1, nSources);
for i = 1:nSources
    ftLeadfield.leadfield(1,i) = {Gain(:, 3*(i-1)+[1 2 3])};
end

end
function [filters] = get_eloreta_solution(EEG,elec,ftHeadmodel,ftLeadfield,Orient)

% compute EEG inverse solution using eLORETA 
% inputs: EEG: EEGLAB DATASET
% srate: sampling rate

% Outputs: filters: 1*nb_regions*nb_channels, nb_regions denotes the number
% of cortical sources, nb_channels denotes the number of EEG channels. 

% This code was originally developped by Sahar Allouch.
% contact: saharallouch@gmail.com

%%

srate=EEG.srate;
nb_trials = 1;
for i=1:nb_trials
    ftData.trial{i} = EEG.data;
    ftData.time{i}  = EEG.times;
end

ftData.elec = elec;
ftData.label = elec.label';
ftData.fsample = srate;


filters = [];

%% eLORETA
cfg                     = [];
cfg.method              = 'eloreta';
cfg.sourcemodel         = ftLeadfield;
cfg.sourcemodel.mom     = transpose(Orient);
cfg.headmodel           = ftHeadmodel;
cfg.eloreta.keepfilter  = 'yes';
cfg.eloreta.keepmom     = 'no';
cfg.eloreta.lambda      = 0.05;
src                     = ft_sourceanalysis(cfg,ftData);

filters(1,:,:)          = cell2mat(transpose(src.avg.filter));

end

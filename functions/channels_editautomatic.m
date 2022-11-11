function reconstruct_src(EEG1,Cond,InvMeth,noisecov,datacov,atlas,ScoutFunction)
% % % Inputs: EEG1 = EEGLAB dataset
% % % % % % % Cond= Bemconductivities : array of 3 columns
% % % % % % % InvMeth=1 if wmne, 2 if sloreta, 3 if dspm, 4 if lcmv
% % % % % % % noisecov and datacov are the noise and data covariance matrices needed for inv solution
% % % % % % % atlas=1 if desikan, 2 if destrieux
        
        
% % % ==== First step: adjust eeg positions 

% 1- Convert xyz to BS format
for iChan=1:length(EEG1.chanlocs)
    if(strcmp(EEG1.chanlocs(iChan).type,'EEG'))
        Loc(iChan,:) = [EEG1.chanlocs(iChan).X; ...
                                            EEG1.chanlocs(iChan).Y; ...
                                     EEG1.chanlocs(iChan).Z] ./ 1000;
    end
end

% 2- Load scalp file to refine channel loc
load('data/Inverse/tess_head.mat','Vertices');
ChanLoc = channel_project_scalp(Vertices, Loc);    

% 3- Create chan BS structure
for c=1:length(EEG1.chanlocs)
ChannelStruct(c).Type=EEG1.chanlocs(c).type;
ChannelStruct(c).Name=EEG1.chanlocs(c).labels;
ChannelStruct(c).Loc=ChanLoc(c,:)';
ChannelStruct(c).Comment=[];
ChannelStruct(c).Orient=[];
ChannelStruct(c).Weight=1;
ChannelStruct(c).Group=[];
end

% % ==== Second step: COmputing headmodel
% 1- OPTIONS for openmeeg
OPTIONS_openmeeg.MEGMethod='';
OPTIONS_openmeeg.ECOGMethod='';
OPTIONS_openmeeg.SEEGMethod='';
OPTIONS_openmeeg.EEGMethod='openmeeg';
OPTIONS_openmeeg.Channel=ChannelStruct;
OPTIONS_openmeeg.iMeg=[];
ieeg=[];
for k=1:length(EEG1.chanlocs)
    if(ChannelStruct(k).Type=='EEG')
        ieeg=[ieeg k];
    end
end
OPTIONS_openmeeg.iEeg=ieeg;
OPTIONS_openmeeg.BemFiles={'data/Inverse/tess_head.mat','data/Inverse/tess_outerskull.mat','data/Inverse/tess_innerskull.mat'};
OPTIONS_openmeeg.BemNames={'Scalp','Skull','Brain'};
% OPTIONS_openmeeg.BemCond=[1,0.0125000000000000,1];
OPTIONS_openmeeg.BemCond=Cond;

load('data/Inverse/tess_cortex_pial_low.mat','Vertices');
OPTIONS_openmeeg.GridLoc=Vertices;
OPTIONS_openmeeg.isAdjoint=0;
OPTIONS_openmeeg.isAdaptative=1;
OPTIONS_openmeeg.Interactive=1;


% 2- Compute HeadModel
[Gain, errMsg] = bst_openmeeg(OPTIONS_openmeeg);

% 3- set Gain in a headmodel BS structure 

% Load default structure of HeadModel
load('data/Inverse/HeadModel.mat');
% Load Options, NoiseCov
load('data/Inverse/OPTIONS.mat');

count=0;
HeadModel.Gain=[];
for k=1:length(EEG1.chanlocs)
    if(ChannelStruct(k).Type=='EEG')
        count=count+1;    
        HeadModel.Gain(count,:)=Gain(k,:);
        OPTIONS.ChannelTypes{count}='EEG';

    end
end


OPTIONS.NoiseCovMat.NoiseCov=noisecov;
OPTIONS.ChannelTypes={};


switch InvMeth
    case 1   
        %  WMNE:
        OPTIONS.InverseMethod='minnorm';
        OPTIONS.InverseMeasure = 'amplitude';
    case 2
        % sloreta
        OPTIONS.InverseMethod='minnorm';
        OPTIONS.InverseMeasure = 'sloreta';
    case 3
        
        % dspm
        OPTIONS.InverseMethod='minnorm';
        OPTIONS.InverseMeasure = 'dspm2018';
    case 4
%          gls
        OPTIONS.InverseMethod='gls';
        OPTIONS.InverseMeasure = 'gls';
    case 5
        
        % lcmv
        OPTIONS.InverseMethod='lcmv';
        OPTIONS.InverseMeasure = 'lcmv';

        % load datacov for lcmv
        OPTIONS.DataCovMat.NoiseCov=datacov;

end

% % ==== Third step: Inverse solution 

[Results, OPTIONS] = bst_inverse_linear_2018(HeadModel,OPTIONS);
source_grid=Results.ImagingKernel*EEG1.data(ieeg,:);

% % ==== Fourth step: Inverse solution 
% 1: load scout atlas depending on user choice
switch atlas
    case 1
        
    case 2
        
% 2: extract sc time series
Sc_timeseries=[];
for sc=1:length(Scouts) 
    Vertices_correspondant=Scouts(sc).Vertices;
    F=source_grid(Vertices_correspondant,:);
    nTime = size(F,2);
    nRow = size(F,1);

%% ===== COMBINE ALL VERTICES =====
switch (ScoutFunction)       
    % MEAN : Average of the patch activity at each time instant
    case 'mean'
        Fs = mean(F,1);
    % STD : Standard deviation of the patch activity at each time instant
    case 'std'
        Fs = std(F,[],1);
    % STDERR : Standard error
    case 'stderr'
        Fs = std(F,[],1) ./ size(F,1);
    % RMS
    case 'rms'
        Fs = sqrt(sum(F.^2,1)); 
        
    % MEAN_NORM : Average of the norms of all the vertices each time instant 
    % If only one components: computes mean(abs(F)) => Compatibility with older versions
    case 'mean_norm'

            % Average absolute values
            Fs = mean(abs(F),1);
       
        
    % MAX : Strongest at each time instant (in absolue values)
    case 'max'
       
       
            Fs = bst_max(F,1);
        

    % POWER: Average of the square of the all the signals
    case 'power'
        
            Fs = mean(F.^2, 1);
       

    % PCA : Display first mode of PCA of time series within each scout region
    case 'pca'
        % Signal decomposition
        Fs = zeros(1, nTime);
        
            [Fs(1,:), explained] = PcaFirstMode(F(:,:));
       
        
    % FAST PCA : Display first mode of PCA of time series within each scout region
    case 'fastpca'
        % Reduce dimensions first
        nMax = 50; % Maximum number of variables to run the PCA on
        if nRow > nMax
            % Norm or not
           
                Fn = abs(F);
            
            % Find the nMax most powerful/spiky source time series
            %powF = sum(F.*F,2);
            powF = max(Fn,[],2) ./ (mean(Fn,2) + eps*min(Fn(:)));
            [tmp__, isF] = sort(powF,'descend');
            F = F(isF(1:nMax),:,:);
        end
        % Signal decomposition
        Fs = zeros(1, nTime);
       
            [Fs(1,:), explained] = PcaFirstMode(F(:,:));
        
        
    % STAT : Average values as if they were statistical results => ignore all the zero-values
    case 'stat'
        % Get the number of samples per time point
        w = sum(F~=0, 1);
        w(w == 0) = 1;
        % Divide each time point by the number of valid samples
        Fs = bst_bsxfun(@rdivide, sum(F,1), w);
                
    % Otherwise: error
    otherwise
        error(['Unknown scout function: ' ScoutFunction]);
end
Sc_timeseries(sc,:)=Fs;
end
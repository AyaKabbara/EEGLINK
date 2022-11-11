function [Sc_timeseries]=reconstruct_src_withheadmodel(EEG1,HeadModel,InvMeth,noisecov,datacov,atlas,ScoutFunction,FileHead,FileCortex,FileInner,FileOuter)
% % % Inputs: EEG1 = EEGLAB dataset
% % % % % % % Cond= Bemconductivities : array of 3 columns
% % % % % % % InvMeth=1 if wmne, 2 if sloreta, 3 if dspm, 4 if lcmv
% % % % % % % noisecov and datacov are the noise and data covariance matrices needed for inv solution
% % % % % % % atlas=1 if desikan, 2 if destrieux

% % % ==== First step: adjust eeg positions 
disp('Reconstruct sources=== First step: adjust eeg positions');
f = waitbar(0,'Please wait...');
pause(1)
waitbar(0,f,'Adjusting EEG positions');
n=0;
% 1- Convert xyz to BS format
for iChan=1:length(EEG1.chanlocs)
    if(strcmp(EEG1.chanlocs(iChan).type,'EEG'))
        n=n+1;
        Loc(iChan,:) = [EEG1.chanlocs(iChan).X; ...
                                            EEG1.chanlocs(iChan).Y; ...
                                     EEG1.chanlocs(iChan).Z] ./ 1000;
    end
end
if(n==0)
    for iChan=1:length(EEG1.chanlocs)
        Loc(iChan,:) = [EEG1.chanlocs(iChan).X; ...
                                            EEG1.chanlocs(iChan).Y; ...
                                     EEG1.chanlocs(iChan).Z] ./ 1000;
        
    end
end

% 2- Load scalp file to refine channel loc
load(FileHead,'Vertices');
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

if(n==0)
    for c=1:length(EEG1.chanlocs)
    
        ChannelStruct(c).Type='EEG';      
    end

end
ieeg=[];
for k=1:length(EEG1.chanlocs)
    if(ChannelStruct(k).Type=='EEG')
        ieeg=[ieeg k];
    end
end

waitbar(0.33,f,'Loading HeadModel');

% Load Options, NoiseCov
load('data/Inverse/OPTIONS.mat');
OPTIONS.ChannelTypes={};

noisecov_new=[];

count=0;
for k=1:length(EEG1.chanlocs)
    if(ChannelStruct(k).Type=='EEG')
        count=count+1;    
        OPTIONS.ChannelTypes{count}='EEG';
        noisecov_new(count,:)=noisecov(k,:);
%         noisecov_new(:,count)=noisecov(:,k);

    end
end
noisecov_new1=[];
count=0;
for k=1:length(EEG1.chanlocs)
    if(ChannelStruct(k).Type=='EEG')
        count=count+1;    
        OPTIONS.ChannelTypes{count}='EEG';
        noisecov_new1(:,count)=noisecov_new(:,k);
%         noisecov_new(:,count)=noisecov(:,k);

    end
end
OPTIONS.NoiseCovMat.NoiseCov=noisecov_new1;
% 

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
disp('Reconstruct sources=== Third step: Inverse solution');
waitbar(0.66,f,'Solving the inverse problem');

% % to remove removed channels from the anallysis
data1=EEG1.data(ieeg,:);
channelsSum=sum(data1,2);
keptChannels=find(channelsSum>-0.0000000000000000001);


[Results, OPTIONS] = bst_inverse_linear_2018(HeadModel,OPTIONS);
source_grid=Results.ImagingKernel(:,keptChannels)*data1(keptChannels,:);
   
% % ==== Fourth step: Extract Scouts time series 
disp('Reconstruct sources=== Fourth step: Extract Scouts time series');
waitbar(0.88,f,'Extracting Scouts time series');

% 1- load scout atlas depending on user choice
switch atlas
    case 1
        load('data/Inverse/scout_Desikan-Killiany_68.mat')
    case 2
        load('data/Inverse/scout_Destrieux_148.mat')
        case 3
    load('data/Inverse/scout_Braintomme_210.mat')

end

% 2- extract sc time series
Sc_timeseries=[];
for sc=1:length(Scouts) 
    Vertices_correspondant=Scouts(sc).Vertices;
    F=source_grid(Vertices_correspondant,:);
    nTime = size(F,2);
    nRow = size(F,1);

%3- COMBINE ALL VERTICES
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
    case 'none'
        Fs=Results.ImagingKernel(:,keptChannels)*data1(keptChannels,:);

    % Otherwise: error
    otherwise
        error(['Unknown scout function: ' ScoutFunction]);
end
Sc_timeseries(sc,:)=Fs;
end

waitbar(1,f,'Finishing');
close(f)
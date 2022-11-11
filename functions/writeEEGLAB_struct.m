function EEG2=writeEEGLAB_struct(eegS,srate,subjname,filename,filepath,fileLocs)
% % Write EEGLAB struct
numberSamples=size(eegS,2);
numberElectrodes=size(eegS,1);
EEG2.data=eegS;
EEG2.setname=subjname;
EEG2.filename=filename;
EEG2.filepath=filepath;
EEG2.subject= '';
EEG2.group= '';
EEG2.condition= '';
EEG2.session= [];
EEG2.comments= '';
EEG2.nbchan= numberElectrodes;
EEG2.trials= 1
EEG2.pnts= numberSamples;
EEG2.srate= srate;
EEG2.xmin= 0;
EEG2.xmax= numberSamples;
%                times= [1×384 double]
EEG2.icaact= [];
EEG2.icawinv= [];
EEG2.icasphere= [];
EEG2.icaweights= [];
EEG2.icachansind= [];
% EEG2.chanlocs= [];
% EEG2.urchanlocs= [];
% EEG2.chaninfo.filename= [];
if(strcmp(fileLocs,''))
    EEG2.chanlocs= [];
EEG2.urchanlocs= [];

else
EEG2.chanlocs= readlocs(fileLocs);
EEG2.urchanlocs= readlocs(fileLocs);
EEG2.chaninfo.filename= fileLocs;
end
EEG2=eeg_checkset(EEG2);
% EEG2.chanlocs= readlocs(fileLocs);
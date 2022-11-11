% This function provides a comprehensive example of using the bids_export
% function. Note that eventually, you may simply use bids_export({file1.set file2.set}) 
% and that all other parameters are highly recommended but optional.

% You may not run this script because you do not have the associated data.
% It correspond to the actual dataset included in the BIDS EEG publication
% available at https://psyarxiv.com/63a4y.
%
% The data itself is available at https://zenodo.org/record/1490922
%
% A. Delorme - Jan 2019

% raw data files (replace with your own)
% ----------------------------------

cd('/Users/ayakabbara/Desktop/projects/EEG_PreProcessing/Raw Data Part 1/set'); %Find and change working folder to raw EEG data
filenames = dir('set_*.set')
nb=10;
for participant = 1:nb %Cycle through participants
    %Get participant name information
    disp(['Participant: ', num2str(participant)]) %Display current participant being processed
   
data(participant).file = filenames(participant).name;
data(participant).session = 1;
data(participant).run     = 1;
data(participant).chanlocs = '/Users/ayakabbara/Desktop/channels63.ced';  % optional

end

% % ---------------------
chanlocs = '/Users/ayakabbara/Desktop/channels63.ced';  % optional
        
% call to the export function
% ---------------------------
%  bids_export(data,'chanlocs', chanlocs);
bids_export(data);
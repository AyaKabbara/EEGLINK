function [elec] = Channels_BS_to_FT(Channel)
% this function converts channel files imported from brainstorm into
% fieldtrip struct


% ===== CHANNEL INFO =====
% Create electrode structure
elec = struct();
iEeg = 1:length(Channel);
elec.label = {Channel(iEeg).Name};
elec.unit  = 'm';
% Electrode position
elec.chanpos = zeros(length(iEeg),3);
for i = 1:length(iEeg)
    elec.chanpos(i,:) = Channel(iEeg(i)).Loc(:,1);
end
elec.elecpos = elec.chanpos;
% elec.tra = eye(length(iEeg));

% end
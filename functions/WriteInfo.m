function WriteInfo(eegS,srate,subjname,info_panel,scalp)
% % subject name, number of electrodes, 
% % number of samples, pathfile
set(info_panel,'Visible','on');
numSamples=size(eegS,2);
numElec=size(eegS,1);

if(scalp==1) 
jLabel = javaObjectEDT(javax.swing.JLabel(['<html><body style="background-color:rgb(240, 240, 240); color:rgb(33, 45, 107);"> <div align=left> <u> Subject name:</u></i>' subjname '<BR> <u> Type:</i></u>' 'Scalp-level signals' '<BR> <u> Number of electrodes:</i></u>' num2str(numElec) '<BR>  <u> Number of samples:</i></u>' num2str(numSamples) '<BR><u> Sampling frequency:</i></u>' num2str(srate) '<BR>' '</body></div>']));
else
    jLabel = javaObjectEDT(javax.swing.JLabel(['<html><body style="background-color:rgb(240, 240, 240); color:rgb(33, 45, 107);"> <div align=left> <u> Subject name:</u></i>' subjname '<BR> <u> Type:</i></u>' 'Source-level signals' '<BR> <u> Number of ROIs:</i></u>' num2str(numElec) '<BR>  <u> Number of samples:</i></u>' num2str(numSamples) '<BR><u> Sampling frequency:</i></u>' num2str(srate) '<BR>' '</body></div>']));
end
[hjLabel, hContainer] = javacomponent(jLabel, [0,0,0,0], info_panel);
set(hContainer, 'Units','norm', 'Position',[0,0,1,1],'BackgroundColor',[0.94 0.94 0.94]);
% Make the label (and its internal container) transparent
jLabel.setOpaque(false)  % the label control itself
% Align the label
jLabel.setVerticalAlignment(jLabel.CENTER);
jLabel.setHorizontalAlignment(jLabel.LEFT);
% Add 6-pixel top border padding and repaint the label
% jLabel.setBorder(javax.swing.BorderFactory.createEmptyBorder(6,0,0,0));
jLabel.repaint;



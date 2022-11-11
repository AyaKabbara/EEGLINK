function ViewSignal(eeg,fig1,plotting_panel)
% global count;
% count=0;
global jRangeSlider;
set(plotting_panel,'Visible','on');
numberSamples=size(eeg,2);
numberElectrodes=size(eeg,1);
% set the rangeslider
jRangeSlider = com.jidesoft.swing.RangeSlider(0,numberSamples,1,numberSamples);  % min,max,low,high
width=get(plotting_panel,'Position');
width=width(3);

jRangeSlider = javacomponent(jRangeSlider, [200,20,200,80], plotting_panel);

set(jRangeSlider, 'MajorTickSpacing',numberSamples/4, 'MinorTickSpacing',numberSamples/16, 'PaintTicks',true, 'PaintLabels',true, ...
    'Background',javax.swing.plaf.ColorUIResource(0.94,0.94,0.94), 'MouseReleasedCallback',{@rangeSlider_change,eeg,fig1,jRangeSlider});

% Plot the signal
set(fig1,'color',[1 1 1],'box','on','GridlineStyle','-','YColor',[0 0 0],'XColor',[0 0 0]);
plot(fig1,eeg(:,1:numberSamples)','color','k','linewidth',0.01);
grid on
set(fig1, 'XLimSpec', 'Tight');
set(fig1, 'YLimSpec', 'Tight');
ylabel(fig1,'Averaged Value (uV)');
xlabel(fig1,'Number of samples ');

function rangeSlider_change(hObj, EventData,eegS,fig1,jRangeSlider)
% global count
% count=count+1

% Prop=get(jRangeSlider);
% Define the window to plot, first, window= all the nb of samples
min = get(jRangeSlider, 'LowValue');
max = get(jRangeSlider, 'HighValue');
min=min+1;
% Plot the signal for the window chosen
plot(fig1,eegS(:,min:max)','color','k','linewidth',0.01);
grid on
set(fig1,'color',[1 1 1],'box','on','GridlineStyle','-','YColor',[0 0 0],'XColor',[0 0 0]);
axis tight
set(fig1, 'XLimSpec', 'Tight');
set(fig1, 'YLimSpec', 'Tight');
ylabel(fig1,'Averaged Value (uV)');
xlabel(fig1,'Number of samples ');



% set(text_nEle,'String',['Number of electrodes: ' num2str(numElec)]);
% set(text_nSam,'String',['Number of samples: ' num2str(numSamples)]);

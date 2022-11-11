function plv = plv_sliding_window(data,srate,window,step,fmin,fmax,dynamic)

% computes the phase locking value (PLV)
% inputs: data: nb_signals*nb_samples
%         srate: sampling frequency
%         window: length of the sliding window in seconds
%         step: step size in seconds

%%

[nb_signals, nb_samples] = size(data);

FrequencyBand=[fmin fmax];
filterorder=4/FrequencyBand(1);

%% filtering with FIR
b1 = fir1(floor(filterorder*srate),[FrequencyBand(1) FrequencyBand(2)]/(srate/2));
for k = 1:nb_signals
    data(k,:) = filtfilt(b1,1,double(data(k,:)));
end

if(step==0)
    step=1;
end

win_samples = window*srate;
nb_shifts  = step*srate;

mid_window = win_samples/2:nb_shifts:nb_samples-win_samples/2;
nb_windows = length(mid_window);


inst_phase = zeros(nb_signals,nb_samples);
for i = 1:nb_signals
    inst_phase(i, :) = angle(hilbert((data(i, :))));
end

%% dynamic plv
plv = zeros(nb_windows,nb_signals,nb_signals);

for i = 1:nb_windows
    tmp = inst_phase(:,1 + mid_window(i) - win_samples/2 : mid_window(i)+win_samples/2);
    plv(i,:,:) = ROInets.plv(tmp);
end

if(dynamic==0)
%% static plv
plv = mean(plv,1);
plv = reshape(plv(1,:,:),[nb_signals,nb_signals]);
end
end

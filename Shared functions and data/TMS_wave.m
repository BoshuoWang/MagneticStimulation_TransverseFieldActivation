function [t_vec, pulse_shape, PW] = TMS_wave(wvf, dt, t_before, t_after)
% wvf: string. "mp", "hs", "bp"
% dt: time step, in ms.
% t_before: additional time before pulse onset, in ms. Positive. 
% t_after: total time after pulse onset, in ms. Positive, will be set to 1 ms if less than 1 ms.

if ~nargin      % Default parameters;
    wvf = 'mp';
    dt = 2e-3;
    t_before = 50e-3;
    t_after = 1.5;
end
if ~nargout     % Plot waveform
    if_plot = 1; 
else
    if_plot = 0;
end



if strcmp(wvf,'mp')
    load('MagproX100_TMS_waves.mat','mp');
    t_rec = mp.t_rec;
    E_rec = mp.E_rec;
elseif strcmp(wvf,'hs')
    load('MagproX100_TMS_waves.mat','hs');
    t_rec = hs.t_rec;
    E_rec = hs.E_rec;
elseif strcmp(wvf,'bp')
    load('MagproX100_TMS_waves.mat','bp');
    t_rec = bp.t_rec;
    E_rec = bp.E_rec;
end
% switch wvf                  % Load waveform and denote the time and E-field data as RECorded
%     case "mp"
%         load('MagproX100_TMS_waves.mat','mp');
%         t_rec = mp.t_rec;
%         E_rec = mp.E_rec;
%     case "hs"
%         load('MagproX100_TMS_waves.mat','hs');
%         t_rec = hs.t_rec;
%         E_rec = hs.E_rec;
%     case "bp"
%         load('MagproX100_TMS_waves.mat','bp');
%         t_rec = bp.t_rec;
%         E_rec = bp.E_rec;
% end

if t_after < 1
    t_after = 1;
end
t_after = ceil( t_after / dt ) * dt;            % Time after pulse onset
if t_before < 0
    t_before = 0;
end
t_before = ceil(t_before / dt) * dt;            % Time before the pulse

t_rec = [ t_rec, t_rec(end) + dt, t_after ];	% Add time point right after end of recording and at very end
E_rec = [ E_rec, 0,               0       ];	% Add zeros to waveform

Fs = 1/dt;      % Sampling rate; in kHz
[pulse_shape, t_vec, ~] = resample(E_rec,t_rec,Fs,10,10);	% Resampling and filtering noise

pulse_shape = pulse_shape / max(pulse_shape);   % Normalized pulse onset to 1
pulse_shape(1) = 0;                             % Set t = 0 amplitude to 0. Can be non-zero due to filtering

delay_t_vec = - fliplr(dt : dt : t_before);     % Time points before the pulse

t_vec =         [ delay_t_vec ,             t_vec];
pulse_shape =   [ zeros(size(delay_t_vec)), pulse_shape];

if if_plot
    figure('Color','w');
    set(gca,'NextPlot','add','Box','on');
    xlabel('Time (ms)');ylabel('Normalized waveform');
    axis([t_vec(1), t_vec(end),-1,1]);
    plot([t_vec(1),t_vec(end)],[0,0],'--k');
    plot(t_rec,E_rec,':b');
    plot(t_vec,pulse_shape,'r--');
end
        
% switch wvf      % Define pulse duration
%     case "mp"
if strcmp(wvf,'mp')
    [~,ind_peak] = max(pulse_shape);    % Find peak of positive phase
        ind_PW = find(pulse_shape(ind_peak+1:end) < 0,1,'first')+ ind_peak - 1; 
        % End of positive phase
elseif strcmp(wvf,'hs')
%     case "hs"
        [~,ind_peak] = min(pulse_shape);    % Find peak of negative phase 
        ind_PW = find(pulse_shape(ind_peak+1:end) > 0,1,'first')+ ind_peak - 1; 
        % End of negative phase
elseif strcmp(wvf,'bp')
%     case "bp"
        [~,ind_peak] = min(pulse_shape);    % Find peak of negative phase 
        [~,ind_temp] = max(pulse_shape(ind_peak+1:end));    
        ind_peak = ind_peak + ind_temp;     % Find peak of second postive phase 
        ind_PW = find(pulse_shape(ind_peak+1:end) < 0,1,'first')+ ind_peak - 1; 
        % Pulse duration, end of second postive phase
end

PW = t_vec(ind_PW);     

ind_pos = (pulse_shape >= 0);
pos_AUC =    ( sum( pulse_shape(  ind_pos ) ) );  	% Area Under Curve for positive phase(s)    
neg_AUC = abs( sum( pulse_shape( ~ind_pos ) ) );	% Area Under Curve for negative phase(s)
pulse_shape( ~ind_pos ) = pulse_shape( ~ind_pos ) * pos_AUC / neg_AUC;  
% Slightly scaling negative phase to make cumulative sum zero  

if if_plot
    disp(sum(pulse_shape));                         % Verify zero sum
    plot(t_vec,pulse_shape,'k-');
    plot(t_vec(ind_PW),pulse_shape(ind_PW),'*k');
end
end
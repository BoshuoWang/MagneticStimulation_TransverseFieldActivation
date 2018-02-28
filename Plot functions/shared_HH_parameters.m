clearvars;
close all;
%% Figure format
figure_length_x = 1500;
figure_length_y = 750;
format_figure.Position = [0,0,figure_length_x,figure_length_y];
format_figure.Color = 'w'; % background color of figure window

x_unit = 40/figure_length_x;
y_unit = 40/figure_length_y;
%% Axis format
format_axis.FontSize = 16;
format_axis.TickLabelInterpreter = 'latex';
format_axis.Color = 'w'; % background color of the plot area
format_axis.TickDir = 'out';
format_axis.LineWidth = 1;

format_axis_label.FontSize = 16;
format_axis_label.Interpreter = 'latex';
format_axis_label.Color = 'k';

format_title.FontSize = 18;
format_title.Interpreter = 'latex';
format_title.Color = 'k';

tick_step = 0.5;
y_lim = [-4.03,0];  %cm
y_ticks = ( round(y_lim(1)) : tick_step : y_lim(2) );
y_tick_labels = cell(length(y_ticks),1);
for ii=1 : 2 : length(y_tick_labels)
    y_tick_labels{ii}= ['$$',num2str(abs(round(y_ticks(ii))),'%d'),'$$'];
end

%% Blank placeholder axis
format_blank_axis = format_axis;
format_blank_axis.XColor = 'w';
format_blank_axis.YColor = 'w';
format_blank_axis.ZColor = 'w';


%% Color maps
color_map_amp = flipud(parula(256));
color_map_per_neg = parula(256);
color_map_per_pos = hot(255*4/3);
for ii = 256:-1:256-8
    color_map_amp(ii,:)= brighten(color_map_amp(ii,:),-(ii-(256-8))/32);
end
for ii = 129:256
    color_map_per_neg(ii,:) = brighten(color_map_per_neg(ii,:),(ii - 128)/128);
end
color_map_per_full = flipud([color_map_per_pos(end/4:end,:);color_map_per_neg]);

max_diff = -100;

color_lim_per_neg = [max_diff, 0];
color_level_per_neg = max_diff : 0.1 : 0;

color_lim_per_full = [max_diff, 100];
color_level_per_full = max_diff : 0.1 : 100;

%% Color bar
color_bar_ticks_per_neg = max_diff : 25 : 0;
color_bar_tick_labels_per_neg = cell(size(color_bar_ticks_per_neg));
for ii = 1 : length(color_bar_ticks_per_neg)
    color_bar_tick_labels_per_neg{ii} = sprintf('$$%d \\%%$$', color_bar_ticks_per_neg(ii));
end

color_bar_ticks_per_full = max_diff : 25 : 100;
color_bar_tick_labels_per_full = cell(size(color_bar_ticks_per_full));
for ii = 1 : length(color_bar_ticks_per_full)
    color_bar_tick_labels_per_full{ii} = sprintf('$$%d \\%%$$', color_bar_ticks_per_full(ii));
end


color_bar_title.FontSize = 16;
color_bar_title.Interpreter = 'latex';
color_bar_title.Color = 'k';
color_bar_title.FontWeight = 'Normal';
color_bar_title.Units = 'Normalized';
color_bar_title.HorizontalAlignment = 'Center';
color_bar_title.VerticalAlignment = 'Bottom';

decade = 1:9;

color_bar.FontSize = 16;
color_bar.TickLabelInterpreter = 'latex';
color_bar.TickDirection = 'out';
color_bar.TickLength = 0.02;
color_bar.LineWidth = 1;

%% Coil outline parameters
x_coil_norm = [-1,0,1,1,0,-1]';
y_coil_norm = [0,0,0,1,1,1]';

y_coil_ind = 1;

c_coil = zeros(6,1,3);
c_coil(1,1,:) = [1,1,1]*0.8;
c_coil(3,1,:) = [1,1,1]*0.8;
c_coil(4,1,:) = [1,1,1]*0.8;
c_coil(6,1,:) = [1,1,1]*0.8;
c_coil(2,1,:) = [1,1,1]*0.4;
c_coil(5,1,:) = [1,1,1]*0.4;

format_coil.EdgeColor = 'k';
format_coil.LineWidth = 1.5;
format_coil.FaceLighting = 'gouraud';

%% Contour lines and labels
contour_line.LineStyle = '-';
contour_line.LineWidth = 1.5;

% Threshold amplitude limits
amp_log_max = 6.25;
amp_log_min = 3;

color_level_amp = amp_log_min:0.01:amp_log_max;

color_lim_amp = [amp_log_min,amp_log_max];

color_bar_ticks_amp =  [log10( kron( 10.^(ceil(amp_log_min):floor(amp_log_max)-1) , decade ) ) , floor(amp_log_max) ];
color_bar_tick_labels_amp = cell(size(color_bar_ticks_amp));
for ii = 1 : length(color_bar_ticks_amp)
    if round(color_bar_ticks_amp(ii)) == color_bar_ticks_amp(ii)
        color_bar_tick_labels_amp{ii} = sprintf('$$10^{%d}$$',color_bar_ticks_amp(ii));
    end
end
color_bar_ticks_amp = [color_bar_ticks_amp,amp_log_max];
color_bar_tick_labels_amp = [color_bar_tick_labels_amp,{'$$+\infty$$'}];
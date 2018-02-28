h_f = figure(format_figure);

color_bar_ticks_amp =  [log10( kron( 10.^(ceil(amp_log_min):floor(amp_log_max)+1) , decade ) ) , floor(amp_log_max)+2 ];
color_bar_tick_labels_amp = cell(size(color_bar_ticks_amp));
for ii = 1 : length(color_bar_ticks_amp)
    if round(color_bar_ticks_amp(ii)) == color_bar_ticks_amp(ii)
        color_bar_tick_labels_amp{ii} = sprintf('$$10^{%d}$$',color_bar_ticks_amp(ii));
    end
end

h_ax_temp = axes(format_blank_axis, 'Position',[x_unit * 3, y_unit *  y_begin(3), x_unit, y_unit * (sum(y_length(1:3))+y_gap*2)]);
ylabel(h_ax_temp,{'\textbf{Stimulation threshold}','Conventional CE'});
set(h_ax_temp.YLabel,format_axis_label);
set(h_ax_temp.YLabel,'FontSize', 20);

caxis(h_ax_temp,color_lim_amp);
colormap(h_ax_temp,color_map_amp);

color_bar_title.String = '$$\mathrm{A/\mu s}$$';
h_cb = colorbar(h_ax_temp,'EastOutside');
set(h_cb,'position',[1 - x_unit * 3, y_unit * y_begin(3) , x_unit * x_gap, y_unit * (sum(y_length(1:3))+y_gap*2)]);
set(h_cb,color_bar,'Ticks',color_bar_ticks_amp,'TickLabels',color_bar_tick_labels_amp,'AxisLocation','out');
set(h_cb.Title,color_bar_title);

h_ax_temp = axes(format_blank_axis, 'Position',[x_unit * 5, y_unit * y_begin(1), x_unit, y_unit * y_length(1)]);
ylabel({'\textbf{Axon}','\textbf{undulation}'});
set(h_ax_temp.YLabel,format_axis_label);
set(h_ax_temp.YLabel,'FontSize', 18);

h_ax_temp = axes(format_blank_axis, 'Position',[x_unit * 5, y_unit *  y_begin(2), x_unit, y_unit * y_length(2)]);
ylabel({'\textbf{Fascicle}','\textbf{undulation}'});
set(h_ax_temp.YLabel,format_axis_label);
set(h_ax_temp.YLabel,'FontSize', 18);

h_ax_temp = axes(format_blank_axis, 'Position',[x_unit * 5, y_unit *  y_begin(3), x_unit, y_unit * y_length(3)]);
ylabel({'\textbf{Axon \& fascicle}','\textbf{undulation}'});
set(h_ax_temp.YLabel,format_axis_label);
set(h_ax_temp.YLabel,'FontSize', 18);

%%
frame = getframe(h_f);
im_0u = frame2im(frame);
im_end_u = im_0u(:,round((1 - x_unit * (3+x_gap)) * figure_length_x)*2+1:end,:);
im_0u = im_0u(:,1:round((x_unit * (5 - x_gap)) * figure_length_x)*2 ,:);
close(h_f);

%%
h_f = figure(format_figure);

h_ax_temp = axes(format_blank_axis,'Position',[x_unit * 3, y_unit *  y_begin(6) , x_unit, y_unit * (sum(y_length(4:6))+y_gap*2)]);
ylabel({'\textbf{Threshold difference (\%)}','vs. straight axons'});
set(h_ax_temp.YLabel,format_axis_label);
set(h_ax_temp.YLabel,'FontSize', 20);

caxis(h_ax_temp,color_lim_per_full);
colormap(h_ax_temp,color_map_per_full);

color_bar_title.String = ' ';
h_cb = colorbar(h_ax_temp,'EastOutside');
set(h_cb,'position',[1 - x_unit * 3, y_unit *  y_begin(6) ,x_unit * x_gap, y_unit * (sum(y_length(4:6))+y_gap*2)]);
set(h_cb,color_bar,'Ticks',color_bar_ticks_per_full,'TickLabels',color_bar_tick_labels_per_full,'AxisLocation','out');
set(h_cb.Title,color_bar_title);
set(h_cb,'TickLength',h_cb.TickLength *(sum(y_length(1:3))+y_gap*2)/(sum(y_length(4:6))+y_gap*2));

h_ax_temp = axes(format_blank_axis, 'Position',[x_unit * 5, y_unit *  y_begin(4), x_unit, y_unit * y_length(4)]);
ylabel({'\textbf{Axon}','\textbf{undulation}'});
set(h_ax_temp.YLabel,format_axis_label);
set(h_ax_temp.YLabel,'FontSize', 18);

h_ax_temp = axes(format_blank_axis, 'Position',[x_unit * 5, y_unit *  y_begin(5), x_unit, y_unit * y_length(5)]);
ylabel({'\textbf{Fascicle}','\textbf{undulation}'});
set(h_ax_temp.YLabel,format_axis_label);
set(h_ax_temp.YLabel,'FontSize', 18);

h_ax_temp = axes(format_blank_axis, 'Position',[x_unit * 5, y_unit *  y_begin(6), x_unit, y_unit * y_length(6)]);
ylabel({'\textbf{Axon \& fascicle}','\textbf{undulation}'});
set(h_ax_temp.YLabel,format_axis_label);
set(h_ax_temp.YLabel,'FontSize', 18);

%%
frame = getframe(h_f);
im_0d = frame2im(frame);
im_end_d = im_0d(:,round((1 - x_unit * (3+x_gap)) * figure_length_x)*2+1:end,:);
im_0d = im_0d(:,1:round((x_unit * (5 - x_gap)) * figure_length_x)*2 ,:);
close(h_f);
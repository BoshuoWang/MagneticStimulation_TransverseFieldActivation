h_f = figure(format_figure);

%%
h_ax_temp = axes(format_blank_axis,'Position',[x_unit * x_begin(1), 1 - y_unit * 1.25, x_unit * (sum(x_length(1:2))+x_gap*1), y_unit * 0.25 ]); 
title(h_ax_temp,'\textbf{Stimulation threshold}');
set(h_ax_temp.Title,format_title,'FontSize', 20);

caxis(h_ax_temp,color_lim_amp);
colormap(h_ax_temp,color_map_amp);

color_bar_title.String = '$$\: \mathrm{A/\mu s} \:$$';
h_cb = colorbar(h_ax_temp,'SouthOutside'); 
set(h_cb,'position',[x_unit * x_begin(1), y_unit * 1.5, x_unit * (sum(x_length(1:2))+x_gap*1), y_unit * y_gap/2]);
set(h_cb,color_bar,'Ticks',color_bar_ticks_amp,'TickLabels',color_bar_tick_labels_amp,'AxisLocation','out');
set(h_cb.Title,color_bar_title);

h_ax_temp = axes(format_blank_axis, 'Position',[x_unit * x_begin(1), 1 - y_unit * 2.75, x_unit * x_length(1), y_unit * 0.25 ]);
title(h_ax_temp,{'Conventional CE',' '});
set(h_ax_temp.Title,format_title,'FontSize', 18);

h_ax_temp = axes(format_blank_axis, 'Position',[x_unit * x_begin(2), 1 - y_unit * 2.75, x_unit * x_length(2), y_unit * 0.25 ]);
title(h_ax_temp,{'Modified CE',' '});
set(h_ax_temp.Title,format_title,'FontSize', 18);

%%
h_ax_temp = axes(format_blank_axis,'Position',[x_unit * x_begin(3), 1 - y_unit * 1.25, x_unit * (sum(x_length(3))+x_gap*0), y_unit * 0.25]); 
title(h_ax_temp,'\textbf{Threshold difference (\%)}');
set(h_ax_temp.Title,format_title,'FontSize', 20);

caxis(h_ax_temp,color_lim_per_neg);
colormap(h_ax_temp,color_map_per_neg);

color_bar_title.String = ' ';
h_cb = colorbar(h_ax_temp,'SouthOutside'); 
set(h_cb,'position',[x_unit * x_begin(3), y_unit * 1.5, x_unit * (sum(x_length(3))+x_gap*0), y_unit * y_gap/2]);
set(h_cb,color_bar,'Ticks',color_bar_ticks_per_neg,'TickLabels',color_bar_tick_labels_per_neg,'AxisLocation','out','Direction','reverse');
set(h_cb.Title,color_bar_title);

set(h_cb,'TickLength',h_cb.TickLength *(sum(x_length(1:2))+x_gap*1)/(sum(x_length(3))+x_gap*0));

h_ax_temp = axes(format_blank_axis, 'Position',[x_unit * x_begin(3), 1 - y_unit * 2.75, x_unit * x_length(3), y_unit * 0.25]);
title(h_ax_temp,{'Modified CE vs. Conventional CE',' '});
set(h_ax_temp.Title,format_title,'FontSize', 18);

%%
frame = getframe(h_f);
im_0 = frame2im(frame);
im_end = im_0(round((1 - y_unit * 2.5) * figure_length_y)*2+1:end,:,:);
im_0 = im_0(1:round((y_unit * 2) * figure_length_y)*2,:,:);
close(h_f);
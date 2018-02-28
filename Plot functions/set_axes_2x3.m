x_ticks= (( round(x_lim(1)) : tick_step : round(x_lim(2)) ));
x_tick_labels = cell(length(x_ticks),1);
for ii=1 : 2 : length(x_tick_labels)
    x_tick_labels{ii}= ['$$',num2str(round(x_ticks(ii)),'%d'),'$$'];
end

% Axes
h_ax =  gobjects(2,3);

ax_pos = cell(2,3);
for ii = 1:2
    for jj = 1: 3
        ax_pos{ii,jj} = [x_unit * x_begin(jj), y_unit * y_begin(ii), x_unit * x_length(jj), y_unit * y_length(ii)];
    end
end

ax_pos_0 = [x_unit * (x_begin(1) - x_gap * 2),  y_unit * y_begin(2), ...
            x_unit, y_unit *(sum(y_length) + y_gap) ];
h_ax_temp = axes('Position',ax_pos_0);
ylabel(h_ax_temp,['\textbf{',coil_title,'}']);
set(h_ax_temp,format_blank_axis);
set(h_ax_temp.YLabel,format_axis_label);
set(h_ax_temp.YLabel,'FontSize', 20);

ax_pos_0 = [x_unit * (x_begin(1)-x_gap * 1),  y_unit * y_begin(1), ...
            x_unit, y_unit * y_length(1) ];
h_ax_temp = axes('Position',ax_pos_0);
ylabel(h_ax_temp,'Monophasic');
set(h_ax_temp,format_blank_axis);
set(h_ax_temp.YLabel,format_axis_label);
set(h_ax_temp.YLabel,'FontSize', 18);

ax_pos_0 = [x_unit * (x_begin(1)-x_gap * 1),  y_unit * y_begin(2), ...
            x_unit, y_unit * y_length(1)];
h_ax_temp = axes('Position',ax_pos_0);
ylabel(h_ax_temp,'Half-sine');
set(h_ax_temp,format_blank_axis);
set(h_ax_temp.YLabel,format_axis_label);
set(h_ax_temp.YLabel,'FontSize', 18);


ax_pos_0 = [x_unit * x_begin(1),  y_unit * y_begin(2), ...
            x_unit , y_unit *(sum(y_length) + y_gap)];
h_ax_temp = axes('Position',ax_pos_0);
ylabel(h_ax_temp,{'Vertical distance $$y \: (\mathrm{cm})$$'}); 
set(h_ax_temp,format_blank_axis);
set(h_ax_temp.YLabel,format_axis_label);

for ii = 1:2
    for jj = 1:3
        h_ax(ii,jj) = axes('Position',ax_pos{ii,jj});
        box on; hold on;
        set(gca,'Ylim',y_lim,'YTick', y_ticks);
        set(gca,'Xlim',x_lim,'XTick', x_ticks);
        switch jj
            case 1
                colormap(gca,color_map_amp);
                caxis(gca,color_lim_amp);
                set(gca,'YTickLabel',y_tick_labels);
            case 2
                colormap(gca,color_map_amp);
                caxis(gca,color_lim_amp);
                set(gca,'YTickLabel',{});
            case 3
                colormap(gca,color_map_per_neg);
                caxis(gca,color_lim_per_neg);
                set(gca,'YTickLabel',{});
        end
        if ii == 1                
            set(gca,'XTickLabel',{});
        else
            set(gca,'XTickLabel',x_tick_labels);
            if jj == 2
                xlabel({'Lateral distance $$x \: (\mathrm{cm})$$'});
            end
        end
    end
    
end

set(h_ax,'DataAspectRatio',[1,1,1]);
set(h_ax,format_axis)
set([h_ax.XLabel,h_ax.YLabel ], format_axis_label);
set([h_ax.Title], format_title);

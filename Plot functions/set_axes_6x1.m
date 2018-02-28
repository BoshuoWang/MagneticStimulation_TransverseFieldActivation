x_begin = zeros(size(x_length));
for ii = 1 : length(x_length)
    x_begin(ii) = x_offset + (x_length(ii) + x_gap) * (ii-1);
end

x_ticks= (( round(x_lim(1)) : tick_step : round(x_lim(2)) ));
x_tick_labels = cell(length(x_ticks),1);
for ii=1 : 2 : length(x_tick_labels)
    x_tick_labels{ii}= ['$$',num2str(round(x_ticks(ii)),'%d'),'$$'];
end

% Axes
h_ax =  gobjects(6,1);

ax_pos = cell(6,1);
for ii = 1:3
    for jj = 1%: 2
        ax_pos{ii,jj} = [x_unit * x_begin(jj), y_unit * y_begin(ii), x_unit * x_length(jj), y_unit * y_length(ii)];       
    end
end
for ii = 4:6
    for jj = 1%:2
        ax_pos{ii,jj} = ax_pos{ii-3,jj};
    end
end

figure(h_f1);
ax_pos_0 = [x_unit * x_begin(1),  y_unit * y_begin(3), ...
            x_unit *(x_begin(end)- x_begin(1) + x_length(end)),...
            y_unit *(y_begin(1)- y_begin(3) + y_length(1) + y_gap)];
h_ax_temp = axes('Position',ax_pos_0);
title(['\textbf{',coil_title,'}']);
set(h_ax_temp,format_blank_axis);
set(h_ax_temp.Title,format_title,'FontSize', 20);

ax_pos_0 = [x_unit * x_begin(1),  y_unit * (y_begin(2) - (y_length(2) + y_gap)/2), ...
            x_unit *(x_begin(end)- x_begin(1) + x_length(end)),...
            y_unit *(y_length(2) + y_gap)];
h_ax_temp = axes('Position',ax_pos_0);
ylabel({'Vertical distance $$Y $$ $$(\mathrm{cm})$$'});
set(h_ax_temp,format_blank_axis);
set(h_ax_temp.YLabel,format_axis_label);

figure(h_f2);
ax_pos_0 = [x_unit * x_begin(1),  y_unit * y_begin(6), ...
            x_unit *(x_begin(end)- x_begin(1) + x_length(end)),...
            y_unit *(y_begin(3)- y_begin(6) + y_length(4) + y_gap)];
h_ax_temp = axes('Position',ax_pos_0);
set(gca,format_axis);set(gca,'XColor','w','YColor','w');
xlabel({'Lateral distance $$X$$ $$(\mathrm{cm})$$'},'Interpreter','latex','Color','k','FontSize', 14); 
set(h_ax_temp,format_blank_axis);
set(h_ax_temp.XLabel,format_axis_label);

for ii = 1:6
    for jj = 1%:2
        if ii<=3
            figure(h_f1);
        else
            figure(h_f2);
        end
        
        h_ax(ii,jj) = axes('Position',ax_pos{ii,jj});
        box on; hold on;
        set(h_ax(ii,jj),'Ylim',y_lim,'YTick', y_ticks);
        switch ii
            case {1,2,3}
                colormap(h_ax(ii,jj),color_map_amp);
                caxis(h_ax(ii,jj),color_lim_amp);
            case {4,5,6}
                colormap(h_ax(ii,jj),color_map_per_full);
                caxis(h_ax(ii,jj),color_lim_per_full);
        end
        switch jj
            case 1
                set(h_ax(ii,jj),'YTickLabel',y_tick_labels);
                set(h_ax(ii,jj),'Xlim',x_lim,'XTick', x_ticks);
                switch ii
                    case {1,2,3,4,5}
                        set(h_ax(ii,jj),'XTickLabel',{});
                    case 6
                        set(h_ax(ii,jj),'XTickLabel',x_tick_labels);
                end
        end
    end
    
end

set(h_ax,'DataAspectRatio',[1,1,1]);
set(h_ax,format_axis)
set([h_ax.XLabel,h_ax.YLabel ], format_axis_label);
set([h_ax.Title], format_title);

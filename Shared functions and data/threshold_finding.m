function threshold = threshold_finding(solver, stimulation, cable, output_ctrl)

h_func      = solver.h_func;                    % Function handle of cable solver, e.g., simulate_cable_HH

amp_init   = solver.thresh_find.amp_init;       % Inital search amplitude
factor     = solver.thresh_find.factor;         % Growth factor of search step
amp_th_acc = solver.thresh_find.amp_th_acc;     % Accuracy of search, e.g., 0.2%
amp_l_lim  = solver.thresh_find.amp_init/solver.thresh_find.range; 	% Lower search limit of amplitude 
amp_u_lim  = solver.thresh_find.amp_init*solver.thresh_find.range; 	% Upper search limit of amplitude

plot_options.if_plot = output_ctrl.if_plot;
if output_ctrl.if_plot                  % Two subplots of amplitudes just sub- and supra-threshold
    figure(output_ctrl.h_fig);
    output_ctrl.h_ax_sub = subplot(1,3,1);          % subthreshold plot in 1st subplot
    output_ctrl.h_ax_sup = subplot(1,3,2);          % suprathreshold plot in 2nd subplot
    output_ctrl.h_ax_sim = subplot(1,3,3);          % 3rd subplot for new search
    set([output_ctrl.h_ax_sub, output_ctrl.h_ax_sup, output_ctrl.h_ax_sim ],'Box','on','NextPlot','add','TickLabelInterpreter','latex','LineWidth',1,'FontSize',12,'Color','w');
    set([output_ctrl.h_ax_sub.XLabel, output_ctrl.h_ax_sub.YLabel, output_ctrl.h_ax_sub.Title,...
         output_ctrl.h_ax_sup.XLabel, output_ctrl.h_ax_sup.YLabel, output_ctrl.h_ax_sup.Title,...
         output_ctrl.h_ax_sim.XLabel, output_ctrl.h_ax_sim.YLabel, output_ctrl.h_ax_sim.Title ],'Interpreter','latex','FontSize',12);
    plot_options.h_axis = output_ctrl.h_ax_sim;
end

output_text = {'no AP','AP'};

stimulation.amp = amp_init;     % Set stimulation amplitude
[disp_str, plot_options] = process_units(solver, stimulation, plot_options);    % Process units for displays

sim_exit_flag = h_func(solver, stimulation, cable, plot_options);	% First simulation with initial seach amplitude
write_fun(output_ctrl.log_fid,{sprintf('Initial search with:  \t%s: \t %s.', disp_str, output_text{sim_exit_flag+1})});

threshold =  NaN;
            
flag_limit = 0;
if (~sim_exit_flag)         % No AP on first run, searching for upper bound.
    amp_ub = amp_init;
    disp_str_ub = disp_str;
    while (~sim_exit_flag) && (~flag_limit)     % While threshold not found, and upper search limited not reached
        move_axes(output_ctrl,sim_exit_flag);
        
        amp_lb = amp_ub; disp_str_lb = disp_str_ub; % Set lower bound
        amp_ub = amp_ub * factor;                   % Increase search amplitude
        if abs(amp_ub) >= abs(amp_u_lim)*0.999
            flag_limit = 1;
            write_fun(output_ctrl.log_fid,{'All trials subthreshold. Threshold could not be determined.',' '});
        else
            stimulation.amp = amp_ub;
            [disp_str_ub, plot_options] = process_units(solver, stimulation, plot_options);    % Process units for displays
            sim_exit_flag = h_func(solver, stimulation, cable, plot_options);
            write_fun(output_ctrl.log_fid,{sprintf('Increasing amplitude: \t%s: \t %s.',disp_str_ub,output_text{sim_exit_flag+1})});
        end
    end
else                        % AP on first run, search for lower bound. 
    amp_lb = amp_init;      
    disp_str_lb = disp_str;
    while ( sim_exit_flag) && (~flag_limit)     % While threshold found, and lower search limited not reached
        move_axes(output_ctrl,sim_exit_flag);
        
        amp_ub = amp_lb; disp_str_ub = disp_str_lb;	% Set upper bound
        amp_lb = amp_lb / factor;                   % Decrease search amplitude
        if abs(amp_lb) <= abs(amp_l_lim)*1.001
            flag_limit = 1;
            write_fun(output_ctrl.log_fid,{'All trials suprathreshold. Threshold could not be determined.',' '});
        else
            stimulation.amp = amp_lb;
            [disp_str_lb, plot_options] = process_units(solver, stimulation, plot_options);    % Process units for displays
            sim_exit_flag = h_func(solver, stimulation, cable, plot_options);
            write_fun(output_ctrl.log_fid,{sprintf('Decreasing amplitude: \t%s: \t %s.',disp_str_lb,output_text{sim_exit_flag+1})});
        end
    end
end

if ~flag_limit
    while ( abs( (amp_ub - amp_lb) / amp_ub ) ) >= amp_th_acc 	% Find threshold with amp_th_acc accuracy
        move_axes(output_ctrl,sim_exit_flag);

        amp_mid = sign(amp_ub) * sqrt(abs(amp_ub)*abs(amp_lb));	% Geometric mean

        stimulation.amp = amp_mid;
        [disp_str, plot_options] = process_units(solver, stimulation, plot_options);
        sim_exit_flag = h_func(solver, stimulation, cable, plot_options);
        write_fun(output_ctrl.log_fid,{ [	'Lower bound: ', disp_str_lb,'.   '...
                                            'Upper bound: ', disp_str_ub,'.   '...
                                            'Search amplitude: ', disp_str,': ',output_text{sim_exit_flag+1},'.']});
        if  ~sim_exit_flag
            amp_lb = amp_mid; disp_str_lb = disp_str;
        else
            amp_ub = amp_mid; disp_str_ub = disp_str;
        end
    end
    threshold = amp_ub;

    write_fun(output_ctrl.log_fid,{['Binary search ended. Threshold: ', disp_str,'.']});
    move_axes(output_ctrl,sim_exit_flag);
end
        
if output_ctrl.if_plot
    delete(output_ctrl.h_ax_sim);
    Postion_vec = get(output_ctrl.h_ax_sup,'Position');
    set(output_ctrl.h_ax_sup,'Position',[0.570 Postion_vec(2) 0.335 Postion_vec(4)]);
    Postion_vec = get(output_ctrl.h_ax_sub,'Position');
    set(output_ctrl.h_ax_sub,'Position',[0.130 Postion_vec(2) 0.335 Postion_vec(4)]);
end

end


%%
function [disp_str, plot_options] = process_units(solver, stimulation, plot_options)

amplitude = stimulation.amp * solver.thresh_find.unit_amp;
exp_3 = floor((log10(abs(amplitude))+1)/3);

switch exp_3
    case 0
        unit_prefix = ' ';
    case 1
        unit_prefix = 'k';
    case 2
        unit_prefix = 'M';
    case 3
        unit_prefix = 'G';
    case -1
        unit_prefix = 'm';
    case -2
        unit_prefix = 'u';
    case -3
        unit_prefix = 'n';   
end

scaling = 10^(-exp_3*3) * solver.thresh_find.unit_amp;
unit_str = [unit_prefix, solver.thresh_find.unit_str];

disp_str = sprintf('%2.4f %s', stimulation.amp * scaling, unit_str);

if plot_options.if_plot
    title_str = ['$$',sprintf('%2.4f', stimulation.amp * scaling),'\: \rm{',unit_str,'}$$'];
    ind = find(title_str == 'u');       % Convert u to mu
    for ii = 1:length(ind)
        title_str = [title_str(1:ind(ii)-1), '\mu ',title_str(ind(ii)+1:end)];
        ind(ii+1:end) = ind(ii+1:end) + 3;
    end
    plot_options.title_str = title_str;
end

end

%%
function move_axes(output_ctrl,sim_exit_flag)
if output_ctrl.if_plot
    h_source = output_ctrl.h_ax_sim;
    if sim_exit_flag
        h_target = output_ctrl.h_ax_sup;
    else
        h_target = output_ctrl.h_ax_sub;
    end
    delete(h_target.Children);
    title( h_target, h_source.Title.String, 'Interpreter','latex');
    xlabel(h_target, h_source.XLabel.String,'Interpreter','latex');
    ylabel(h_target, h_source.YLabel.String,'Interpreter','latex');
    set(   h_target, 'XLim', h_source.XLim,...
                     'YLim', h_source.YLim );
                 
    copyobj(h_source.Children, h_target);
    pause(0.000001);
    delete( h_source.Children);
end
end
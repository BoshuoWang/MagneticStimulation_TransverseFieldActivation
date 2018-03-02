function results = main_MS_HH(	mod_prmtr, out_ctrl )
%
% mod_prmtr: structure specifying model parameter:
% model_name        Model: coil_waveform. 'SC_mp', 'SC_hs', 'F8Ca_mp', 'F8Ca_hs', 'F8Cp_mp', 'F8Cp_hs'
% id              	Parameter ID of test case: SC: 1-615, F8Ca: 1-465, F8Cp: 1-615
%
% out_ctrl: structure specifying output control:
% if_save_data   	Whether to save results in a .mat file for each simulation (logical or 0/1)
% if_write_log  	Whether to write threshold finding process in a .txt log (logical or 0/1)
% if_plot         	Whether to plot threshold finding process (logical or 0/1)

%% Logistics
addpath('Shared functions and data');        % Path of shared functions and data

folder_name = [ mod_prmtr.model_name,'_HH'];                % Folder for model, add membrane type to folder name          
create_folders(out_ctrl,folder_name);                       % Create subfolders for data, logs, and figures

out_ctrl.log_fid = 0;                                       % Defaults is to display in MATLAB command window
if out_ctrl.if_write_log                                    % Write in .txt file
    logfilename = fullfile(folder_name,'Logs',['log_',num2str(mod_prmtr.id),'.txt']);	% Log filename
    write_fun( out_ctrl.log_fid,{' ',['Simulation process will be written in: ',logfilename]});
    out_ctrl.log_fid = fopen(logfilename,'w');              % Open log file
end

%% Set parameters for simulation loop
num_sim = 2;                                                % Number of simulations 2
MCE = [0,1];                                                % 1 using conventional cable equation (CE), 1 using modified CE
CE_str = {'CE','MCE'};                                      % Description of CE used

results = struct(   'th_CE',  NaN, ...                      % Default: straigth axon, CE
                    'th_MCE', NaN, 'th_per_diff_MCE', NaN...
                );  
%%  Main loop for simulations
t_main = tic;
[solver, stimulation, cable] = specify_model_MS_HH( mod_prmtr );	% Specify parameters for solver, stimulation, and cable

for ii = 1 : num_sim
    t_th = tic;
    
    solver.is_MCE =  MCE(ii);                                           % Whether to use MCE
    
    if ii == 1
        write_fun( out_ctrl.log_fid, solver.txt.log_txt);              	% Output model specification related text
    elseif ~isnan(results.(['th_',CE_str{1}]))                          % If threshold found for default simulation (ii == 1, straigth axon, CE), search parameters adjusted
        solver.thresh_find.amp_init = results.(['th_',CE_str{1}]) * (0.05 + randn(1) * 0.01);	% Initial search amplitude set to 5% of default threshold
        solver.thresh_find.factor   = (solver.thresh_find.factor)^(1/4);                        % Smaller factor more robust search
    end
        
    write_fun(out_ctrl.log_fid, {'-----------------------------------------------------------',...
                                 ['Solver: ',CE_str{ii}],' '});

    if out_ctrl.if_plot         % Set up figure
        out_ctrl.h_fig = figure('Position',[00 00 1400 800],'Color',[1,1,1]);
        axes('position',[0.05,0.95,0.9,0.00]);box off; axis off;
        title(  [solver.txt.fig_title, CE_str{ii}], 'Interpreter','latex','FontSize',14);
    end
    
    results.(['th_',CE_str{ii}]) = threshold_finding( solver, stimulation, cable, out_ctrl );

    if ii ~= 1                                                  % Percentage difference of threshold compared to default
        if ~isnan(results.(['th_',CE_str{1}]))
            results.(['th_per_diff_',CE_str{ii}]) = ( results.(['th_',CE_str{ii}]) / results.(['th_',CE_str{1}]) - 1) * 100;
            % Positive/negative for higher/lower threshold than default
            if abs( results.(['th_per_diff_',CE_str{ii}])  ) < solver.thresh_find.amp_th_acc * 2 * 100
                results.(['th_per_diff_',CE_str{ii}]) = 0;    % Set difference to zero if less than twice the threshold search accuracy (e.g., for 0.5% accuracy, a difference of 1%)
            end
        elseif ~isnan(results.(['th_',CE_str{ii}]))           % If no threshold obtained for default
            results.(['th_per_diff_',CE_str{ii}]) = -100;     % Then any obtained threshold is 100% less
        end
        write_fun(out_ctrl.log_fid,	{sprintf('Percentage difference: %2.3f %%.', results.(['th_per_diff_',CE_str{ii}]))});    % Write/display results
    end
                      
    if out_ctrl.if_plot                                         % Save and close figures
        figure_filename = fullfile(folder_name,'Figures',['Fig_',num2str(mod_prmtr.id),'_',CE_str{ii},'.fig']);
        saveas(out_ctrl.h_fig,figure_filename,'fig');
        close(out_ctrl.h_fig);
    end
    
    write_fun(out_ctrl.log_fid, {' ',sprintf('Run time for search: %3.2f min.',toc(t_th)/60),' '});
end

%% Saving results and closing files
write_fun( out_ctrl.log_fid,    {'-----------------------------------------------------------',...
                                 sprintf('Total run time: %3.3f min.', toc(t_main)/60)});    % Output run time 
if out_ctrl.if_save_data
    filename = fullfile(folder_name,'Results',['result_',num2str(mod_prmtr.id),'.mat']);
    save(filename,'mod_prmtr', 'results');
    write_fun(out_ctrl.log_fid, {sprintf('Results saved in %s.', filename)});
end
if out_ctrl.if_write_log
    out_ctrl.log_fid = fclose(out_ctrl.log_fid);
end
rmpath('Shared functions and data');
end
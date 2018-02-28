function results = main_MS_RMG(	mod_prmtr, out_ctrl )
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

folder_name = [ mod_prmtr.model_name,'_RMG'];               % Folder for model, add membrane type to folder name          
create_folders(out_ctrl,folder_name);                       % Create subfolders for data, logs, and figures

out_ctrl.log_fid = 0;                                       % Defaults is to display in MATLAB command window
if out_ctrl.if_write_log                                    % Write in .txt file
    logfilename = fullfile(folder_name,'Logs',['log_',num2str(mod_prmtr.id),'.txt']);	% Log filename
    write_fun( out_ctrl.log_fid,{' ',['Simulation process will be written in: ',logfilename]});
    out_ctrl.log_fid = fopen(logfilename,'w');              % Open log file
end

%% Set parameters for simulation loop
num_sim = 5;                                                % Number of simulations 5
suff_str = {'CE','MCE','UA','UF','UAF'};                    % Suffix describing 5 simulations
UND = [0,0,1,2,3];                                          % 2 without undulation (UND=0), 3 with undulation (UND~=0)
axon_str = {    'straight',...                              % Description of axon models
                'straight',...
                'axon undulation',...
                'fiber undulation',...
                'axon and fiber undulation'...
            };
MCE = [0,1,0,0,0];                                          % 4 using conventional cable equation (CE), 1 using modified CE
CE_str = {'CE','MCE','CE','CE','CE'};                       % Description of CE used

results = struct(   'th_CE',  NaN, ...                      % Default: straigth axon, CE
                    'th_MCE', NaN, 'th_per_diff_MCE', NaN,...
                    'th_UA',  NaN, 'th_per_diff_UA',  NaN,...
                    'th_UF',  NaN, 'th_per_diff_UF',  NaN,...
                    'th_UAF', NaN, 'th_per_diff_UAF', NaN...
                );  
%%  Main loop for simulations
t_main = tic;

for ii = 1 : num_sim
    t_th = tic;
    
    mod_prmtr.UND= UND(ii);                                             % Set undulation parameter
    [solver, stimulation, cable] = specify_model_MS_RMG( mod_prmtr );	% Specify parameters for solver, stimulation, and cable
    solver.is_MCE =  MCE(ii);                                           % Whether to use MCE
    
    if ii == 1
        write_fun( out_ctrl.log_fid, solver.txt.log_txt);              	% Output model specification related text
    elseif ~isnan(results.(['th_',suff_str{1}]) )                       % If threshold found for default simulation (ii == 1, straigth axon, CE), search parameters adjusted
        solver.thresh_find.amp_init = results.(['th_',suff_str{1}]) * (0.1 + randn(1) * 0.01);  % Initial search amplitude set to 10% of default threshold
        solver.thresh_find.factor   = sqrt(solver.thresh_find.factor);                          % Smaller factor for faster convergence in binary search
    elseif ~isnan(results.(['th_',suff_str{2}]) )           % If threshold found for MCE simulation (ii == 2), search parameters adjusted
        solver.thresh_find.amp_init = results.(['th_',suff_str{2}]) * (0.1 + randn(1) * 0.01);  % Initial search amplitude set to 10% of default threshold
        solver.thresh_find.factor   = sqrt(solver.thresh_find.factor);                          % Smaller factor for faster convergence in binary search
    end
        
    write_fun(out_ctrl.log_fid, {'-----------------------------------------------------------',...
                                 ['Nerve fiber: ',axon_str{ii},'. Solver: ',CE_str{ii}],' '});

    if out_ctrl.if_plot         % Set up figure
        out_ctrl.h_fig = figure('Position',[00 00 1400 800],'Color',[1,1,1]);
        axes('position',[0.05,0.95,0.9,0.00]);box off; axis off;
        title(  [solver.txt.fig_title, axon_str{ii},'; ',CE_str{ii}], 'Interpreter','latex','FontSize',14);
    end
    
    results.(['th_',suff_str{ii}]) = threshold_finding( solver, stimulation, cable, out_ctrl );

    if ii ~= 1                                                  % Percentage difference of threshold compared to default
        if ~isnan(results.(['th_',suff_str{1}]))
            results.(['th_per_diff_',suff_str{ii}]) = ( results.(['th_',suff_str{ii}]) / results.(['th_',suff_str{1}]) - 1) * 100;
            % Positive/negative for higher/lower threshold than default
            if abs( results.(['th_per_diff_',suff_str{ii}])  ) < solver.thresh_find.amp_th_acc * 2 * 100
                results.(['th_per_diff_',suff_str{ii}]) = 0;    % Set difference to zero if less than twice the threshold search accuracy (e.g., for 0.5% accuracy, a difference of 1%)
            end
        elseif ~isnan(results.(['th_',suff_str{ii}]))           % If no threshold obtained for default
            results.(['th_per_diff_',suff_str{ii}]) = -100;     % Then any obtained threshold is 100% less
        end
        write_fun(out_ctrl.log_fid,	{sprintf('Percentage difference: %2.3f %%.', results.(['th_per_diff_',suff_str{ii}]))});    % Write/display results
    end
                      
    if out_ctrl.if_plot                                         % Save and close figures
        figure_filename = fullfile(folder_name,'Figures',['Fig_',num2str(mod_prmtr.id),'_',suff_str{ii},'.fig']);
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
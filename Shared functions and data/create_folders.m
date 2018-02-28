function create_folders(out_ctrl, folder_name)

% Create subfolder for saving data, if not already exist
if out_ctrl.if_save_data 
    subfoldername = fullfile(folder_name,'Results');
    if ~exist(subfoldername,'dir')
        mkdir(subfoldername);
    end
end

% Create subfolder for logs, if not already exist
if out_ctrl.if_write_log 
    subfoldername = fullfile(folder_name,'Logs');
    if ~exist(subfoldername,'dir')
        mkdir(subfoldername);      
    end
end

% Create subfolder for figures, if not already exist
if out_ctrl.if_plot 
    subfoldername = fullfile(folder_name,'Figures');
    if ~exist(subfoldername, 'dir')
        mkdir(subfoldername);
    end
end

end
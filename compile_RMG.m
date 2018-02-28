coil_type =     { 'SC', 'F8Ca', 'F8Cp'};
parameter_no =  [ 615,  465,    615 ];

dX = 0.25;                  % Steps in X direction, 2.5 mm in cm;
dY = dX;

N_coil = [21, 14, 14];
R_coil = [10, 8,  8 ] * dX;

Y_vec= -(0.5 : dY : 4);     % Vertical distance between nerve from coil: 0.5 to 4 cm 15 parameters
X_vec = {( -R_coil(1) * 2 : dX : R_coil(1) * 2),...
         ( 0 : dX : R_coil(2) * 3.75),...
         (-R_coil(3) * 2.5 : dX : R_coil(3) * 2.5)};

wvf = {'mp','hs'};
axon = {'HH','RMG'};

for ii = 1: length(coil_type)
    [XX,YY] = ndgrid(X_vec{ii},Y_vec);      % Full grid of nerve placement locations
    NaN_matrix = NaN(size(XX));
    for jj = 1: length(wvf)
        %% RMG
        
        model_name = [coil_type{ii},'_',wvf{jj},'_',axon{2}];
        compiled_results = struct(  'model',model_name,...
                                    'R_coil',R_coil(ii),'N_coil',N_coil(ii),...
                                    'XX',XX,'YY',YY,...
                                    'parameter_id',NaN_matrix,...
                                    'th_CE',  NaN_matrix, ...                      % Default: straigth axon, CE
                                    'th_MCE', NaN_matrix, 'th_per_diff_MCE', NaN_matrix,...
                                    'th_UA',  NaN_matrix, 'th_per_diff_UA',  NaN_matrix,...
                                    'th_UF',  NaN_matrix, 'th_per_diff_UF',  NaN_matrix,...
                                    'th_UAF', NaN_matrix, 'th_per_diff_UAF', NaN_matrix );
        if exist([model_name,'/Results'],'dir') ==  0
            error('LoadConvertDataFromCluster:NoDataFromClusterParameters','Data folder does not exist for given parameters.');
        end
        for kk = 1:numel(XX)
            filename = fullfile(model_name,'Results',['result_',num2str(kk),'.mat']);
            if exist(filename,'file') > 0
                load(filename,'mod_prmtr', 'results');

                parameter_id = mod_prmtr.id;
                compiled_results.parameter_id(parameter_id)    	= parameter_id;
                compiled_results.th_CE(parameter_id)            = results.th_CE;
                compiled_results.th_MCE(parameter_id)           = results.th_MCE;
                compiled_results.th_per_diff_MCE(parameter_id)  = results.th_per_diff_MCE;
                compiled_results.th_UA(parameter_id)            = results.th_UA;
                compiled_results.th_per_diff_UA(parameter_id)   = results.th_per_diff_UA;
                compiled_results.th_UF(parameter_id)            = results.th_UF;
                compiled_results.th_per_diff_UF(parameter_id)   = results.th_per_diff_UF;
                compiled_results.th_UAF(parameter_id)           = results.th_UAF;
                compiled_results.th_per_diff_UAF(parameter_id)  = results.th_per_diff_UAF;
            else
                disp(['File does not exist:',filename]);
            end
        end
        
        filename = fullfile(model_name,[model_name,'_compiled_result.mat']);
        save(filename,'compiled_results');
        disp(['Compiled ', model_name,'.']);
    end
end

plot_MS_RMG_combined;
plot_MS_RMG_UND_combined;
function [solver, stimulation, cable] = specify_model_MS_HH(modprmtr)
%% Model parameter: axon placement, waveform
dX = 0.25;                  % Steps in X direction, 2.5 mm in cm;
dY = dX;
Y_vec= -(0.5 : dY : 4);     % Vertical distance between nerve from coil: 0.5 to 4 cm 15 parameters
    
if strncmp(modprmtr.model_name,'SC_',3)                  % Single coil
    num_windings = 1;
    N_coil = 21;                    % Number of coil windings
    R_coil = 10 * dX;               % Coil radius in cm, coil diameter 5 cm = 50 mm
    min_length = R_coil * 6;        % Minimum axon length in either direction in cm, 15 cm
    X_vec = -R_coil * 2 : dX : R_coil * 2;
    % Axon placement in horizontal plane; -5 cm to 5 cm, 41 parameters
    % Total parameters: 615 = 41 * 15
    coil_shift = 0;                 % Coil shift
    coil_orientation = 0 * pi/180;  % Coil rotation
    coil_str = 'Circular coil';
    str_ind = 4;                    % Start location of waveform in model string
elseif strncmp(modprmtr.model_name,'F8C',3)             % Figure-8 coil
        num_windings = 2;    
        N_coil = 14;                % Number of coil windings
        R_coil = 8 * dX;            % Coil radius in cm, coil diameter 4 cm = 40 mm
        coil_shift = R_coil;
        if strncmp(modprmtr.model_name,'F8Ca_',5)    	% Aligned figure-8 coil
            min_length = R_coil * 7;                    % Minimum axon length in either direction in cm, 14 cm
            X_vec = 0 : dX : R_coil * 3.75;
            % Axon placement in horizontal plane; 0 to 7.5 cm, 31 parameters
            % Total parameters: 465 = 31 * 15
            coil_orientation = 0 * pi/180;              % Coil rotation
            coil_str = 'Figure-8 coil - aligned';       
        elseif strncmp(modprmtr.model_name,'F8Cp_',5) 	% Perpendicular figure-8 coil
            min_length = R_coil * 8;                    % Minimum axon length in either direction in cm, 16 cm
            X_vec = -R_coil * 2.5 : dX : R_coil * 2.5;
            % Axon placement in horizontal plane; -5 to 5 cm, 41 parameters
            % Total parameters: 615 = 41 * 15
            coil_orientation = 90 * pi/180;             % Coil rotation
            coil_str = 'Figure-8 coil - perpendicular';
        end
        str_ind = 6;                % Start location of waveform in model string
end

[XX,YY] = ndgrid(X_vec,Y_vec);      % Full grid of nerve placement locations
X = XX(modprmtr.id);                % Lateral placement given by parameter id
Y = YY(modprmtr.id);                % Vertical placement given by parameter id

modprmtr.wvf = modprmtr.model_name(str_ind:end);     % Waveform string: mp, monophasic; hs, half-sine; bp, biphasic

if strcmp(modprmtr.wvf,'mp')
    wvf_str = 'Monophasic';
elseif strcmp(modprmtr.wvf,'hs')
    wvf_str = 'Half-sine';
elseif strcmp(modprmtr.wvf,'bp')
    wvf_str = 'Biphasic';
end
% switch modprmtr.wvf
%     case "mp"
%         wvf_str = 'Monophasic';
%     case "hs"
%         wvf_str = 'Half-sine';
%     case "bp"
%         wvf_str = 'Biphasic';
% end

solver.txt.log_txt = {  sprintf('Coil type: \t%s',coil_str),...
                        sprintf('Waveform: \t%s',wvf_str)...
                        sprintf('Parameter ID:\t%d',modprmtr.id), ...
                        sprintf('Lateral axon-coil distance:\t %2.1f mm',X*10), ...
                        sprintf('Vertical axon-coil distance:\t %2.1f mm',abs(Y)*10)};
solver.txt.fig_title = [coil_str,'; ',...
                        wvf_str,'; ',...
                        'Parameter ID: $$',num2str(modprmtr.id,'%d'),'$$; ',...
                        '$$X=', num2str(X*10,'%3.1f'),'\: \rm{mm}$$; ',...
                        '$$Y=', num2str(Y*10,'%3.1f'),'\: \rm{mm}$$; '];

%% Cellular parameters
% Specific to C & PS model (Roth & Basser 1990; Schnabel & Johannes, 2001;
% Neu, 2016a,b)
T = 23.5;       % degree Celcius; Roth & Basser 1990: 18.5 C

% Conductivities of extra- and intra-cellular spaces
sigma_i = 28.2 ;            % Intracellular conductivity, in mS/cm;
% sigma_e = 10;               % Extracellular conductivity, in mS/cm;

R_a = 3e-4;              % Axon radius, in cm; 3 um radius
c_m = 1;                    % Membrane capacitance, uF/cm^2
% Cellular time constant for cylindrical cell is 13.55 ns per um in radius;
% tau_c = R * c_m * (sigma_i^-1 + sigma_e^-1)
% 3 um radius, tau_c =  40.6 ns; 
% 0.1 us = 2.5*tau_c    ->  reaching 91.8% of IP
% 0.2 us = 5 tau_c      ->  reaching 99.3% of IP

% HH parameters: original Hodgkin-Huxley
V_rest = -70;   % mV; Roth & Basser 1990: -65 mV; Cartee 2000, Rattay & Aberham 1993: -70 mV
E_Na = V_rest + 115;        g_Na = 120;     % mV & mS/cm^2;
E_K  = V_rest - 12;         g_K  = 36;   
E_L  = V_rest + 10.6;       g_L  = 0.3;    
% g_bar = 0.6773 mS/cm^2 at rest -> r_m = 1.476 kOhm*cm^2 
% NOTE early simulations had V_rest = -70.156 due to setting E_L = -60, 
% while it should be E_L =-59.4 

% Calculated parameters
freq = 100e-3;          % 100 Hz in kHz
lambda_100 = sqrt(R_a * sigma_i / (2*pi*freq*c_m) /2);  % in cm; NOTE: NEURON has lambda_f a sqrt(2) times larger
d_lambda = 0.1;                     % Interval is determined by d_lambda rule
dz = lambda_100 * d_lambda;
% For R = 3um, lambda100 = 820.5 um
% d_lambda = 0.3 -> dz = 246.2 um; d_lambda = 0.1 -> dz = 82.1 um

% Emperical parameters from simulation
v = 0.2335;                   % cm/ms; conduction speed 2.335 mm/ms


%% Specify cable
N_theta = 15;               % Discretization of azimuthal angle
d_theta =  pi / N_theta;    % Interval for integration, in radian
theta = linspace( d_theta/2, pi - d_theta/2, N_theta );         % Integration points between 0 and pi, row vector

N_comp = ceil(min_length/dz) * 2 + 1;

axon_length = dz * ceil(min_length/dz);    % axon length rounded
z = linspace( -axon_length, axon_length, N_comp )';
% Axial coordinates, in cm. Row vector

R_i = dz / (sigma_i*pi*R_a^2);       % Axial resistance between nodes, in kOhm
Area = 2 * pi * R_a * dz;        % Element area; cm^2
C_m = c_m * Area;                   % Node membrane capacitance, in uF
ones_A = ones(N_comp, 1);                     % Column vector; empty array
TP_weight = ones(N_comp, N_theta) * d_theta / pi;
cable = struct( 'N_comp',N_comp,...         % Number of compartments
                'z',z,...                   % Center coordinates of compartment, cm (along local longitudinal axis)
                'dz',dz * ones_A,...        % Compartment length, cm
                'R', R_a * ones_A,...       % Compartment radius, cm
                'R_i',R_i * ones_A,...      % Compartment axial resistance, kOhm
                'R_i_left',R_i * ones_A,... % Axial resistance to left neighbor, kOhm
                'R_i_right',R_i * ones_A,...% Axial resistance to right neighbor, kOhm
                'Area',Area * ones_A,...    % Compartment Area, cm^2
                'C_m',C_m * ones_A,...      % Compartment capacitance, uF
                'TP_dim', ones_A,...        % Dimension: 1 for cylindrical; 2 for sphercial
                'TP_weight',TP_weight...    % Integration weights, row vector for each node
                );

cable.z_ind_no_act = [1,N_comp];                            % Force activation term to zero at two terminals
z_ind_AP = N_comp;                                         	% Location for AP to reach for detection, terminal
z_prop = abs(max(cable.z) - min(cable.z));                  % Maximum propagation distance of AP 

% Axial resistance; sealed ends are reflected by d_phi_e_left/right = 0 at terminals
cable.R_i_left(1) = inf; 
cable.R_i_left(2:end)    = ( cable.R_i(1:end-1) + cable.R_i(2:end))/2;
cable.R_i_right(1:end-1) = ( cable.R_i(1:end-1) + cable.R_i(2:end))/2;
cable.R_i_right(end) = inf; 

% Biophysics of cable
cable.V_rest = V_rest;

% Ion channels
cable.E_Na = E_Na;
cable.E_K  = E_K;
cable.E_L  = E_L;

cable.g_Na = g_Na;
cable.g_K  = g_K;
cable.g_L  = g_L;

x = X;                    % Global coordinates of cable compartments  
z = cable.z;              % Global coordinates of cable compartments 

%% E-field at cable (see Basser 1994, Focal Magnetic Stimulation of an Axon, IEEE TBME)
mu_0 = 4*pi*1e-7;           % in H/m = N/A^2 = T*m/A = Wb/(A*m) = V*s/(A*m)
mu_0 = mu_0*1e-2;           % convert units to mV*ms/(uA*cm)
dI_dt = 10^9;               % Basic rate of change of coil current, 1 A/us in uA/ms, 

cur_sign = [1, -1];
Ex = ones_A * 0;
Ez = ones_A * 0;
for ii = 1 : num_windings
    % Coordinate system in Basser 1994 uses different coordinate system. 
    % For E-field calculation, a coil-centered coordinate system is used, with
    % z axis vertical through center of circular windings, x axis aligned with
    % the axon, y axis transverse. 
    [PHI_z, THETA_z, R_z] = cart2sph(   z + cur_sign(ii) * coil_shift * sin(coil_orientation),...
                                        x + cur_sign(ii) * coil_shift * cos(coil_orientation), Y );  % spherical coordinates with polar angle measured from the y axis
    THETA_z = pi/2-THETA_z; 	% cart2sph gives elevation, NOT polar angle
    sin_theta = sin(THETA_z); 	sin_theta(abs(sin_theta) < eps) = 0;
    sin_phi = sin(PHI_z);       sin_phi(abs(sin_phi) < eps) = 0;
    cos_phi = cos(PHI_z);       cos_phi(abs(cos_phi) < eps) = 0;
    R_sin_2 =  R_coil^2 + R_z.^2 + 2* R_coil * R_z .* sin_theta;    % cm^2
    k_2 =  4* R_coil * R_z .* sin_theta ./ R_sin_2 ;    % unitless, Eq. 5 of Basser 1994
    [KK,EE] = ellipke(k_2,eps);                         % unitless, completed elliptic integrals of the 1st and 2nd kind

    E_phi = mu_0 / pi * (- cur_sign(ii) * dI_dt) * N_coil * R_coil ./ ...              % Eq. 4 of Basser 1994
                sqrt(R_sin_2) .* ( 2* ( KK - EE ) ./ (k_2)  - KK );    % in mV/cm
    E_phi(abs(sin_theta) < eps) = 0;

    % Total field
    Ex = Ex + E_phi .*  cos_phi;        % mV/cm, transverse component of E-field
    Ez = Ez + E_phi .* -sin_phi;        % mV/cm, axial component of E-field
end


d_phi_e = - Ez .* cable.dz;          	% Pseudo-potenial drops, in mV

stimulation.d_phi_e_left =  [ 0 ; ( d_phi_e(2:end) + d_phi_e(1:end-1) )/2 ];    % Finite difference in potenial, in mV
stimulation.d_phi_e_right = [ ( d_phi_e(1:end-1) + d_phi_e(2:end) )/2 ; 0 ];    % Finite difference in potenial, in mV

stimulation.ER_TP = kron(   ( 1 + 1 ./ cable.TP_dim ) .* abs( Ex ) .*...
                             cable.R , cos(theta)  );

%% Time and stimulation waveform
dt = 5e-3;              % Time step 5 us, in ms
t_before = 10e-3;       % Time before pulse onset
t_after = round( (5 + z_prop / v) /dt ) * dt;   % Time after pulse onset, ~5 ms for AP initiation + AP propagation

[solver.t_vec, stimulation.pulse_shape, stimulation.PW] = TMS_wave(modprmtr.wvf, dt, t_before, t_after);
plot_t_intv = [0.5:0.5:1.5,2.5:2.5:10,15:5:solver.t_vec(end)];               % plot interval 0.5 ms, 2.5 ms, and 5 ms

%% Solver related parameters
solver.n_theta = N_theta;
solver.Temp = T;
solver.V_init = V_rest;
solver.h_func = str2func('simulate_cable_HH');

solver.thresh_find.unit_str = 'A/us';	% Display unit
solver.thresh_find.unit_amp = 1;        % Conversion ratio to display unit

% Set initial search amplitude 
amp_init = 10e3;    % 10000 A/us; 10 kA/us, 1 MA in 0.1 ms
th_acc = 0.5e-2;    % 0.5%, accuracy of threshold finding
factor = 2;         % Factor for increase/decreasing search amplitude
range = 10^3;       % Find threshold within 3 order of magnitudes from initial value

solver.thresh_find.amp_init = amp_init;
solver.thresh_find.amp_th_acc = th_acc;
solver.thresh_find.factor = factor;
solver.thresh_find.range = range; 
        
solver.thresh_find.phi_AP = -10;        % mV; threshold definition, phi_m to cross -10
solver.thresh_find.z_ind_AP = z_ind_AP;
solver.plot_t_intv = plot_t_intv;           

end
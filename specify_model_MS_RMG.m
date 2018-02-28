function [solver, stimulation, cable] = specify_model_MS_RMG(modprmtr)
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
% Richardson, McIntyre & Grill 2000 (RMG)
T = 37;                     % Temperature, Degree Celcius

% Conductivities of intra- and extra-cellular spaces
sigma_i = 1/0.07;           % Intracellular conductivity, in mS/cm; resistivity: 70 Ohm*cm = 0.07 kOhm*cm
% sigma_e = 1/0.5;            % Extracellular conductivity, in mS/cm; resistivity: 500 Ohm*cm = 0.5 kOhm*cm

% Nodal membrane parameters
R_n = 1.65e-4;              % Nodal radius, in cm; 3.3 um diameter
c_n = 2;                    % Nodal membrane capacitance, in uF/cm^2
l_n = 1e-4;                 % Nodal length, in cm; 1 um
% "Cellular" time constant for cylindrical nodal segment
% tau_c = R_n * c_n * (sigma_i^-1 + sigma_e^-1) = 188.1 ns
% 3 * tau_c = 0.56 us  ->  reaching 95.0% of steady state TP
% 5 * tau_c = 0.94 us  ->  reaching 99.3% of steady state TP

% Ion channel parameters for nodes, in mV & mS/cm^2;
V_rest = -82;                       % in MRG 2002: -80;
E_Na = 50;        g_Na = 3000;      g_Nap = 5;  % fast & persistent Na
E_K  = -84;       g_K  = 80;        % Slow K
E_L  = -83.38;    g_L  = 80;        % Leakage
% g_bar = 104.3 mS/cm^2 at rest -> r_m = 0.0096 kOhm*cm^2
% tau_n = 19.2 us

% Internodal membrane parameters
R_in = 3e-4;                % Internodal axon radius, in cm; 6 um fiber diameter (10 um diameter including myelin)
N_lamella = 120;            % 120 myelin lamella; 2 membranes per lamella
c_in = 0.1/2/N_lamella;     % Internodal total myelin capacitance, in uF/cm^2
g_in = 1/2/N_lamella;       % Internodal total myelin conductance, in mS*cm^2
L_in = 1150e-4;             % Internodal length, in cm; 1150 um
if ~modprmtr.UND
    N_in = 10;             	% 10 compartments per internode (default for straight fiber)
else
    N_in = 100;             % 100 compartments per internode for undulating fiber
    min_node_uni_str = ceil( (min_length - l_n/2)/(l_n + L_in) );       % Minimum number of nodes in either direction (excluding middle) without extension of length
    min_length = min_length * 1.2;      % Increase length by 20%  
end
l_in = L_in / N_in;         % Internodal compartment length, in cm

% Emperical parameters from simulation/RMG paper
v = 6.1;                    % cm/ms; conduction speed 61 m/s = 6.1 cm/ms from RMG paper

%% Specify cable
N_theta = 15;               % Discretization of azimuthal angle
d_theta =  pi / N_theta;    % Interval for integration, in radian
theta = linspace( d_theta/2, pi - d_theta/2, N_theta );         % Integration points between 0 and pi, row vector

min_node_uni = ceil( (min_length - l_n/2)/(l_n + L_in) );       % Minimum number of nodes in either direction (excluding middle)
N_node = min_node_uni * 2 + 1;              % Number of nodal compartments
N_comp = N_node + (N_node - 1)* N_in;       % Number of all compartments

Empty_N = zeros(N_node,1);              % Column vector; empty array
Empty_th = zeros(N_node,N_theta);       % Column vector expanded; empty array
node = struct(  'cable_ID',Empty_N,...  % the index of the node within the entire cable
                'TP_dim',Empty_N,...    % Dimension: 1 for cylindrical; 2 for sphercial
                'TP_weight',Empty_th... % Integration weights, row vector for each node
              );
Empty_C = zeros(N_comp, 1);             % Column vector; empty array
cable = struct( 'N_comp',N_comp,...     % Number of compartments
                'z',Empty_C,...         % Center coordinates of compartment, cm (along local longitudinal axis)
                'dz',Empty_C,...        % Compartment length, cm
                'R',Empty_C,...         % Compartment radius, cm
                'R_i',Empty_C,...       % Compartment axial resistance, kOhm
                'R_i_left',Empty_C,...  % Axial resistance to left neighbor, kOhm
                'R_i_right',Empty_C,... % Axial resistance to right neighbor, kOhm
                'Area',Empty_C,...      % Compartment Area, cm^2
                'C_m',Empty_C,...       % Compartment capacitance, uF
                'is_node',Empty_C,...   % Is compartment a node? logical 0/1
                'N_nodes',N_node,...    % Number of nodes
                'node',node...          % Nodal data
              );       

z_in_rel = l_in * ( (1:N_in) - 0.5 );
% Relavtive axial coordinates of the center of N_in internodal compartments
% within one internode from its left end

for ii = 1 : min_node_uni *2 + 1      % Add node and internode
    % 1 nodal compartments
    ind_n = (1 + N_in) * (ii-1) + 1;                        % Index of compartment in the cable: (ii-1) nodes and internodes to the left
    cable.z(ind_n) = (l_n + L_in) * (ii-1) + l_n/2;         % Center coordinates of compartment, cm
    cable.dz(ind_n) = l_n;                                  % Compartment's length, in cm
    cable.R(ind_n) = R_n;                                   % Compartment's radius, in cm
    cable.R_i(ind_n) = l_n / (sigma_i * pi * R_n^2);        % Compartment's axial resistance, in kOhm
    cable.Area(ind_n) = 2 * pi * R_n * l_n;                 % Compartment's area; cm^2
    cable.C_m(ind_n) = c_n * 2 * pi * R_n * l_n;            % Compartment's membrane capacitance, in uF
    cable.is_node(ind_n) = true;                            % Compartment is node
        cable.node.cable_ID(ii) = ind_n;                    % The index of the node within the entire cable
        cable.node.TP_dim(ii) = 1;                          % Dimension parameter for cylindrical compartments is 1
        cable.node.TP_weight(ii,:) = d_theta / pi;          % Each patch of the membrane is only a fraction of the total area
    if ii == min_node_uni *2 + 1 
        break                                               % No internode after last nodal compartment
    end
    
    % N_in internodal compartments
    ind_in = ii + N_in * (ii-1) + (1:N_in);                 % Index of compartments in the cable: ii nodes and  (ii-1) internodes to the left
    cable.z(ind_in) = l_n * ii + L_in * (ii-1) + z_in_rel;  % Center coordinates of compartments, cm
    cable.dz(ind_in) = l_in;                                % Compartments' length, in cm
    cable.R(ind_in) = R_in;                                 % Compartments' radius, in cm
    cable.R_i(ind_in) = l_in / (sigma_i * pi * R_in^2);     % Compartments' axial resistance, in kOhm
    cable.Area(ind_in) = 2 * pi * R_in * l_in;              % Compartments' area; cm^2
    cable.C_m(ind_in) = c_in * 2 * pi * R_in * l_in;        % Compartments' membrane capacitance, in uF
    cable.is_node(ind_in) = false;                          % Compartments are internode
end

cable.z = cable.z - (min_node_uni * (l_n + L_in) + l_n/2); 	% Shift origin of coordinates to middle
cable.z_ind_no_act = [1,N_comp];                            % Force activation term to zero at two terminals
z_ind_AP = N_comp;                                         	% Location for AP to reach for detection, terminal
z_prop = abs(max(cable.z) - min(cable.z));                  % Maximum propagation distance of AP 

if modprmtr.UND
    cable.Area([1,N_comp]) = cable.Area([1,N_comp]) * 100;  % Compartment's area; cm^2. Increase surface area by 100 to reduce polarization near terminal due to undulation
    cable.C_m([1,N_comp])  = c_n * cable.Area([1,N_comp]); 	% Compartment's membrane capacitance, in uF    
    z_ind_AP = N_comp - (min_node_uni - min_node_uni_str) * (N_in+1);	% Location for AP to reach for detection, at same location as straigth axons
end 

% Axial resistance; sealed ends are reflected by d_phi_e_left/right = 0 at terminals
cable.R_i_left(1) = inf; 
cable.R_i_left(2:end)    = ( cable.R_i(1:end-1) + cable.R_i(2:end))/2;
cable.R_i_right(1:end-1) = ( cable.R_i(1:end-1) + cable.R_i(2:end))/2;
cable.R_i_right(end) = inf; 

% Biophysics of cable
cable.V_rest = V_rest;
cable.g_in = g_in;

% Nodal ion channels
cable.node.E_Na = E_Na;
cable.node.E_K  = E_K;
cable.node.E_L  = E_L;

cable.node.g_Na = g_Na;
cable.node.g_Nap = g_Nap;
cable.node.g_K  = g_K;
cable.node.g_L  = g_L;

% Undulation parameters
lambda_a = 0.2e-1;              % Wavelength of axonal undulation, 0.2 mm in cm
k_a = 2*pi/lambda_a;            % Wavenumber, in rad * cm^-1

lambda_f = 5;                   % Wavelength of fascicle undulation, 5 cm
k_f = 2*pi/lambda_f;            % Wavenumber,in rad * cm^-1

if modprmtr.UND
    switch modprmtr.UND
        case 1                  % Only axon undulation
            A_a = 40e-4;        % Amplitude of axon undulation,     40 um in cm
            A_f = 0.0e-1;       % Amplitude of fascicle undulation, 0.0 mm in cm
        case 2                  % Only fasicle undulation
            A_a = 00e-4;        % Amplitude of axon undulation,     00 um in cm
            A_f = 0.8e-1;       % Amplitude of fascicle undulation, 0.8 mm in cm
        case 3                  % Axon and fascicle undulation
            A_a = 40e-4;        % Amplitude of axon undulation,     40 um in cm
            A_f = 0.8e-1;       % Amplitude of fascicle undulation, 0.8 mm in cm
    end
    % Undulation function for interpolation of cable's compartments
    dz_str = lambda_a/100;     % Step size  nerve trunk, 2 um in cm
    z_str = (floor(min(cable.z)/dz_str) : ceil(max(cable.z)/dz_str)) * dz_str;  % Coordinates along nerve trunk, long enough to cover undulating axon
    dx_dz_str = k_a * A_a * cos(k_a * z_str) + k_f * A_f * cos(k_f * z_str);        % Slope of undulation function
    ds = sqrt( 1 + dx_dz_str.^2 )*dz_str;                                           % Length of local arc segment
    s = ds(1)/2 + cumsum([0,(ds(1:end-1)/2 + ds(2:end)/2)]);                    % Cummulative arc length from left end
    s = s - median(s);                                                          % Arc length from center
    
    % Interpolate to convert local longitudinal coordinate (cable.z) of undulating axon to the longitudinal coordinate along the nerve
    z_n = interp1(s, z_str, cable.z, 'spline');                                 % Global coordinates of cable compartments along the nerve
    x_n = X +        A_a * sin(k_a * z_n) +       A_f * sin(k_f * z_n);         % Global coordinates of cable compartments  
    dx_dz =    k_a * A_a * cos(k_a * z_n) + k_f * A_f * cos(k_f * z_n);         % Slope of undulation
    alpha_und = atan(dx_dz);                                                    % Angle between local and global coordinate system
else
    x_n = X;                    % Global coordinates of cable compartments  
    z_n = cable.z;              % Global coordinates of cable compartments 
end

%% E-field at cable (see Basser 1994, Focal Magnetic Stimulation of an Axon, IEEE TBME)
mu_0 = 4*pi*1e-7;           % in H/m = N/A^2 = T*m/A = Wb/(A*m) = V*s/(A*m)
mu_0 = mu_0*1e-2;           % convert units to mV*ms/(uA*cm)
dI_dt = 10^9;               % Basic rate of change of coil current, 1 A/us in uA/ms, 

cur_sign = [1, -1];
Ex = Empty_C;
Ez = Empty_C;
for ii = 1 : num_windings
    % Coordinate system in Basser 1994 uses different coordinate system. 
    % For E-field calculation, a coil-centered coordinate system is used, with
    % z axis vertical through center of circular windings, x axis aligned with
    % the axon, y axis transverse. 
    [PHI_z, THETA_z, R_z] = cart2sph(   z_n + cur_sign(ii) * coil_shift * sin(coil_orientation),...
                                        x_n + cur_sign(ii) * coil_shift * cos(coil_orientation), Y );  % spherical coordinates with polar angle measured from the y axis
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

if modprmtr.UND == 1
    % Converting to local E-field components
    Ex_n = Ex .* cos(alpha_und) - Ez .* sin(alpha_und);
    Ez_n = Ex .* sin(alpha_und) + Ez .* cos(alpha_und);
else
    Ex_n = Ex;
    Ez_n = Ez;
end

d_phi_e = - Ez_n .* cable.dz;          	% Pseudo-potenial drops, in mV

stimulation.d_phi_e_left =  [ 0 ; ( d_phi_e(2:end) + d_phi_e(1:end-1) )/2 ];    % Finite difference in potenial, in mV
stimulation.d_phi_e_right = [ ( d_phi_e(1:end-1) + d_phi_e(2:end) )/2 ; 0 ];    % Finite difference in potenial, in mV

stimulation.ER_TP = kron(   ( 1 + 1 ./ cable.node.TP_dim ) .* abs( Ex_n(cable.node.cable_ID) ) .*...
                             cable.R( cable.node.cable_ID ) , cos(theta)  );

%% Time and stimulation waveform
dt = 2e-3;              % Time step 2 us, in ms
t_before = 10e-3;       % Time before pulse onset
t_after = round( (1 + z_prop / v) /dt ) * dt;   % Time after pulse onset, ~1 ms for AP initiation + AP propagation

[solver.t_vec, stimulation.pulse_shape, stimulation.PW] = TMS_wave(modprmtr.wvf, dt, t_before, t_after);
plot_t_intv = [0.05:0.05:0.15,0.25:0.25:1,1.5:0.5:solver.t_vec(end)];               % plot interval, 50 us, 0.25 ms us and 0.5 ms

%% Solver related parameters
solver.n_theta = N_theta;
solver.Temp = T;
solver.V_init = V_rest;
solver.h_func = str2func('simulate_cable_RMG');

solver.thresh_find.unit_str = 'A/us';	% Display unit
solver.thresh_find.unit_amp = 1;        % Conversion ratio to display unit

% Set initial search amplitude 
amp_init = 100;     % 100 A/us;  10 kA in 0.1 ms
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
function  [exit_flag, t_end] = simulate_cable_RMG(solver, stimulation, cable, plot_options)

% Convention of units
% mV = ms * uA / uF ;
% uA = mS * mV;
% mV = kOhm * uA;
% cm

exit_flag = 0;

%% Parameters set up
%%% Solver related
is_MCE = solver.is_MCE;     % Whether to use modified CE

t  = solver.t_vec;          % Simulation time (row vector, len_t)
dt = [0, diff(t)];          % Simulation time step (row vector, len_t)
len_t = length(t);
t_end = t(end);

T = solver.Temp;            % temperature
V_init = solver.V_init;     % Initial potential

z_ind_AP = solver.thresh_find.z_ind_AP;     % Location for AP detection 
phi_AP   = solver.thresh_find.phi_AP;       % Threshold for AP detection, in mV

%%% Stimulation related
pulse_shape = stimulation.pulse_shape * stimulation.amp;
% pulse shape (normalized) times amplitude (row vector, [1*len_t])

d_phi_e_left  = stimulation.d_phi_e_left;
d_phi_e_right = stimulation.d_phi_e_right;
% Difference of extracellular potential (column vector)

%%% Cable parameters
N_comp = cable.N_comp;          % Total number of compartments

z    = cable.z;                 % Cable's longitudinal coordinates (local, arc length)

Area = cable.Area;              % surface area oof each segment (column vector, len_z);
C_m  = cable.C_m;               % membrane capacitance at each segment in uF (column vector)

R_i_left = cable.R_i_left;    	% Axial resistance to left neighbor (column vector);
R_i_right = cable.R_i_right;   	% Axial resistance to right neighbor (column vector);

V_rest = cable.V_rest;          % Resting potential, in mV
g_in   = cable.g_in;            % Internodal conductance, in mS/cm^2

N_nodes = cable.N_nodes;        % Number of nodes
cable_ID = cable.node.cable_ID; % ID/index of nodes within the cable

E_Na = cable.node.E_Na;         % Na reversal potential, in mV
E_K  = cable.node.E_K;          % K reversal potential, in mV
E_L  = cable.node.E_L;          % Leakage reversal potential, in mV

g_Na = cable.node.g_Na;         % Na conductance in mS/cm^2
g_Nap = cable.node.g_Nap;       % Na conductance in mS/cm^2
g_K  = cable.node.g_K;          % K conductance in mS/cm^2
g_L  = cable.node.g_L;          % Nodal leak conductance in mS/cm^2

%% Initialize
% Initalize average membrane potential to V_init
phi_m_bar = zeros(N_comp,1) + V_init;

% Initialize equivelant conductance and potential to myelin; values of nodes will overwrite during time steps
g_bar = zeros(N_comp,1) + g_in;
E_bar = zeros(N_comp,1) + V_rest;

if is_MCE
    ER_TP = stimulation.ER_TP;
    TP_weight = cable.node.TP_weight;
    n_theta = solver.n_theta;    
    Empty_A = zeros(N_nodes,n_theta);        % Placeholder for membrane potential and gating particles at node
else
    Empty_A = zeros(N_nodes,1);              % Placeholder for membrane potential and gating particles at node
end

phi_m = Empty_A + V_init;
[m,~,h,~,p,~,s,~] = RMG(phi_m, T);

if plot_options.if_plot
    h_axis = plot_options.h_axis;
    if_plot = plot_options.if_plot;
    plot_t_intv = solver.plot_t_intv;
    [~,plot_ind_PW] = min(abs(solver.t_vec - stimulation.PW));
    [~,plot_ind_0]  = min(abs(solver.t_vec));
    
    title_str = plot_options.title_str;     
    plot(h_axis,[min(z),max(z)]*10,[E_Na,E_Na],'--k');
    plot(h_axis,[min(z),max(z)]*10,[E_K,E_K],'--k');
    plot(h_axis,[min(z),max(z)]*10,[E_L,E_L],'--k');
    plot(h_axis,[min(z),max(z)]*10,[V_rest,V_rest],':k');
    plot(h_axis,z(z_ind_AP)*10,E_Na,'*k');
    axis tight;ylim(h_axis,[-90,60]);
    xlabel(h_axis,'Axial position:  $$z \: \mathrm{(mm)}$$','Interpreter','latex');
    ylabel(h_axis,{'Average nodal membrane potential $$\overline{\varphi}_{\mathrm{m}} \: \mathrm{mV}$$'},'Interpreter','latex');
    title(h_axis,title_str,'Interpreter','latex');
end

%% Simulation, backward Euler steps
for t_ind = 2:len_t
    % Calculate equivalent ion channel conductivity and reversal potential
    if is_MCE
        g_bar(cable_ID) = sum( ( ( g_Na .* m.^3 .* h + g_Nap .* p.^3 )  + (g_K.* s) + g_L ) .* TP_weight ,2);       % mS/cm^2
        E_bar(cable_ID) = sum( ( ( E_Na - ER_TP * pulse_shape(t_ind) ) .* ( g_Na .* m.^3 .* h + g_Nap .* p.^3 ) + ...
                                 ( E_K  - ER_TP * pulse_shape(t_ind) ) .* ( g_K .* s                          ) + ...
                                 ( E_L                               ) .* ( g_L                               ) ) ...
                                 .* TP_weight, 2 ) ./ g_bar(cable_ID);  % mV
    else
        g_bar(cable_ID) =    ( ( ( g_Na .* m.^3 .* h + g_Nap .* p.^3 )  + (g_K.* s) + g_L )                );       % mS/cm^2
        E_bar(cable_ID) =    ( ( ( E_Na                              )  * ( g_Na .* m.^3 .* h + g_Nap .* p.^3 ) + ...
                                 ( E_K                               )  * ( g_K  .* s                         ) + ...
                                 ( E_L                               )  * ( g_L                               ) ) ...
                                                ) ./ g_bar(cable_ID);	% mV
    end
    
    tau_mem = C_m ./ (Area .* g_bar);           % Time constant at each membrane location, in ms
    Lambda2_left  = 1 ./ (R_i_left  .* Area .* g_bar);
    Lambda2_right = 1 ./ (R_i_right .* Area .* g_bar);
    % Normalized length constant squared at each point; Lambda =  lambda / dz
    Activating_f = ( -Lambda2_left  .* d_phi_e_left + ...
                      Lambda2_right .* d_phi_e_right ) * pulse_shape(t_ind) ;
    Activating_f(cable.z_ind_no_act) = 0;
    Lambda2_diag  =  Lambda2_left + Lambda2_right;
    F = tau_mem .* phi_m_bar + dt(t_ind) * (E_bar + Activating_f);
    A = tau_mem  + dt(t_ind) + dt(t_ind) * Lambda2_diag;
    B = -Lambda2_left  * dt(t_ind);
    C = -Lambda2_right * dt(t_ind);
    
    phi_m_bar = tridiag(A, B, C, F);    % Backward Euler step
    
    if any(abs(phi_m_bar(cable_ID)) > 10e3)
        exit_flag = 0;
        break;
    end
    
    % Generate tridiagonal matrix and RHS function for backward Euler
    if is_MCE
        phi_m = repmat( phi_m_bar(cable_ID), [1,n_theta] ) + ER_TP * pulse_shape(t_ind);
    else
        phi_m = phi_m_bar(cable_ID); 
    end
    [m_inf, tau_m, h_inf, tau_h, p_inf, tau_p, s_inf, tau_s] = RMG(phi_m, T);
    % Backward Euler for gating variables
    m = ( m_inf * dt(t_ind) + m .* tau_m) ./ ( dt(t_ind) + tau_m ) ;
    h = ( h_inf * dt(t_ind) + h .* tau_h) ./ ( dt(t_ind) + tau_h ) ;
    s = ( s_inf * dt(t_ind) + s .* tau_s) ./ ( dt(t_ind) + tau_s ) ;
    p = ( p_inf * dt(t_ind) + p .* tau_p) ./ ( dt(t_ind) + tau_p ) ;
    
    if if_plot
        if t_ind == plot_ind_0
        	plot(h_axis,z*10,phi_m_bar,'k','LineWidth',2);
        end
        if t_ind == (plot_ind_0 + 1)
            plot(h_axis,z*10,phi_m_bar,'c','LineWidth',2);
        end
        if any(abs( t(t_ind) - plot_t_intv ) < 1e-6 )
            plot(h_axis,z*10,phi_m_bar,'b');
        end
        if t_ind == plot_ind_PW
            plot(h_axis,z*10,phi_m_bar,'m','LineWidth',2);
        end
    end
    
    if any(phi_m_bar(z_ind_AP) > phi_AP )
        t_end = t(t_ind);
        if if_plot
            plot(h_axis,z(z_ind_AP)*10,phi_m_bar(z_ind_AP),'r*','LineWidth',2);
            plot(h_axis,z*10,phi_m_bar,'r','LineWidth',2,'LineWidth',2);
            title(h_axis,{ [title_str,': \textbf{AP},  $$t =',num2str(t_end,'%1.3f'),'\: \rm{ms} $$']},'Interpreter','latex');
        end
        exit_flag=1;
        break
    end

end

if ~exit_flag && if_plot
    title(h_axis,{ [title_str, ': \textbf{NO AP}']},'Interpreter','latex');
end

end
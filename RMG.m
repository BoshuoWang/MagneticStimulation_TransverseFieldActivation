function [m_inf, tau_m, h_inf, tau_h, p_inf, tau_p, s_inf, tau_s] = RMG(V_m, T)

% Ion channels in RMG 2000
% Fast Na channel: m^3*h
% Persistant Na channel: p^3
% Slow K channel: s

switch nargin
    case 0
        V_m = -82;      % Default resting potential: -82 mV
        T = 37;         % Default temperature: 37 degree Celcius
    case 1
        T = 37;         % Default temperature: 37 degree Celcius
end

T0 = 20;

% Q10s & scaling factor for channel dynamics 
Q10_m = 2.2;    K_m = Q10_m^( (T - T0) / 10);
Q10_h = 2.9;    K_h = Q10_h^( (T - T0) / 10); 
Q10_p = 2.2;    K_p = Q10_p^( (T - T0) / 10);
Q10_s = 3;      K_s = Q10_s^( (T - T0) / 10);

%% Fast Na activation gate M: m^3
A_alpha = 1.86 * K_m;               A_beta = 0.086 * K_m;
V_half_alpha = -25.4;               V_half_beta = -29.7;
K_alpha = 10.3;                     K_beta = 9.16;

alpha_m =  A_alpha * vtrap( ( V_m - V_half_alpha ) , K_alpha );
beta_m  =  A_beta  * vtrap(-( V_m - V_half_beta )  , K_beta );

tau_m = 1 ./ ( alpha_m + beta_m );
m_inf = alpha_m .* tau_m;

%% Fast Na inactivation gate H: h^1     Different equations for beta
A_alpha = 0.0336 * K_h;         	A_beta = 2.3 * K_h;
V_half_alpha = -118;                V_half_beta = -35.8;
K_alpha = 11;                       K_beta = 13.4;

alpha_h =  A_alpha * vtrap(-( V_m - V_half_alpha ) , K_alpha );
beta_h  =  A_beta  ./ ( 1 + exp( -( V_m - V_half_beta  ) / K_beta  ) ) ;

tau_h = 1 ./ ( alpha_h + beta_h );
h_inf = alpha_h .* tau_h;

%% Persistent Na activation gate p: p^3
A_alpha = 0.186 * K_p;              A_beta = 0.0086 * K_p;
V_half_alpha = -48.4;               V_half_beta = -42.7;
K_alpha = 10.3;                     K_beta = 9.16;

alpha_p =  A_alpha * vtrap( ( V_m - V_half_alpha ) , K_alpha );
beta_p  =  A_beta  * vtrap(-( V_m - V_half_beta )  , K_beta );

tau_p = 1 ./ ( alpha_p + beta_p );
p_inf = alpha_p .* tau_p;

%% Slow K activation gate s: s^1
A_alpha = 0.00122 * K_s;        A_beta = 0.0007393  * K_s;
V_half_alpha = -19.5;         	V_half_beta = -87.1;
K_alpha = 23.6;               	K_beta = 21.8;

alpha_s =  A_alpha * vtrap( ( V_m - V_half_alpha ) , K_alpha );
beta_s  =  A_beta  * vtrap(-( V_m - V_half_beta )  , K_beta );

tau_s = 1 ./ ( alpha_s + beta_s );
s_inf = alpha_s .* tau_s;

end

%%
function z = vtrap(x , y)	% Avoid devision by zeros

z = x ./ ( 1 - exp( - x/y ));

eps = 1e-3;             
ind = ( abs(x / y) < eps);
z(ind) = y + x(ind)/2;

end
function [m_inf,tau_m,h_inf,tau_h,n_inf,tau_n]=HH(V_m, T, V_rest)
% Gating parameters of HH sodium and potassium ion channels for absolute 
% membrane potential Vm (can be scalar, vector, matrix)
% 
% Results can be adjusted to reflect different temperature or resting  
% potential. Default values are: 
% Temperature: T = 6.3 degree Celcius
% Resting potential: V_rest = -65 mV
% 
% Units of tau(s) in ms;

% This is the original Hodgkin-Huxley treatment for the set of sodium and 
% potassium channels found in the squid giant axon membrane:
% "A quantitative description of membrane current and its application 
% conduction and excitation in nerve" J.Physiol. 117:500-544, 1952.
% Membrane voltage is in absolute mV and has been reversed in polarity
% from the original HH convention.

switch nargin
    case 0
        V_m = -65;
        T = 6.3;        % Temperature 6.3 degree Celcius
        V_rest = -65;   % Resting potential -65 mV
    case 1
        T = 6.3;        % Temperature 6.3 degree Celcius
        V_rest = -65;   % Resting potential -65 mV
    case 2
        V_rest = -65;   % Resting potential -65 mV
end

Q10 = 3;
T0 = 6.3;               % T_0 6.3 degree Celcius
K = Q10^((T-T0)/10);    % scaling factor for channel dynamics 

%% MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
A_alpha = 0.1;      V_half_alpha = 25 + V_rest;     K_alpha = 10;
A_beta = 4;         V_half_beta = V_rest;         K_beta = 18;

alpha_m = A_alpha * vtrap( ( V_m - V_half_alpha ) , K_alpha );
beta_m  = A_beta .* exp(-(V_m - V_half_beta) / K_beta) ;    

m_inf = alpha_m ./ (alpha_m + beta_m);
tau_m = 1 ./ (alpha_m + beta_m) / K;
%% HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH
A_alpha = 0.07;     V_half_alpha = V_rest;          K_alpha = 20;
A_beta = 1;         V_half_beta = 30+ V_rest;       K_beta = 10;

alpha_h = A_alpha .* exp(-(V_m - V_half_alpha) / K_alpha);
beta_h  = A_beta ./ (1 + exp( -(V_m - V_half_beta)/K_beta));

h_inf = alpha_h ./ (alpha_h + beta_h);
tau_h = 1 ./ (alpha_h + beta_h) / K;
%% NNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN
A_alpha = 0.01;     V_half_alpha = 10 + V_rest;    K_alpha = 10;
A_beta = 0.125;     V_half_beta = V_rest;           K_beta = 80;

alpha_n = A_alpha * vtrap( ( V_m - V_half_alpha ) , K_alpha );
beta_n  = A_beta .* exp(-(V_m - V_half_beta)/K_beta);   

n_inf = alpha_n ./ (alpha_n + beta_n);
tau_n = 1 ./ (alpha_n + beta_n) / K;

end

%%
function z = vtrap(x , y)	% Avoid devision by zeros

z = x ./ ( 1 - exp( - x/y ));

eps = 1e-3;
ind = abs(x / y) < eps;
z(ind) = y + x(ind)/2;

end
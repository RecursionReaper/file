clc;
clear;
%% GIVEN VALUES (FRIIS WITH SYSTEM LOSS L)
Pt = 5;                 % Transmitted power (W)
f = 2.4e9;              % Frequency (Hz)
R = 2000;               % Distance (m)
Gt_dB = 8;              % Tx antenna gain (dBi)
Gr_dB = 10;             % Rx antenna gain (dBi)
c = 3e8;                % Speed of light (m/s)
L_dB = 2;               % System loss in dB
%% CONVERSIONS
lambda = c / f;                 % Wavelength (m)
Gt = 10^(Gt_dB/10);             % Tx gain (linear)
Gr = 10^(Gr_dB/10);             % Rx gain (linear)
L  = 10^(L_dB/10);              % System loss (linear)
%% RECEIVED POWER (FRIIS WITH /L)
Pr = Pt * (lambda/(4*pi*R))^2 * Gt * Gr * (1/L);
Pr_dBm = 10*log10(Pr*1000);
fprintf('Received Power = %.4e W\n', Pr);
fprintf('Received Power = %.2f dBm\n\n', Pr_dBm);
%% 1) Pr vs Pt
Pt_var = linspace(1,10,50);
Pr_Pt = Pt_var .* (lambda/(4*pi*R)).^2 .* Gt .* Gr .* (1/L);
figure;
plot(Pt_var, Pr_Pt, 'LineWidth', 2);
xlabel('Transmitted Power Pt (W)');
ylabel('Received Power Pr (W)');
title('Pr vs Pt (with System Loss L)');
grid on;
%% 2) Pr vs Distance
R_var = linspace(500,5000,50);
Pr_R = Pt .* (lambda./(4*pi*R_var)).^2 .* Gt .* Gr .* (1/L);
figure;
plot(R_var, Pr_R, 'LineWidth', 2);
xlabel('Distance R (m)');
ylabel('Received Power Pr (W)');
title('Pr vs Distance (with System Loss L)');
grid on;
%% 3) Pr vs Wavelength
lambda_var = linspace(0.05,0.3,50);
Pr_lambda = Pt .* (lambda_var./(4*pi*R)).^2 .* Gt .* Gr .* (1/L);
figure;
plot(lambda_var, Pr_lambda, 'LineWidth', 2);
xlabel('Wavelength \lambda (m)');
ylabel('Received Power Pr (W)');
title('Pr vs Wavelength (with System Loss L)');
grid on;
%% 4) Pr vs System Loss (L)
SL_dB = linspace(0,40,50);      % System loss in dB (0 to 40 dB typical)
L_var = 10.^(SL_dB/10);         % Convert to linear
Pr_SL = Pt * Gt * Gr * (lambda/(4*pi*R))^2 ./ L_var;
figure;
plot(SL_dB, Pr_SL, 'LineWidth', 2);
xlabel('System Loss L (dB)');
ylabel('Received Power Pr (W)');
title('Pr vs System Loss L');
grid on;
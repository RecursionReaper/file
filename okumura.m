clc;
clear;
%% ===================== Given / Initial Conditions =====================
D0_km  = 50;        % Reference distance (km)
hte    = 100;       % Base station height (m)
hre    = 10;        % Mobile station height (m)
f0_MHz = 900;       % Operating frequency (MHz)
EIRP_W   = 1000;                      % 1 kW
EIRP_dBm = 10*log10(EIRP_W*1000);     % 1 kW = 60 dBm
Gr_dB    = 0;                         % Rx antenna gain
G_area   = 9;                         % Area gain/correction
% Height gain factors (given formula on board)
G_hte = 20*log10(hte/200);
G_hre = 20*log10(hre/3);
%% ===================== (1) Pr vs Attenuation =====================
% Use attenuation values from frequency sweep
f = 10:10:900;                         % MHz
A_mu = 35 + 10*log10(f/100);           % dB
% For Pr vs Attenuation, keep distance fixed at D0_km (50 km)
Lf_D0 = 32.45 + 20*log10(f0_MHz) + 20*log10(D0_km);   % dB
% Path loss as function of A_mu (only A_mu varies)
L50_A = Lf_D0 + A_mu - G_hte - G_hre - G_area;        % dB
% Received power as function of A_mu
Pr_A = EIRP_dBm - L50_A + Gr_dB;                      % dBm
% Plot 1: Pr vs Attenuation
figure;
plot(A_mu, Pr_A, 'LineWidth', 2);
grid on;
xlabel('Median Attenuation A_\mu (dB)');
ylabel('Received Power P_r (dBm)');
title('P_r vs Attenuation (Okumura, D = 50 km, f = 900 MHz)');
%% ===================== (2) Pr vs Distance =====================
% Distance sweep (km)
d = 1:1:50;
% Attenuation fixed at f0_MHz = 900 MHz
A_mu_900 = 35 + 10*log10(f0_MHz/100);
% Free space loss vs distance at f0
Lf_d = 32.45 + 20*log10(f0_MHz) + 20*log10(d);
% Okumura path loss vs distance
L50_d = Lf_d + A_mu_900 - G_hte - G_hre - G_area;
% Received power vs distance
Pr_d = EIRP_dBm - L50_d + Gr_dB;
% Plot 2: Pr vs Distance
figure;
plot(d, Pr_d, 'LineWidth', 2);
grid on;
xlabel('Distance (km)');
ylabel('Received Power P_r (dBm)');
title('P_r vs Distance (Okumura, f = 900 MHz, EIRP = 1 kW)');
%% ===================== Print values at 900 MHz, 50 km =====================
Lf_900_50  = 32.45 + 20*log10(f0_MHz) + 20*log10(D0_km);
L50_900_50 = Lf_900_50 + A_mu_900 - G_hte - G_hre - G_area;
Pr_50      = EIRP_dBm - L50_900_50 + Gr_dB;
fprintf('\n================= AT f = %d MHz, D = %d km =================\n', f0_MHz, D0_km);
fprintf('EIRP   = %.2f dBm\n', EIRP_dBm);
fprintf('Lf     = %.2f dB\n', Lf_900_50);
fprintf('A_mu   = %.2f dB\n', A_mu_900);
fprintf('G_hte  = %.2f dB\n', G_hte);
fprintf('G_hre  = %.2f dB\n', G_hre);
fprintf('G_area = %.2f dB\n', G_area);
fprintf('L50    = %.2f dB\n', L50_900_50);
fprintf('Pr     = %.2f dBm\n', Pr_50);
fprintf('=============================================================\n');
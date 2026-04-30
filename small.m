clc;
clear;
close all;
% -------------------- Fixed Parameters --------------------
fc_fixed = 1000;     % Frequency (MHz)
hte = 120;           % Tx antenna height (m)
hre = 10;            % Rx antenna height (m)
d_fixed = 50;        % Distance (km)
% -------------------- Path Loss (Fixed Values) --------------------
a_hre = (1.1*log10(fc_fixed) - 0.7)*hre - (1.56*log10(fc_fixed) - 0.8);
L_urban_val = 69.55 + 26.16*log10(fc_fixed) - 13.82*log10(hte) - a_hre + (44.9 - 6.55*log10(hte))*log10(d_fixed);
L_suburban_val = L_urban_val - 2*(log10(fc_fixed/28))^2 - 5.4;
L_open_val = L_urban_val - 4.78*(log10(fc_fixed))^2 + 18.33*log10(fc_fixed) - 40.98;
fprintf('\n===== HATA MODEL PATH LOSS VALUES =====\n');
fprintf('Frequency           = %d MHz\n', fc_fixed);
fprintf('Distance            = %d km\n', d_fixed);
fprintf('Tx antenna height   = %d m\n', hte);
fprintf('Rx antenna height   = %d m\n\n', hre);
fprintf('Urban Path Loss     = %.2f dB\n', L_urban_val);
fprintf('Suburban Path Loss  = %.2f dB\n', L_suburban_val);
fprintf('Open Area Path Loss = %.2f dB\n', L_open_val);
% -------------------- Path Loss vs Frequency --------------------
f = 150:10:1500;
a_hre_f = (1.1*log10(f) - 0.7).*hre - (1.56*log10(f) - 0.8);
L_urban_f = 69.55 + 26.16*log10(f) - 13.82*log10(hte) - a_hre_f + (44.9 - 6.55*log10(hte))*log10(d_fixed);
L_suburban_f = L_urban_f - 2*(log10(f/28)).^2 - 5.4;
L_open_f = L_urban_f - 4.78*(log10(f)).^2 + 18.33*log10(f) - 40.98;
figure;
plot(f, L_urban_f, 'r', 'LineWidth', 2); hold on;
plot(f, L_suburban_f, 'b', 'LineWidth', 2);
plot(f, L_open_f, 'g', 'LineWidth', 2);
grid on;
xlabel('Frequency (MHz)');
ylabel('Path Loss (dB)');
title('Hata Model: Path Loss vs Frequency');
legend('Urban', 'Suburban', 'Open Area');
% -------------------- Path Loss vs Distance --------------------
d = 1:1:50;
L_urban_d = 69.55 + 26.16*log10(fc_fixed) - 13.82*log10(hte) - a_hre + (44.9 - 6.55*log10(hte))*log10(d);
L_suburban_d = L_urban_d - 2*(log10(fc_fixed/28))^2 - 5.4;
L_open_d = L_urban_d - 4.78*(log10(fc_fixed))^2 + 18.33*log10(fc_fixed) - 40.98;
figure;
plot(d, L_urban_d, 'r', 'LineWidth', 2); hold on;
plot(d, L_suburban_d, 'b', 'LineWidth', 2);
plot(d, L_open_d, 'g', 'LineWidth', 2);
grid on;
xlabel('Distance (km)');
ylabel('Path Loss (dB)');
title('Hata Model: Path Loss vs Distance');
legend('Urban', 'Suburban', 'Open Area');
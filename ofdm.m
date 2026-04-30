clc; clear; close all;
%% OFDM Parameters
N = 64;          % Subcarriers
cp = 16;         % Cyclic prefix
M = 4;           % QPSK
SNR = 20;        % SNR in dB
%% Transmitter
k = log2(M);                 % Bits per symbol
bits = randi([0 1], N*k, 1); % Input bits
sym = bi2de(reshape(bits,k,[]).','left-msb');
qpsk = pskmod(sym,M,pi/4,'gray');
tx_ifft = ifft(qpsk,N);
tx = [tx_ifft(end-cp+1:end); tx_ifft];
%% Channel
rx = awgn(tx,SNR,'measured');
%% Receiver
rx = rx(cp+1:end);
rx_fft = fft(rx,N);
demod = pskdemod(rx_fft,M,pi/4,'gray');
out = reshape(de2bi(demod,k,'left-msb').',[],1);
%% Bit Rate Analysis
bits_ofdm = N*k;
samples_ofdm = N + cp;
eff = bits_ofdm/samples_ofdm;
cp_overhead = cp/samples_ofdm * 100;
fs = [1 10 20];          % MHz
rate = eff * fs;         % Mbps
fprintf('\nOFDM BIT RATE ANALYSIS\n');
fprintf('QPSK bits/symbol = %d\n',k);
fprintf('Subcarriers = %d\n',N);
fprintf('CP length = %d\n',cp);
fprintf('Bits per OFDM symbol = %d\n',bits_ofdm);
fprintf('Samples per OFDM symbol = %d\n',samples_ofdm);
fprintf('Efficiency = %.2f bits/sample\n',eff);
fprintf('CP overhead = %.1f %%\n',cp_overhead);
for i = 1:length(fs)
   fprintf('Bit rate at %d MHz = %.2f Mbps\n',fs(i),rate(i));
end
%% Plots
figure;
subplot(3,1,1)
stairs(bits,'LineWidth',1.5); grid on;
title('Input Bits'); ylim([-0.5 1.5]);
subplot(3,1,2)
plot(real(tx),'LineWidth',1.5); grid on;
title('OFDM Time Domain Signal');
subplot(3,1,3)
stairs(out,'LineWidth',1.5); grid on;
title('Recovered Bits'); ylim([-0.5 1.5]);
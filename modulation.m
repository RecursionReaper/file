clc; clear; close all;
%% Common Parameters
N    = 16;       % number of bits
spb  = 64;       % samples per bit
fs   = 64;       % sampling frequency
nfft = 4096;     % FFT size
t    = 0:1/fs:1-1/fs;   % time vector for one bit duration (64 samples)
%% Input Data (impulse at position 3)
data      = zeros(1, N);
data(3)   = 1;
%% ── PAM ──────────────────────────────────────────────────────────────────
% Repeat each bit value 64 times to make a rectangular pulse
pam = repelem(data, spb);
%% ── BFSK ─────────────────────────────────────────────────────────────────
% bit=0 uses frequency f0, bit=1 uses frequency f1
f0   = 2;
f1   = 5;
bfsk = zeros(1, N*spb);
for i = 1:N
   if data(i) == 0
       freq = f0;
   else
       freq = f1;
   end
   start_idx = (i-1)*spb + 1;
   end_idx   = i*spb;
   bfsk(start_idx:end_idx) = cos(2*pi*freq*t);
end
%% ── OFDM ─────────────────────────────────────────────────────────────────
% Place a single tone on subcarrier 4, take IFFT, add cyclic prefix
X       = zeros(1, N);
X(4)    = 1;
s       = real(ifft(X));          % OFDM symbol: N=16 samples
cp      = 4;                      % cyclic prefix length
s_with_cp = [s(end-cp+1:end), s]; % prepend last 4 samples → total 20 samples
ofdm    = repelem(s_with_cp, spb/4);  % upsample by 16 → total 320 samples
%% ── GMSK Gaussian Pulse ──────────────────────────────────────────────────
% Gaussian filter pulse shape (not the full GMSK modulated signal)
BT      = 0.3;
tg      = -3:1/fs:3;              % time axis for pulse
a       = sqrt(log(2)) / BT;     % alpha parameter
gmsk    = exp(-(a * tg).^2);
gmsk    = gmsk / sum(gmsk);       % normalise so area = 1
%% ── Store All Signals ────────────────────────────────────────────────────
sig   = {pam, bfsk, ofdm, gmsk};
names = {'PAM', 'BFSK', 'OFDM', 'GMSK'};
%% ── Plot 1: Input Data ───────────────────────────────────────────────────
figure;
stem(data, 'filled');
title('Input Impulse Data');
xlabel('Bit Index');
ylabel('Amplitude');
grid on;
%% ── Plot 2: Time Domain ──────────────────────────────────────────────────
figure;
for i = 1:4
   subplot(4, 1, i);
   time_axis = (0 : length(sig{i})-1) / fs;
   plot(time_axis, sig{i}, 'LineWidth', 1.3);
   title([names{i}, ' Time Response']);
   xlabel('Time (s)');
   ylabel('Amplitude');
   grid on;
end
%% ── Plot 3: Frequency Domain ─────────────────────────────────────────────
figure;
for i = 1:4
   S        = fft(sig{i}, nfft);
   mag      = 20 * log10(abs(S) / max(abs(S)) + 1e-12);
   freq_axis = (0 : nfft/2 - 1) * fs / nfft;
   subplot(4, 1, i);
   plot(freq_axis, mag(1 : nfft/2), 'LineWidth', 1.3);
   title([names{i}, ' Frequency Response']);
   xlabel('Frequency (Hz)');
   ylabel('Magnitude (dB)');
   ylim([-80, 5]);
   grid on;
end

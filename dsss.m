clc; clear; close all;
%% Parameters
data = [1 0 1 0];
L = 8;                         % chips per bit
SNR = 10;
%% 1. Data conversion and expansion
bip = 2*data - 1;              % 1 -> +1, 0 -> -1
d = repelem(bip, L);           % chip-rate data
%% 2. PN sequence generation
N = length(d);
pnGen = comm.PNSequence( ...
   'Polynomial',[5 2 0], ...
   'InitialConditions',[1 0 0 0 1], ...
   'SamplesPerFrame',N);
pn = 2*pnGen().' - 1;          % PN: 0/1 to -1/+1
%% 3. Spreading and channel
tx = d .* pn;                  % DSSS spreading
rx = awgn(tx, SNR, 'measured');
%% 4. Despreading and detection
des = rx .* pn;                % despreading
mat = reshape(des, L, []);
metric = sum(mat);
det_bip = sign(metric);
det_bip(det_bip == 0) = 1;
det = (det_bip + 1)/2;
out = repelem(det_bip, L);
%% 5. Display
disp('Original bits:'); disp(data);
disp('Detected bits:'); disp(det);
%% 6. Plots
t = 1:N;
figure;
subplot(5,1,1); stairs(t,d,'LineWidth',1.5); grid on;
title('Input Data'); ylim([-1.5 1.5]);
subplot(5,1,2); stairs(t,pn,'LineWidth',1.5); grid on;
title('PN Sequence'); ylim([-1.5 1.5]);
subplot(5,1,3); stairs(t,tx,'LineWidth',1.5); grid on;
title('DSSS Transmitted Signal'); ylim([-1.5 1.5]);
subplot(5,1,4); stairs(t,rx,'LineWidth',1.5); grid on;
title('Received Signal with AWGN'); ylim([-2.5 2.5]);
subplot(5,1,5); stairs(t,out,'LineWidth',1.5); grid on;
title('Detected Output Signal'); ylim([-1.5 1.5]);
xlabel('Time');
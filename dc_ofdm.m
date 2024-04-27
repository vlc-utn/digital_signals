%% DC-OFDM
% Full communication system with DC-OFDM, with an AWGN channel.
clc; clear; close all;

%% Parameters
Nsc = 64;                   % Number of sub-carriers
M = 16;                     % Modulation order
mod_type = "QAM";           % Modulation type
symbol_qtty = Nsc * 1e4;    % Amount of symbols to transmit
EsNo_dB = 0:2:20;           % EsNo
Ncp = 12;                   % Cyclic prefix symbols
constellation = [(-3 -3i), (-3 -1i), (-3 +1i), (-3 +3i), ...
    (-1 -3i), (-1 -1i), (-1 +1i), (-1 +3i), ...
    (1 -3i), (1 -1i), (1 +1i), (1 +3i), ...
    (3 -3i), (3 -1i), (3 +1i), (3 +3i)];

%% Communication system
% Symbols to transmit. Each row corresponds to an OFDM symbol of Nsc
% length.
d = randi([0, M-1], symbol_qtty/Nsc, Nsc);
error_qtty = zeros(size(EsNo_dB));

[u, U, s] = Modulator.ofdm(d, constellation, Ncp);

for i=1:1:length(EsNo_dB)
    r = Channel.add_awgn_noise(s, EsNo_dB(i));
    [U_r, u_r, d_r] = Demodulator.ofdm(r, constellation, Ncp);
    error_qtty(i) = sum(sum(d~=d_r, 2));
end

ser = error_qtty / symbol_qtty;
ser_theory = Theory.ser_AWGN(mod_type, M, EsNo_dB);

%% Plotting
semilogy(EsNo_dB, ser, LineStyle="-"); hold on;
semilogy(EsNo_dB, ser_theory, LineStyle="--"); hold on;

grid on;
legend( strcat(num2str(M), "-", mod_type, " Simulated"), ...
    strcat(num2str(M), "-", mod_type, " Theoretical") );
xlabel("Es/N0 [dB]");
ylabel("SER");
title("Symbol Error Rate");
ylim([1e-6, 1]);
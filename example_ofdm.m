%% Example OFDM
% Full communication system with CP-OFDM, with an AWGN channel.
clc; clear; close all;

%% Parameters
Nsc = 64;                    % Number of sub-carriers
M = 16;                     % Modulation order
mod_type = "QAM";           % Modulation type
symbol_qtty = Nsc * 1e4;    % Amount of symbols to transmit
EsNo_dB = 0:2:20;           % EsNo
Ncp = 12;                   % Cyclic prefix symbols

%% Communication system
% Symbols to transmit. Each row corresponds to an OFDM symbol of Nsc
% length.
d = randi([0, M-1], symbol_qtty/Nsc, Nsc);
error_qtty = zeros(size(EsNo_dB));

%%% Modulator
for i=1:1:height(d)
    % For each OFDM symbol...
    [u, constellation] = Modulator.modulate(d(i,:), mod_type, M);
    U = ifft(u, Nsc);
    s = [U(end - Ncp + 1 : end) U]; % Add cyclic prefix
    
    %%% Channel
    for j=1:1:length(EsNo_dB)
        % For each ESNo value...
        r = Channel.add_awgn_noise(s, EsNo_dB(j));
        
        %%% Demodulator
        U_r = r(Ncp+1 : Nsc + Ncp); % Remove cyclic prefix
        u_r = fft(U_r, Nsc);
        d_r = Demodulator.demodulate(u_r, mod_type, M, constellation);
        
        error_qtty(j) = error_qtty(j) + sum(d(i,:)~=d_r);
    end
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

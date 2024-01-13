%% UNFINISHED equalizer in full system 
clc; clear; close all;
addpath("Functions");

%% Parameters
symbol_qtty = 1e5;              % Number os symbols to transmit
EsNo_dB = 0:2:30;               % EsNo values;
M = 2;                          % Modulation order
mod_type = ModulationTypes.PAM; % Modulation type

beta = 0.8;                     % Slope for the SRRC FIR filter
L = 1;                          % Oversampling factor
duration = 3;                   % Duration of the SRRC pulse

channel_type = ChannelTypes.AWGN;

x = randi([0, M-1], 1, symbol_qtty);
ser = zeros(1, length(EsNo_dB));

h_c = [0.04 -0.05 0.07 -0.21 -0.5 0.72 0.36 0.21 0.03 0.07];%Channel A
nTaps = 31;


%% Transmision
for i=1:1:length(EsNo_dB)
    mod = Modulator(mod_type, M);
    [s, constellation] = mod.modulate(x);
    %s = pulse_shaping_srrc(s, beta, L, duration);

    % Add channel effect
    s = conv(s, h_c, "full");
    
    channel = Channel(channel_type, EsNo_dB(i), L);
    r = channel.add_noise(s);
    
    demod = Demodulator(mod_type, M, constellation);
    %r = pulse_deshaping_srrc(r, beta, L, duration);

    % Equalize
    [w, n0] = zf_equalizer(h_c, nTaps);
    r = conv(r, w, "full");
    r = r(n0:n0+symbol_qtty-1);   % Apply delay
    
    
    y = demod.demodulate(r);
    
    ser(i) = sum(y ~= x)/symbol_qtty;
    
end

semilogy(EsNo_dB, ser); hold on;
xlabel("Es/N0 [dB]");
ylabel("SER (Symbol Error Rate)");
title("Symbol error rate with equalizer");
grid on;
ylim([1e-4, 1]);

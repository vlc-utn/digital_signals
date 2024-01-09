%% Symbol Error Rate.
% Calculate the SER for different modulation types for different channel
% types.

clc; clear; close all;
addpath("Functions");

%% Parameters
sample_qtty = 1e5;                  % Number of samples
EsNo_dB = 0:2:40;                   % EsNo
mod_type = ModulationTypes.QAM;     % Modulation type.
M = [4,16,64];                      % Number of symbols
channel_type = ChannelTypes.Ricean;   % Channel type

% Ratio between power of LOS and NLOS components. Used for Ricean channel
PlosPnlos_dB = 20; 

%% Calculations
for m=1:1:length(M)
    x = randi([0, M(m)-1], 1, sample_qtty);
    ser = zeros(1, length(EsNo_dB));

    for i=1:1:length(EsNo_dB)
        mod = Modulator(mod_type, M(m));
        [s, constellation] = mod.modulate(x);
    
        channel = Channel(channel_type, EsNo_dB(i), PlosPnlos_dB=PlosPnlos_dB);
        [r, n, h] = channel.add_noise(s);

        demod = Demodulator(mod_type, M(m), constellation);
        y = demod.demodulate(r);

        ser(i) = sum(x~=y)/sample_qtty;
    end

    if (channel_type == ChannelTypes.AWGN)
        ser_theory = ser_AWGN(mod_type, M(m), EsNo_dB);
    elseif (channel_type == ChannelTypes.Rayleigh)
        ser_theory = ser_rayleigh(mod_type, M(m), EsNo_dB);
    elseif (channel_type == ChannelTypes.Ricean)
        ser_theory = ser_ricean(mod_type, M(m), EsNo_dB, PlosPnlos_dB);
    end

    semilogy(EsNo_dB, ser); hold on;
    semilogy(EsNo_dB, ser_theory, LineStyle="--"); hold on;
end

grid on;
xlabel("Es/N0 [dB]");
ylabel("SER");
title("Symbol Error Rate");
ylim([1e-6, 1])


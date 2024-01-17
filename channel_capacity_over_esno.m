%% Channel capacity over EbNo
% Get the channel capacity as a function of the EsNo, for different 
% modulation techniques (M-QAM, M-PAM, M-PSK)
clc; clear; close all;

%% Parameters
mod_type = "QAM";               % Modulation type.
M = [4, 16, 64];                % Number of symbols. Modulation order.
symbol_qtty = 1e4;              % Amount of symbols used in the simulation.
EsNo_dB = -10:2:30;             % Repeat the simulation for every value of EsNo.
L = 20;                         % [samples/symbol] Oversampling factor
beta = 0.5;                     % Square root rised cosine (srrc) slope
duration = 5;                   % Duration of the srrc pulse in symbol times.

%% Intermidiate variables
colors = ["b", "r", "g", "c", "m", "k"];   % Colors for plotting
legendString = cell(1, length(M)+1);              % For text in plot as "16-QAM"

% Channel capacity calculated with entropy formula
C_entropy = zeros(1, length(EsNo_dB));

% Channel capacity calculated with Gaussian probabilty density function
C_pdf = zeros(1, length(EsNo_dB));

for m=1:length(M)
    d = randi([0, M(m)-1], 1, symbol_qtty);     % Input symbol stream.
    d_r = zeros(1, symbol_qtty);                % Ouput symbol stream.   

    % Modulator
    [u, constellation] = Modulator.modulate(d, mod_type, M(m));
    v = Modulator.upsample(u, L);
    [s, h_tx, delay_tx] = Modulator.pulse_shaping_srrc(v, beta, L, duration);

    for i=1:length(EsNo_dB)
        % Channel
        [r, h_c, N0] = Channel.add_awgn_noise(s, EsNo_dB(i), L);
  
        % Demodulator
        r = Demodulator.flat_fading_equalizer(r, h_c);
        [v_r, h_rx, delay_rx] = Demodulator.pulse_filter_srrc(r, beta, L, duration);
        u_r = Demodulator.downsample(v_r, L, delay_tx + delay_rx);


        d_r = Demodulator.demodulate(u_r, mod_type, M(m), constellation);
        

        h_c = Demodulator.downsample(h_c, L, delay_tx);
        C_pdf(i) = Theory.channel_capacity_from_pdf(u_r, constellation, h_c, N0);
      
        % Channel capacity with entropy and formulas
        C_entropy(i) = Scope.channel_capacity(M(m),d,d_r);
    end
    plot(EsNo_dB, C_pdf, LineWidth=1.0, Color=colors(m), LineStyle='-'); hold on;
    legendString{m} = strcat(num2str(M(m)), "-", mod_type);
    plot(EsNo_dB, C_entropy, LineWidth=1.0, Color=colors(m), LineStyle="--"); hold on;
end

% Calculate theoretical maximum channel capacity, with shannon formula
C_maximum = Theory.maximum_channel_capacity(EsNo_dB);
plot(EsNo_dB, C_maximum, LineWidth=1.0, Color=colors(end), LineStyle='-'); hold on;
legendString{end} = "Maximum";

legend(legendString);
xlabel("Es/N0 [dB]");
ylabel("C [bits/symbol]");
title("Channel capacity for several modulations");
grid on;

%% Example with fading channel
% Make a full transmission / reception, and plot signals on every step of
% the modulation
clc; clear; close all;

%% Parameters
mod_type = ModulationTypes.QAM;     % Modulation type.
M = 16;                             % Modulation order.
symbol_qtty = 1e4;                  % Amount of symbols to send.
L = 10;                             % Oversampling factor.
nTaps = 30;                         % Taps for pulse shaping FIR filters.
beta = 1;                           % Slope of the SRRC filter.
EsNo_dB = 20;                       % EsNo

%% Transmitter
d = randi([0, M-1], 1, symbol_qtty);
[u, constellation] = Modulator.modulate(d, mod_type, M);
v = Modulator.upsample(u, L);
[s, p, delay_tx] = Modulator.pulse_shaping_srrc(v, beta, L, nTaps);

%% Channel
[r, h_c] = Channel.add_awgn_noise(s, EsNo_dB, L);

%% Receiver
r = Demodulator.flat_fading_equalizer(r, h_c);
[v_r, g, delay_rx] = Demodulator.pulse_filter_srrc(r, beta, L, nTaps);
u_r = Demodulator.downsample(v_r, L, delay_tx + delay_rx);
d_r = Demodulator.demodulate(u_r, mod_type, M, constellation);

%% Plotting
Scope.plot_eye_diagram(v_r, L, delay_rx + delay_tx, 3, 1000);
Scope.plot_fir_filter(p, Title="Tx Filter");
Scope.plot_fir_filter(g, Title="Rx Filter");
Scope.plot_IQ(u_r);
Scope.plot_constellation(constellation);


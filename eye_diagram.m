%% Eye Diagram
% Plot the eye diagram for a received pulse shaped symbols stream.

clc; clear; close all;
addpath("Functions");

%% Parameters
mod_type = ModulationTypes.QAM;     % Modulation type
M = 4;                              % Modulation order
symbol_qtty = 1e4;                  % Amount of symbols to send
beta = 1;                           % Slope of the SRRC filter
L = 10;                             % Oversampling factor
duration = 3;                       % Duration of the pulse function in +- symbol time.
channel_type = ChannelTypes.AWGN;   % Channel type
EsNo_dB = 30;                       % EsNo

%% Modulation
x = randi([0, M-1], 1, symbol_qtty);

mod = Modulator(mod_type, M);
[s, constellation] = mod.modulate(x);
s = pulse_shaping_srrc(s, beta, L, duration);

%% Channel noise
channel = Channel(channel_type, EsNo_dB, L);
r = channel.add_noise(s);

%% Eye diagram
[~, v_r, delay] = pulse_deshaping_srrc(r, beta, L, duration);
eye = Scope.plot_eye_diagram(v_r, L, delay, 3, 1000);

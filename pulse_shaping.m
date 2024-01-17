%% Pulse Shaping
% Time and frequency representation of the following signals:
% - Rectangular pulse.
% - Sinc.
% - Rised cosine.
% - Square root rised cosine (for Rx and Tx).
clc; clear; close all;

%% Parameters
nTaps = 50;         % Taps for FIR filters
L = 10;             % Oversampling factor
alpha = 0.5;        % Alpha constant for raised cosine (0 < alpha < 1)
beta = 0.5;         % Beta constant for srrc (0 < beta < 1)           

%% FIR filters
rect = Modulator.rect_pulse(L, nTaps);
sinc_p = Modulator.sinc_pulse(L, nTaps);
rc = Modulator.rc_pulse(alpha, L, nTaps);

srrc = Modulator.srrc_pulse(beta, L, nTaps);
%srrc = conv(srrc, srrc, "same"); % Apply two filters, Rx and Tx.

Scope.plot_fir_filter(rect, Title="Rectangular pulse");
Scope.plot_fir_filter(sinc_p, Title="Sinc pulse");
Scope.plot_fir_filter(rc, Title="Rised cosine");
Scope.plot_fir_filter(srrc, Title="Square root rised cosine");

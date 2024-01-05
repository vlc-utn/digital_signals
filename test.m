%% Test
% El contenido de este archivo son pruebas sueltas, y no debe considerarse
% como contenido relevante.

clc; clear; close all;

M = 16;
symbol_qtty = 1000;
EsNo_dB = 30;

a = Modulator("qam", M, UseCommToolbox=false);
c = Channel(ChannelTypes.AWGN, EsNo_dB, PlosPnlos_dB=10);

x = randi([0, M-1], 1, symbol_qtty);

[s, constellation] = a.modulate(x);

r = c.add_noise(s);

b = Demodulator("qam", M, constellation, UseCommToolbox=false);
y = b.demodulate(s);

figure();
plot(real(r), imag(r), "*")
grid on;



%% Pulse Shaping
% Time and frequency representation of the following signals:
% - Rectangular pulse.
% - Sinc.
% - Rised cosine.
% - Square root rised cosine (for Rx and Tx).

clc; clear; close all;

%% Parameters
fsym = 5;           % [Hz] Symbol time.
fs   = 50;          % [Hz] Sample frecuency.

% Pulses will be truncated after:
%   -duration*Tsym < t < duration*Tsym 
duration = 5;

alpha = 0.5;        % Alpha constant for raised cosine (0 < alpha < 1)
beta = 0.5;         % Beta constant for srrc (0 < beta < 1)           

%% Temporal signals

Tsym = 1/fsym;                                  % Symbol time
L = fs/fsym;                                    % Oversampling factor
t = -duration*Tsym : 1/fs : duration*Tsym;      % Time vector        

% Pulse signal
pulse = (t > -Tsym/2) .* (t <= Tsym/2);       

% Sinc signal
sinc= sinc(t/Tsym);                             
sinc = sinc .* (t > -duration*Tsym) .* (t <= duration*Tsym);

% Raised cosine signal
raised_cosine = (sin(pi*t/Tsym) ./ (pi*t/Tsym)) .* (cos(pi*alpha*t/Tsym)) ./ (1 - (2*alpha*t/Tsym).^2);
raised_cosine(ceil(length(t)/2)) = 1;   % raised_cosine(t=0) = 1
raised_cosine(t==Tsym/(2*alpha)) = (alpha/2)*sin(pi/(2*alpha));
raised_cosine(t==-Tsym/(2*alpha)) = (alpha/2)*sin(pi/(2*alpha));

% Root Square Raised Cosine signal
srrc = srrc_pulse(beta, L, duration);
srrc = conv(srrc, srrc, "same"); % Apply two filters, Rx and Tx.

%% FFT (frequency domain)
N0 = 2 ^ nextpow2(length(t));           % Samples for the fft
freq=fs/N0*(-N0/2:N0/2-1);              % Frequency vector

% Pulse signal
DFT_pulse = fft(pulse, N0);
DFT_pulse = DFT_pulse ./ abs(DFT_pulse(1)); % Normalize
DFT_pulse = fftshift(DFT_pulse);

% Sinc signal
DFT_sinc = fft(sinc, N0);   
DFT_sinc = DFT_sinc ./ abs(DFT_sinc(1));    % Normalize
DFT_sinc = fftshift(DFT_sinc);

% Raised cosine signal
DFT_RC = fft(raised_cosine, N0);
DFT_RC = DFT_RC ./ abs(DFT_RC(1));          % Normalize          
DFT_RC = fftshift(DFT_RC);

% Root Square Raised Cosine signal
DFT_SRRC = fft(srrc, N0);
DFT_SRRC = DFT_SRRC ./ abs(DFT_SRRC(1));    % Normalize          
DFT_SRRC = fftshift(DFT_SRRC);

%% Plotting
figure();
subplot(4,2,1);
plot(t, pulse);
xlabel("Time [seg]");
ylabel("Amplitude");
title("Rectangular pulse");
grid on;

subplot(4,2,2);
plot(freq, (abs(DFT_pulse)))
xlabel("Freq. [Hz]");
ylabel("Magnitude");
title("DFT of rectangular pulse");
grid on;
xlim([-1/Tsym*5, 1/Tsym*5]);

subplot(4,2,3);
plot(t, sinc);
xlabel("Time [seg]");
ylabel("Amplitude");
title("Sinc");
grid on;
legend(sprintf("-%d.Tsym < t < %d.Tsym",duration, duration));

subplot(4,2,4);
plot(freq, (abs(DFT_sinc)))
xlabel("Freq. [Hz]");
ylabel("Magnitude");
title("DFT of SINC");
grid on;
xlim([-1/Tsym*5, 1/Tsym*5]);

subplot(4,2,5);
plot(t, raised_cosine);
xlabel("Time [seg]");
ylabel("Amplitude");
title("Raised Cosine (RC)");
grid on;
legend(sprintf("Alpha = %0.2f", alpha));

subplot(4,2,6);
plot(freq, (abs(DFT_RC)))
xlabel("Freq. [Hz]");
ylabel("Magnitude");
title("DFT of Raised Cosine");
grid on;
xlim([-1/Tsym*5, 1/Tsym*5]);

subplot(4,2,7);
plot(t, srrc);
xlabel("Time [seg]");
ylabel("Amplitude");
title("Square Root Raised Cosine (SRRC) (h_{tx}(t)*h_{rx}(t))");
grid on;
legend(sprintf("Beta = %0.2f", beta));

subplot(4,2,8);
plot(freq, (abs(DFT_SRRC)))
xlabel("Freq. [Hz]");
ylabel("Magnitude");
title("DFT of Square Root Raised Cosine (H_{tx}(f).H_{rx}(f))");
grid on;
xlim([-1/Tsym*5, 1/Tsym*5]);

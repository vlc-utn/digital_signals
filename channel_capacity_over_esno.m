%% Channel capacity over EbNo
% Get the channel capacity as a function of the EbNo, for different 
% modulation techniques (M-QAM, M-PAM, M-PSK)
clc; clear; close all;
addpath("Functions");

%% Parameters
mod_type = "QAM";               % Modulation type.
M = [4, 16, 64];                % Number of symbols. Modulation order.
sample_qtty = 1e4;              % Amount of samples used in the simulation.
EsNo_dB = -10:1:30;             % Repeat the simulation for every value of EbNo.
h = ones(1, sample_qtty);       % Flat fading channel gain.
include_entropy_plot = false;   % Includes channel capacity calculated from entropy.

%% Intermidiate variables
colors = ["b", "g", "c", "m", "k"];         % Colors for plotting
legendString = cell(1, length(M));          % For text in plot as "16-QAM"

% Channel capacity calculated with entropy formula
C_with_entropy = zeros(1, length(EsNo_dB));


% Channel capacity calculated with Gaussian probabilty density function
C_with_pdf = zeros(1, length(EsNo_dB));


for m=1:length(M)
    x = randi([0, M(m)-1], 1, sample_qtty);     % Input symbol stream.
    y = zeros(1, length(x));                    % Ouput symbol stream.    

    for i=1:length(EsNo_dB)
        mod = Modulator(mod_type, M(m));
        [s, constellation] = mod.modulate(x);
        
        channel = Channel("AWGN", EsNo_dB(i));
        r = channel.add_noise(s);
        N0 = channel.get_N0();
        
        demod = Demodulator(mod_type, M(m), constellation);
        y = demod.demodulate(r);
        
        % Channel capacity base on the normal distribution condional
        % probability (PDF formula)
        Hx = log2(M(m));  % Ideal input symbol entropy
        pdfs = exp(-(abs(ones(M(m),1)*r - constellation'*h).^2)/N0);
        prob_yx = max(pdfs, realmin);                       % prob of each constellation points
        prob_yx = prob_yx./ (ones(M(m),1)*sum(prob_yx));    % normalize probabilities
        Hyx = -mean(sum(prob_yx.*log2(prob_yx)));
        C_with_pdf(i) = Hx - Hyx;
      
        % Channel capacity with entropy and formulas
        if (include_entropy_plot)
            C_with_entropy(i) = channel_capacity(M(m),x,y);
        end
    end

    plot(EsNo_dB, C_with_pdf, LineWidth=1.0, Color=colors(m), ...
        LineStyle='-'); hold on;
    legendString{m} = strcat(num2str(M(m)), "-", mod_type);
    if (include_entropy_plot)
        plot(EsNo_dB, C_with_entropy, LineWidth=1.0, Color=colors(m), ...
            LineStyle="--"); hold on;
    end
end

legend(legendString);
xlabel("Es/N0 [dB]");
ylabel("C [bits/symbol]");
title("Channel capacity for several modulations");
grid on;

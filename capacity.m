clc; clear; close all;

addpath("Functions");

M = 16;
symbol_qtty = 1e4;
EsNo_dB = -10:1:30;   % Vectorizar

x = randi([0, M-1], length(EsNo_dB), symbol_qtty);

y = zeros(1, length(x));
C = zeros(1, length(EsNo_dB));
D = zeros(1, length(EsNo_dB));

for i=1:length(EsNo_dB)
    mod = Modulator("PAM", M);
    [s, constellation] = mod.modulate(x(i,:));
    
    channel = Channel("AWGN", EsNo_dB(i));
    r = channel.add_noise(s);
    
    demod = Demodulator("PAM", M, constellation);
    y(1,:) = demod.demodulate(r);
    
    % Chequear
    h = ones(1, symbol_qtty);
    Es = 1/length(s) * sum(abs(s).^2);
    N0 = Es/channel.EsNo;

    Hx = log2(M);
    pdfs = exp(-(abs(ones(M,1)*r - constellation'.*h).^2)/N0);
    prob_yx = max(pdfs, realmin);                   %prob of each constellation points
    prob_yx = prob_yx./ (ones(M,1)*sum(prob_yx));   %normalize probabilities
    Hyx = -mean(sum(prob_yx.*log2(prob_yx)));
    C(i)=Hx - Hyx;
    Hyxx = entropy(M, x(i,:), y);
    Hx = entropy(M, x(i,:));
    Hy = entropy(M, y);
    D(i) = Hx + Hy - Hyxx;
end

plot(EsNo_dB - 10*log10(log2(M)), C,'LineWidth',1.0); hold on;
plot(EsNo_dB - 10*log10(log2(M)), D,'LineWidth',1.0); hold on;
xlabel("EbN0")

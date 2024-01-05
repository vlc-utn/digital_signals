clc; clear; close all;

EbNo_dB = 0:2:20;
M = 4;
PlosPnlos_dB = 3;
symbol_qtty = 1e6;

EsNo_dB = EbNo_dB + 10*log10(log2(M));

SER_sim = zeros(1,length(EsNo_dB));

x = randi([0,M-1], length(EsNo_dB), symbol_qtty);

y = zeros(length(EsNo_dB), symbol_qtty);

for i=1:length(EsNo_dB)
    mod = Modulator("PSK", M);
    [s, constellation] = mod.modulate(x(i,:));

    channel = Channel(ChannelTypes.Ricean, EsNo_dB(i), PlosPnlos_dB=PlosPnlos_dB);
    r = channel.add_noise(s);
    
    demod = Demodulator("PSK", M, constellation);
    y(i,:) = demod.demodulate(r);

    SER_sim(i) = sum(x(i,:)~=y(i,:))/symbol_qtty;
end


semilogy(EbNo_dB, SER_sim);
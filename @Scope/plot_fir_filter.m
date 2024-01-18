function plot_fir_filter(fir, options)
    %PLOT_FIR_FILTER Plot the samples and frequency respons of a FIR
    % filter.
    %
    % Args:
    %   - fir = FIR filter.
    %   - options.Title = Title for the plot.
    arguments(Input)
        fir (1,:) double
        options.Title string = "FIR filter"
    end
    
    n = -floor(length(fir)/2) : 1 : floor((length(fir)-1)/2);

    N0 = 1024 * 2^(nextpow2(length(fir)));      % Samples for the fft
    freq= 2*pi/N0*(-N0/2:N0/2-1);               % Frequency vector

    DFT = fftshift(fft(fir, N0));
    DFT_dB = 20*log10(abs(DFT));

    figure();
    subplot(2,1,1);
    stem(n, fir);
    xlabel("Samples");
    ylabel("Amplitude");
    title(options.Title);
    grid on;

    subplot(2,1,2);
    plot(freq, DFT_dB)
    xlabel("Normalized freq. [rad/sample]");
    ylabel("Magnitude [dB]");
    title(strcat("DFT of ", options.Title));
    grid on;
    xlim([-pi, pi]);
end


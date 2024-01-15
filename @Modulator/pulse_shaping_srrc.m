function [s, p, delay] = pulse_shaping_srrc(v, beta, L, duration)
    %PULSE_SHAPING_SRRC. Given the oversampled symbols "v", this function 
    % convolves the result with the SRRC (Square Root Rised Cosine).
    %
    % Args:
    %   - v = Oversampled symbol vector.
    %   - beta = slope for frequency response of the srrc pulse.
    %   - L = Oversampling factor (amount of samples per symbol).
    %   - duration = Amount of "Tsym" that the pulse will last before
    %   being truncated, as an integer.
    %
    % Outputs:
    %   - s = Pulse shaped symbols.
    %   - p = pulse shaping filter.
    %   - delay = Delay introduced by the srrc FIR filter.
    arguments(Input)
        v (1,:) double
        beta double
        L double
        duration double
    end
    arguments(Output)
        s (1,:) double
        p (1,:) double
        delay double
    end

    [srrc, delay] = Modulator.srrc_pulse(beta, L, duration);
    p = srrc;

    % Use "full" to get values of the pulse before and after the symbol
    s = conv(v, srrc, "full");
end
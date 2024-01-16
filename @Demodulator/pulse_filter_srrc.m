function [v_r, p, delay] = pulse_filter_srrc(r, beta, L, duration)
    %PULSE_FILTER_SRRC. Given a stream of srrc pulses, this function
    % convolves the stream with the srrc pulse, giving a raised cosine
    % pulse form.
    %
    % Args:
    %   - r = Received samples vector.
    %   - beta = slope for frequency response of the srrc pulse.
    %   - L = Oversampling factor (amount of samples per symbol).
    %   - duration = Amount of "Tsym" that the pulse will last before
    %   being truncated, as an integer.
    %
    % Outputs:
    %   - v_r = Pulse shaped received samples.
    %   - p = pulse shaping filter
    %   - delay = Delay of the FIR filter of the receiver.

    arguments(Input)
        r (1,:) double
        beta double
        L double
        duration double
    end
    arguments(Output)
        v_r (1,:) double
        p (1,:) double
        delay double
    end

    [srrc, delay] = Modulator.srrc_pulse(beta, L, duration);
    p = srrc;

    % Use "full" to get values of the pulse before and after the symbol
    v_r = conv(r, srrc, "full");
end
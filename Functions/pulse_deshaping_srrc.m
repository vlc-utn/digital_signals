function [u_r, v_r, delay] = pulse_deshaping_srrc(r, beta, L, duration)
    %PULSE_DESHAPING_SRRC. Given a stream of srrc pulses, this function
    % convolves the stream with the srrc pulse, and then downsamples the
    % result by a factor of "L".
    %
    % Args:
    %   - u = Symbol vector.
    %   - beta = slope for frequency response of the srrc pulse.
    %   - L = Oversampling factor (amount of samples per symbol).
    %   - duration = Amount of "Tsym" that the pulse will last before
    %   being truncated, as an integer.
    %
    % Outputs:
    %   - u_r = Constellation received symbols.
    %   - v_r = Pulse shaped received samples.
    %   - delay = delay of the sum of the receiver and transmitter FIR
    %   filters.

    arguments(Input)
        r (1,:) double
        beta double
        L double
        duration double
    end
    arguments(Output)
        u_r (1,:) double
        v_r (1,:) double
        delay double
    end

    [srrc, delay] = srrc_pulse(beta, L, duration);
    delay = 2*delay;

    % Use "full" to get values of the pulse before and after the symbol
    v_r = conv(r, srrc, "full");

    u_r = v_r(delay+1 : L : end - delay); 
end
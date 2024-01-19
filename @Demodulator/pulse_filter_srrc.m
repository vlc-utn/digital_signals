function [v_r, g, delay] = pulse_filter_srrc(a_r, beta, L, nTaps)
    %PULSE_FILTER_SRRC. Given a stream of srrc pulses, this function
    % convolves the stream with the srrc pulse, giving a raised cosine
    % pulse form.
    %
    % Args:
    %   - a_r = Received samples vector, after equalization.
    %   - beta = slope for frequency response of the srrc pulse.
    %   - L = Oversampling factor (amount of samples per symbol).
    %   - nTaps = The filter will have "nTaps + 1" coefficients.
    %
    % Outputs:
    %   - v_r = Pulse shaped received samples.
    %   - g = pulse shaping filter
    %   - delay = Delay of the FIR filter of the receiver.

    arguments(Input)
        a_r (1,:) double
        beta double
        L double
        nTaps double
    end
    arguments(Output)
        v_r (1,:) double
        g (1,:) double
        delay double
    end

    [srrc, delay] = Modulator.srrc_pulse(beta, L, nTaps);
    g = srrc;

    % Use "full" to get values of the pulse before and after the symbol
    v_r = conv(a_r, srrc, "full");
end
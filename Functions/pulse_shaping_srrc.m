function s = pulse_shaping_srrc(u, beta, L, duration)
    %PULSE_SHAPING_SRRC. Given a stream of symbols, this function
    % oversamples the vector by a factor "L", and convolves the result with
    % the SRRC (Square Root Rised Cosine) function.
    %
    % Args:
    %   - u = Symbol vector.
    %   - beta = slope for frequency response of the srrc pulse.
    %   - L = Oversampling factor (amount of samples per symbol).
    %   - duration = Amount of "Tsym" that the pulse will last before
    %   being truncated, as an integer.
    %
    % Outputs:
    %   s = Pulse shaped symbols. Size will be (1, 2*L*duration+1);

    arguments(Input)
        u (1,:) double
        beta double
        L double
        duration double
    end
    arguments(Output)
        s (1,:) double
    end

    % Matrix with first row "u", and L-1 rows with zeros.
    v = [u; zeros(L-1,length(u))]; 

    % Concatenate each column to create a single column vector, and 
    % traspose.
    v = v(:)';

    srrc = srrc_pulse(beta, L, duration);

    % Use "full" to get values of the pulse before and after the symbol
    s = conv(v, srrc, "full");
end
function [rect, delay] = rect_pulse(L, nTaps)
    %RC_PULSE. Rectangular pulse. Returns the shape of the FIR pulse filter.
    %
    % Args:
    %   - alpha = RC frequency slope (0 < beta < 1). 
    %   - L = Oversampling factor (amount of samples per symbol).
    %   - nTaps = The filter will have "nTaps + 1" coefficients.
    %
    % Outputs:
    %   - rect = Rectangular pulse. Length will be "nTaps + 1";
    %   - delay = FIR filter delay. Number of samples until the middle 
    %   point of the pulse (delay = nTaps/2).
    arguments(Input)
        L double
        nTaps double
    end
    arguments(Output)
        rect (1,:) double
        delay double
    end
    n = -nTaps/2 : 1 : nTaps/2;  % Sample vector

    rect = (n > -L/2) .* (n <= L/2);

    delay = (length(n)-1)/2; %FIR filter delay
end


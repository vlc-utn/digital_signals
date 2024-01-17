function [rc, delay] = rc_pulse(alpha, L, nTaps)
    %RC_PULSE. Rised Cosine. Returns the shape of the FIR pulse filter.
    %
    % Args:
    %   - alpha = RC frequency slope (0 < beta < 1). 
    %   - L = Oversampling factor (amount of samples per symbol).
    %   - nTaps = The filter will have "nTaps + 1" coefficients.
    %
    % Outputs:
    %   - rc = Rised Cosine. Length will be "nTaps + 1";
    %   - delay = FIR filter delay. Number of samples until the middle 
    %   point of the pulse (delay = nTaps/2).
    arguments(Input)
        alpha double
        L double
        nTaps double
    end
    arguments(Output)
        rc (1,:) double
        delay double
    end
    n = -nTaps/2 : 1 : nTaps/2;  % Sample vector

    % Rised cosine function
    rc = (sin(pi*n/L) ./ (pi*n/L)) .* (cos(pi*alpha*n/L)) ...
        ./ (1 - (2*alpha*n/L).^2);
    
    % Singularities
    rc(ceil(length(n)/2)) = 1;   % raised_cosine(t=0) = 1
    rc(n==L/(2*alpha)) = (alpha/2)*sin(pi/(2*alpha));
    rc(n==-L/(2*alpha)) = (alpha/2)*sin(pi/(2*alpha));

    delay = (length(n)-1)/2; % FIR filter delay
end


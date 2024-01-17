function [srrc, delay] = srrc_pulse(beta, L, nTaps)
    %SRRC_PULSE. Square Root Rised Cosine. Returns the shape of the FIR 
    % pulse filter.
    %
    % Args:
    %   - beta = SRRC frequency slope (0 < beta < 1). 
    %   - L = Oversampling factor (amount of samples per symbol).
    %   - nTaps = The filter will have "nTaps + 1" coefficients.
    %
    % Outputs:
    %   - srrc = Square Root Rised Cosine. Length will be "nTaps + 1";
    %   - delay = FIR filter delay. Number of samples until the middle 
    %   point of the pulse (delay = nTaps/2).
    arguments(Input)
        beta double
        L double
        nTaps double
    end
    arguments(Output)
        srrc (1,:) double
        delay double
    end
    n = -nTaps/2 : 1 : nTaps/2;  % Sample vector

    % SRRC function
    num = sin(pi*n*(1-beta)/L) + ((4*beta*n/L).*cos(pi*n*(1+beta)/L));
    den = pi*n.*(1-(4*beta*n/L).^2)/L;
    srrc = 1/sqrt(L)*num./den;

    % Catch singularities
    srrc(ceil(length(srrc)/2)) = 1/sqrt(L)*((1-beta)+4*beta/pi);
    temp=(beta/sqrt(2*L))*( (1+2/pi)*sin(pi/(4*beta)) + (1-2/pi)*cos(pi/(4*beta)));
    srrc(n==L/(4*beta))=temp; 
    srrc(n==-L/(4*beta))=temp;

    delay = (length(n)-1)/2; %FIR filter delay
end

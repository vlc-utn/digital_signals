function [srrc, delay] = srrc_pulse(beta, L, duration)
    %SRRC_PULSE. Square Root Rised Cosine. Returns the shape of the FIR 
    % pulse filter.
    %
    % Args:
    %   - beta = SRRC frequency slope (0 < beta < 1). 
    %   - L = Oversampling factor (amount of samples per symbol).
    %   - duration = Amount of "Tsym" that the pulse will last before
    %   being truncated. The symbol will last for:
    %       -duration*L     < n < duration*L
    %       -duration*Tsym  < t < duration*Tsym
    %
    % Outputs:
    %   - srrc = Square Root Rised Cosine. Size will be (1, 2*L*duration+1);
    %   - delay = FIR filter delay. Number of samples until the middle 
    %   point of the pulse (delay = L*duration).
    arguments(Input)
        beta double
        L double
        duration double
    end
    arguments(Output)
        srrc (1,:) double
        delay double
    end
    n = - duration*L : 1 : duration*L;  % Sample vector

    % SRRC function
    num = sin(pi*n*(1-beta)/L) + ((4*beta*n/L).*cos(pi*n*(1+beta)/L));
    den = pi*n.*(1-(4*beta*n/L).^2)/L;
    srrc = 1/sqrt(L)*num./den;

    % Catch singularities
    srrc(ceil(length(srrc)/2)) = 1/sqrt(L)*((1-beta)+4*beta/pi);
    temp=(beta/sqrt(2*L))*( (1+2/pi)*sin(pi/(4*beta)) + (1-2/pi)*cos(pi/(4*beta)));
    srrc(n==L/(4*beta))=temp; 
    srrc(n==-L/(4*beta))=temp;

    % FIR filter delay
    delay = (length(srrc)-1)/2; %FIR filter delay
end

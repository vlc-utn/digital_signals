function [a_r, w, n0, error]= zf_equalizer(r, h, nTaps)
    %ZERO_FORCING_EQUALIZER. Generate a ZF equalizer, and apply the result
    % to the received signal.
    %
    % Args:
    %   - r = Received signal.
    %   - h = Impulse response of the channel.
    %   - nTaps = Length of the equalizer. The higher the value, the higher
    %   the delay and computational cost.
    %
    % Outputs:
    %   - a_r = Equalized signal.
    %   - w = Delay optimized zero forcing equalizer.
    %   - n0 = Delay index.
    %   - error = Mean square error.
    arguments(Input)
        r (1,:) double
        h (1,:) double
        nTaps double
    end
    arguments(Output)
        a_r (1,:) double
        w (:, 1)
        n0 double
        error double
    end

    % Get Toeplitz matrix for convolution of "h"
    first_column = zeros(1, length(h) + nTaps - 1);
    first_column(1, 1:length(h)) = h;
    first_row = zeros(1, nTaps);
    first_row(1) = h(1);
    H = toeplitz(first_column, first_row);

    % Get pseudo inverse matrix
    Hp = (H'*H)^-1 * H'; 

    % Get the optimum delay
    [~, n0] = max(diag(H*Hp));
    n0 = n0 - 1;

    % Get delta function with optimum delay
    delta_no = zeros(length(h) + nTaps - 1, 1);
    delta_no(n0+1) = 1;

    % Get equalizer
    w = Hp*delta_no;

    % Get error of the equalizer
    error = 1 - delta_no.'*H*Hp*delta_no;

    % Apply equalizer to signal
    a_r = conv(r, w, "full");
    a_r = a_r(n0 + 1 : 1 : end);   % Apply delay
end
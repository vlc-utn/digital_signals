function [w, n0, error]= zf_equalizer(h,N)
    %ZERO_FORCING_EQUALIZER.
    %
    % Args:
    %   - h = Impulse response of the whole channel (Receiver, channel and
    %   trasmitter).
    %   - N = Length of the equalizer. The higher the value, the higher the
    %   delay and computational cost.
    % Outputs:
    %   - w = Delay optimized zero forcing equalizer.
    %   - n0 = Delay index (as Matlab index)
    %   - error = Mean square error
    arguments(Input)
        h (1,:) double
        N double
    end
    arguments(Output)
        w (:, 1)
        n0 double
        error double
    end

    % Get Toeplitz matrix for convolution of "h"
    first_column = zeros(1, length(h) + N - 1);
    first_column(1, 1:length(h)) = h;
    first_row = zeros(1, N);
    first_row(1) = h(1);
    H = toeplitz(first_column, first_row);

    % Get pseudo inverse matrix
    Hp = (conj(H)'*H)^-1 * conj(H)'; 

    % Get the optimum delay, as a Matlab index.
    [~, n0] = max(diag(H*Hp));

    % Get delta function with optimum delay
    delta_no = zeros(length(h) + N - 1, 1);
    delta_no(n0) = 1;

    % Get equalizer
    w = Hp*delta_no;

    % Get error of the equalizer
    error = 1 - delta_no'*H*Hp*delta_no;
end
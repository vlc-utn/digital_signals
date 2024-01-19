function [a_r, w, n0, error]= mmse_equalizer(r, h, nTaps, EsNo_dB)
    %MINIMUM_MEAN_SQUARE_ERROR_EQUALIZER. Generate a MMSE equalizer, and 
    % apply the result to the received signal.
    %
    % Args:
    %   - r = Received signal.
    %   - h = Impulse response of the whole channel (Receiver, channel and
    %   trasmitter).
    %   - nTaps = Length of the equalizer. The higher the value, the 
    %   higher the delay and computational cost.
    %   - EsNo = SNR (Signal to noise ratio) of the signal, in dB.
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
        EsNo_dB double
    end
    arguments(Output)
        a_r (1,:) double
        w (:, 1) double
        n0 double
        error double
    end

    EsNo = 10^(EsNo_dB/10);

    % Get Toeplitz matrix for convolution of "h"
    first_column = zeros(1, length(h) + nTaps - 1);
    first_column(1, 1:length(h)) = h;
    first_row = zeros(1, nTaps);
    first_row(1) = h(1);
    H = toeplitz(first_column, first_row);

    % Get the optimum delay, as a Matlab index.
    [~, n0] = max(diag(H* (H'*H + eye(nTaps)/EsNo)^-1 * H'));
    n0 = n0 - 1;

    % Get delta function with optimum delay
    delta_no = zeros(length(h) + nTaps - 1, 1);
    delta_no(n0+1) = 1;

    % Get equalizer
    w = (H'*H + eye(nTaps)/EsNo)^-1 * H'*delta_no;

    % Get error of the equalizer
    error = 1 - delta_no.'*H * (H'*H + eye(nTaps)/EsNo)^-1 * H'*delta_no;

    % Apply equalizer to signal
    a_r = conv(r, w, "full");
    a_r = a_r(n0 + 1 : 1 : end);   % Apply delay
end
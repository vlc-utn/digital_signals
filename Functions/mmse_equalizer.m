function [w, n0, error]= mmse_equalizer(h,N, EsNo_dB)
    %MINIMUM_MEAN_SQUARE_ERROR_EQUALIZER.
    %
    % Args:
    %   - h = Impulse response of the whole channel (Receiver, channel and
    %   trasmitter).
    %   - N = Length of the equalizer. The higher the value, the higher the
    %   delay and computational cost.
    %   - EsNo = SNR (Signal to noise ratio) of the signal, in dB
    % Outputs:
    %   - w = Delay optimized zero forcing equalizer.
    %   - n0 = Delay index (as Matlab index)
    %   - error = Mean square error
    arguments(Input)
        h (1,:) double
        N double
        EsNo_dB double
    end
    arguments(Output)
        w (:, 1)
        n0 double
        error double
    end

    EsNo = 10^(EsNo_dB/10);

    % Get Toeplitz matrix for convolution of "h"
    first_column = zeros(1, length(h) + N - 1);
    first_column(1, 1:length(h)) = h;
    first_row = zeros(1, N);
    first_row(1) = h(1);
    H = toeplitz(first_column, first_row);

    % Get pseudo inverse matrix
    Hp = (conj(H)'*H)^-1 * conj(H)'; 

    % Get the optimum delay, as a Matlab index.
    [~, n0] = max(diag(H*(conj(H)'*H + eye(N)/EsNo)^-1*Hp));

    % Get delta function with optimum delay
    delta_no = zeros(length(h) + N - 1, 1);
    delta_no(n0) = 1;

    % Get equalizer
    w = (Hp*H + eye(N)/EsNo)^-1*conj(H)'*delta_no;

    % Get error of the equalizer
    error = 1 - delta_no'*H*(Hp*H + eye(N)/EsNo)^-1*conj(H)'*delta_no;
end
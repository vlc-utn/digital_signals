function [n, N0] = get_wgn(s, EsNo_dB, L)
    %GET_WGN Return the complex white Gaussian noise.
    %
    % Args:
    %   - s = Transmitted signal
    %   - EsNo_dB = Symbol energy / Noise energy, in dB.
    %   - L = Oversampling factor.
    %
    % Outputs:
    %   - n = White Gaussian Noise, of the same size as "s".
    %   - N0 = Noise energy.
    arguments(Input)
        s (1,:) double
        EsNo_dB double
        L double = 1
    end
    arguments(Output)
        n (1,:) double
        N0 double
    end
    % Calculate N0 from EsN0
    EsNo = 10^(EsNo_dB/10);
    Es = L/length(s) * sum(abs(s).^2);
    N0 = Es/EsNo;

    % Calculate WGN
    n = sqrt(N0/2)*(randn(size(s)) + 1i*randn(size(s)));
end
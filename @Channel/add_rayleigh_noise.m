function [r, h_c, N0] = add_rayleigh_noise(s, EsNo_dB, L)
    %ADD_RAYLEIGH_NOISE Adds Rayleigh noise to the signal, as: r = s.*h_c + n.
    %
    % Args:
    %   - s = Transmitted symbols, as complex points.
    %   - EsNo_dB = Symbol energy / Noise energy, in dB.
    %   - L = Oversampling factor.
    %
    % Outputs:
    %   - r = Received symbols, with noise added.
    %   - h_c = Rayleigh channel impulse response.
    %   - N0 = Noise energy.
    arguments(Input)
        s (1,:) double
        EsNo_dB double
        L double = 1
    end
    arguments(Output)
        r (1,:) double
        h_c (1,:) double
        N0 double
    end
    h_c = 1/sqrt(2)*(randn(size(s)) + 1i*randn(size(s)));
    [n, N0] = Channel.get_wgn(s, EsNo_dB, L);
    r = s.*h_c + n;
end
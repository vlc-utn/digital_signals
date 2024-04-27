function [r, h_c, N0] = add_awgn_noise(s, EsNo_dB, L, h_c)
    %ADD_AWGN_NOISE Adds AWGN (Additive White Gaussian Noise) to the
    % signal, as: r = conv(s,h_c) + n.
    % If "h_c" is not given, or is a scalar, then: r = s.*h_c + n.
    %
    % Args:
    %   - s = Transmitted symbols, as complex points.
    %   - EsNo_dB = Symbol energy / Noise energy, in dB.
    %   - L = Oversampling factor.
    %   - h_c = (Optional) Channel impulse response.
    %
    % Outputs:
    %   - r = Received symbols, with noise added.
    %   - h_c = Channel impulse response.
    %   - N0 = Noise energy.
    arguments(Input)
        s (:,:) double
        EsNo_dB double
        L double = 1
        h_c (1,:) double = 1
    end
    arguments(Output)
        r (:,:) double
        h_c (1,:) double
        N0 double
    end
    r = conv2(s, h_c, "full");
    [n, N0] = Channel.get_wgn(r, EsNo_dB, L);
    r = r + n;
    if (length(h_c) == 1)
        h_c = h_c*ones(1, width(s));
    end
end
function [r, h_c, N0] = add_ricean_noise(s, EsNo_dB, L, PlosPnlos_dB)
    %ADD_RICEAN_NOISE Adds Rayleigh noise to the signal, as: r = s.*h_c + n.
    %
    % Args:
    %   - s = Transmitted symbols, as complex points.
    %   - EsNo_dB = Symbol energy / Noise energy, in dB.
    %   - L = Oversampling factor.
    %   - PlosPnlos_dB = Relationship between the power of the LOS 
    %   component and power of the NLOS component.
    %
    % Outputs:
    %   - r = Received symbols, with noise added.
    %   - h_c = Ricean channel impulse response.
    %   - N0 = Noise energy.
    arguments(Input)
        s (1,:) double
        EsNo_dB double
        L double
        PlosPnlos_dB double
    end
    arguments(Output)
        r (1,:) double
        h_c (1,:) double
        N0 double
    end
    k = 10^(PlosPnlos_dB/10);
    u = sqrt(k/(2*(k+1)));      % Mean of normal distribution
    sigma = sqrt(1/(2*(k+1)));  % Standard devaiton of normal distribution
    h_c = (sigma*randn(size(s)) + u) + 1i*(sigma*randn(size(s)) + u);
    [n, N0] = Channel.get_wgn(s, EsNo_dB, L);
    r = s.*abs(h_c) + n;
    r = r./abs(h_c);        % Filter that compensates channel attenuation
end
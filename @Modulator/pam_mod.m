function [u, constellation] = pam_mod(d, M)
    %PAM_MOD Pulse Amplitude Modulation
    %
    % Args:
    %   - d = Input Symbols. Values should be between [0, M-1].
    %   - M = Modulation order. Amount of symbols.
    %
    % Outputs:
    %   - u = Modulated symbols as complex points.
    %   - constellation = Reference constellation used.
    arguments (Input)
        d (1,:) double
        M double
    end
    arguments (Output)
        u (1,:) double
        constellation (1,:) double
    end
    m = 1:1:M;
    constellation = complex(2*m - 1 - M);
    u = constellation(d+1);
end
function [u, constellation] = qam_mod(d, M)
    %QAM_MOD Pulse Amplitude Modulation
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
    if(((M~=1) && ~mod(floor(log2(M)),2))==0) % M not a even power of 2
        error('Only Square QAM supported. M must be even power of 2');
    end
    constellation = Modulator.constructQAM(M); %construct reference constellation
    u = constellation(d+1);
end
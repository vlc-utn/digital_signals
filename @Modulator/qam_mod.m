function [s, constellation] = qam_mod(this, x)
    %QAM_MOD Pulse Amplitude Modulation
    % Args:
    %   this = Modulator class reference.
    %   x = Input Symbols. Values should be between [0, M-1].
    % Outputs:
    %   s = Modulated symbols as complex points.
    %   constellation = Reference constellation used.
    arguments (Input)
        this Modulator
        x (1,:) int32
    end
    arguments (Output)
        s (1,:) double
        constellation (1,:) double
    end
    if(((this.M~=1) && ~mod(floor(log2(this.M)),2))==0) % M not a even power of 2
        error('Only Square QAM supported. M must be even power of 2');
    end
    constellation = this.constructQAM(this.M); %construct reference constellation
    s = constellation(x+1);
end
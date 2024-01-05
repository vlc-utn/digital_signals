function [s, constellation] = modulate(this, x)
    %MODULATE Modulate symbol stream "x", according to the modulator
    % specifications set in the constructor.
    % Args:
    %   this = Modulator class reference.
    %   x = Input Symbols. Values should be between [0, M-1].
    % Outputs:
    %   s = Modulated symbols as complex points.
    %   constellation = Reference constellation used.
    if (this.UseCommToolbox)
        switch this.ModType
            case ModulationTypes.QAM
                s = qammod(x, this.M);
                constellation = qammod(0:1:this.M-1, this.M);
            case ModulationTypes.PAM
                s = pammod(x, this.M);
                constellation = pammod(0:1:this.M-1, this.M);
            case ModulationTypes.PSK
                s = pskmod(x, this.M);
                constellation = pskmod(0:1:this.M-1, this.M);
            otherwise
                error("Unknown Modulation type.");
        end
    else
        switch this.ModType
            case ModulationTypes.QAM
                [s, constellation] = this.qam_mod(x);
            case ModulationTypes.PAM
                [s, constellation] = this.pam_mod(x);
            case ModulationTypes.PSK
                [s, constellation] = this.psk_mod(x);
            otherwise
                error("Unknown Modulation type.");
        end
    end
end 
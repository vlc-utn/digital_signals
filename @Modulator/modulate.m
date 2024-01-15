function [u, constellation] = modulate(d, mod_type, M, use_comm_toolbox)
    %MODULATE Modulate symbol stream "d", using the modulation ModType,
    % with "M" symbols.
    %
    % Args:
    %   - d = Input Symbols. Values should be between [0, M-1].
    %   - ModType = modulation type ["QAM", "PAM", "PSK", etc]
    %   - M = Modulation order. Amount of symbols.
    %   - use_comm_toolbox = (optional). Use Matlab's communication
    %   toolbox.
    % Outputs:
    %   - u = Modulated symbols as complex points.
    %   - constellation = Reference constellation used.
    arguments(Input)
        d (1,:) double
        mod_type ModulationTypes
        M double
        use_comm_toolbox logical = false
    end
    arguments(Output)
        u (1,:) double
        constellation (1,:) double
    end

    if (use_comm_toolbox)
        switch mod_type
            case ModulationTypes.QAM
                u = qammod(d, M);
                constellation = qammod(0:1:M-1, M);
            case ModulationTypes.PAM
                u = pammod(d, M);
                constellation = pammod(0:1:M-1, M);
            case ModulationTypes.PSK
                u = pskmod(d, M);
                constellation = pskmod(0:1:M-1, M);
            otherwise
                error("Unknown Modulation type.");
        end
    else
        switch mod_type
            case ModulationTypes.QAM
                [u, constellation] = Modulator.qam_mod(d, M);
            case ModulationTypes.PAM
                [u, constellation] = Modulator.pam_mod(d, M);
            case ModulationTypes.PSK
                [u, constellation] = Modulator.psk_mod(d, M);
            otherwise
                error("Unknown Modulation type.");
        end
    end
end 
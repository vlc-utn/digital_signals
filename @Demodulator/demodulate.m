function d_r = demodulate(u_r, mod_type, M, constellation, use_comm_toolbox)
    %DEMODULATE Convert an array of complex mapped points into digital
    % symbols.
    %
    % Args:
    %   - u_r = Vector of complex points, after equalization.
    %   - mod_type = Modulation type.
    %   - M = Modulation order. Amount of symbols.
    %   - constellation = Digital symbols mapped as complex points.
    %   - use_comm_toolbox = (optional) If "true", will use Matlab's
    %   communication toolbox functions.
    % Outputs:
    %   - d_r = Received Digital symbols.
    arguments(Input)
        u_r (:,:) double
        mod_type ModulationTypes
        M double
        constellation (1,:) double
        use_comm_toolbox logical = false
    end
    arguments(Output)
        d_r (:,:) double
    end
    if(use_comm_toolbox)
        switch mod_type
            case ModulationTypes.QAM
                d_r = qamdemod(u_r, M);
            case ModulationTypes.PAM
                d_r = pamdemod(u_r, M);
            case ModulationTypes.PSK
                d_r = pskdemod(u_r, M);
            otherwise
                error("Unknown Modulation type.");
        end
    else
        d_r = Demodulator.find_minimum_symbol_distance(u_r, constellation);
    end
end
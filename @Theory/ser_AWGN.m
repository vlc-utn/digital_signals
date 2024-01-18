function ser = ser_AWGN(mod_type, M, EsNo_dB)
    %SER_AWGN Return the theoretical ser (symbol error rate),
    % for the given modulation and EsNo value.
    %
    % Args:
    %   mod_type = Modulation type.
    %   M = Number of symbols.
    %   EsNo_dB = Vector of EsNo values.
    % Outputs:
    %   ser = Symbol error rate.
    arguments (Input)
        mod_type ModulationTypes
        M double
        EsNo_dB (1,:)
    end
    arguments (Output)
        ser (1,:)
    end

    EsNo = 10.^(EsNo_dB/10);
    EbNo = EsNo/log2(M);
    
    switch mod_type
    case ModulationTypes.PSK
        if M == 2   % BPSK
            ser = 0.5*erfc(sqrt(EbNo));
        elseif M==4 % for QPSK
            ser = erfc(sqrt(EbNo)) - 0.5*erfc(sqrt(EbNo)).^2;
        else        % for other higher order M-ary PSK
            ser=erfc(sqrt(EsNo)*sin(pi/M));
        end

    case ModulationTypes.QAM
        ser = 1 -(1-(1-1/sqrt(M))*erfc(sqrt(3/2*EsNo/(M-1)))).^2;

    case ModulationTypes.PAM
        ser=2*(1-1/M)*0.5*erfc(sqrt(3*EsNo/(M^2-1)));
    otherwise
        error('theoretical_ser_AWGN.m: Invalid modulation (MOD_TYPE) selected');
    end
end


function ser = ser_rayleigh(mod_type, M, EsNo_dB)
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
            ser = 0.5*(1-sqrt(EbNo/(1+EbNo)));
        else
            ser = zeros(size(EsNo));
            g = sin(pi/M).^2;
            for i=1:length(EsNo) 
                fun = @(x) 1./(1+(g.*EsNo(i)./(sin(x).^2))); % Moment generating function (MGF)
                ser(i) = (1/pi)*integral(fun,0,pi*(M-1)/M);
            end
        end

    case ModulationTypes.QAM
        ser = zeros(size(EsNo));
        for i=1:length(EsNo)
            g = 1.5/(M-1);
            fun = @(x) 1./(1+(g.*EsNo(i)./(sin(x).^2))); % Moment generating function (MGF)
            ser(i) = 4/pi*(1-1/sqrt(M))*integral(fun,0,pi/2)-4/pi*(1-1/sqrt(M))^2*integral(fun,0,pi/4);
        end

    case ModulationTypes.PAM
        ser = zeros(size(EsNo));
        for i=1:length(EsNo)
            g = 3/(M^2-1);
            fun = @(x) 1./(1+(g.*EsNo(i)./(sin(x).^2))); % Moment generating function (MGF)
            ser(i) = 2*(M-1)/(M*pi)*integral(fun,0,pi/2);
        end
    otherwise
        error('theoretical_ser_AWGN.m: Invalid modulation (MOD_TYPE) selected');
    end
end
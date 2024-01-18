classdef Theory
    %THEORY All theoretical calculations, independant of the received or
    %transmitted signals.
    
    properties
    end
    
    methods
        function this = Theory()
            %THEORY Empty constructor. Used as NameSpace
        end
    
    end

    methods(Static)
        % Channel capacity
        C_max = maximum_channel_capacity(EsNo_dB)
        C_pdf = channel_capacity_from_pdf(u_r, constellation, h_c, EsNo_dB)

        % Symbol error rate
        ser = ser_ricean(mod_type, M, EsNo_dB, PlosPnlos_dB)
        ser = ser_rayleigh(mod_type, M, EsNo_dB)
        ser = ser_AWGN(mod_type, M, EsNo_dB)
    end
end


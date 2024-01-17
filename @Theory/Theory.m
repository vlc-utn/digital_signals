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
        C_max = maximum_channel_capacity(EsNo_dB)
        C_pdf = channel_capacity_from_pdf(u_r, constellation, h_c, EsNo_dB)
    end
end


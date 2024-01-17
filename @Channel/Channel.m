classdef Channel < handle
    %CHANNEL Modelates differents types of channels and their noise.

    properties
    end
    
    methods (Access = public)
        function this = Channel()
            %CHANNEL Empty constructor. Class is used as NameSpace
        end
    end

    methods(Static)
        [n, N0] = get_wgn(s, EsNo_dB, L)
        [r, h_c, N0] = add_awgn_noise(s, EsNo_dB, L, h_c)
        [r, h_c, N0] = add_rayleigh_noise(s, EsNo_dB, L)
        [r, h_c, N0] = add_ricean_noise(s, EsNo_dB, L, PlosPnlos_dB)
    end
end


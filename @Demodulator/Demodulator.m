classdef Demodulator
    %DEMODULATOR Digital demodulator. This class encompasses all the
    %functionality needed for a receiver to work properly.
    
    properties   
    end
    
    methods (Access = public)
        function this = Demodulator()
            %DEMODULATOR Empty contructor. Used as NameSpace.
        end
    end

    methods(Static)
        % Equalizers
        [a_r, w] = flat_fading_equalizer(r, h_tx, delay_tx, h_c, h_rx, delay_rx, L)
        [a_r, w, n0, error]= zf_equalizer(r, h, nTaps)
        [a_r, w, n0, error]= mmse_equalizer(r, h, nTaps, EsNo_dB)

        % Each method represents a functionality from the receiver
        [v_r, g, delay] = pulse_filter_srrc(a_r, beta, L, nTaps)
        u_r = downsample(v_r, L, delay)
        d_r = demodulate(u_r, mod_type, M, constellation, use_comm_toolbox)

        % Defects
        z = receiver_impairments(r, g, phi, dc_i, dc_q)
        w = blind_iq_compensation(z, constellation)

        % Utility
        d_r = find_minimum_symbol_distance(a_r, constellation)
    end
end


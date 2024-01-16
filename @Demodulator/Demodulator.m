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
        % Each method represents a functionality from the receiver
        [v_r, p, delay] = pulse_filter_srrc(r, beta, L, duration)
        u_r = downsample(v_r, L, delay)
        d_r = demodulate(a_r, mod_type, M, constellation, use_comm_toolbox)
        
        % Utility
        d_r = find_minimum_symbol_distance(a_r, constellation)
    end
end


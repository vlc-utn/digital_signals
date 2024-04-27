classdef Modulator
    %MODULATOR Digital modulator. This class encompasses all the
    %functionality needed for a transmitter to work properly.
    
    properties            
    end
    
    methods (Access = public)
        function this = Modulator()
        %MODULATOR Empty constructor. Used as a NameSpace.
        end

    end

    methods(Static)
        % Each method represents a functionality from the transmitter
        [u, constellation] = modulate(d, mod_type, M, use_comm_toolbox)
        v = upsample(u, L)
        [s, p, delay] = pulse_shaping_srrc(v, beta, L, nTaps)

        [u, U, s] = ofdm(d, constellation, Ncp)

        % Modulation types
        [u, constellation] = pam_mod(d, M)
        [u, constellation] = psk_mod(d, M)
        [u, constellation] = qam_mod(d, M)
        [ref,varargout] = constructQAM(M)
        [grayCoded]=dec2gray(decInput)

        % Pulse shaping
        [srrc, delay] = srrc_pulse(beta, L, nTaps)
        [rc, delay] = rc_pulse(alpha, L, nTaps)
        [sinc_p, delay] = sinc_pulse(L, nTaps)
        [rect, delay] = rect_pulse(L, nTaps)
    end
end


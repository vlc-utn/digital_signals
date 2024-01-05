function [s, constellation] = psk_mod(this, x)
    %PSK_MOD Pulse Amplitude Modulation
    % Args:
    %   this = Modulator class reference.
    %   x = Input Symbols. Values should be between [0, M-1].
    % Outputs:
    %   s = Modulated symbols as complex points.
    %   constellation = Reference constellation used.
    arguments (Input)
        this Modulator
        x (1,:) int32
    end
    arguments (Output)
        s (1,:) double
        constellation (1,:) double
    end
    m = 1:1:this.M;
    constellation= (cos((m-1)*2*pi/this.M) + 1i*sin((m-1)*2*pi/this.M));
    s = constellation(x+1);
end
function u_r = downsample(v_r, L, delay)
    %DOWNSAMPLE. Given the pulse shaped received symbols "v_r", this
    % function will read and return only the values of the samples that
    % correspond to the symbols, discarding the rest.
    %
    % Args:
    %   - v_r = Pulse shaped received samples
    %   - L = Oversampling factor.
    %   - delay = Digital delay imposed by the transmitter and receiver FIR
    %   filters.
    %
    % Outputs:
    %   - u_r = Complex points received.
    arguments(Input)
        v_r (1,:) double
        L double
        delay double
    end
    arguments(Output)
        u_r (1,:) double
    end
    
    u_r = v_r(delay+1 : L : end - delay);
end
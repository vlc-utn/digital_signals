function z = receiver_impairments(r, g, phi, dc_i, dc_q)
    %RECEIVER_IMPAIRMENTS Simulate the receiver's defects.
    %
    % Args:
    %   - r = Received signal, before passing for the IQ receiver.
    %   - g = Gain mismatch [times].
    %   - phi = Phase mismatch [°].
    %   - dc_i = DC offset for the In-Phase branch.
    %   - dc_q = DC offset for the Quadrature branch.
    %   
    % Outputs:
    %   - z = Received signal, after the IQ receiver.
    %
    arguments(Input)
        r (1,:) double
        g double = 1
        phi double = 0
        dc_i double = 0
        dc_q double = 0
    end
    arguments(Output)
        z (1,:) double
    end
    % Phase imbalance and crosstalk
    z_i = real(r);
    z_q = -g*sind(phi)*real(r) + g*cosd(phi)*imag(r);

    % DC offset
    z_i = z_i + dc_i;
    z_q = z_q + dc_q;

    z = z_i + 1i*z_q;
end
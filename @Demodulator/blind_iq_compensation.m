function w = blind_iq_compensation(z, constellation)
    %BLIND_IQ_COMPENSATION Function to estimate and compensate IQ 
    % impairments for the single-branch IQ impairment model.
    %
    % Args:
    %   - z = Impaired signal from the IQ receiver.
    %   - constellation = Symbol complex mapping usedby the transmitter.
    %
    % Outputs:
    %   - w = Compensated signal
    arguments(Input)
        z (1,:) double
        constellation (1,:) double = 0
    end
    arguments(Output)
        w (1,:) double
    end
    z_i = real(z);
    z_q = imag(z);

    % Compensate DC offset first (assuming
    z_i = z_i - (mean(z_i) - mean(real(constellation)));
    z_q = z_q - (mean(z_q) - mean(imag(constellation)));

    % Calculate parameters
    theta1 = (-1)*mean(sign(z_i).*z_q);
    theta2 = mean(abs(z_i));
    theta3 = mean(abs(z_q));

    % Calculate coefficients
    c1 = theta1/theta2;
    c2 = sqrt(theta3^2-theta1^2) / theta2;

    % Compensate signal
    w_i = z_i;
    w_q = (c1*z_i + z_q) / c2;
    w= w_i +1i*w_q;
end
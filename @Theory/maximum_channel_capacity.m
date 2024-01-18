function C_max = maximum_channel_capacity(EsNo_dB, h_c)
    %MAXIMUM_CHANNEL_CAPACITY Returns theoretical channel capacity, using
    % the Shannon's formula: C = log2(1 + EsNo)
    %
    % Args:
    %   - EsNo_dB
    %   - h_c = Flat fading channel response
    %   
    % Outputs:
    %   - C_max = Maximum channel capacity.
    arguments(Input)
        EsNo_dB (1,:) double
        h_c (1,:) double = [1, 1]
    end
    arguments(Output)
        C_max double
    end
    EsNo = 10.^(EsNo_dB/10);

    % This expression is a matrix where each column represents, for an EsNo
    % value, all possible values for the channel capacity "C_max". Then,
    % the mean is done for each column, getting the mean value of the
    % channel capacity.
    C_max = mean(log2(1 + (abs(h_c).^2).' * EsNo./mean(abs(h_c).^2) ));
end


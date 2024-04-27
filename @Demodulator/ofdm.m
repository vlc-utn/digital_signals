function [U_r, u_r, d_r] = ofdm(r, constellation, Ncp)
    %OFDM Receive and demodulate an OFDM transmision
    %
    % Args:
    %   - r = Received symbols.
    %   - constellation
    %   - Ncp = Number of symbols used for cyclic prefix.
    %
    % Outputs:
    %   - U_r = Signal received after removing the cyclic prefix.
    %   - u_r = FFT(U_r)
    %   - d_r = Demodulation of the signal, using the constellation.

    U_r = r(:, Ncp+1 : end); % Remove cyclic prefix
    u_r = fft(U_r, [], 2);
    d_r = Demodulator.demodulate(u_r, ModulationTypes.QAM, length(constellation), constellation);
end


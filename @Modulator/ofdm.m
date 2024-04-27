function [u, U, s] = ofdm(d, constellation, Ncp)
    %OFDM Modulate a signal using OFDM.
    %
    % Args:
    %   - d = Input Symbols. Width(d) is the number of subcarriers.
    %   Height(d) is the number of OFDM symbols to transmit.
    %   - constellation = QAM constellation used for codification.
    %   - Ncp = Number of elements for cyclic prefix.
    %
    % Outputs:
    %   - u = Modulated symbols, using the "constellation" argument.
    %   - U = IFFT(u).
    %   - s = U, but with cyclic prefix added.
    u = constellation(d+1);
    U = ifft(u, [], 2);
    s = [U(:, end - Ncp + 1 : end) U]; % Add cyclic prefix
end


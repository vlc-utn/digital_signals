function C_pdf = channel_capacity_from_pdf(u_r, constellation, h_c, N0)
    %CHANNEL_CAPACITY_FROM_PDF Calculate the channel capacity using the
    % normal PDF (probability density function). This function only works
    % for flat fading channels (AWGN, Rayleigh or Ricean).
    %
    % Args:
    %   - u_r = Received complex point symbols (before demodulation).
    %   - constellation = Transmitted complex constellation.
    %   - h_c = Flat fading channel response. Should be same size as "u_r".
    %   - N0 = Noise energy.
    %
    % Outputs:
    %   - C_pdf = Channel capacity, using the pdf formula.
    %
    arguments(Input)
        u_r (1,:) double
        constellation (1,:) double
        h_c (1,:) double
        N0 double
    end
    arguments(Output)
        C_pdf double
    end
    M = length(constellation);      % Amount of symbols
    Hx = log2(M);                   % Ideal input symbol entropy

    
    % Note: We are using this as the standard deviation of the normal
    % distribution because after the equalization, the expresion ends up
    % being: r = s + n/||h||^2
    sigma_squared = N0 ./ abs(h_c).^2;

    % Probability density function for normal distribution
    pdfs = exp(-(abs(ones(M,1)*u_r - constellation.'*ones(1,length(u_r))).^2) ./ sigma_squared);
    prob_yx = max(pdfs, realmin);                   % probability of each constellation points
    prob_yx = prob_yx ./ (ones(M,1)*sum(prob_yx));  % normalize probabilities
    Hyx = -mean(sum(prob_yx.*log2(prob_yx)));       % Conditional entropy
    C_pdf = Hx - Hyx;
end


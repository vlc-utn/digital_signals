function a_r = flat_fading_equalizer(r, h_c)
    %FLAT_FADING_EQUALIZER Given that the signal was affected by a flat
    % fading channel as: 
    %   r = s.*h_c + n.
    % By multiplying by the complex conjugate and dividing by the norm, we
    % get the same singal as before:
    %   a_r = s + n .* conj(h_c)/|h_c|^2
    % This function doesn't work as a normal equalizer, because the channel
    % response is actually a FIR filter with length "1" h = h[0], but the
    % tap value is a random variable.
    %
    % Args:
    %   - r = Received signal, before applying the matched pulse filter.
    %   - h_c = Channel response.
    %
    % Outputs:
    %   - a_r = Equalized received signal.
    a_r = r .* conj(h_c) ./ (abs(h_c).^2);
end


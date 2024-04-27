function d_r = find_minimum_symbol_distance(a_r, constellation)
    %FIND_MINIMUM_SYMBOL_DISTANCE Returns the digital symbol associated
    % with the closest point of the contellation to "a_r".
    %
    % Args:
    %   - a_r = Vector with complex points.
    %   - constellation = Complex constellation, used for modulation.
    %   
    % Outputs:
    %   - d_r = Received digital symbols.
    arguments(Input)
        a_r (:,:) double
        constellation (1,:) double
    end
    arguments(Output)
        d_r (:,:) double
    end
    d_r = zeros(size(a_r));
    constellation_matrix = repmat(constellation, width(a_r), 1).';

    for i=1:1:height(a_r)
        x = repmat(a_r(i,:), height(constellation_matrix), 1);
        distance = abs(constellation_matrix - x);
        [~, d_r(i,:)] = min(distance, [], 1);
    end

    d_r = d_r -1;
end
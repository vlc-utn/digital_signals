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
        a_r (1,:) double
        constellation (1,:) double
    end
    arguments(Output)
        d_r (1,:) double
    end
    d_r = zeros(1,length(a_r));
    for i=1:length(a_r)
        distance = abs(constellation - a_r(i));
        [~, d_r(i)] = min(distance);
    end
    d_r = d_r -1;
end
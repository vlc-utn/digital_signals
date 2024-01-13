function C = channel_capacity(M,x,y)
    %CHANNEL_CAPACITY Get the channel capacity C [bits/symbol] for digital
    % transmitted symbols "x" and digital received symbols "y".
    %
    % Args:
    %   - M = Number of symbols.
    %   - x = Digital transmitted symbols, from [0;M-1].
    %   - y = Digital received symbols, from [0;M-1].
    %
    % Outputs:
    %   - C = Channel capacity in [bits/symbol].
    arguments (Input)
        M double
        x (1,:) int32
        y (1,:) int32
    end
    arguments (Output)
        C double
    end
    [Hx, Hy, Hxy] = Scope.entropy(M,x,y);
    C = Hx + Hy - Hxy;

    % Alternate expression for channel capacity, as seen in the theory
    %     [Px, Py, Pxy, Py_x, Px_y] = Scope.probability(M,x,y);
    %     expression = (Px*ones(1,M))' .* Py_x .* (log2(Py_x ./ (Py*ones(1,M)) ));
    %     C = sum(sum(expression));
end

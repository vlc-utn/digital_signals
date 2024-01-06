function [Px, Py, Pxy, Py_x, Px_y] = probability(M, x, y)
    %PROBABILITY Get all probabilities related to the signals "x" and "y".
    % The probability matrices are as follows, for M = 3:
    %   
    %   Px = [ P(x0) ]      Py = [ P(y0) ]
    %        [ P(x1) ]           [ P(y1) ]
    %        [ P(x2) ]           [ P(y2) ]
    %
    %   Pxy = [ P(x0,y0) P(x0,y1) P(x0,y2) ]
    %         [ P(x1,y0) P(x1,y1) P(x1,y2) ]
    %         [ P(x2,y0) P(x2,y1) P(x2,y2) ]
    %
    %   Py_x = [ P(y0|x0) P(y0|x1) P(y0|x2) ]
    %          [ P(y1|x0) P(y1|x1) P(y1|x2) ]
    %          [ P(y2|x0) P(y2|x1) P(y2|x2) ]
    %
    %   Px_y = [ P(x0|y0) P(x0|y1) P(x0|y2) ]
    %          [ P(x1|y0) P(x1|y1) P(x1|y2) ]
    %          [ P(x2|y0) P(x2|y1) P(x2|y2) ]
    %
    % Args:
    %   - M = Number of symbols.
    %   - x = Digital transmitted symbols, from [0;M-1].
    %   - y = (optional) Digital received symbols, from [0;M-1].
    %
    % Outputs:
    %   - Px = Probability for each transmitted symbol.
    %   - Py = Probability for each received symbol.
    %   - Pxy = Probability of the intersection for each transmitted and
    %   received symbol P(x,y).
    %   - Py_x = Conditional probability P(Y|X).
    %   - Px_y = Conditional probability P(X|Y).
    arguments (Input)
        M double
        x (1,:) double
        y (1,:) = 0
    end
    arguments (Output)
        Px (:,1) double
        Py (:,1) double
        Pxy (:,:) double
        Py_x (:,:) double
        Px_y (:,:) double
    end

    symbols = 0:1:M;
    
    % Get probability of each symbol in "x"
    Px = zeros(M, 1);
    for i = 1:1:M
        Px(i) = sum(x==symbols(i)) / length(x);
    end

    if (nargin == 2)
        return
    end

    % Get probability of each symbol in "y"
    Py = zeros(M, 1);
    for i = 1:1:M
        Py(i) = sum(y==symbols(i)) / length(y);
    end
    
    % Get intersection probability P(x,y)
    Pxy = zeros(M, M);
    for i = 1:1:M % For each input symbol
        for j = 1:1:M % For each output symbol
            for k = 1:1:length(x) % For each element
                Pxy(i,j) = Pxy(i,j) + (y(k)==symbols(j) && x(k)==symbols(i));
            end
            Pxy(i,j) = Pxy(i,j) / length(x);
            Pxy(i,j) = max(Pxy(i,j), realmin);  % Avoids "NaN" values.
        end
    end

    if (nargout < 3)
        return
    end
    
    % Get conditional probability P(y|x)
    Py_x = (Pxy ./ ( Px*ones(1,M)) )';

    % Get conditional probability P(x|y)
    Px_y = Pxy ./ (Py*ones(1,M))';
end

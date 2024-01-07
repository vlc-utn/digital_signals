function [Hx, Hy, Hxy] = entropy(M, x, y)
    %ENTROPY Return the entropy of the digital symbols "x" and "y". 
    % If only "x" is specified, then only the entropy "Hx" will be returned.
    % Formula for entropy is:
    %   H(X) = -Sum_x { P(x)*log2(P(x)) }
    %
    % Args:
    %   - M = Number of symbols.
    %   - x = Digital transmitted symbols, from [0;M-1].
    %   - y = (optional) Digital received symbols, from [0;M-1].
    %
    % Outputs:
    %   - Hx = Entropy of the transmitted signal.
    %   - Hy = Entropy of the received signal.
    %   - Hxy = Entropy of the intersection of both signals.
    arguments (Input)
        M double
        x (1,:) int32
        y (1,:) int32 = 0
    end
    arguments (Output)
        Hx double
        Hy double
        Hxy double
    end

    if (nargin == 2)
        % Calculate entropy for one random variable as:
        % H(X) = -Sum_x { P(x)*log2(P(x)) }
        Px = probability(M, x);
        Hx = -sum(Px.*log2(Px));

    elseif (nargin == 3)
        % Calculate entropy input, output and intersection as:
        % H(X) = -Sum_x { P(x)*log2(P(x)) }
        % H(Y) = -Sum_y { P(y)*log2(P(y)) }
        % H(X,Y) = -Sum_x Sum_y { P(x,y) * log2(P(x,y) }
        [Px, Py, Pxy] = probability(M,x,y);

        % Make any probability non zero, to avoid errors with the logarithm
        Px = max(Px, realmin);
        Py = max(Py, realmin);
        Pxy = max(Pxy, realmin);

        % Get entropies
        Hx = -sum(Px.*log2(Px));
        Hy = -sum(Py.*log2(Py));
        Hxy = -sum(sum(Pxy.*log2(Pxy)));        
    end
end
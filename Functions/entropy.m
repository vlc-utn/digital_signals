function H = entropy(M, x, y)
    %ENTROPY Return the entropy of the digital signal.
    arguments
        M double
        x (1,:) int32
        y (1,:) int32 = 0
    end
    symbols = 0:1:M-1;
    
    % Get probability of each symbol in "x"
    Px = zeros(1, M);
    for i = 1:1:M
        Px(i) = sum(x==symbols(i)) / length(x);
    end

    if (nargin == 2)
        % Calculate entropy for one random variable
        % H(X) = -Sum_x { P(x)*log2(P(x)) }
        H = -sum(Px.*log2(Px));
    end

    if (nargin == 3)
        % Calculate entropy for the intersection of both variables
        % H(X,Y) = -Sum_x Sum_y { P(x,y) * log2(P(x,y) }
        % With P(x,y) = P(y|x)*P(x)

        % Row "i" and column "j" represent values for P(yj, xi)
        Pyx = zeros(M, M);
        for i = 1:1:M
            for j = 1:1:M
                for k = 1:1:length(x)
                    Pyx(i,j) = Pyx(i,j) + (y(k)==symbols(j) && x(k)==symbols(i));
                end
                Pyx(i,j) = Pyx(i,j) / length(x);
                Pyx(i,j) = max(Pyx(i,j), realmin);
            end
        end

        H = -sum(sum(Pyx.*log2(Pyx)));
    end
end
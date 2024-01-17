function v = upsample(u, L)
    %UPSAMPLE Given an input vector "u", return the same vector, but with
    % "L-1" zeros in between symbol. 
    %
    % Args:
    %   - u = Complex plane mapped symbols.
    %   - L = Oversampling factor (samples / symbols).
    %
    % Outputs:
    %   - v = Oversampled symbols (same as "u", but with "L-1" zeros in
    %   between symbols).
    arguments(Input)
        u (1,:) double
        L double
    end
    arguments(Output)
        v (1,:) double
    end

    % Matrix with first row "u", and L-1 rows with zeros.
    v = [u; zeros(L-1,length(u))]; 

    % Concatenate each column to create a single column vector, and 
    % traspose.
    v = v(:).';
end


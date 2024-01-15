classdef Scope
    %SCOPE This class encompasses all plotting functions and data analisys
    % done on the signals at any stage of the transmission.
    % 
    % This class is used as a namespace.
    
    properties
        % Empty properties
    end
    
    methods
        function this = Scope()
            %SCOPE Empty constructor
        end
    end

    methods(Static)
        [Px, Py, Pxy, Py_x, Px_y] = probability(M, x, y)
        [Hx, Hy, Hxy] = entropy(M, x, y)
        C = channel_capacity(M,x,y)

        % All plots
        eye = plot_eye_diagram(v_r, L, delay, trace_length, trace_qtty)
        plot_constellation(constellation)
        plot_IQ(points)
    end
end


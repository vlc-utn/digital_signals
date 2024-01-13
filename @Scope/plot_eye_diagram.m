% TODO
function eye = plot_eye_diagram(v_r, L, delay, trace_length, trace_qtty)
    %PLOT_EYE_DIAGRAM
    %
    % Args:
    %   - v_r = Received pulse shaped symbols.
    %   - L = Oversampling factor (how many samples per symbol).
    %   - delay = FIR delay from both receiver and transmitter (should be
    %   2*duration*L.
    %   - trace_length = Amount of symbols to plot in the same eye diagram.
    %   - trace_qtty = Amount of traces to overlap in the same eye diagram.
    % Outputs:
    %   - eye (trace_length*L, trace_qtty) = matrix where each column 
    %   represents a trace, and there are as many columns as "trace_qtty".
    %
    arguments(Input)
        v_r (1,:) double
        L double
        delay double
        trace_length double = 3
        trace_qtty double = 100
    end
    arguments(Output)
        eye (:,:)
    end

    % "Tsym" equals "L" samples.
    symbol_length = L;
    trace_length = trace_length*symbol_length;

    % Time vector, as: 0 < t < N*Tsym
    t = (0 : 1 : (trace_length-1)) / symbol_length;

    % Create a matrix where each column represents a pulse signal, 
    % and there are "pulse_qtty" rows.
    eye = reshape(v_r(delay+1 : delay + trace_length*trace_qtty), trace_length, trace_qtty);
    
    plot(t, eye)
    title('Eye diagram'); 
    xlabel('t/T_{sym}');
    ylabel('Amplitude');
end
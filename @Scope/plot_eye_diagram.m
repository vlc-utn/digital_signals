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
        trace_length double = 1
        trace_qtty double = 100
    end
    arguments(Output)
        eye (:,:)
    end

    samples_per_screen = L*trace_length;
    t = (-samples_per_screen/2 : 1 : samples_per_screen/2) / L;

    % Create a matrix where each column represents a pulse signal, 
    % and there are "pulse_qtty" columns.
    eye = reshape(v_r(delay+1 + samples_per_screen/2 : ...
        delay + samples_per_screen*trace_qtty + samples_per_screen/2), ...
        samples_per_screen, ...
        trace_qtty);

    % Add the first element of the next symbol as the last element of the
    % previous symbol shown on the screen
    eye(end+1,:) = v_r(delay+1 + 3/2*samples_per_screen : ...
        samples_per_screen : ...
        delay + samples_per_screen*trace_qtty + 3/2*samples_per_screen);
    
    subplot(2,1,1)
    plot(t, real(eye))
    xlabel('t/T_{sym}');
    ylabel('Amplitude');
    title('Eye diagram for In-Phase signal');

    subplot(2,1,2)
    plot(t, imag(eye))
    xlabel('t/T_{sym}');
    ylabel('Amplitude');
    title('Eye diagram for Quadrature signal');
end
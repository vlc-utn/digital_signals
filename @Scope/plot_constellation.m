function plot_constellation(constellation)
    %PLOT_CONSTELLATION Plots the constellation, adding the bits for each
    % symbol.
    % Args:
    %   - constellation = Constellation's complex points.
    % Outputs:
    %   - None.
    arguments(Input)
        constellation (1,:) double
    end

    figure();
    scatter(real(constellation), imag(constellation), 50, "red", "filled"); hold on;

    for i=1:1:length(constellation)
        text(real(constellation(i)), imag(constellation(i)), dec2bin(i-1, log2(length(constellation))), VerticalAlignment="bottom", HorizontalAlignment="center" ); hold on;
    end
    xlabel("In Phase");
    ylabel("Quadrature");
    title("Constellation");
    grid on;
end


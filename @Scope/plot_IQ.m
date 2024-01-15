function plot_IQ(points)
    %PLOT_IQ Plot complex points in a IQ (In phase, Quadrature) diagram.
    %
    % Args:
    %   points = Complex points to plot
    arguments(Input)
        points (1,:) double
    end
    figure();
    scatter(real(points), imag(points), 5, "blue", "filled");
    xlabel("In Phase");
    ylabel("Quadrature");
    title("Constellation");
    grid on;
end

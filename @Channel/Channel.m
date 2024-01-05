classdef Channel
    %CHANNEL Modelates differents types of channels and their noise.
    
    properties
        ChannelType ChannelTypes
        EsNo double
        PlosPnlos double
    end
    
    methods (Access = public)
        function this = Channel(ChannelType, EsNo_dB, options)
            %CHANNEL Constructor
            % Args:
            %   - ChannelType = Type of channel (AWGN, Rayleigh, Ricean).
            %   - EsNo_dB = Relationship between symbol energy (Es) and 
            %   Noise PSD (No)
            %   - options.PlosPnlos_dB = Relationship between the power of the
            %   LOS component and power of the NLOS component (used for
            %   Ricean channel).
            arguments
                ChannelType ChannelTypes
                EsNo_dB double
                options.PlosPnlos_dB double = -1
            end
            this.ChannelType = ChannelType;
            this.EsNo = 10^(EsNo_dB/10);
            if (this.ChannelType == ChannelTypes.Ricean)
                if (options.PlosPnlos_dB == -1)
                    error("Should specify 'PlosPnlos_dB' for Ricean channel.")
                else
                    this.PlosPnlos = 10^(options.PlosPnlos_dB/10);
                end
            end
        end

        function [r, n, h] = add_noise(this, s)
            %ADD_NOISE Adds noise to the transmitted signal.
            % Args:
            %   this = Channel class.
            %   s = Modulated symbols, as complex points.
            % Outputs:
            %   r = Modulated symbols with noise added.
            switch this.ChannelType
                case ChannelTypes.AWGN
                    n = this.AWGN_noise(s);
                    r = s + n;
                case ChannelTypes.Rayleigh
                    [n, h] = this.Rayleigh_noise(s);
                    r = abs(h).*s + n;
                    r = r./abs(h);  % Filtro que compensa atenuacion del canal
                case ChannelTypes.Ricean
                    [n, h] = this.Ricean_noise(s);
                    r = abs(h).*s + n;
                    r = r./abs(h); % Filtro que compensa atenuacion del canal
                otherwise
                    error("Unknown channel type.")
            end
        end
    end

    methods (Access = private)
        function n = AWGN_noise(this, s)
            %AWGN_NOISE Generates Additive Waveform Gaussian Noise.
            Es = 1/length(s) * sum(abs(s).^2);
            N0 = Es/this.EsNo;
            n = sqrt(N0/2)*(randn(size(s)) + 1i*randn(size(s)));
        end

        function [n, h] = Rayleigh_noise(this, s)
            %RAYLEIGH_NOISE Generates Rayleigh noise.
            n = this.AWGN_noise(s);
            h = 1/sqrt(2)*(randn(size(s)) + 1i*randn(size(s)));
        end
        function [n, h] = Ricean_noise(this, s)
            %RICEAN_NOISE Generates Ricean noise
            k = this.PlosPnlos;
            u = sqrt(k/(2*(k+1)));
            sigma = sqrt(1/(2*(k+1)));
            h = (sigma*randn(size(s)) + u) + 1i*(sigma*randn(size(s)) + u);
            n = this.AWGN_noise(s);
        end
    end
end


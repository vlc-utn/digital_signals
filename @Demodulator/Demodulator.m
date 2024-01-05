classdef Demodulator
    %DEMODULATOR Digital demodulator.
    
    properties
        ModType ModulationTypes     % Modulation type.
        M double                    % Modulation order.
        % Constellation maping each complex point with a digital symbol
        Constellation (1,:) double  
        % If "True" Matlab's Communication Toolbox functions will be used 
        % for modulation
        UseCommToolbox logical        
    end
    
    methods (Access = public)
        function this = Demodulator(ModType, M, constellation, options)
            arguments
                ModType ModulationTypes
                M double
                constellation (1,:) double
                options.UseCommToolbox logical = false
            end
            this.ModType = ModType;
            this.M = M;
            this.Constellation = constellation;
            this.UseCommToolbox = options.UseCommToolbox;
        end
        
        function y = demodulate(this, r)
            if(this.UseCommToolbox)
            switch this.ModType
                case ModulationTypes.QAM
                    y = qamdemod(r, this.M);
                case ModulationTypes.PAM
                    y = pamdemod(r, this.M);
                case ModulationTypes.PSK
                    y = pskdemod(r, this.M);
                otherwise
                    error("Unknown Modulation type.");
            end
            else
                y = this.find_minimum_symbol_distance(r);
            end

        end
    end

    methods (Access = private)
        function y = find_minimum_symbol_distance(this, r)
            y = zeros(1,length(r));
            for i=1:length(r)
                distance = abs(this.Constellation - r(i));
                [~, y(i)] = min(distance);
            end
            y = y -1;
        end
    end
end


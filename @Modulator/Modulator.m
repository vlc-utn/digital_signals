classdef Modulator
    %MODULATOR Digital modulator.
    
    properties
        ModType ModulationTypes     % Modulation type
        M double                    % Modulation order
        % If "True" Matlab's Communication Toolbox functions will be used 
        % for modulation
        UseCommToolbox logical      
            
    end

    methods (Access = private)
        [s, constellation] = pam_mod(this, x)
        [s, constellation] = psk_mod(this, x)
        [s, constellation] = qam_mod(this, x)
        [ref,varargout]= constructQAM(this, M)
        [grayCoded]=dec2gray(this, decInput)
    end
    
    methods (Access = public)
        function this = Modulator(ModType, M, options)
        %MODULATOR Constructor function.
        % Args: 
        %   ModType = Modulation Type.
        %   M = Modulation orden. Amount of constellation points.
        %   UseCommToolbox = [true | false]. If "true", Matlab's
        %    Communication Toolbox functions will be used. Otherwise,
        %    personal modulation functions will be used.
            arguments
                ModType ModulationTypes
                M double
                options.UseCommToolbox logical = false
            end

            this.ModType = ModType;
            this.M = M;
            this.UseCommToolbox = options.UseCommToolbox;
        end

        [s, constellation] = modulate(this, x)
    end
end


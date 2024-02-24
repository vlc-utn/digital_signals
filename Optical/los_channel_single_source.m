%% LOS Channel Single Source
% Simulate LOS channel gain for a single source.
clc; clear; close all;

%% Room parameters
lx = 6; ly = 6; lz = 3;             % Dimensions of the Room Environment [m]

%% Tx parameters
half_angle = 70;                    % Semi angle of the LED at half power illumination
Pt = 20;                            % Transmitted Power of the LED [mW]
r_s = [-lx/4, -ly/4, 0];            % Position of LED
n_s = [0, 0, 1];                    % Orientation of the source

% Calculated (don't modify)
m = -log(2)/log(cosd(half_angle));  % Lamberts Mode Number

%% Rx parameters
area = 0.001;                       % Area of the Photodiode
Ts = 1;                             % Gain of the Optical Filter
n = 1.5;                            % Refractive Index of the Lens
FOV = 70;                           % Field of View of the Photodiode
Responsivity = 1;                   % Responsivity

% Position of receiver
x = linspace(-lx/2, lx/2, lx*5);    % Points to evaluate in the "X" axis.
y = linspace(-ly/2, ly/2, ly*5);    % Points to evaluate in the "Y" axis.
z = 2.25;                           % Points to evaluate in the "Z" axis.
n_r = [0, 0, -1];                   % Orientation of the receiver

% Calculated (don't modify)
[XR, YR, ZR] = meshgrid(x, y, z);   % Obtain all possible points
r_r = [XR(:), YR(:), ZR(:)];        % Vectorize
g = (n^2)/(sind(FOV).^2);           % Gain of the optical concentrator

%% Cálculos

% Normalize orientation of senders
for i=1:1:height(n_s)
    n_s(i,:) = n_s(i,:) ./ norm(n_s(i,:));
end

% Pre-allocate vectors
distance = ones(1, length(r_r));
cos_emitter = ones(size(distance));
cos_receiver = ones(size(distance));

% Vector operations
for i=1:1:length(r_r)
    distance(i) = norm(r_s - r_r(i,:));
    cos_emitter(i) = dot(n_s, (r_r(i,:) - r_s) ./ distance(i)); 
    cos_receiver(i) = dot(n_r, (r_s - r_r(i,:)) ./ distance(i));
end

% Revert to meshgrid coordinates
distance = reshape(distance, size(XR));
cos_emitter = reshape(cos_emitter, size(XR));
cos_receiver = reshape(cos_receiver, size(XR));

% LOS channel response
H_LOS = ( (m+1) / (2*pi) ) .* cos_emitter.^m .* ...
    ( area .* cos_receiver ./ (distance.^2) ) * Ts .* g;     

% Received power
P_received = Pt .* H_LOS * Responsivity;
P_received_dBm = 10*log10(P_received);

%% Figure
surfc(x, y, P_received_dBm) ;
title('Received Power in Indoor - VLC System corresponding to the LOS path');
xlabel('x in m');
ylabel('y in m');
zlabel('Received Power in dBm');
axis([-lx/2, lx/2, -ly/2, ly/2, min(min(P_received_dBm)), max(max(P_received_dBm))]);
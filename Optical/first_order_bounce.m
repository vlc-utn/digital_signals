%% LOS Channel Single Source
% Simulate LOS channel gain for a single source.
clc; clear; close all;

%% Room parameters
lx = 5; ly = 5; lz = 2.15;             % Dimensions of the Room Environment [m]
rho = 0.8;

% Number of points to evaluate in the simulation
Nx = round(lx*5);
Ny = round(ly*5);
Nz = round(lz*5);

% Calculated (don't modify)
n_lw = [0 1 0];                     % Orientation left wall.
n_rw = [0 -1 0];                    % Orientation right wall.
n_bw = [1 0 0];                     % Orientation back wall.
n_fw = [-1 0 0];                    % Orientation front wall.

dA = lz*ly / (Ny*Nz);

%% Tx parameters
half_angle = 70;                    % Semi angle of the LED at half power illumination
Pt = 20;                            % Transmitted Power of the LED [mW]
r_s = [0, 0, 0];            % Position of LED
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
x = linspace(-lx/2, lx/2, Nx);    % Points to evaluate in the "X" axis.
y = linspace(-ly/2, ly/2, Ny);    % Points to evaluate in the "Y" axis.
z = linspace(0, lz, Nz);          % Points to evaluate in the "Z" axis.
n_r = [0, 0, -1];                   % Orientation of the receiver

% Calculated (don't modify)
[XR, YR, ZR] = meshgrid(x, y, 2.25);   % Obtain all possible points
r_r = [XR(:), YR(:), ZR(:)];        % Vectorize
g = (n^2)/(sind(FOV).^2);           % Gain of the optical concentrator

% Coordinates for the four walls.
[X_LW, Y_LW, Z_LW] = meshgrid(x, -ly/2, z);
[X_RW, Y_RW, Z_RW] = meshgrid(x, ly/2, z);
[X_BW, Y_BW, Z_BW] = meshgrid(-lx/2, y, z);
[X_FW, Y_FW, Z_FW] = meshgrid(lx/2, y, z);

r_walls = [X_LW(:), Y_LW(:), Z_LW(:);
           X_RW(:), Y_RW(:), Z_RW(:);
           X_BW(:), Y_BW(:), Z_BW(:);
           X_FW(:), Y_FW(:), Z_FW(:)];

n_walls = [repmat(n_lw, numel(X_LW), 1);
           repmat(n_rw, numel(X_RW), 1);
           repmat(n_bw, numel(X_BW), 1);
           repmat(n_fw, numel(X_FW), 1)];
%% Cálculos

c = physconst("LightSpeed");

% Normalize orientation of senders
for i=1:1:height(n_s)
    n_s(i,:) = n_s(i,:) ./ norm(n_s(i,:));
end

%% Calculate channel gain from emitter to wall
% Pre-allocate vectors
distance = ones(1, length(r_walls));
cos_emitter = ones(size(distance));
cos_receiver = ones(size(distance));

for i=1:1:length(r_walls)
    distance(i) = norm(r_s - r_walls(i,:));
    cos_emitter(i) = dot(n_s, (r_walls(i,:) - r_s) ./ distance(i)); 
    cos_receiver(i) = dot(n_walls(i,:), (r_s - r_walls(i,:)) ./ distance(i));
end

% Emmiter to wall
H_k0 = ( (m+1) / (2*pi) ) .* cos_emitter.^m .* ...
    ( dA .* rho .* cos_receiver ./ (distance.^2) ); 

%% Calculate channel gain from wall to receiver
% Pre-allocate vectors
distance = ones(1, length(r_walls));
cos_emitter = ones(size(distance));
cos_receiver = ones(size(distance));
H_k1 = zeros(1,length(r_r));

% Vector operations
for i=1:1:length(r_r)
    for j=1:1:length(r_walls)
        distance(j) = norm(r_walls(j,:) - r_r(i,:));
        cos_emitter(j) = dot(n_walls(j,:), (r_r(i,:) - r_walls(j,:)) ./ distance(j));
        cos_receiver(j) = dot(n_r, (r_walls(j,:) - r_r(i,:)) ./ distance(j));

        if (abs(acosd(cos_receiver(j))) > FOV)
            cos_receiver(j) = 0;
        end
    end

    H_k1(i) = sum( H_k0 .* 1/pi .* cos_emitter .* area .* cos_receiver ./ (distance.^2) .* Ts .* g);
end

% Received power
P_received = Pt .* H_k1 * Responsivity;
P_received_dBm = 10*log10(P_received);

P_received_dBm = reshape(P_received_dBm, size(XR));

%% Figure
surfc(x, y, P_received_dBm) ;
title('Received Power in Indoor - VLC System corresponding to the LOS path');
xlabel('x in m');
ylabel('y in m');
zlabel('Received Power in dBm');
axis([-lx/2, lx/2, -ly/2, ly/2, min(min(P_received_dBm)), max(max(P_received_dBm))]);
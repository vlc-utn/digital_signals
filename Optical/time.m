%% LOS Channel Single Source
% Simulate LOS channel gain for a single source.
clc; clear; close all;

%% Room parameters
lx = 5; ly = 5; lz = 3;             % Dimensions of the Room Environment [m]
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
Pt = 1;                            % Transmitted Power of the LED [W]
r_s = [0, 0, 0];            % Position of LED
n_s = [0, 0, 1];                    % Orientation of the source

% Calculated (don't modify)
m = -log(2)/log(cosd(half_angle));  % Lamberts Mode Number

%% Rx parameters
area = 0.0001;                       % Area of the Photodiode
Ts = 1;                             % Gain of the Optical Filter
n = 1.5;                            % Refractive Index of the Lens
FOV = 60;                           % Field of View of the Photodiode
Responsivity = 1;                   % Responsivity

% Position of receiver
x = linspace(-lx/2, lx/2, Nx);    % Points to evaluate in the "X" axis.
y = linspace(-ly/2, ly/2, Ny);    % Points to evaluate in the "Y" axis.
z = linspace(0, lz, Nz);          % Points to evaluate in the "Z" axis.
n_r = [0, 0, -1];                   % Orientation of the receiver

% Calculated (don't modify)
[XR, YR, ZR] = meshgrid(x, y, 3);   % Obtain all possible points
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

%% Temporal vector
delta_t = sqrt(dA)/c;
t_vector = 0:delta_t:30e-9;
h_vector_los = zeros(height(r_r),length(t_vector));
h_vector_nlos = zeros(height(r_r),length(t_vector));  

%% Calculate channel gain from emitter to wall
% Pre-allocate vectors
distance_sr = zeros(1, height(r_r));
cos_tx_sr   = zeros(size(distance_sr));
cos_rx_sr   = zeros(size(distance_sr));

distance_sw = zeros(1, length(r_walls));
cos_tx_sw   = zeros(size(distance_sw));
cos_rx_sw   = zeros(size(distance_sw));
distance_wr = zeros(size(distance_sw));
cos_tx_wr   = zeros(size(distance_sw));
cos_rx_wr   = zeros(size(distance_sw));

for j=1:1:height(r_r)
    
    % LOS component
    distance_sr(j) = norm(r_s - r_r(j,:));
    cos_tx_sr(j) = dot(n_s, (r_r(j,:) - r_s) ./ distance_sr(j)); 
    cos_rx_sr(j) = dot(n_r, (r_s - r_r(j,:)) ./ distance_sr(j));

    if (abs(acosd(cos_rx_sr(j))) <= FOV)
        [~, index] = min(abs(distance_sr(j)/c - t_vector));
        h_vector_los(j, index) = h_vector_los(j, index) + ( (m+1) / (2*pi) ) .* cos_tx_sr(j).^m .* ...
            ( area .* cos_rx_sr(j) ./ (distance_sr(j).^2) ) * Ts .* g;
    end

    for i=1:1:length(r_walls)
        distance_sw(i) = norm(r_s - r_walls(i,:));
        cos_tx_sw(i) = dot(n_s, (r_walls(i,:) - r_s) ./ distance_sw(i)); 
        cos_rx_sw(i) = dot(n_walls(i,:), (r_s - r_walls(i,:)) ./ distance_sw(i));
        distance_wr(i) = norm(r_walls(i,:) - r_r(j,:));
        cos_tx_wr(i) = dot(n_walls(i,:), (r_r(j,:) - r_walls(i,:)) ./ distance_wr(i));
        cos_rx_wr(i) = dot(n_r, (r_walls(i,:) - r_r(j,:)) ./ distance_wr(i));
    
        if (abs(acosd(cos_rx_wr(i))) <= FOV )
            [~, index] = min(abs((distance_sw(i) + distance_wr(i))/c - t_vector)); 
    
            h_vector_nlos(j, index) = h_vector_nlos(j, index) + (m+1) * area * rho * dA * Ts * g * ...
                cos_tx_sw(i)^m * cos_rx_sw(i) * cos_tx_wr(i) * cos_rx_wr(i) / ...
                (2*pi^2 * distance_sw(i)^2 * distance_wr(i)^2);
        end
    end
end

mean_delay = zeros(1, height(r_r));
Drms = zeros(size(mean_delay));
mean_delay_nlos = zeros(size(mean_delay));
Drms_nlos = zeros(size(mean_delay));
mean_delay_los = zeros(size(mean_delay));
Drms_los = zeros(size(mean_delay));

h_vector = h_vector_nlos + h_vector_los;

for j=1:1:height(r_r)
    mean_delay(j) = sum((h_vector(j,:)).^2.*t_vector)/sum(h_vector(j,:).^2);
    Drms(j) = sqrt(sum((t_vector-mean_delay(j)).^2.*h_vector(j,:).^2)/sum(h_vector(j,:).^2));

    mean_delay_nlos(j) = sum((h_vector_nlos(j,:)).^2.*t_vector)/sum(h_vector_nlos(j,:).^2);
    Drms_nlos(j) = sqrt(sum((t_vector-mean_delay(j)).^2.*h_vector_nlos(j,:).^2)/sum(h_vector_nlos(j,:).^2));

    mean_delay_los(j) = sum((h_vector_los(j,:)).^2.*t_vector)/sum(h_vector_los(j,:).^2);
    Drms_los(j) = sqrt(sum((t_vector-mean_delay(j)).^2.*h_vector_los(j,:).^2)/sum(h_vector_los(j,:).^2));
end

mean_delay = reshape(mean_delay, size(XR));
mean_delay = mean_delay /1e-9;
Drms = reshape(Drms, size(XR));
Drms = Drms / 1e-9;

mean_delay_nlos = reshape(mean_delay_nlos, size(XR));
mean_delay_nlos = mean_delay_nlos /1e-9;
Drms_nlos = reshape(Drms_nlos, size(XR));
Drms_nlos = Drms_nlos / 1e-9;

mean_delay_los = reshape(mean_delay_los, size(XR));
mean_delay_los = mean_delay_los /1e-9;
Drms_los = reshape(Drms_los, size(XR));
Drms_los = Drms_los / 1e-9;

%% Received power
% P_received = Pt .* (H_k1 + H_LOS) .* Responsivity;
% P_received = Pt .* H_k1 .* Responsivity;
% P_received_dBm = 10*log10(P_received/1e-3);
% 
% P_received_dBm = reshape(P_received_dBm, size(XR));
% 
% %% Figure
% figure();
% surfc(x, y, P_received_dBm) ;
% title('Received Power in Indoor - VLC System corresponding to the LOS path');
% xlabel('x in m');
% ylabel('y in m');
% zlabel('Received Power in dBm');
% axis([-lx/2, lx/2, -ly/2, ly/2, min(min(P_received_dBm)), max(max(P_received_dBm))]);

figure();
surfc(x, y, mean_delay);
title('Mean delay');
xlabel('x in m');
ylabel('y in m');
zlabel('Mean delay spread [ns]');
axis([-lx/2, lx/2, -ly/2, ly/2, min(min(mean_delay)), max(max(mean_delay))]);

figure();
surfc(x, y, Drms);
title('RMS spread');
xlabel('x in m');
ylabel('y in m');
zlabel('RMS spread [ns]');
axis([-lx/2, lx/2, -ly/2, ly/2, min(min(Drms)), max(max(Drms))]);

figure();
surfc(x, y, Drms_nlos);
title('RMS spread NLOS');
xlabel('x in m');
ylabel('y in m');
zlabel('RMS spread NLOS [ns]');
axis([-lx/2, lx/2, -ly/2, ly/2, min(min(Drms_nlos)), max(max(Drms_nlos))]);

figure();
surfc(x, y, Drms_los);
title('RMS spread LOS');
xlabel('x in m');
ylabel('y in m');
zlabel('RMS spread LOS [ns]');
axis([-lx/2, lx/2, -ly/2, ly/2, min(min(Drms_los)), max(max(Drms_los))]);

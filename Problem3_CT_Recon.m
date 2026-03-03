% Problem3_CT_Recon.m
% DIPWM3 – CT Reconstruction from Corrupted Fanbeam Data
% Marquette University & MCW
% Bing Xia.

clear; close all; clc;

%% Load or recreate Phantom and Fanbeam projections (from Problem 2)
im_size = 600;
im = phantom('Modified Shepp-Logan', im_size);

% Source-to-center distance
D = 1.5 * hypot(im_size, im_size)/2;

% Original fanbeam projections
ct_view = fanbeam(im, D, ...
    'FanSensorGeometry','arc', ...
    'FanSensorSpacing',0.1, ...
    'FanRotationIncrement',0.4);

%% (a) Zero out channels 400-410
ct_view_corrupt = ct_view;          % copy original
ct_view_corrupt(:, 400:410) = 0;    % zero out selected channels

% Display modified Views vs Channels
view_vs_chan_corrupt = flipud(ct_view_corrupt');
figure;
imshow(view_vs_chan_corrupt, []);
title('Modified Views vs Channels (Channels 400-410 Zeroed)');
drawnow;

%% (b) Reconstruct using filtered back-projection
recon_corrupt = ifanbeam(ct_view_corrupt, D, ...
    'FanSensorGeometry','arc', ...
    'FanSensorSpacing',0.1, ...
    'FanRotationIncrement',0.4, ...
    'OutputSize', im_size);

% Display reconstructed image
figure;
imshow(recon_corrupt, []);
title('Reconstructed Image from Corrupted Data');
drawnow;
% CT_data_acquisition_full.m
% CT Reconstruction using Filtered Backprojection
% Marquette University & MCW
% Bing Xia.

clear; close all; clc;

%% (a) Create 600x600 Modified Shepp-Logan Phantom
im_size = 600;
im = phantom('Modified Shepp-Logan', im_size);

figure;
imshow(im, []);
title('Modified Shepp-Logan Phantom');
drawnow;

%% (b) Create fan-beam projections (arc geometry)

% Distance from source to center of rotation
D = 1.5 * hypot(im_size, im_size) / 2;

ct_view = fanbeam(im, D, ...
    'FanSensorGeometry','arc', ...
    'FanSensorSpacing', 0.1, ...
    'FanRotationIncrement', 0.4);

% Display Views vs Channels (Sinogram)
view_vs_chan = flipud(ct_view');  

figure;
imshow(view_vs_chan, []);
title('Views vs Channels (Fan-beam Sinogram)');
drawnow;

%% (c) Reconstruct using Filtered Backprojection (ifanbeam)

recon_im = ifanbeam(ct_view, D, ...
    'FanSensorGeometry','arc', ...
    'FanSensorSpacing', 0.1, ...
    'FanRotationIncrement', 0.4, ...
    'OutputSize', im_size);

figure;
imshow(recon_im, []);
title('Reconstructed Image using Filtered Backprojection');
drawnow;

%% End of Script
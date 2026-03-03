%% Problem 4 – Lynn Lake Water Area Estimation
% MATLAB region-growing approach to estimate total acres of surface water

clear; clc; close all;

%% Step 1: Load images
lake_image     = imread('LynnLake_1750ft.png');          % 原始地形图
water_mask     = imread('LynnLake_1750ft_water_mask.png'); % 黑色标记水面
ref_area_image = imread('LynnLake_1750ft_640acre.png');  % 640 acres 黑色参考区域

%% Step 2: Convert images to grayscale or binary
% 水面 mask 黑色 = 0
water_binary = water_mask(:,:,1) == 0;  % 假设黑色 R 通道 = 0
ref_binary   = ref_area_image(:,:,1) == 0;

%% Step 3: Display images for verification
figure;
subplot(1,3,1); imshow(lake_image); title('Original Topology Map');
subplot(1,3,2); imshow(water_binary); title('Water Mask (Binary)');
subplot(1,3,3); imshow(ref_binary); title('Reference Area (640 acres)');

%% Step 4: Region-growing (optional)
% 假设你想用 MATLAB 内置 region-growing
% 可以用 bwselect 或 imsegflood 等函数
% 这里直接使用水面 mask 的黑色区域

% 如果想使用 seed-based region growing, 例如：
% seed = [x, y]; % 手动选择湖中心
% water_region = imsegflood(rgb2gray(lake_image), seed, 'Connectivity', 8);

%% Step 5: Calculate total water area in acres using ratio
num_water_pixels = sum(water_binary(:));
num_ref_pixels   = sum(ref_binary(:));

water_area_acres = num_water_pixels / num_ref_pixels * 640;

fprintf('Estimated Lynn Lake water area (1750 ft, 1976): %.2f acres\n', water_area_acres);

%% Step 6: Optional - visualize overlay
figure; imshow(lake_image); hold on;
h = imshow(cat(3, ones(size(water_binary)), zeros(size(water_binary)), zeros(size(water_binary))));
set(h, 'AlphaData', 0.3 * water_binary); % 红色半透明覆盖水面
title(sprintf('Water Surface Overlay - %.2f acres', water_area_acres));
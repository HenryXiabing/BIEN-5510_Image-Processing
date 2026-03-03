%% Problem 6: Color Image Filtering – Sunflower
% Marquette University & MCW
% Bing Xia.

clear; clc; close all;

%% Part (a) – Gaussian smoothing

% Read color image
I = imread('sunflower.tif');

% Define a large Gaussian filter (sigma large enough to blur details)
hsize = 25;      % filter size (adjust to get large smooth blob)
sigma = 10;      % standard deviation

% Apply Gaussian filter to each channel separately
I_smooth = zeros(size(I), 'like', I);
for c = 1:3
    I_smooth(:,:,c) = imgaussfilt(I(:,:,c), sigma, 'FilterSize', hsize);
end

% Display original and smoothed images
figure;
subplot(1,2,1); imshow(I); title('Original Image');
subplot(1,2,2); imshow(I_smooth); title('Gaussian Smoothed Image (Large Sigma)');

%% Part (b) – Laplacian sharpening

% Define Laplacian kernels
% Eq (3-29)
L1 = [0  1  0; 1 -4  1; 0  1  0];

% Eq (3-30)
L2 = [1  1  1; 1 -8  1; 1  1  1];

% Add 1 to center to preserve low-frequency content
L1_sharp = L1 + eye(3);
L2_sharp = L2 + eye(3);

% Apply sharpening to each channel
I_sharp1 = zeros(size(I), 'like', I);
I_sharp2 = zeros(size(I), 'like', I);
for c = 1:3
    I_sharp1(:,:,c) = imfilter(I(:,:,c), L1_sharp, 'replicate');
    I_sharp2(:,:,c) = imfilter(I(:,:,c), L2_sharp, 'replicate');
end

% Display results
figure;
subplot(1,3,1); imshow(I); title('Original Image');
subplot(1,3,2); imshow(I_sharp1); title('Sharpened with L1 kernel');
subplot(1,3,3); imshow(I_sharp2); title('Sharpened with L2 kernel');

%% Explanation
disp(['L1 emphasizes immediate neighbors (4-connectivity), giving moderate sharpening. ', ...
      'L2 emphasizes all neighbors (8-connectivity), producing stronger sharpening and more edge contrast.']);

% coherent_noise_mask.m -  Remove Coherent noise from image  
% Marquette University
% Fred J. Frigo, Ph.D.
% 
% Image Processing
% See Digital Image Processing with MATLAB, 3rd edition, project 5.5 
%

noise_im = imread('astronaut-interference.tif'); % 
[yres, xres] = size(noise_im);
figure();
imshow(noise_im);
title('Image corrupted by coherent noise'); drawnow;

% Take the magnitude of the FFT
F=fft2(double(noise_im));
S=fftshift(F);
A=abs(S);

% Display in log format
figure();
L=log(A);
imagesc(L);
title("Log Magnitude of FFT image");drawnow;

% Search the upper left hand quadrant of matrix L to find max row, col
row1 = round((yres/2) * 0.98);
col1 = round((xres/2) * 0.98);
L1 = L(1:row1, 1:col1);
[max_val1, max_idx1] = max(L1(:));  % Find max value and its index
[max_row1, max_col1] = ind2sub(size(L1), max_idx1); % Convert index to row and column

% The image with coherent noise has spike noise centered at this point
C1 = [int16(max_col1),        int16(max_row1)];

% Find the coherent noise in the lower right corner of Fourier space
L2 = zeros([yres, xres]);
row2 = round((yres/2) * 1.02);
col2 = round((xres/2) * 1.02);
L2(row2:yres-1, col2:xres-1) = L(row2:yres-1, col2:xres-1);
[max_val2, max_idx2] = max(L2(:));  % Find max value and its index
[max_row2, max_col2] = ind2sub(size(L2), max_idx2); % Convert index to row and column
C2 = [int16(max_col2), int16(max_row2)];

% Create two circular masks to get rid of the coherent noise (Ideal Filter)
% Requires MATLAB 2024a or later
% radius = 1; % radius of mask value is empirial
% H1 = double(circles2mask( [ double(C1); double(C2)], radius, [yres xres]));

% Cepstral filter - zero oout the 2 noise points
H3=ones(yres, xres);
H3(C1(2),C1(1)) = 0.0;
H3(C2(2),C2(1)) = 0.0;

figure;
imagesc(H3);
title('2D Mask Filter'); drawnow;

% zoom in to the center of Fourier space
x1 = round(xres*0.45);
y1 = round(yres*0.45);
x2 = round(xres*0.55);
y2 = round(yres*0.55);

figure();
mesh(H3(y1:y2, x1:x2)); 
title("Zoomed Magnitude of the 2D mask filter"); drawnow;

% Apply the Ideal notch filter to remove the coherent noise
SF = S.*H3;
F1 = fftshift(SF);
complex_image = ifft2(F1);
filtered_image = abs(complex_image);
scale_max = max(max(filtered_image));
scaled_image = (filtered_image/scale_max);
figure;
imshow(scaled_image); drawnow;
title("Filtered image using Cepstral filter");drawnow;

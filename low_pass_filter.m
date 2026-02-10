% low_pass_filter.m - Apply Gaussian low pass filter to image
% Fred J. Frigo, Ph.D.
% 29-Jan-2025
%
 
% Read color photo
function low_pass_filter( imfile )

if(nargin == 0)
    [fname,iname] = uigetfile('*.*', 'Select Image file');
    imfile = strcat(iname, fname);
end

% Read color photo
im = imread(imfile);  
figure();
imshow(im);
title("Color image");  drawnow;
 
% Convert to gray scale
gray = rgb2gray(im);
[rows, cols] = size(gray);
fprintf('Image resolution: %d x %d pixels\n', rows, cols);

figure();
imshow(gray);
title("Gray scale image"); drawnow;

% Take the 2D Fourier Transform
F=fft2(double(gray));
S=fftshift(F);

% Create Gaussian Filter with step size of 1 and empirical std deviation
std_gauss = 0.05 * cols;
myfilter = fspecial('gaussian', [rows cols], std_gauss); 
myfilter_max = max(max(myfilter));  % normalize
myfilter = myfilter/myfilter_max;
figure;
mesh(myfilter);  
title("Gaussian Filter Kernel"); drawnow;

% Apply the filter to the complex Fourier space image
LPF=myfilter.*S;
SLPF = fftshift(LPF);
complex_image = ifft2(SLPF);
mag_image = abs(complex_image);
im_max = max(max(mag_image));
lpf_gray = (mag_image/im_max);

figure();
imshow(lpf_gray);
filter_image_title = sprintf("Low Pass Filtered Image: %d x %d", rows, cols);
title(filter_image_title); drawnow;



% high_pass_filter.m - Apply Gaussian high pass filter to image
% Fred J. Frigo, Ph.D.
% 28-Jan-2026
%
 
% Read color photo
function high_pass_filter( imfile )

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
std_gauss = 0.01 * cols;
myfilter = fspecial('gaussian', [rows cols], std_gauss); 
myfilter_max = max(max(myfilter));  % normalize
myfilter = myfilter/myfilter_max;
myfilter = 1.0 - myfilter;
figure;
mesh(myfilter);  
title("Gaussian Filter Kernel"); drawnow;

% Apply the filter to the complex Fourier space image
HPF=myfilter.*S;
SLPF = fftshift(HPF);
complex_image = ifft2(SLPF);
mag_image = abs(complex_image);
im_max = max(max(mag_image));
hpf_gray = (mag_image/im_max);

figure();
imshow(hpf_gray);
filter_image_title = sprintf("High Pass Filtered Image: %d x %d", rows, cols);
title(filter_image_title); drawnow;



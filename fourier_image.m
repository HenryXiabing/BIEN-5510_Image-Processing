% fourier_image.m - display magnitude of Fourier Transformed image
% Fred J. Frigo, Ph.D.
% 29-Jan-2035
%
 
% Read color photo
function fourier_image( imfile )


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

figure();
imshow(gray);
title("Gray scale image");  drawnow;

% Take the magnitude of the FFT
F=fft2(double(gray));
S=fftshift(F);
A=abs(S);
figure();
imagesc(A);
axis image;
title("Magnitude of FFT image"); drawnow;

% Display in log format
figure();
L=log(A);
imagesc(L);
axis image;
title("Log Magnitude of FFT image"); drawnow;


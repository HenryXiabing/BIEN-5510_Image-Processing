%% Problem 7: DICOM Image Analysis (Simplified)

clear; clc; close all;

% File name
filename = 'e31s3i11.dcm';

% Check file existence
if ~exist(filename, 'file')
    error('DICOM file "%s" not found in current folder.', filename);
end

%% (a) Read and display original grayscale image
img = dicomread(filename);
dicom_info = dicominfo(filename);

figure('Name','Original DICOM Image','Position',[100 100 800 600]);
imshow(img, []); 
title('Original Grayscale DICOM Image');
colorbar;
xlabel('Column'); ylabel('Row');

%% (b) Window width and level
if isfield(dicom_info,'WindowCenter'); wc = double(dicom_info.WindowCenter); else wc = mean(img(:)); end
if isfield(dicom_info,'WindowWidth');  ww = double(dicom_info.WindowWidth);  else ww = 2*std(double(img(:))); end

fprintf('Window Center (Level): %.2f\n', wc);
fprintf('Window Width: %.2f\n', ww);

%% (c) Histogram of pixel values
img_double = double(img(:));
figure('Name','Histogram of Pixel Values','Position',[200 200 800 600]);
histogram(img_double, 256, 'FaceColor','k','EdgeColor','none');
title('Histogram of Pixel Values');
xlabel('Pixel Value'); ylabel('Frequency');
grid on;
%% Problem 7: DICOM Image Analysis
% Marquette University & MCW
% Bing Xia.

clear; clc; close all;

%% File information
% The image 'e31s3i11.dcm' was created on a Signa 450W wide bore 
% magnetic resonance imaging system (1.5T) and exported in DICOM format.

filename = 'e31s3i11.dcm';

% Check if file exists
if ~exist(filename, 'file')
    error('DICOM file "%s" not found in current folder.', filename);
end

%% (a) Read and display original grayscale image
fprintf('=== Part (a): Reading and displaying DICOM image ===\n');

% Read DICOM image and header information
img = dicomread(filename);
dicom_info = dicominfo(filename);

% Display the original grayscale image
figure('Name', 'Original DICOM Image', 'Position', [100 100 800 600]);
imshow(img, []);
title(['Original Grayscale DICOM Image: ' filename]);
colorbar;
xlabel('Column');
ylabel('Row');

% Display basic image information
fprintf('Image successfully loaded: %s\n', filename);
fprintf('Image size: %d x %d pixels\n', size(img, 1), size(img, 2));
fprintf('Pixel value range: [%d, %d]\n\n', min(img(:)), max(img(:)));

%% (b) Extract window width and level from DICOM header
fprintf('=== Part (b): DICOM header window settings ===\n');

% Extract Window Center (Level)
if isfield(dicom_info, 'WindowCenter')
    wc = double(dicom_info.WindowCenter);
    fprintf('Window Center (Level) found in DICOM header.\n');
else
    wc = mean(double(img(:)));
    fprintf('Window Center not found in header. Using mean pixel value.\n');
end

% Extract Window Width
if isfield(dicom_info, 'WindowWidth')
    ww = double(dicom_info.WindowWidth);
    fprintf('Window Width found in DICOM header.\n');
else
    ww = 2 * std(double(img(:)));
    fprintf('Window Width not found in header. Using 2 * standard deviation.\n');
end

% Display the values
fprintf('\nWindow Center (Level): %.2f\n', wc);
fprintf('Window Width: %.2f\n\n', ww);

% Create a figure to display window settings
figure('Name', 'DICOM Window Settings', 'Position', [300 300 600 400]);
axis off;
text(0.1, 0.7, 'DICOM Window Settings from Header:', 'FontSize', 14, 'FontWeight', 'bold');
text(0.1, 0.5, sprintf('Window Center (Level): %.2f', wc), 'FontSize', 12);
text(0.1, 0.4, sprintf('Window Width: %.2f', ww), 'FontSize', 12);
text(0.1, 0.2, ['File: ' filename], 'FontSize', 10, 'FontAngle', 'italic');
title('Window Width and Level Values');

%% (c) Generate histogram of pixel values
fprintf('=== Part (c): Generating histogram ===\n');

% Convert image to double and extract all pixel values
img_double = double(img(:));

% Create histogram
figure('Name', 'Histogram of Pixel Values', 'Position', [400 400 900 600]);

% Plot histogram with 256 bins
histogram(img_double, 256, 'FaceColor', [0.3 0.3 0.3], 'EdgeColor', 'none');
title(['Histogram of Pixel Values: ' filename]);
xlabel('Pixel Value');
ylabel('Frequency');
grid on;
hold on;

% Calculate statistics
mean_val = mean(img_double);
std_val = std(double(img(:)));
min_val = min(img_double);
max_val = max(img_double);

% Add statistical information to the histogram
xline(mean_val, 'r-', 'LineWidth', 2, 'DisplayName', sprintf('Mean: %.2f', mean_val));
xline(mean_val - std_val, 'g--', 'LineWidth', 1.5, 'DisplayName', sprintf('-1 Std: %.2f', mean_val - std_val));
xline(mean_val + std_val, 'g--', 'LineWidth', 1.5, 'DisplayName', sprintf('+1 Std: %.2f', mean_val + std_val));
xline(min_val, 'b:', 'LineWidth', 1, 'DisplayName', sprintf('Min: %.2f', min_val));
xline(max_val, 'b:', 'LineWidth', 1, 'DisplayName', sprintf('Max: %.2f', max_val));

legend('Location', 'best');
hold off;

% Print statistical information
fprintf('Histogram Statistics:\n');
fprintf('  Mean pixel value: %.2f\n', mean_val);
fprintf('  Standard deviation: %.2f\n', std_val);
fprintf('  Minimum pixel value: %.2f\n', min_val);
fprintf('  Maximum pixel value: %.2f\n', max_val);
fprintf('  Dynamic range: %.2f\n\n', max_val - min_val);

%% (d) Source code included
fprintf('=== Part (d): Source code included ===\n');
fprintf('This MATLAB script file serves as the source code.\n');
fprintf('File name: %s\n', mfilename);
fprintf('Analysis complete.\n');

%% Optional: Display image with window width/level applied
% This shows the clinical effect of the window settings
figure('Name', 'Windowed Display', 'Position', [500 500 800 600]);

% Apply window/level to enhance display
windowed_img = img;
windowed_img(img < (wc - ww/2)) = (wc - ww/2);
windowed_img(img > (wc + ww/2)) = (wc + ww/2);

subplot(1,2,1);
imshow(img, []);
title('Original Display (Full Range)');
xlabel('Column'); ylabel('Row');
colorbar;

subplot(1,2,2);
imshow(windowed_img, []);
title(sprintf('Windowed Display (WC=%.1f, WW=%.1f)', wc, ww));
xlabel('Column'); ylabel('Row');
colorbar;

%% Summary
fprintf('\n=====================================\n');
fprintf('Problem 7 completed successfully.\n');
fprintf('=====================================\n');

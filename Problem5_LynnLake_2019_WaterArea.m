%% Problem 5 – Lynn Lake 2019 Surface Water Estimation
% 5-seed region growing version

clear; clc; close all;

%% Step 1: Load images
lake_image = imread('Lynn_ERSI_World_mask.png');
ref_image  = imread('Lynn_ERSI_World_mask.png');

%% Step 2: Convert to grayscale
gray_lake = (0.2989*double(lake_image(:,:,1)) + ...
             0.5870*double(lake_image(:,:,2)) + ...
             0.1140*double(lake_image(:,:,3))) / 255;

gray_ref = (0.2989*double(ref_image(:,:,1)) + ...
            0.5870*double(ref_image(:,:,2)) + ...
            0.1140*double(ref_image(:,:,3))) / 255;

%% Step 3: Extract 640-acre reference region
figure;
imshow(gray_ref);
title('Click inside WHITE 640-acre reference region');

[col_ref,row_ref] = ginput(1);
row_ref = round(row_ref);
col_ref = round(col_ref);

BW_640 = grayconnected(gray_ref,row_ref,col_ref,0.01);

figure;
imshow(BW_640);
title('640 Acre Reference Region (B/W)');

pixels_640 = sum(BW_640,'all');
pixels_per_acre = pixels_640 / 640.0;

fprintf('Pixels per acre = %.4f\n',pixels_per_acre);

%% Step 4: Select 5 seed points for lake water
figure;
imshow(gray_lake);
title('Click 5 points inside lake water (spread them out)');

[col,row] = ginput(5);   % <-- 5 seed points

row = round(row);
col = round(col);

% Initialize empty mask
BW_water = false(size(gray_lake));

% Loop through all 5 seeds
for i = 1:5
    BW_temp = grayconnected(gray_lake,row(i),col(i),0.05);
    BW_water = BW_water | BW_temp;   % Combine regions
end

figure;
imshow(BW_water);
title('Detected Water Region (5 Seeds, B/W)');

pixels_water = sum(BW_water,'all');

%% Step 5: Compute lake area
water_area_acres = pixels_water / pixels_per_acre;

fprintf('Estimated Lynn Lake surface water (1777 ft): %.2f acres\n',water_area_acres);

%% Step 6: Save mask
imwrite(BW_water,'LynnLake_2019_WaterMask_5Seeds.png');
fprintf('Water mask saved.\n');

%% Step 7: Overlay
figure;
imshow(lake_image); hold on;

h = imshow(cat(3,ones(size(BW_water)),zeros(size(BW_water)),zeros(size(BW_water))));
set(h,'AlphaData',0.3*BW_water);

title(sprintf('Lake Surface Overlay - %.2f acres',water_area_acres));
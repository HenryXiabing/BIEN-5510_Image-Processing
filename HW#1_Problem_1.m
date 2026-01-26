% rgb_image.m - create red/green/blue color image
% Put this program and the image in the same folder
function rgb_image()

    % ---- specify image file explicitly ----
    imfile = 'BingXia.jpg';

    % Check if file exists
    if ~isfile(imfile)
        error('Image file "%s" not found in current directory.', imfile);
    end

    % Read color photo
    rgbImage = imread(imfile);

    % Display original image
    figure;
    imshow(rgbImage);
    title('Original Image');

    % Extract color channels
    redChannel   = rgbImage(:,:,1);   % Red channel
    greenChannel = rgbImage(:,:,2);   % Green channel
    blueChannel  = rgbImage(:,:,3);   % Blue channel

    % Create an all-black channel
    allBlack = zeros(size(rgbImage,1), size(rgbImage,2), 'uint8');

    % Create color versions of individual channels
    just_red   = cat(3, redChannel,   allBlack,    allBlack);
    just_green = cat(3, allBlack,     greenChannel,allBlack);
    just_blue  = cat(3, allBlack,     allBlack,    blueChannel);

    % Display RGB channel images
    figure; imshow(just_red);   title('Red Channel');
    figure; imshow(just_green); title('Green Channel');
    figure; imshow(just_blue);  title('Blue Channel');

    % Show image resolution and number of pixels
    [rows, cols, ~] = size(rgbImage);
    fprintf('Image resolution: %d x %d pixels\n', rows, cols);
    fprintf('Total number of pixels: %d\n', rows * cols);

end

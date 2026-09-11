%% 02. Read, Display, and Understand Image Types
% Author: Md. Mobarak Karim, Ph.D.
%
% Goal: understand what is actually stored in an image before processing it.

%% 1. Read an image
image = imread('cameraman.tif');

% Always inspect size, class, and intensity range first.
disp(size(image))
disp(class(image))
fprintf('Min = %g, Max = %g\n', double(min(image(:))), double(max(image(:))))

%% 2. Display a grayscale image
figure
imshow(image)
title('Grayscale image')

%% 3. Grayscale vs RGB
% Grayscale image: rows x columns
% RGB image:       rows x columns x 3

rgbImage = imread('peppers.png');
disp(size(rgbImage))
disp(class(rgbImage))

figure
imshow(rgbImage)
title('RGB image')

%% 4. Access color channels
redChannel   = rgbImage(:,:,1);
greenChannel = rgbImage(:,:,2);
blueChannel  = rgbImage(:,:,3);

figure
subplot(1,3,1); imshow(redChannel);   title('Red')
subplot(1,3,2); imshow(greenChannel); title('Green')
subplot(1,3,3); imshow(blueChannel);  title('Blue')

%% 5. Convert RGB to grayscale when appropriate
% rgb2gray combines RGB channels using luminance weighting.
% Use it when a grayscale representation matches your analysis question.
% Do NOT automatically collapse scientific fluorescence channels together.

grayImage = rgb2gray(rgbImage);
figure
imshow(grayImage)
title('RGB converted to grayscale')

%% 6. Numeric classes matter
% Common image classes:
% uint8  -> usually 0...255
% uint16 -> usually 0...65535
% single/double -> range depends on how values were created
%
% Integer images are efficient for storage. Floating-point images are often
% convenient for calculations, but conversion must be intentional.

fprintf('uint8 range: 0 to %d\n', intmax('uint8'))
fprintf('uint16 range: 0 to %d\n', intmax('uint16'))

%% 7. im2double vs double
% double(image) changes the numeric class but keeps uint8 values 0...255.
% im2double(image) converts standard integer images into the normalized
% floating-point range expected by many image-processing workflows.

rawDouble = double(image);
normalizedDouble = im2double(image);

fprintf('double(image) range: %.1f to %.1f\n', min(rawDouble(:)), max(rawDouble(:)))
fprintf('im2double range: %.3f to %.3f\n', min(normalizedDouble(:)), max(normalizedDouble(:)))

%% 8. Display range vs pixel values
% imshow(I, []) stretches the current data range for DISPLAY ONLY.
% It does not rewrite the matrix I.

lowContrast = uint8(double(image) * 0.3 + 80);

figure
subplot(1,2,1); imshow(lowContrast);    title('Default display')
subplot(1,2,2); imshow(lowContrast, []); title('Display stretched with []')

%% 9. Read metadata when needed
% imfinfo is useful for standard image-file metadata.
% More complex microscopy formats may need dedicated readers.

info = imfinfo('cameraman.tif');
disp(info(1))

%% 10. Save an image
% imwrite writes an image matrix to disk.
% Save derived images with new names; do not overwrite raw research data.

outputName = fullfile(tempdir, 'cameraman_copy.tif');
imwrite(image, outputName)
fprintf('Saved copy to: %s\n', outputName)

%% 11. What to check before processing
% Ask:
% - Is it grayscale, RGB, or multichannel scientific data?
% - What is size(image)?
% - What is class(image)?
% - What is the numerical range?
% - Are physical pixel sizes or acquisition metadata needed?
% - Is the display misleading me about the stored data?

%% 12. Practice
% 1. Load peppers.png and print size/class/min/max.
% 2. Display each RGB channel independently.
% 3. Compare double() and im2double().
% 4. Explain why imshow(I,[]) changes display but not the image matrix.

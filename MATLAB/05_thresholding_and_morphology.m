%% 05. Thresholding and Morphology
% Author: Md. Mobarak Karim, Ph.D.
%
% Goal: convert an intensity image into a binary mask, then clean only the
% artifacts that have a defensible biological/technical reason to remove.

%% 1. Load and inspect
image = imread('coins.png');
figure; imshow(image); title('Original image')
figure; imhist(image); title('Histogram')

%% 2. Global threshold with Otsu
% graythresh returns a normalized threshold in [0,1].
% imbinarize can calculate Otsu internally.
% Global thresholding is a good first choice when one threshold can plausibly
% separate foreground and background across the whole image.

level = graythresh(image);
maskGlobal = imbinarize(image, level);

figure
subplot(1,2,1); imshow(image);      title('Original')
subplot(1,2,2); imshow(maskGlobal); title(sprintf('Global mask, level=%.3f', level))

%% 3. Foreground polarity
% A mask is only correct if true pixels represent the objects you intend to
% analyze. Sometimes the desired foreground is dark instead of bright.

maskDark = image < uint8(level * 255);

%% 4. Adaptive thresholding
% Use adaptive thresholding when background/illumination changes across the
% image and a single global threshold fails for that reason.
%
% adaptthresh calculates a local threshold surface. Sensitivity changes how
% readily pixels are classified as foreground.

T = adaptthresh(image, 0.5, 'ForegroundPolarity', 'bright');
maskAdaptive = imbinarize(image, T);

figure
subplot(1,2,1); imshow(maskGlobal);   title('Global')
subplot(1,2,2); imshow(maskAdaptive); title('Adaptive')

%% 5. Remove small objects
% bwareaopen removes connected foreground components smaller than a chosen
% pixel area. Choose the size from imaging resolution/object expectations,
% not simply because a value makes the mask look cleaner.

minArea_px = 50;
maskClean = bwareaopen(maskGlobal, minArea_px);

figure
subplot(1,2,1); imshow(maskGlobal); title('Before cleanup')
subplot(1,2,2); imshow(maskClean);  title(sprintf('Remove objects < %d px', minArea_px))

%% 6. Fill holes
% imfill(...,'holes') fills background regions completely enclosed by
% foreground. Use it only if holes are artifacts for your analysis question.

maskFilled = imfill(maskClean, 'holes');
figure
subplot(1,2,1); imshow(maskClean);  title('Before filling')
subplot(1,2,2); imshow(maskFilled); title('Filled holes')

%% 7. Erosion and dilation
% Morphology uses a structuring element to define neighborhood geometry.
% erosion shrinks foreground; dilation expands it.

se = strel('disk', 2);
eroded = imerode(maskFilled, se);
dilated = imdilate(maskFilled, se);

figure
subplot(1,3,1); imshow(maskFilled); title('Mask')
subplot(1,3,2); imshow(eroded);     title('Eroded')
subplot(1,3,3); imshow(dilated);    title('Dilated')

%% 8. Opening and closing
% Opening = erosion then dilation: can remove small protrusions/objects.
% Closing = dilation then erosion: can close small gaps.
% These operations can change object geometry; validate before measurement.

opened = imopen(maskFilled, se);
closed = imclose(maskFilled, se);

figure
subplot(1,3,1); imshow(maskFilled); title('Original mask')
subplot(1,3,2); imshow(opened);     title('Opening')
subplot(1,3,3); imshow(closed);     title('Closing')

%% 9. Validate the mask against raw data
% A binary mask should never be judged alone.

overlay = labeloverlay(image, maskFilled, 'Transparency', 0.6);
figure
imshow(overlay)
title('Validate segmentation on original image')

%% 10. Thresholding decision guide
% Global threshold:
% - use when illumination is reasonably uniform and one split makes sense.
%
% Adaptive threshold:
% - use when local background variation is the main reason global fails.
%
% Morphology:
% - use only to correct a defined mask artifact.
%
% Always ask whether cleanup changes meaningful small structures.

%% 11. Practice
% 1. Change the global threshold manually and compare masks.
% 2. Change adaptive sensitivity from 0.3 to 0.7.
% 3. Change minArea_px and identify what real structures are lost.
% 4. Explain why morphology can bias shape measurements.

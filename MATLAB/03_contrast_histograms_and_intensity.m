%% 03. Histograms, Intensity, and Contrast
% Author: Md. Mobarak Karim, Ph.D.
%
% Goal: learn how to inspect intensity distributions and decide whether
% contrast adjustment is needed.

%% 1. Load and inspect
image = imread('pout.tif');
figure; imshow(image); title('Original image')

fprintf('Class: %s\n', class(image))
fprintf('Range: %g to %g\n', double(min(image(:))), double(max(image(:))))

%% 2. Histogram
% A histogram counts how many pixels fall at each intensity.
% It helps reveal clipping, narrow dynamic range, multiple populations, and
% whether one global threshold may be reasonable.

figure
imhist(image)
title('Image histogram')

%% 3. Percentiles
% Percentiles are often more robust than min/max because a few extreme pixels
% do not dominate them.

d = double(image(:));
p1 = prctile(d,1);
p99 = prctile(d,99);
fprintf('1st percentile = %.2f, 99th percentile = %.2f\n', p1, p99)

%% 4. Display-only contrast
% imshow(I,[]) changes DISPLAY mapping only.
figure
imshow(image, [])
title('Display stretched only')

%% 5. Global intensity remapping with imadjust
% imadjust changes pixel values. Use it when you intentionally want a new
% contrast representation, not merely a prettier display.

limits = stretchlim(image, [0.01 0.99]);
adjusted = imadjust(image, limits, []);

figure
subplot(1,2,1); imshow(image);    title('Original')
subplot(1,2,2); imshow(adjusted); title('imadjust')

%% 6. Histogram equalization
% histeq redistributes intensities globally. It can reveal contrast but may
% also exaggerate noise or create an appearance that is less quantitative.

equalized = histeq(image);
figure
subplot(1,2,1); imshow(image);      title('Original')
subplot(1,2,2); imshow(equalized);  title('histeq')

%% 7. Local contrast enhancement
% adapthisteq (CLAHE-style) works locally and can help when contrast varies
% across the field. Use it cautiously because local enhancement can amplify
% noise and alter visual relationships.

localEnhanced = adapthisteq(image, 'ClipLimit', 0.01);
figure
subplot(1,2,1); imshow(image);          title('Original')
subplot(1,2,2); imshow(localEnhanced);  title('adapthisteq')

%% 8. Decision guide
% Use histogram/percentiles first.
% Use display stretching when only visualization is the problem.
% Use imadjust when a defined global remapping is useful.
% Use adapthisteq when illumination/contrast varies locally.
% Do not apply enhancement automatically before quantitative analysis.

%% 9. Practice
% 1. Compare histograms before/after imadjust.
% 2. Change the stretchlim percentiles.
% 3. Change adapthisteq ClipLimit and explain the trade-off.
% 4. Explain the difference between changing display and changing data.

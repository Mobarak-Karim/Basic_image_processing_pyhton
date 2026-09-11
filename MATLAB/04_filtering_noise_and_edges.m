%% 04. Filtering, Noise, and Edges
% Author: Md. Mobarak Karim, Ph.D.
%
% Goal: choose a filter because of a specific image problem, not because
% filtering is a routine step.

%% 1. Load image and add controlled noise for learning
image = im2double(imread('cameraman.tif'));

noisyGaussian = imnoise(image, 'gaussian', 0, 0.002);
noisyImpulse = imnoise(image, 'salt & pepper', 0.03);

figure
subplot(1,3,1); imshow(image);         title('Original')
subplot(1,3,2); imshow(noisyGaussian); title('Gaussian-like noise')
subplot(1,3,3); imshow(noisyImpulse);  title('Salt & pepper noise')

%% 2. Gaussian filter
% imgaussfilt smooths by weighted local averaging.
% Use it when small-scale random variation should be reduced and some blur
% is acceptable.
% Sigma controls the smoothing scale: larger sigma -> stronger blur.

sigma = 1.2;
gaussianFiltered = imgaussfilt(noisyGaussian, sigma, 'Padding', 'replicate');

figure
subplot(1,2,1); imshow(noisyGaussian);     title('Before')
subplot(1,2,2); imshow(gaussianFiltered);  title(sprintf('Gaussian sigma = %.1f', sigma))

%% 3. Median filter
% medfilt2 replaces a pixel by the median of a neighborhood.
% It is often a better first choice for isolated bright/dark impulse noise.
% Larger neighborhoods remove more noise but can erase small structures.

medianFiltered = medfilt2(noisyImpulse, [3 3], 'symmetric');

figure
subplot(1,2,1); imshow(noisyImpulse);   title('Impulse noise')
subplot(1,2,2); imshow(medianFiltered); title('3x3 median filter')

%% 4. Why filtering is a trade-off
% Every smoothing filter suppresses some spatial information.
% Ask:
% - What type of noise/problem do I see?
% - What is the smallest real structure I need to preserve?
% - Will smoothing change a later threshold or measurement?
% - Did I compare filtered and raw images side-by-side?

%% 5. Edge detection
% edge detects rapid spatial intensity changes.
% Sobel is useful for learning gradients; Canny includes smoothing and
% non-maximum suppression and is often more selective.

edgesSobel = edge(image, 'sobel');
edgesCanny = edge(image, 'canny');

figure
subplot(1,3,1); imshow(image);      title('Original')
subplot(1,3,2); imshow(edgesSobel); title('Sobel edges')
subplot(1,3,3); imshow(edgesCanny); title('Canny edges')

%% 6. Gradient magnitude
% imgradient gives a continuous gradient magnitude rather than a binary edge map.

gradientMagnitude = imgradient(image, 'sobel');
figure
imshow(gradientMagnitude, [])
title('Gradient magnitude')
colorbar

%% 7. Parameter sensitivity
sigmas = [0.5 1 2 4];
figure
for i = 1:numel(sigmas)
    filtered = imgaussfilt(image, sigmas(i));
    subplot(2,2,i)
    imshow(filtered)
    title(sprintf('sigma = %.1f', sigmas(i)))
end

%% 8. Practice
% 1. Compare Gaussian and median filtering on both noise types.
% 2. Increase sigma until a small feature visibly disappears.
% 3. Compare Sobel and Canny edge maps.
% 4. Explain why an edge map is not automatically an object segmentation.

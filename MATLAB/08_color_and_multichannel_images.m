%% 08. Color and Multichannel Images
% Author: Md. Mobarak Karim, Ph.D.
%
% Goal: understand that RGB color images and scientific multichannel images
% may have similar array shapes but very different meanings.

%% 1. RGB image structure
rgbImage = imread('peppers.png');

fprintf('Size: %s\n', mat2str(size(rgbImage)))
fprintf('Class: %s\n', class(rgbImage))

figure
imshow(rgbImage)
title('RGB image')

%% 2. Extract RGB channels
R = rgbImage(:,:,1);
G = rgbImage(:,:,2);
B = rgbImage(:,:,3);

figure
subplot(1,3,1); imshow(R); title('Red channel')
subplot(1,3,2); imshow(G); title('Green channel')
subplot(1,3,3); imshow(B); title('Blue channel')

%% 3. RGB to grayscale
% rgb2gray is appropriate when you intentionally want a luminance-like
% grayscale representation of a standard color image.
% Do not use rgb2gray blindly on fluorescence channels with different markers.

grayImage = rgb2gray(rgbImage);
figure
imshow(grayImage)
title('RGB -> grayscale')

%% 4. Scientific channels are not automatically RGB
% A fluorescence stack may be rows x columns x channels, but channel 1 may
% represent nuclei, channel 2 vasculature, etc. The third dimension is then
% biological/acquisition information rather than display color.

rows = 256;
cols = 256;
[xGrid, yGrid] = meshgrid(1:cols, 1:rows);

% Synthetic nuclei-like spots.
nuclei = exp(-((xGrid-80).^2 + (yGrid-100).^2)/(2*12^2)) + ...
         exp(-((xGrid-170).^2 + (yGrid-150).^2)/(2*18^2));

% Synthetic vessel-like structure.
vessel = exp(-((yGrid - (0.45*xGrid + 35)).^2)/(2*5^2));

nuclei = mat2gray(nuclei);
vessel = mat2gray(vessel);

multiChannel = cat(3, nuclei, vessel);

fprintf('Synthetic multichannel size: %s\n', mat2str(size(multiChannel)))

%% 5. Display scientific channels independently
figure
subplot(1,2,1); imshow(multiChannel(:,:,1), []); title('Channel 1: nuclei-like')
subplot(1,2,2); imshow(multiChannel(:,:,2), []); title('Channel 2: vessel-like')

%% 6. Create a visualization composite
% This composite is for visualization. It does not mean the data were
% acquired as RGB.

composite = zeros(rows, cols, 3);
composite(:,:,1) = nuclei;  % red display
composite(:,:,2) = vessel;  % green display

figure
imshow(composite)
title('Synthetic two-channel composite')

%% 7. Analyze channels separately when the question is channel-specific
% Example: segment nuclei from channel 1 only.

nucleiMask = imbinarize(nuclei);
nucleiMask = bwareaopen(nucleiMask, 20);

figure
subplot(1,2,1); imshow(nuclei, []);     title('Nuclei channel')
subplot(1,2,2); imshow(nucleiMask);     title('Nuclei mask')

%% 8. Measure one channel inside regions defined by another
% A common scientific workflow is:
% - segment objects in one marker/channel
% - measure intensity from another marker/channel inside those same objects.

labels = bwlabel(nucleiMask);
stats = regionprops('table', labels, vessel, 'Area', 'MeanIntensity');
disp(stats)

%% 9. Channel questions to ask
% - What physical fluorophore/marker does each channel represent?
% - Is channel order documented?
% - Are intensities quantitative/comparable?
% - Is there spectral bleed-through or background?
% - Was any channel normalized for display only?
% - Should segmentation use one channel or a combination?

%% 10. Practice
% 1. Swap red/green display channels in the composite.
% 2. Segment the vessel channel instead of nuclei.
% 3. Measure nuclei-channel intensity in vessel-defined regions.
% 4. Explain why a scientific 3-channel stack should not automatically be
%    treated like a photograph.

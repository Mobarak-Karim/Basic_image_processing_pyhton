%% 06. Segmentation and Object Labels
% Author: Md. Mobarak Karim, Ph.D.
%
% Goal: move from a binary foreground/background mask to individual objects
% that can be validated and measured.

%% 1. Start from a binary mask
image = imread('coins.png');
mask = imbinarize(image);
mask = bwareaopen(mask, 50);
mask = imfill(mask, 'holes');

figure
subplot(1,2,1); imshow(image); title('Original')
subplot(1,2,2); imshow(mask);  title('Binary mask')

%% 2. Connected components
% bwconncomp groups touching foreground pixels into connected objects.
% This is useful when objects are already separated in the binary mask.

CC = bwconncomp(mask);
fprintf('Connected objects: %d\n', CC.NumObjects)

%% 3. Label matrix
% labelmatrix converts connected components to an integer label image:
% 0 = background, 1 = first object, 2 = second object, etc.

labels = labelmatrix(CC);

figure
imshow(label2rgb(labels, 'jet', 'k', 'shuffle'))
title('Connected-component labels')

%% 4. Validate labels on the original image
% labeloverlay is one of the most important quality-control steps.
% If labels do not match visible objects, do not trust measurements yet.

overlay = labeloverlay(image, labels, 'Transparency', 0.65);
figure
imshow(overlay)
title('Label overlay for validation')

%% 5. Connectivity matters
% In 2-D, pixels can be connected through 4-neighborhood or 8-neighborhood.
% The default often works well, but connectivity can change object counts.

CC4 = bwconncomp(mask, 4);
CC8 = bwconncomp(mask, 8);

fprintf('4-connectivity objects: %d\n', CC4.NumObjects)
fprintf('8-connectivity objects: %d\n', CC8.NumObjects)

%% 6. Why touching objects are difficult
% Connected-component labeling cannot separate objects if the binary mask
% says they are one connected region. In that situation you need a different
% segmentation strategy, possibly distance-transform watershed.

%% 7. Distance transform for touching objects
% bwdist(~mask) gives distance from foreground pixels to the nearest
% background. Peaks tend to occur near object centers.

distanceMap = bwdist(~mask);
figure
imshow(distanceMap, [])
title('Distance transform')
colorbar

%% 8. Watershed concept
% Watershed treats an image like a topographic surface.
% A common touching-object workflow is:
% mask -> distance transform -> find/modify minima -> watershed -> split mask.
%
% Watershed is powerful but can over-segment. It should not be used simply
% because it exists; use it when touching objects are a demonstrated problem.

D = -distanceMap;
D(~mask) = -Inf;
L = watershed(D);

maskWatershed = mask;
maskWatershed(L == 0) = 0;

figure
subplot(1,2,1); imshow(mask);          title('Original mask')
subplot(1,2,2); imshow(maskWatershed); title('Simple watershed split')

%% 9. Relabel after splitting
labelsSplit = bwlabel(maskWatershed);
overlaySplit = labeloverlay(image, labelsSplit, 'Transparency', 0.65);

figure
imshow(overlaySplit)
title('Watershed result - validate carefully')

%% 10. Segmentation validation questions
% - Does every label correspond to one intended object?
% - Are objects merged?
% - Are single objects split into fragments?
% - Are border objects acceptable for the analysis question?
% - Are small bright artifacts becoming labels?
% - Does the result remain sensible if a parameter changes slightly?

%% 11. Practice
% 1. Compare 4- and 8-connectivity.
% 2. Find an image/mask where two objects touch.
% 3. Compare connected-components labeling with watershed.
% 4. Explain why watershed output must be validated visually.

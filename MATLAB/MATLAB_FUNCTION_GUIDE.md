# MATLAB Image Processing Function Guide

**Author: Md. Mobarak Karim, Ph.D.**

This guide answers a practical beginner question: **Which MATLAB function should I try, and why?**

The rule is simple: choose a function because it addresses a specific problem you observed in the data.

## I need to inspect an image

### `size(I)`
Use when you need rows, columns, and channels.

```matlab
size(I)
```

### `class(I)`
Use when you need to know whether data are `uint8`, `uint16`, `single`, `double`, etc.

```matlab
class(I)
```

### `min(I(:))`, `max(I(:))`
Use to inspect the stored numerical range.

```matlab
[min(I(:)) max(I(:))]
```

## I need to display an image

### `imshow(I)`
Use for ordinary image display.

### `imshow(I, [])`
Use when you want MATLAB to stretch the current numeric range **for display only**.

Do not confuse better display contrast with changed pixel values.

## I need to convert an RGB photograph to grayscale

### `rgb2gray(I)`
Use for ordinary RGB color data when a luminance-style grayscale image matches the analysis question.

Do **not** automatically apply it to scientific fluorescence channels.

## I need floating-point image values

### `im2double(I)`
Use when you want standard integer image data converted to normalized floating point.

```matlab
I2 = im2double(I);
```

### `double(I)`
Use when you only want the numeric class changed and intentionally want to keep the original numeric magnitudes.

The two operations are not equivalent for `uint8`/`uint16` images.

## I need to understand contrast

### `imhist(I)`
Use to inspect the intensity distribution before choosing thresholds or contrast operations.

### `stretchlim(I)` + `imadjust(I,...)`
Use for a deliberate global intensity remapping.

### `adapthisteq(I)`
Use when local contrast varies across the image and local enhancement is justified.

Caution: local enhancement can amplify noise and alter appearance strongly.

## I have small-scale smooth/random noise

### `imgaussfilt(I, sigma)`
Use for Gaussian-like noise or when gentle smoothing is useful before another step.

Important parameter: `sigma`.

Larger sigma means stronger smoothing and more loss of fine structure.

## I have isolated salt-and-pepper noise

### `medfilt2(I, [m n])`
Use when isolated extreme pixels are the problem.

Median filtering often preserves edges better than Gaussian smoothing for impulse noise.

## I want edges

### `edge(I, 'sobel')`
Useful for basic gradient-based edge detection.

### `edge(I, 'canny')`
Useful when you want a more selective edge detector with smoothing and non-maximum suppression.

Remember: edges are not automatically segmented objects.

## I need one threshold for the whole image

### `graythresh(I)` + `imbinarize(I, level)`
Use when one global threshold is a reasonable model for foreground/background separation.

```matlab
level = graythresh(I);
BW = imbinarize(I, level);
```

Validate the mask against the raw image.

## Illumination/background changes across the image

### `adaptthresh(I, sensitivity)` + `imbinarize`
Use when a single threshold fails specifically because local background varies.

```matlab
T = adaptthresh(I, 0.5);
BW = imbinarize(I, T);
```

Important parameter: `Sensitivity` or the sensitivity input.

Higher sensitivity generally classifies more pixels as foreground.

## I need to remove tiny foreground objects

### `bwareaopen(BW, P)`
Use when connected foreground regions smaller than `P` pixels are known artifacts for the analysis.

Do not choose `P` only because the image looks cleaner. Tie it to resolution and expected object size.

## I need to fill enclosed holes

### `imfill(BW, 'holes')`
Use when holes inside segmented objects are artifacts for your measurement goal.

Do not fill real biological cavities automatically.

## I need erosion, dilation, opening, or closing

### `imerode`, `imdilate`, `imopen`, `imclose`
Use with a structuring element such as:

```matlab
se = strel('disk', 2);
```

These operations change object geometry. Validate carefully before shape measurement.

## I need individual object IDs

### `bwconncomp(BW)`
Use when you want connected-component information efficiently.

### `bwlabel(BW)`
Use when you want a label matrix directly.

If touching objects form one connected region, connected-component labeling cannot separate them by itself.

## Touching objects need to be split

### `bwdist` + `watershed`
Use when objects are truly touching and a distance-transform watershed model is appropriate.

Watershed can easily over-segment. Always inspect an overlay.

## I need to see whether labels match objects

### `labeloverlay(I, L)`
One of the most useful QC functions in an image-analysis pipeline.

```matlab
overlay = labeloverlay(I, L, 'Transparency', 0.65);
imshow(overlay)
```

Use before trusting `regionprops` output.

## I need object measurements

### `regionprops('table', ...)`
Use for geometric and intensity measurements from binary/labeled objects.

```matlab
T = regionprops('table', L, I, ...
    'Area', 'Centroid', 'MeanIntensity');
```

Remember that `Area` is in pixels unless you apply physical calibration.

## I need to process many files

### `dir` + `fullfile` + a reusable function

```matlab
files = dir(fullfile(folder, '*.tif'));

for i = 1:numel(files)
    path = fullfile(files(i).folder, files(i).name);
    I = imread(path);
    % call validated analysis function
end
```

Batch processing should come **after** the single-image pipeline has been validated.

## I need to save quantitative results

### `writetable(T, 'results.csv')`
Use for measurement tables.

### `save('parameters.mat', 'params')`
Use for MATLAB variables/parameter structures.

## Decision checklist before choosing a function

Ask these questions in order:

1. What exactly is wrong or missing in the current image representation?
2. Is the issue display-only or does the underlying data need processing?
3. What assumption does the candidate function make?
4. Which parameter controls its behavior?
5. What real structures could the operation damage?
6. How will I compare the result with the raw image?
7. How will I record the chosen parameter for reproducibility?

That reasoning is more important than memorizing the function name.

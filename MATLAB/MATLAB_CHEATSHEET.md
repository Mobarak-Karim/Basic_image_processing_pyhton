# MATLAB Image Processing Cheat Sheet

**Author: Md. Mobarak Karim, Ph.D.**

Use this after you understand the concepts. For reasoning about which method to choose, see [`MATLAB_FUNCTION_GUIDE.md`](MATLAB_FUNCTION_GUIDE.md).

## Basic syntax

```matlab
x = 5;                  % assignment
name = "sample";       % string
flag = true;            % logical
values = [10 20 30];    % row vector
M = [1 2; 3 4];         % matrix
```

## Inspect variables

```matlab
whos
size(M)
class(M)
numel(M)
```

## Indexing

MATLAB starts at **1**.

```matlab
values(1)       % first item
values(end)     % last item
values(2:3)     % slice
M(2,3)          % row 2, column 3
M(:,2)          % all rows, column 2
M(1:10,20:30)   % crop-like indexing
```

## Element-wise math

```matlab
y = x.^2;
z = a .* b;
r = a ./ b;
```

Use `.*`, `./`, and `.^` when an equation should operate element-by-element.

## if / elseif / else

```matlab
if value > 100
    label = "high";
elseif value > 50
    label = "medium";
else
    label = "low";
end
```

## switch / case

```matlab
switch method
    case "otsu"
        disp("global threshold")
    case "adaptive"
        disp("local threshold")
    otherwise
        disp("unknown")
end
```

## for loop

```matlab
for i = 1:5
    disp(i)
end
```

## while loop

```matlab
count = 0;
while count < 3
    count = count + 1;
end
```

## Function call

```matlab
m = mean(values);
```

## Local function

```matlab
function y = linearModel(x, slope, intercept)
    y = slope .* x + intercept;
end
```

## File paths

```matlab
path = fullfile("data", "image.tif");
files = dir(fullfile("data", "*.tif"));
```

## Read/display image

```matlab
I = imread("image.tif");
imshow(I)
```

## Inspect image

```matlab
size(I)
class(I)
min(I(:))
max(I(:))
```

## Convert image for calculations

```matlab
I2 = im2double(I);
```

## Crop

```matlab
crop = I(rowStart:rowEnd, colStart:colEnd);
```

## Histogram

```matlab
imhist(I)
```

## Gaussian filtering

```matlab
smooth = imgaussfilt(I, 1.0);
```

## Median filtering

```matlab
filtered = medfilt2(I, [3 3]);
```

## Global threshold

```matlab
level = graythresh(I);
BW = imbinarize(I, level);
```

## Adaptive threshold

```matlab
T = adaptthresh(I, 0.5);
BW = imbinarize(I, T);
```

## Remove small objects

```matlab
BW = bwareaopen(BW, 50);
```

## Fill holes

```matlab
BW = imfill(BW, "holes");
```

## Label objects

```matlab
L = bwlabel(BW);
```

## Validate labels

```matlab
overlay = labeloverlay(I, L, "Transparency", 0.65);
imshow(overlay)
```

## Measure

```matlab
T = regionprops("table", L, I, ...
    "Area", "Centroid", "MeanIntensity");
```

## Save table

```matlab
writetable(T, "results.csv");
```

## Debugging habit

When something is wrong:

```matlab
size(variable)
class(variable)
min(variable(:))
max(variable(:))
```

Then inspect the exact line that failed and reduce the problem to a smaller example.

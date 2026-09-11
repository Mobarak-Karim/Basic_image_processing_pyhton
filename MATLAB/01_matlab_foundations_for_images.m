%% 01. MATLAB Foundations -> Scientific Thinking -> Images
% Author: Md. Mobarak Karim, Ph.D.
% Level: Complete beginner
%
% Goal:
% This lesson teaches the MATLAB language used throughout the rest of the
% image-processing course. A learner should not need a separate MATLAB
% programming tutorial before continuing.
%
% Learning rule:
% Before running a section, predict what it should do. Then run it, inspect
% the result, change one value, and explain why the result changed.

%% 1. How MATLAB code works
% MATLAB normally executes a script from top to bottom.
%
% A semicolon suppresses output in the Command Window.
% A percent sign starts a comment.
% A double percent sign starts a section, similar to a notebook cell.

x = 5;          % assignment statement: store 5 in x
y = x + 2;      % expression x + 2 is evaluated, then stored in y
disp(y)         % call the built-in function disp

%% 2. Useful commands while learning
% clc       -> clear Command Window text
% clear     -> remove variables from the workspace
% close all -> close figure windows
% whos      -> inspect variables, sizes, classes, and memory use
% help NAME -> short help in the Command Window
% doc NAME  -> open full documentation

whos

%% 3. Variables and naming
% A variable is a readable name referring to a value.
% In scientific code, names should communicate meaning and units.
%
% Good:
%   pixelSize_um
%   thresholdValue
%   exposure_ms
%
% Avoid vague names such as a1, q, or tmp when a descriptive name is easy.

pixelSize_um = 0.65;
thresholdValue = 120;
sampleName = "mouse_embryo";
isValid = true;

%% 4. Basic data types
% MATLAB numeric values are double precision by default.
%
% Common classes:
% double  -> default numeric type
% single  -> lower-precision floating point
% uint8   -> unsigned 8-bit integer, common for images
% uint16  -> unsigned 16-bit integer, common for scientific images
% logical -> true/false
% string  -> text using double quotes
% char    -> older text representation using single quotes

count = 12;
piApprox = 3.14159;
label = "cell";
flag = true;

class(count)
class(label)
class(flag)

%% 5. Converting data types
% Use conversion functions intentionally.
% Examples: double(), single(), uint8(), uint16(), string(), logical().

textValue = "42";
numberValue = str2double(textValue);
disp(numberValue)

%% 6. Arithmetic operators
% +   addition
% -   subtraction
% *   matrix multiplication
% /   matrix division
% ^   matrix power
%
% Element-wise operators are essential in scientific MATLAB:
% .*  element-wise multiplication
% ./  element-wise division
% .^  element-wise power
%
% For scalar numbers, * and .* give the same result. For arrays they mean
% different things, so develop the habit of asking whether your equation is
% matrix algebra or element-by-element arithmetic.

a = 10;
b = 3;

disp(a + b)
disp(a - b)
disp(a * b)
disp(a / b)
disp(a ^ b)

%% 7. Operator precedence and parentheses
% MATLAB follows standard mathematical precedence. Parentheses make the
% intended grouping easier to read and reduce mistakes.

a = 3;
b = 4;
c = 5;
result1 = a + b * c;
result2 = (a + b) * c;

disp([result1 result2])

%% 8. How to translate a mathematical formula into MATLAB
% This is one of the most important skills in scientific programming.
%
% Use this checklist:
% 1. Write the equation clearly.
% 2. Identify every symbol.
% 3. State the units of every quantity.
% 4. Decide which values are inputs.
% 5. Decide what output you need.
% 6. Translate mathematical operators into MATLAB syntax.
% 7. Decide whether operations are scalar, matrix, or element-wise.
% 8. Preserve grouping with parentheses.
% 9. Test a simple case with a known answer.
% 10. Check the expected trend and units.
% 11. Only then apply the code to experimental data.

%% 9. Equation example: circle area
% Original equation:
%       A = pi * r^2
%
% Inputs: radius r
% Output: area A
% If r is in micrometers, A is in square micrometers.

radius_um = 5;
area_um2 = pi * radius_um^2;
fprintf('Area = %.3f um^2\n', area_um2)

% Validation: r = 1 should give approximately pi.
testArea = pi * 1^2;
assert(abs(testArea - pi) < 1e-12)

%% 10. Equation example: linear relationship
% Original equation:
%       y = m*x + b
%
% Descriptive variable names can be clearer than single-letter symbols.

slope = 2.5;
xValue = 4;
intercept = 1.2;
yValue = slope * xValue + intercept;
disp(yValue)

%% 11. Equation example: exponential attenuation
% A Beer-Lambert-style model:
%       I = I0 * exp(-mu*z)
%
% Conceptual checks before coding:
% - At z = 0, I should equal I0.
% - If mu > 0, intensity should decrease as depth increases.
% - mu*z must be dimensionless, so the units must cancel.

I0 = 1.0;
mu_per_mm = 2.0;
z_mm = [0 0.5 1.0 2.0];

% exp() already operates element-by-element on an array.
I = I0 .* exp(-mu_per_mm .* z_mm);
disp(table(z_mm(:), I(:), 'VariableNames', {'Depth_mm','Intensity'}))

%% 12. Equation example: Euclidean distance
%       d = sqrt((x2-x1)^2 + (y2-y1)^2)

x1 = 2;
y1 = 3;
x2 = 8;
y2 = 11;

distance = sqrt((x2-x1)^2 + (y2-y1)^2);
disp(distance)

%% 13. Equation example: normalization
% A common normalization equation is
%       xNorm = (x - xmin) / (xmax - xmin)
%
% For an array, subtraction and division should be element-wise.

values = [10 20 30 40 50];
xMin = min(values);
xMax = max(values);
valuesNorm = (values - xMin) ./ (xMax - xMin);
disp(valuesNorm)

%% 14. Equation example: Gaussian function
%       G(x) = exp(-(x-mu)^2/(2*sigma^2))
%
% Here x is a vector, so the square must be element-wise: .^2

x = -5:0.1:5;
mu = 0;
sigma = 1;
G = exp(-((x - mu).^2) ./ (2 * sigma^2));

figure
plot(x, G, 'LineWidth', 1.5)
xlabel('x')
ylabel('G(x)')
title('Gaussian function')
grid on

%% 15. Conceptualizing a programming problem before writing code
% Before touching MATLAB, write the problem in plain language.
%
% Example question:
% "For every segmented object, keep it only if its area is at least
% 100 pixels AND its mean intensity is above 120."
%
% Inputs:
% - area
% - mean intensity
%
% Rule:
% keep = (area >= 100) AND (meanIntensity > 120)
%
% Output:
% logical true/false

area_pixels = 250;
meanIntensity = 160;
keepObject = (area_pixels >= 100) && (meanIntensity > 120);
disp(keepObject)

%% 16. Pseudocode
% Pseudocode is plain-language logic written before exact MATLAB syntax.
%
% Example:
%   LOAD image
%   INSPECT size and class
%   IF RGB
%       convert to grayscale
%   END
%   SMOOTH image
%   COMPUTE threshold
%   CREATE binary mask
%   REMOVE tiny objects
%   LABEL objects
%   MEASURE objects
%   SAVE table
%
% Pseudocode is extremely useful when a project feels too complicated.

%% 17. Vectors and matrices
% MATLAB is built around arrays.
%
% Row vector:
rowVector = [10 20 30 40];

% Column vector:
columnVector = [10; 20; 30; 40];

% Matrix:
M = [1 2 3; 4 5 6; 7 8 9];

disp(M)
size(M)

%% 18. The colon operator
% The colon operator creates sequences and selects ranges.

indices = 1:5;
evenValues = 0:2:10;
disp(indices)
disp(evenValues)

%% 19. MATLAB indexing starts at 1
% This is different from Python/NumPy.
%
% MATLAB images are typically indexed as image(row, column).

values = [10 20 30 40 50];
firstValue = values(1);
lastValue = values(end);
middleValues = values(2:4);

disp(firstValue)
disp(lastValue)
disp(middleValues)

%% 20. Matrix indexing
% For a matrix M(row, column):

M = [10 20 30; 40 50 60; 70 80 90];
centerValue = M(2,2);
firstTwoRows = M(1:2, :);
lastTwoColumns = M(:, 2:3);

disp(centerValue)
disp(firstTwoRows)
disp(lastTwoColumns)

%% 21. Linear indexing
% MATLAB can also access an array using one index. MATLAB stores arrays in
% column-major order. For image work, row/column indexing is usually easier
% for beginners to reason about.

M = [1 2; 3 4];
disp(M(3))

%% 22. Strings
% Use double quotes for modern MATLAB strings.

sample = "zebrafish";
stage = "48 hpf";
message = sample + " at " + stage;
disp(message)

%% 23. Cell arrays
% Cell arrays can hold mixed content types. Curly braces extract contents.

mixed = {"sampleA", 42, true};
disp(mixed{1})
disp(mixed{2})

%% 24. Structures
% Structures store named fields and are useful for parameter sets.

params.sigma = 1.0;
params.threshold = 120;
params.method = "otsu";

disp(params)
disp(params.sigma)

%% 25. Tables
% Tables are excellent for measurements because columns have names.

objectID = (1:3)';
area_px = [120; 250; 175];
meanIntensity = [90; 150; 130];

measurementTable = table(objectID, area_px, meanIntensity);
disp(measurementTable)

%% 26. Comparison operators
% ==  equal
% ~=  not equal
% >   greater than
% <   less than
% >=  greater than or equal
% <=  less than or equal

x = 10;
disp(x == 10)
disp(x ~= 5)
disp(x > 7)

%% 27. Logical operators
% For scalar conditions:
% &&  short-circuit AND
% ||  short-circuit OR
% ~   NOT
%
% For element-wise logical arrays:
% &   AND
% |   OR
% ~   NOT

area = 250;
meanIntensity = 160;
keep = (area > 100) && (meanIntensity > 120);
disp(keep)

%% 28. if / elseif / else
% Use conditional statements when the program must choose between paths.

meanIntensity = 135;

if meanIntensity > 180
    category = "bright";
elseif meanIntensity > 100
    category = "medium";
else
    category = "dim";
end

disp(category)

%% 29. switch / case
% MATLAB's switch/case is useful when one variable can take one of several
% named modes. It is similar in purpose to Python match/case.

method = "otsu";

switch method
    case "otsu"
        message = "Use a global Otsu threshold.";
    case "adaptive"
        message = "Use adaptive thresholding.";
    otherwise
        message = "Unknown method.";
end

disp(message)

%% 30. for loops
% Use a for loop when repeating a task over known items.

files = ["a.tif", "b.tif", "c.tif"];

for i = 1:numel(files)
    fprintf('File %d: %s\n', i, files(i))
end

%% 31. Loop over values directly
% MATLAB often uses indexing, but you can also iterate over vector values.

thresholds = [80 100 120 140];
for threshold = thresholds
    fprintf('Testing threshold = %d\n', threshold)
end

%% 32. while loops
% A while loop continues while its condition remains true.
% Make sure something inside the loop changes the condition.

count = 0;
while count < 3
    disp(count)
    count = count + 1;
end

%% 33. break and continue
values = [5 -2 8 -1 10];

for i = 1:numel(values)
    value = values(i);

    if value < 0
        continue  % skip negative values
    end

    disp(value)

    if value == 10
        break     % stop the loop
    end
end

%% 34. Built-in functions
% A function performs an operation. Parentheses contain input arguments.
%
% Common examples:
% mean(values)
% max(values)
% size(M)
% class(M)
% numel(values)

values = [10 20 30 40];
disp(mean(values))
disp(max(values))
disp(numel(values))

%% 35. Positional arguments and name-value arguments
% Many MATLAB functions accept required positional inputs followed by
% optional name-value pairs.
%
% Example later:
% imgaussfilt(image, 1.5, 'Padding', 'replicate')
%
% Always read the documentation for the exact function signature.

%% 36. Writing your own local function
% In modern MATLAB, local functions may appear at the end of a script.
% We will call a function here and define it at the bottom of this file.

area = circleArea(5);
disp(area)

%% 37. Why use functions?
% Functions help you:
% - avoid repeating code
% - give a meaningful name to a calculation
% - test one piece independently
% - reuse the same logic for many files
% - make parameters explicit

result = linearModel(4, 2.5, 1.2);
disp(result)

%% 38. Anonymous functions
% A function handle can store a small function.

squareValue = @(x) x.^2;
disp(squareValue([1 2 3 4]))

%% 39. Scripts versus functions
% Script:
% - runs in the current workspace
% - convenient for exploration and teaching
%
% Function:
% - has explicit inputs and outputs
% - has its own local workspace
% - better for reusable analysis pipelines
%
% A common workflow is:
% explore in a script -> understand the steps -> move stable logic into a
% function.

%% 40. Files and paths
% Use fullfile instead of manually typing separators. It works across
% Windows, macOS, and Linux.

folder = "data";
filename = "image.tif";
imagePath = fullfile(folder, filename);
disp(imagePath)

%% 41. Listing files with dir
% This pattern is central to batch image processing.

files = dir(fullfile("data", "*.tif"));
% files may be empty if this repository does not currently contain TIFFs.
fprintf('Found %d TIFF files\n', numel(files))

%% 42. Common errors and debugging strategy
% Common MATLAB problems include:
% - Undefined function or variable
% - Index exceeds array bounds
% - Matrix dimensions must agree
% - Incorrect use of * instead of .*
% - Unexpected data class/range
% - Missing toolbox function
%
% Debugging workflow:
% 1. Read the first useful error message.
% 2. Identify the exact line.
% 3. Inspect the variables used on that line.
% 4. Check size(), class(), min(), max().
% 5. Reduce the problem to a small example.
% 6. Fix one issue at a time.

A = ones(3,4);
B = ones(3,4);

size(A)
size(B)

% Element-wise multiplication works because the sizes match.
C = A .* B;
size(C)

%% 43. try / catch
% Use try/catch when failure is expected and you want controlled handling.
% Do not use it to hide errors you should understand.

try
    value = str2double("12.5");
    assert(~isnan(value), 'Conversion failed')
    disp(value)
catch ME
    fprintf('Problem: %s\n', ME.message)
end

%% 44. assert for validation
% assert stops execution if a condition is false. It is useful for checking
% assumptions before an analysis continues.

pixelSize_um = 0.5;
assert(pixelSize_um > 0, 'Pixel size must be positive.')

%% 45. From scalar mathematics to array mathematics
% Suppose x contains several values. To evaluate y = x^2 + 2x + 1 for each
% value, use element-wise power and multiplication.

x = 0:5;
y = x.^2 + 2.*x + 1;
disp(y)

%% 46. Vectorization
% MATLAB is designed to operate on entire arrays. Prefer array operations
% when they express the mathematics clearly.

values = 1:5;
squaresVectorized = values.^2;

disp(squaresVectorized)

%% 47. Logical masks
% A comparison on an array produces a logical array. This is central to
% image thresholding.

values = [50 90 120 180 220];
mask = values > 120;
disp(mask)
disp(values(mask))

%% 48. Images are arrays
% A grayscale image is typically a 2-D matrix:
% rows x columns
%
% An RGB image is typically:
% rows x columns x 3
%
% Pixel access uses image(row, column), not image(x, y).

image = imread('cameraman.tif');

size(image)
class(image)
min(image(:))
max(image(:))

figure
imshow(image)
title('Original image')

%% 49. Crop an image using matrix slicing
% Rows 80 through 180, columns 100 through 200.

crop = image(80:180, 100:200);

figure
imshow(crop)
title('Cropped region')

%% 50. Image statistics
% Convert to double only when the mathematical operation requires it and
% you understand the expected range.

meanIntensity = mean(double(crop(:)));
stdIntensity = std(double(crop(:)));
minIntensity = min(crop(:));
maxIntensity = max(crop(:));

fprintf('Mean: %.2f\n', meanIntensity)
fprintf('Std : %.2f\n', stdIntensity)
fprintf('Min : %d\n', minIntensity)
fprintf('Max : %d\n', maxIntensity)

%% 51. A binary image mask
% Create a logical mask for pixels brighter than 120.

threshold = 120;
brightMask = image > threshold;

figure
imshow(brightMask)
title('Pixels > 120')

%% 52. Pixel area to physical area
% If one pixel is pixelSizeY_um tall and pixelSizeX_um wide:
%
% area_um2 = area_pixels * pixelSizeY_um * pixelSizeX_um

area_pixels = 500;
pixelSizeY_um = 0.5;
pixelSizeX_um = 0.5;

area_um2 = area_pixels * pixelSizeY_um * pixelSizeX_um;
fprintf('Physical area = %.2f um^2\n', area_um2)

%% 53. A complete mini reasoning example
% Question:
% What fraction of this image is brighter than a chosen threshold?
%
% Step 1: input -> grayscale image
% Step 2: rule -> pixel > threshold
% Step 3: output -> fraction of true pixels
% Step 4: validate -> fraction must lie between 0 and 1

threshold = 140;
mask = image > threshold;
fractionBright = nnz(mask) / numel(mask);

assert(fractionBright >= 0 && fractionBright <= 1)
fprintf('Bright-pixel fraction = %.3f\n', fractionBright)

%% 54. Practice problems
% Do these without copying the answer from another source.
%
% 1. Define width_um and height_um and compute rectangle area.
% 2. Translate y = a*x.^2 + b*x + c for x = 0:10.
% 3. Write an if statement that labels an intensity as dim/medium/bright.
% 4. Use a for loop to print thresholds 50, 100, 150, 200.
% 5. Write a function converting pixel area to um^2.
% 6. Crop a different part of cameraman.tif.
% 7. Create a mask above the crop mean.
% 8. Explain in words why image > threshold returns a logical image.
% 9. Explain the difference between * and .*.
% 10. Write pseudocode for: load -> smooth -> threshold -> measure.

%% 55. Final takeaway
% The goal is not to memorize MATLAB commands.
%
% The transferable skill is:
%
% QUESTION
%   -> define inputs and output
%   -> write concept/equation
%   -> check units
%   -> write pseudocode
%   -> translate to MATLAB
%   -> test a simple case
%   -> validate behavior
%   -> apply to data
%
% Once this reasoning process is comfortable, image-processing functions
% become tools inside a workflow rather than mysterious commands.

%% Local functions
function area = circleArea(radius)
%CIRCLEAREA Return area of a circle with the same squared units as radius.
    area = pi * radius.^2;
end

function y = linearModel(x, slope, intercept)
%LINEARMODEL Evaluate y = slope*x + intercept element-by-element.
    y = slope .* x + intercept;
end

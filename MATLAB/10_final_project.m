%% 10. Final Project: From Question to Reproducible Measurements
% Author: Md. Mobarak Karim, Ph.D.
%
% Goal: combine the entire MATLAB course into one transparent workflow.
% The emphasis is not on producing the prettiest mask. The emphasis is on
% being able to explain every analytical decision.

%% 1. Define the analysis question
% Example question:
% "How many bright, coin-like objects are present, and what are their areas
% and mean intensities?"
%
% Before coding, identify:
% INPUT  -> grayscale image
% OUTPUT -> object count + measurement table
% MODEL  -> bright foreground can be separated by thresholding
% RISKS  -> touching objects, small artifacts, border objects

%% 2. Load and inspect raw data
image = imread('coins.png');

fprintf('Size: %s\n', mat2str(size(image)))
fprintf('Class: %s\n', class(image))
fprintf('Range: %g to %g\n', double(min(image(:))), double(max(image(:))))

figure
subplot(1,2,1); imshow(image); title('Raw image')
subplot(1,2,2); imhist(image); title('Histogram')

%% 3. Define parameters in one place
params.gaussianSigma = 1.0;
params.minObjectArea_px = 50;
params.fillHoles = true;
params.pixelSizeY_um = 0.5;  % example calibration - replace for real data
params.pixelSizeX_um = 0.5;

%% 4. Preprocess only for a defined reason
% Here mild Gaussian smoothing is used to suppress small-scale variation
% before global thresholding. Compare it with the original image.

imageFloat = im2double(image);
smoothed = imgaussfilt(imageFloat, params.gaussianSigma);

figure
subplot(1,2,1); imshow(imageFloat); title('Original')
subplot(1,2,2); imshow(smoothed);   title(sprintf('Gaussian sigma=%.1f', params.gaussianSigma))

%% 5. Segment
% Otsu/global threshold is used because the histogram and illumination make
% one global threshold a reasonable first model for this teaching image.

level = graythresh(smoothed);
maskRaw = imbinarize(smoothed, level);

figure
subplot(1,2,1); imshow(smoothed); title('Image used for threshold')
subplot(1,2,2); imshow(maskRaw);  title(sprintf('Raw mask, level=%.3f', level))

%% 6. Clean the mask
mask = bwareaopen(maskRaw, params.minObjectArea_px);

if params.fillHoles
    mask = imfill(mask, 'holes');
end

figure
subplot(1,2,1); imshow(maskRaw); title('Before cleanup')
subplot(1,2,2); imshow(mask);    title('After cleanup')

%% 7. Label objects
labels = bwlabel(mask);
objectCount = max(labels(:));
fprintf('Object count = %d\n', objectCount)

%% 8. Validate segmentation on the original image
% This is a mandatory step before measurement.

overlay = labeloverlay(image, labels, 'Transparency', 0.65);
figure
imshow(overlay)
title('QC overlay: labels on raw image')

%% 9. Measure validated objects
measurements = regionprops('table', labels, image, ...
    'Area', 'Centroid', 'Perimeter', 'Eccentricity', 'MeanIntensity');

measurements.ObjectID = (1:height(measurements))';
measurements = movevars(measurements, 'ObjectID', 'Before', 1);

%% 10. Convert area into physical units
measurements.Area_um2 = measurements.Area .* ...
    params.pixelSizeY_um .* params.pixelSizeX_um;

disp(measurements)

%% 11. Inspect distributions
figure
subplot(1,2,1)
histogram(measurements.Area_um2)
xlabel('Area (um^2)')
ylabel('Count')
title('Area distribution')

subplot(1,2,2)
scatter(measurements.Area_um2, measurements.MeanIntensity, 'filled')
xlabel('Area (um^2)')
ylabel('Mean intensity')
title('Area vs intensity')

%% 12. Parameter sensitivity
% A scientifically useful pipeline should not collapse when a parameter is
% changed slightly. Here we vary Gaussian sigma and inspect object count.

sigmaValues = [0 0.5 1.0 1.5 2.0];
counts = zeros(size(sigmaValues));

for i = 1:numel(sigmaValues)
    sigma = sigmaValues(i);

    if sigma == 0
        testImage = imageFloat;
    else
        testImage = imgaussfilt(imageFloat, sigma);
    end

    testMask = imbinarize(testImage);
    testMask = bwareaopen(testMask, params.minObjectArea_px);
    testMask = imfill(testMask, 'holes');
    counts(i) = max(bwlabel(testMask), [], 'all');
end

sensitivityTable = table(sigmaValues(:), counts(:), ...
    'VariableNames', {'GaussianSigma','ObjectCount'});
disp(sensitivityTable)

figure
plot(sigmaValues, counts, 'o-', 'LineWidth', 1.5)
xlabel('Gaussian sigma')
ylabel('Object count')
title('Parameter sensitivity')
grid on

%% 13. Save results and parameters
resultsFile = fullfile(tempdir, 'matlab_final_project_measurements.csv');
paramsFile = fullfile(tempdir, 'matlab_final_project_parameters.mat');

writetable(measurements, resultsFile)
save(paramsFile, 'params', 'level', 'sensitivityTable')

fprintf('Saved results: %s\n', resultsFile)
fprintf('Saved parameters: %s\n', paramsFile)

%% 14. What should be documented for real research data?
% - analysis question
% - source/acquisition metadata
% - software/version/toolbox versions
% - every processing parameter
% - thresholding/segmentation method
% - exclusions and QC criteria
% - physical calibration
% - representative overlays
% - output-table column definitions

%% 15. Final self-test
% You should now be able to explain:
% 1. Why the image was converted with im2double.
% 2. Why Gaussian smoothing was used and what sigma means.
% 3. Why global thresholding was considered appropriate here.
% 4. What bwareaopen changes.
% 5. Why an overlay is required before regionprops.
% 6. How pixel area becomes physical area.
% 7. Why parameter sensitivity matters.
% 8. Why parameters must be saved with results.

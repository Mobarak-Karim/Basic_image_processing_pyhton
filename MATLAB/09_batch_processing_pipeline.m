%% 09. Batch Processing and Reusable Pipelines
% Author: Md. Mobarak Karim, Ph.D.
%
% Goal: turn a working single-image analysis into a reusable function and
% apply the same logic consistently to multiple images.

%% 1. Why batch processing comes late in the course
% Do not automate an analysis you have not validated on representative
% single images. Automation multiplies both good decisions and bad decisions.

%% 2. Explicit analysis parameters
params.gaussianSigma = 1.0;
params.minObjectArea_px = 50;
params.thresholdMethod = "otsu";

disp(params)

%% 3. Test one image first
image = imread('coins.png');
[resultTable, labels, mask] = analyzeOneImage(image, params);

disp(resultTable)

figure
subplot(1,3,1); imshow(image); title('Input')
subplot(1,3,2); imshow(mask);  title('Mask')
subplot(1,3,3); imshow(labeloverlay(image, labels, 'Transparency', 0.65)); title('Labels')

%% 4. Discover files with dir
% Put copies of your test TIFF images in a folder such as data/raw.
% fullfile makes the path portable across operating systems.

inputFolder = fullfile('data', 'raw');
files = dir(fullfile(inputFolder, '*.tif'));
fprintf('Found %d TIFF files\n', numel(files))

%% 5. Preallocate a container for per-image tables
allResults = table();

%% 6. Batch loop
% This section runs only if TIFF files were found.

for i = 1:numel(files)
    filename = files(i).name;
    filepath = fullfile(files(i).folder, filename);

    fprintf('Processing %d/%d: %s\n', i, numel(files), filename)

    image = imread(filepath);

    % If the image is RGB, convert only if grayscale analysis is appropriate.
    if ndims(image) == 3 && size(image,3) == 3
        image = rgb2gray(image);
    end

    [resultTable, ~, ~] = analyzeOneImage(image, params);

    % Record source filename so measurements can be traced back.
    resultTable.SourceFile = repmat(string(filename), height(resultTable), 1);

    allResults = [allResults; resultTable]; %#ok<AGROW>
end

%% 7. Save batch results
if ~isempty(allResults)
    outputFile = 'matlab_batch_measurements.csv';
    writetable(allResults, outputFile)
    fprintf('Saved %s\n', outputFile)
end

%% 8. Save parameters too
% Results without parameters are hard to reproduce.
save('matlab_batch_parameters.mat', 'params')

%% 9. Common batch-processing mistakes
% - processing different image types with one untested pipeline
% - silently converting RGB/scientific channels incorrectly
% - hard-coding thresholds without validation
% - overwriting raw data
% - not recording filenames
% - not saving parameter values
% - assuming a pipeline that works on one image works on all images

%% 10. Practice
% 1. Add a threshold mode option to analyzeOneImage.
% 2. Save a QC overlay for each processed image.
% 3. Add try/catch so one unreadable file does not stop the entire batch.
% 4. Record MATLAB version and parameter values with the results.

%% Local function
function [resultTable, labels, mask] = analyzeOneImage(image, params)
%ANALYZEONEIMAGE Simple, transparent example segmentation pipeline.
%
% Inputs:
%   image  - 2-D grayscale image
%   params - structure with gaussianSigma and minObjectArea_px
%
% Outputs:
%   resultTable - object measurements
%   labels      - labeled object matrix
%   mask        - final binary mask

    % Convert integer image to normalized floating point for filtering.
    imageFloat = im2double(image);

    % Smooth only to suppress small-scale noise before thresholding.
    smoothed = imgaussfilt(imageFloat, params.gaussianSigma);

    % Global Otsu threshold. Replace this if your data require another model.
    mask = imbinarize(smoothed);

    % Remove tiny components using an explicitly recorded area threshold.
    mask = bwareaopen(mask, params.minObjectArea_px);
    mask = imfill(mask, 'holes');

    % Label connected objects.
    labels = bwlabel(mask);

    % Measure area and mean intensity from the original image.
    resultTable = regionprops('table', labels, image, 'Area', 'MeanIntensity');
    resultTable.ObjectID = (1:height(resultTable))';
    resultTable = movevars(resultTable, 'ObjectID', 'Before', 1);
end

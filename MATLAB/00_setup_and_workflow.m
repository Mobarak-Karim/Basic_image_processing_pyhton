%% 00. MATLAB Setup and Image-Analysis Workflow
% Author: Md. Mobarak Karim, Ph.D.
%
% This lesson explains how to use MATLAB as a reproducible scientific
% workspace before doing image processing.

%% 1. Clean start
clc
clear
close all

%% 2. Inspect the MATLAB installation
% ver lists installed products and versions.
ver

% which shows which implementation MATLAB will call.
which imread
which imshow
which imgaussfilt
which imbinarize
which regionprops

%% 3. Understand the MATLAB interface
% Command Window -> quick commands and output
% Editor         -> scripts/functions
% Workspace      -> variables currently in memory
% Current Folder -> files MATLAB can see directly
% Figure windows -> plots and image displays
%
% For this course, use scripts with %% sections and run one section at a time.

%% 4. Current folder and path
currentFolder = pwd;
disp(currentFolder)

% Use fullfile to construct paths safely.
dataFolder = fullfile(currentFolder, 'data');
disp(dataFolder)

%% 5. Reproducible analysis habit
% A useful image-processing workflow is:
%
% QUESTION
%   -> LOAD
%   -> INSPECT size/class/range/channels
%   -> PREPROCESS only for a defined reason
%   -> SEGMENT
%   -> VALIDATE against original image
%   -> MEASURE
%   -> SAVE parameters and results
%
% Never jump directly from loading to measurement.

%% 6. Inspect before processing
image = imread('cameraman.tif');

fprintf('Class: %s\n', class(image))
fprintf('Rows: %d, Columns: %d\n', size(image,1), size(image,2))
fprintf('Min: %g, Max: %g\n', double(min(image(:))), double(max(image(:))))

figure
imshow(image)
title('Always inspect the raw image first')

%% 7. Keep display separate from quantitative modification
% Changing how an image is displayed does not necessarily change data.
% imagesc automatically maps values for display; the matrix remains the same.

figure
imagesc(image)
axis image off
colormap gray
colorbar
title('Display mapping with imagesc')

%% 8. Save parameters explicitly
% Put important analysis settings in a structure instead of scattering
% unexplained numbers through the script.

params.gaussianSigma = 1.0;
params.thresholdMethod = "otsu";
params.minObjectArea_px = 50;

disp(params)

%% 9. Record software information when reproducibility matters
matlabVersion = version;
disp(matlabVersion)

%% 10. Recommended working folders
% A simple project structure can be:
%
% project/
%   data/raw/       original copies, unchanged
%   data/processed/ derived images if needed
%   results/        CSV/MAT measurement tables
%   figures/        exported QC figures
%   scripts/        analysis code
%
% Do not overwrite authoritative raw research data.

%% 11. First practice
% 1. Run ver and identify whether Image Processing Toolbox is installed.
% 2. Use help imread and doc imread.
% 3. Change the current image to another MATLAB sample image if available.
% 4. Explain the difference between changing display and changing pixels.

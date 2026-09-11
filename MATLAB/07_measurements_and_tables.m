%% 07. Object Measurements and Tables
% Author: Md. Mobarak Karim, Ph.D.
%
% Goal: measure objects only after segmentation has been validated.

%% 1. Create a labeled object image
image = imread('coins.png');
mask = imbinarize(image);
mask = bwareaopen(mask, 50);
mask = imfill(mask, 'holes');
labels = bwlabel(mask);

figure
imshow(labeloverlay(image, labels, 'Transparency', 0.65))
title('Validate labels before measuring')

%% 2. regionprops
% regionprops measures geometry from a binary or labeled image.
% Common properties include Area, Centroid, BoundingBox, Perimeter,
% Eccentricity, MajorAxisLength, and MinorAxisLength.

stats = regionprops('table', labels, ...
    'Area', 'Centroid', 'BoundingBox', 'Perimeter', ...
    'Eccentricity', 'MajorAxisLength', 'MinorAxisLength');

disp(stats(1:min(5,height(stats)), :))

%% 3. Intensity measurements
% Supply the intensity image to measure intensity within each label.

intensityStats = regionprops('table', labels, image, ...
    'Area', 'MeanIntensity', 'MinIntensity', 'MaxIntensity');

disp(intensityStats(1:min(5,height(intensityStats)), :))

%% 4. Combine measurements
% regionprops can request geometry and intensity together.

measurements = regionprops('table', labels, image, ...
    'Area', 'Centroid', 'Perimeter', 'Eccentricity', 'MeanIntensity');

measurements.ObjectID = (1:height(measurements))';
measurements = movevars(measurements, 'ObjectID', 'Before', 1);

disp(measurements(1:min(5,height(measurements)), :))

%% 5. Pixel units vs physical units
% Area returned by regionprops is in pixels unless you convert it.
% For anisotropic pixels:
%
% area_um2 = area_pixels * pixelSizeY_um * pixelSizeX_um

pixelSizeY_um = 0.5;
pixelSizeX_um = 0.5;

measurements.Area_um2 = measurements.Area .* pixelSizeY_um .* pixelSizeX_um;

%% 6. Length conversion
% If pixels are square, one simple length conversion is:
% length_um = length_pixels * pixelSize_um
%
% For anisotropic pixels or complex measurements, physical calibration needs
% more careful handling.

pixelSize_um = 0.5;
measurements.Perimeter_um = measurements.Perimeter .* pixelSize_um;

%% 7. Inspect distributions
% Summary statistics and plots can reveal segmentation artifacts.

disp(summary(measurements))

figure
histogram(measurements.Area_um2)
xlabel('Area (um^2)')
ylabel('Object count')
title('Object area distribution')

%% 8. Quality-control filtering
% Filtering measurements is not a substitute for correct segmentation.
% If you remove objects based on area/intensity, record the criteria.

minArea_um2 = 20;
keep = measurements.Area_um2 >= minArea_um2;
filteredMeasurements = measurements(keep, :);

fprintf('Objects before QC: %d\n', height(measurements))
fprintf('Objects after QC : %d\n', height(filteredMeasurements))

%% 9. Save a table
outputFile = fullfile(tempdir, 'object_measurements.csv');
writetable(filteredMeasurements, outputFile)
fprintf('Saved: %s\n', outputFile)

%% 10. Measurement checklist
% Before reporting a number, ask:
% - Was segmentation visually validated?
% - What units does the measurement have?
% - Were border objects included or excluded?
% - Were any size/intensity filters applied?
% - Are calibration values correct?
% - Are acquisition conditions comparable across samples?

%% 11. Practice
% 1. Add Circularity if supported by your MATLAB version.
% 2. Convert area using a different pixel calibration.
% 3. Plot MeanIntensity vs Area_um2.
% 4. Identify suspicious outliers and inspect those objects in the image.

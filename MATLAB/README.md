# MATLAB Image Processing: A Practical Beginner Track

**Author: Md. Mobarak Karim, Ph.D.**

This folder is the MATLAB companion to the Python course in the root of this repository. It is designed for a **complete beginner** who wants to learn MATLAB and image processing together without first completing a separate programming course.

## Why `.m` files instead of `.mlx`?

MATLAB Live Scripts (`.mlx`) are binary files and do not display well as source code on GitHub. The lessons here use ordinary MATLAB scripts with `%%` section markers. In the MATLAB Editor, each `%%` block behaves like a notebook cell: you can run one section at a time, inspect variables, change values, and rerun the section.

If you prefer the Live Editor, open a lesson in MATLAB and save a personal copy as a Live Script.

## Learning philosophy

For programming and scientific equations, use this sequence:

```text
question -> concept/equation -> inputs/units -> pseudocode -> MATLAB -> test -> validate -> apply
```

For image analysis, use this sequence:

```text
question -> inspect data -> preprocess only if needed -> segment -> validate -> measure -> save
```

Do not memorize commands without understanding what problem they solve.

## Course order

| Lesson | Topic | Main ideas |
|---|---|---|
| [`00_setup_and_workflow.m`](00_setup_and_workflow.m) | Setup and workflow | MATLAB Editor, sections, workspace, paths, toolboxes, reproducible workflow |
| [`01_matlab_foundations_for_images.m`](01_matlab_foundations_for_images.m) | **MATLAB foundations + scientific thinking** | Variables, types, vectors/matrices, indexing, logic, loops, functions, equations, debugging, images as arrays |
| [`02_read_display_and_image_types.m`](02_read_display_and_image_types.m) | Read/display/types | `imread`, grayscale/RGB, class, ranges, display vs data |
| [`03_contrast_histograms_and_intensity.m`](03_contrast_histograms_and_intensity.m) | Histograms + contrast | `imhist`, percentiles, `imadjust`, local enhancement |
| [`04_filtering_noise_and_edges.m`](04_filtering_noise_and_edges.m) | Filtering + edges | Gaussian, median, gradients/edges, parameter trade-offs |
| [`05_thresholding_and_morphology.m`](05_thresholding_and_morphology.m) | Thresholding + morphology | Global/adaptive thresholding, cleanup, holes, structuring elements |
| [`06_segmentation_and_labels.m`](06_segmentation_and_labels.m) | Segmentation + labels | Connected components, labels, overlays, watershed concepts |
| [`07_measurements_and_tables.m`](07_measurements_and_tables.m) | Measurements | `regionprops`, tables, intensity/shape metrics, physical units |
| [`08_color_and_multichannel_images.m`](08_color_and_multichannel_images.m) | Color + multichannel | RGB vs scientific channels, channel-specific analysis |
| [`09_batch_processing_pipeline.m`](09_batch_processing_pipeline.m) | Batch processing | Functions, `dir`, `fullfile`, reusable pipelines, saving results |
| [`10_final_project.m`](10_final_project.m) | Final project | End-to-end segmentation, validation, measurement, parameter recording |

## Requirements

The MATLAB language fundamentals require only MATLAB. Most image-processing lessons use **Image Processing Toolbox**.

Useful checks inside MATLAB:

```matlab
ver
which imread
which imgaussfilt
which imbinarize
which regionprops
```

If an image-processing function is missing, check whether Image Processing Toolbox is installed and licensed.

## MATLAB habits emphasized in this course

- MATLAB indexing starts at **1**, not 0.
- Images are usually indexed as `image(row, column)`.
- `*`, `/`, and `^` are matrix operations; use `.*`, `./`, and `.^` for element-by-element equations.
- A semicolon suppresses command-window output.
- Use descriptive variable names and include units when useful, e.g. `pixelSize_um`.
- Use `size`, `class`, `min`, `max`, and visualization before applying image-processing functions.
- Validate segmentation against the original image before trusting measurements.

## Companion references

- [`MATLAB_CHEATSHEET.md`](MATLAB_CHEATSHEET.md) — quick syntax reference.
- [`MATLAB_FUNCTION_GUIDE.md`](MATLAB_FUNCTION_GUIDE.md) — which image-processing function to try, why, and what to inspect.

## Official documentation

- MATLAB language fundamentals: https://www.mathworks.com/help/matlab/language-fundamentals.html
- MATLAB matrices and arrays: https://www.mathworks.com/help/matlab/matrices-and-arrays.html
- MATLAB programming: https://www.mathworks.com/help/matlab/programming-and-data-types.html
- Image Processing Toolbox: https://www.mathworks.com/help/images/

## Author

**Md. Mobarak Karim, Ph.D.**

# Beginner Image Processing Cheat Sheet

**Author: Md. Mobarak Karim, Ph.D.**

## Inspect first
```python
print(image.shape, image.dtype)
print(image.min(), image.max(), image.mean())
```

## Display
```python
plt.imshow(image, cmap="gray")
plt.axis("off")
plt.show()
```

## Crop
```python
crop = image[row_start:row_end, col_start:col_end]
```

## Smooth
```python
smooth = ski.filters.gaussian(image, sigma=1.0)
```

## Threshold
```python
t = ski.filters.threshold_otsu(smooth)
mask = smooth > t
```

## Clean mask
```python
mask = ski.morphology.remove_small_objects(mask, min_size=100)
mask = ski.morphology.remove_small_holes(mask, area_threshold=100)
```

## Label objects
```python
labels = ski.measure.label(mask)
```

## Measure
```python
props = ski.measure.regionprops_table(
    labels, intensity_image=image,
    properties=("label", "area", "mean_intensity")
)
df = pd.DataFrame(props)
```

## Save results
```python
df.to_csv("outputs/results.csv", index=False)
```

## Debugging habit
When an output looks wrong, inspect the intermediate image or mask immediately before it. Do not change five parameters at once.

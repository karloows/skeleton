# skeleton example

A demonstration app for the skeleton loading package.

## Features

This example showcases all three core skeleton widgets:

- **SkeletonText** — drop-in for `Text` with color-matched bones
- **SkeletonImage** — drop-in for `Image` with average-color bones
- **SkeletonBox** — drop-in wrapper for fill widgets with color-matched bones

## Running

```bash
flutter pub get
flutter run -d chrome  # or macOS, or any available device
```

Toggle between the **Loading** and **Loaded** tabs to see how each widget transitions from skeleton to real content. Notice how the bone colors match the actual content — text bones inherit text color, image bones sample from the image's pixels, and fill bones use the declared color.

# skeleton example

Runnable example app for `skeleton`.

## Run

```sh
fvm flutter pub get
fvm flutter run
```

## What it shows

- `SkeletonText` — drop-in for `Text` with color-matched bones
- `SkeletonImage` — drop-in for `Image` with average-color bones
- `SkeletonBox` — drop-in wrapper for fill widgets with color-matched bones

Toggle between the **Loading** and **Loaded** tabs to see how each widget
transitions from skeleton to real content. Notice how the bone colors match
the actual content — text bones inherit text color, image bones sample from
the image's pixels, and fill bones use the declared color.

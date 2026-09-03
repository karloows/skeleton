# skeleton

Skeleton loading widgets for Flutter that match the **color** of the
content they replace, not just its shape. A text placeholder is tinted
with the text's own color, an image placeholder is tinted with that
image's average color (initially a neutral gray, then asynchronously
updated when sampling completes), and a box placeholder uses the same fill
color as the real content — so the loading state fades into the real UI
instead of flashing from generic gray to full color.

See [PLAN.md](PLAN.md) for the full roadmap, including planned niches
beyond color-matching (async-aware reflow, per-widget-type smart bones,
diff-based list updates, and zero-flash first paint).

## Features

- `Skeleton` — an ambient scope that marks a subtree as loading.
- `SkeletonText` — wraps a `Text`; bone color follows the text's own
  style color.
- `SkeletonImage` — drop-in for `Image`; bone color is sampled from the
  image's average pixel color, and bone size matches the image's own
  decoded dimensions when `width`/`height` aren't given.
- `SkeletonBox` — wraps a `Container`; bone color and size follow the
  container's own `color`/`width`/`height`.

`width`/`height` are optional everywhere — omit them and each widget sizes
itself from its content (or the space its parent gives it) instead of a
generic placeholder box.

## Usage

```dart
Skeleton(
  loading: isLoading,
  child: Column(
    children: [
      SkeletonImage(
        image: NetworkImage(user.avatarUrl),
        borderRadius: BorderRadius.circular(24),
      ),
      SkeletonText(
        child: Text(
          user.name,
          style: const TextStyle(fontSize: 16, color: Colors.black87),
        ),
      ),
      SkeletonBox(
        child: Container(
          color: Colors.blue.shade50,
          width: 120,
          height: 32,
          child: PriceTag(product.price),
        ),
      ),
    ],
  ),
);
```

Toggle `loading` on the ambient `Skeleton` and every descendant
`SkeletonText`/`SkeletonImage`/`SkeletonBox` switches between its bone and
the real widget automatically.

## Additional information

Still pre-1.0 and under active development — see [PLAN.md](PLAN.md) for
what's built and what's planned next.

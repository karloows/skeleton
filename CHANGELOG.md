## 0.0.1

Initial release: color-matched Flutter skeleton loading widgets.

* `Skeleton` — ambient scope marking a subtree as loading.
* `SkeletonText` — drop-in for `Text`; bone color follows the text's own
  style color, reflows live from a `preview` listenable, and supports a
  custom `borderRadius` (e.g. a pill shape for price tags).
* `SkeletonImage` — drop-in for `Image`; bone color is sampled from the
  image's average pixel color.
* `SkeletonBox` — wraps a `Container`; bone color and size follow the
  container's own fill.
* `SkeletonBone` — low-level shimmer bone for building custom
  color-matched placeholders.

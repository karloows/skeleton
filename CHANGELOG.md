# Changelog

## [0.2.1](https://github.com/karloows/skeleton/compare/v0.2.0...v0.2.1) (2026-09-04)


### Bug Fixes

* **assets:** compress demo GIF to meet pub.dev size limit ([#25](https://github.com/karloows/skeleton/issues/25)) ([308728e](https://github.com/karloows/skeleton/commit/308728e3119cac019b496009b4952c4f4a169233))

## [0.2.0](https://github.com/karloows/skeleton/compare/v0.1.0...v0.2.0) (2026-09-04)


### Features

* **bone:** add SkeletonStyle animation variants ([#24](https://github.com/karloows/skeleton/issues/24)) ([4ca9ef2](https://github.com/karloows/skeleton/commit/4ca9ef277e45f22c6eee10d6eac9839fc7e717ea))


### Bug Fixes

* **api:** resolve SkeletonImage per ambient config, verify SDK floor ([#19](https://github.com/karloows/skeleton/issues/19)) ([a1acae6](https://github.com/karloows/skeleton/commit/a1acae6cbb2e5acdfcbf99e8ebe0945efedcc7f9)), closes [#7](https://github.com/karloows/skeleton/issues/7) [#6](https://github.com/karloows/skeleton/issues/6)

## [0.1.0](https://github.com/karloows/skeleton/compare/v0.0.1...v0.1.0) (2026-09-03)


### Features

* **api:** add color-matched skeleton loading widgets ([#5](https://github.com/karloows/skeleton/issues/5)) ([a1d0008](https://github.com/karloows/skeleton/commit/a1d0008fc6324d6e92cd26abce59d3d0467f455a))
* **api:** expose borderRadius on SkeletonText ([#16](https://github.com/karloows/skeleton/issues/16)) ([179b537](https://github.com/karloows/skeleton/commit/179b53724491f51e001dace72381ecb5ab23019b))
* **api:** reflow SkeletonText bone width from a preview listenable ([#15](https://github.com/karloows/skeleton/issues/15)) ([103d143](https://github.com/karloows/skeleton/commit/103d143acf84add4e5f0b74c40ba05126fdf7167))
* **example:** update demo app to use picsum.photos for images ([#9](https://github.com/karloows/skeleton/issues/9)) ([82a08fb](https://github.com/karloows/skeleton/commit/82a08fbbab41cbf6aea6d473fb6284d81e6f9d4a))

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

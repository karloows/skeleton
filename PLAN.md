# Plan

## What this package is

A Flutter skeleton-loading package. The difference from existing packages
(`skeletonizer`, `auto_skeleton`, `skeletonizer_plus`) is that those only
infer **shape** from the widget tree (bone size/position matches layout) and
paint it with a static, theme-configured shimmer color. This package infers
shape **and** derives its behavior from the actual content in five ways
listed below. Shape-matching is table stakes, reuse the same wrapping
pattern those packages use (a widget wraps real content and swaps it for
bones while loading). The five niches below are what make this package
worth using instead of the existing ones.

Do not reinvent shape-inference from scratch — that part is a solved
problem. Spend the design and implementation effort on the five items
below, in priority order.

## Architecture decision

Existing packages (notably `skeletonizer`) implement auto-detection by
wrapping arbitrary widget trees and rewriting them via a custom
`RenderObject`/element-walking layer. Do not copy that approach here.

Build with **normal widgets and explicit composition** instead:

- A small `Skeleton` `InheritedWidget` carries the ambient `loading: bool`
  down the tree (set once at a screen/section boundary).
- A small set of drop-in replacement widgets (`SkeletonText`,
  `SkeletonBox`, `SkeletonImage`, more added per niche below) read that
  ambient state and either render the real child or a color-matched bone.
- Consumers opt in per-widget by using `SkeletonText(...)` instead of
  `Text(...)`, `SkeletonImage(...)` instead of `Image(...)`, etc. This is
  slightly more explicit than "wrap literally anything," but it avoids
  render-object trickery, keeps behavior predictable, and is the "first
  real version" this codebase's own conventions call for.
- Fully-automatic tree rewriting (wrap *any* subtree with zero widget
  changes) is out of scope unless niches 1-3 prove insufficient on their
  own — treat it as a possible v2, not a v0 requirement.

## Public API sketch (v0, niche 1 only)

- `Skeleton({required bool loading, required Widget child})` — scope
  widget; `Skeleton.of(context)` reads the ambient `loading` flag.
- `SkeletonBone({required Color color, double? width, double? height,
  BorderRadius borderRadius})` — the shared low-level bone: paints a
  shimmering placeholder in the given color. Exported so custom bones can
  be built later, but consumers normally use the typed widgets below.
- `SkeletonText(String data, {TextStyle? style, double? width})` — drop-in
  for `Text`. While loading, samples `style.color` (or the ambient
  `DefaultTextStyle` color) and renders a bone in that color, sized from
  the text length/font size.
- `SkeletonBox({required Widget child, required Color color, double?
  width, double? height, BorderRadius borderRadius})` — drop-in wrapper
  for `Container`/`Card`/other fill widgets. While loading, renders a bone
  in `color`.
- `SkeletonImage({required ImageProvider image, double? width, double?
  height, BoxFit? fit, BorderRadius borderRadius})` — drop-in for `Image`.
  While loading, decodes the image once, computes an average pixel color
  (via `dart:ui`, no extra dependency), and renders a bone in that color;
  falls back to a neutral gray until the sample resolves.

Keep all four widgets independent and composable — no shared base class
until real duplication shows up.

## The five niches

### 1. Color-matched bones (primary identity, build first)

Scaffolded now — see the public API sketch above and the files under
`lib/src/`.

Bones are painted with colors sampled from the real content instead of a
flat theme shimmer color.

- `Image` widgets: sample the dominant/average pixel color of the image
  (decode once, cache the result) and use it as the bone's base color.
  Until sampling completes, render a neutral gray fallback. This means
  SkeletonImage shows a brief gray bone → color-matched bone → real image,
  trading a small flash for avoiding pre-decoding overhead in v0.
- `Text` widgets: use the resolved `TextStyle.color` (or the ambient
  `DefaultTextStyle` color) as the bone color instead of a generic gray.
  Text colors are available synchronously; no fallback needed.
- `Container` / `Card` / other fill widgets: use their `color` /
  `decoration` fill directly. Fill colors are available synchronously;
  no fallback needed.
- Fallback: only `SkeletonImage` uses a neutral gray fallback (while
  decoding). Other widgets never show a generic gray — only content-matched
  color from the start.
- The effect goal: for `SkeletonText` and `SkeletonBox`, fade from
  color-matched placeholder into real content (no gray flash).
  For `SkeletonImage`, accept a brief gray→color transition as a v0 trade-off;
  upgrade to pre-decoded snapshots (niche 5) if this becomes a UX issue.

### 2. Async-aware reflow

Bones resize/reshape live as real data becomes known, instead of being a
static placeholder that gets replaced wholesale once loading finishes.

Scaffolded now:

- `SkeletonText` takes an optional `preview` (`ValueListenable<String?>`).
  While loading, the bone measures against `preview.value` instead of
  `child.data` whenever it's non-null, and re-measures on every update via
  `ValueListenableBuilder` — so it narrows or grows to match the real
  length as soon as that's known, even before `child` itself is rebuilt
  with the final string.
- The "list of bones grows/shrinks to match the real item count" case
  needs no new widget: compose Flutter's own `ValueListenableBuilder`
  around a `List.generate` of `SkeletonBone`s, keyed off a
  `ValueListenable<int?>` item count. Existing primitives already cover
  it.

### 3. Per-widget-type smart bones

Instead of generic rectangles/circles derived purely from bounding boxes,
infer semantic bone shapes from widget *type* and common patterns:

- `CircleAvatar` / avatar-shaped images → circle bone. Already covered:
  `SkeletonImage(width: d, height: d, borderRadius: BorderRadius.circular(d
  / 2))` — no new API needed.
- Star-rating rows → a row of small circle bones. Already covered: compose
  `SkeletonBone`s with a circular `borderRadius` inside a `Row` — no new
  widget needed.
- Price-tag-like text → pill bone. `SkeletonText` didn't expose a way to
  override its bone shape at all (unlike the other three widgets, which
  all already take `borderRadius`). Scaffolded: `SkeletonText` now takes
  an optional `borderRadius` too, defaulting to its existing font-scaled
  radius. The package doesn't sniff "is this a price tag" itself (that's
  app-level judgement, e.g. a currency-prefix regex would be fragile
  across locales) — the caller decides and passes a large radius.
- No auto-detection lookup table was built — the three cases above don't
  need one now that `borderRadius` is consistent across all four widgets.
  Add one only if a real case shows up that isn't just "pick a radius."

### 4. Diff-based skeleton updates

For lists/grids that change incrementally (pagination, infinite scroll),
only skeletonize the new/changed items instead of re-skeletonizing the
whole subtree on every rebuild.

- Applies to `ListView`/`GridView`-style children with keys.
- Implementation should key off existing widget keys already used by the
  list, not introduce a new keying scheme.

### 5. Zero-flash first paint

Avoid a frame where the real widget briefly renders before the skeleton
wrapper kicks in (a known issue with runtime-wrapping approaches that must
build the real subtree once to measure it).

- Because this package uses explicit typed widgets (see Architecture
  decision above) rather than runtime tree rewriting, this niche mostly
  reduces to: make sure `SkeletonText`/`SkeletonBox`/`SkeletonImage`
  decide real-vs-bone synchronously during `build()`, with no
  post-frame swap. `SkeletonImage`'s color sampling is the one
  async exception (it must decode a frame first) — bound how long it
  shows the neutral fallback before investigating a snapshot/precompute
  approach.
- Only reach for build-time/codegen solutions if the synchronous-build
  approach above proves insufficient in real usage.

## Priority and phasing

Build in the order listed above. Niche 1 (color) is the package's identity
and should ship first as a usable v0 — see `lib/src/` for the current
scaffold. Niches 2-5 are incremental value on top and can ship
independently in later versions — do not block niche 1 on designing all
five APIs up front.

## Non-goals

- No speculative abstraction layers or plugin systems for hypothetical
  future bone types.
- No extra dependencies unless Flutter or Dart cannot reasonably cover the
  job (image color sampling uses `dart:ui`/`Image` APIs already in
  Flutter, not a package).
- Do not attempt to out-build `skeletonizer` on shape-inference alone —
  that is not this package's differentiator.
- No fully-automatic "wrap any widget tree" rewriting in v0 — see
  Architecture decision above.

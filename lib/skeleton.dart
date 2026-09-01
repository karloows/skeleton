/// Color-matched skeleton loading widgets for Flutter.
///
/// Exported API:
/// - [Skeleton] marks a subtree as loading for the widgets below.
/// - [SkeletonText] is a drop-in for [Text] with a color-matched bone.
/// - [SkeletonBox] is a drop-in wrapper for fill widgets with a
///   color-matched bone.
/// - [SkeletonImage] is a drop-in for [Image] with a bone sampled from the
///   image's average color.
/// - [SkeletonBone] is the low-level shimmer bone used to build custom
///   color-matched placeholders.
library;

export 'src/skeleton_bone.dart' show SkeletonBone;
export 'src/skeleton_box.dart' show SkeletonBox;
export 'src/skeleton_image.dart' show SkeletonImage;
export 'src/skeleton_scope.dart' show Skeleton;
export 'src/skeleton_text.dart' show SkeletonText;

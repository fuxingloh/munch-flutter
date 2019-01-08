import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:munch_app/components/shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:munch_app/api/file_api.dart' as file;
import 'package:munch_app/styles/colors.dart';

/// url to find from sizes
String _findUrl(List<file.ImageSize> sizes, {double width, double height}) {
  if (sizes == null) return null;
  if (sizes.isEmpty) return null;

  sizes.sort((s1, s2) => s1.width.compareTo(s2.width));
  for (var size in sizes) {
    if (size.width >= width && size.height > height) {
      return size.url;
    }
  }

  return sizes.last?.url;
}

class ShimmerSizeImage extends StatelessWidget {
  /// minWidth & minHeight are in logical pixel
  const ShimmerSizeImage({
    Key key,
    this.minWidth,
    this.minHeight = 1,
    @required this.sizes,
    this.fit = BoxFit.cover,
  }) : super(key: key);

  final double minWidth, minHeight;
  final List<file.ImageSize> sizes;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final width = minWidth ?? MediaQuery.of(context).size.width;

    final pixelWidth = width * MediaQuery.of(context).devicePixelRatio;
    final pixelHeight = minHeight * MediaQuery.of(context).devicePixelRatio;

    var url = _findUrl(sizes, width: pixelWidth, height: pixelHeight);
    if (url == null) return Container(color: MunchColors.whisper100);
    return _ShimmerImage(url, width: width, height: minHeight, fit: fit);
  }
}

class _ShimmerImage extends CachedNetworkImage {
  _ShimmerImage(
    String imageUrl, {
    @required double width,
    @required double height,
    BoxFit fit = BoxFit.cover,
  }) : super(
          imageUrl: imageUrl,
          errorWidget: const DecoratedBox(
            decoration: BoxDecoration(color: MunchColors.whisper100),
          ),
          fadeOutDuration: const Duration(milliseconds: 0),
          fadeInDuration: const Duration(milliseconds: 200),
          placeholder: const Shimmer(),
          fit: fit,
        );
}

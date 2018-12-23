import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:munch_app/components/Shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:munch_app/api/file_api.dart' as file;

class ShimmerImageWidget extends StatelessWidget {
  /// minWidth & minHeight are in logical pixel
  const ShimmerImageWidget({
    Key key,
    this.minWidth,
    this.minHeight = 1,
    @required this.sizes,
  }) : super(key: key);

  final double minWidth, minHeight;
  final List<file.ImageSize> sizes;

  /// url to find from sizes
  String _findUrl(List<file.ImageSize> sizes, {double width, double height}) {
    sizes.sort((s1, s2) => s1.width.compareTo(s2.width));
    for (var size in sizes) {
      if (size.width >= width && size.height > height) {
        return size.url;
      }
    }

    return sizes.last?.url;
  }

  @override
  Widget build(BuildContext context) {
    final width = minWidth ?? MediaQuery.of(context).size.width;
    String url = _findUrl(sizes, width: width, height: minHeight);

    return CachedNetworkImage(
      imageUrl: url,
      errorWidget: const Icon(Icons.error),
      fadeOutDuration: const Duration(milliseconds: 200),
      fadeInDuration: const Duration(milliseconds: 200),
      placeholder: ShimmerWidget(),
    );
  }
}

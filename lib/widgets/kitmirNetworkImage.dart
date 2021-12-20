import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:octo_image/octo_image.dart';

class KTNetworkImage extends StatelessWidget {
  final String imageURL;
  final bool isOval;
  final BoxFit boxFit;
  final double? width;
  final double? height;
  const KTNetworkImage(
      {this.width, this.height, Key? key, required this.imageURL, this.isOval = false, this.boxFit = BoxFit.fill})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isOval
        ? ClipOval(
            child: OctoImage(
              height: height,
              width: width,
              image: CachedNetworkImageProvider(imageURL),
              placeholderBuilder: OctoPlaceholder.blurHash(
                'LEHV6nWB2yk8pyo0adR*.7kCMdnj',
              ),
              errorBuilder: OctoError.icon(color: Colors.red),
              fit: boxFit,
            ),
          )
        : OctoImage(
            height: height,
            width: width,
            image: CachedNetworkImageProvider(imageURL),
            placeholderBuilder: OctoPlaceholder.blurHash('LEHV6nWB2yk8pyo0adR*.7kCMdnj', fit: BoxFit.fill),
            errorBuilder: OctoError.icon(color: Colors.red),
            fit: boxFit,
          );
  }
}

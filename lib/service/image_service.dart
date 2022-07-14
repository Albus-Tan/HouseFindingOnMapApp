import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

final Image noImage = Image.asset("assets/picture/404.jpg");

Widget getNetWorkImage(String url) {
  return CachedNetworkImage(
    imageUrl: url,
    fit: BoxFit.cover,
    // placeholder: (context, url) => const CircularProgressIndicator(),
    progressIndicatorBuilder: (context, url, downloadProgress) =>
        CircularProgressIndicator(value: downloadProgress.progress),
    errorWidget: (context, url, error) => noImage,
  );
//   return
// // Now, in the widget's image property of your first example:
//       (url != null) // Only use the network image if the url is not null
//           ? Image.network(
//               url,
//               loadingBuilder: (context, child, loadingProgress) =>
//                   (loadingProgress == null)
//                       ? child
//                       : const CircularProgressIndicator(),
//               errorBuilder: (context, error, stackTrace) => noImage,
//             )
//           : noImage;
}

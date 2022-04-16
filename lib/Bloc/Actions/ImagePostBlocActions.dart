import 'dart:async';
import 'package:flutter/material.dart';

abstract class ImagePostActions {
  Future<Size> getImageSizeFromUrl(String cityName);
}

class ImagePostBlocActions implements ImagePostActions {
  @override
  Future<Size> getImageSizeFromUrl(String imageUrl) {
    Completer<Size> completer = Completer();
    Image image = Image.network(imageUrl);
    image.image.resolve(ImageConfiguration()).addListener(
      ImageStreamListener(
        (ImageInfo image, bool synchronousCall) {
          var myImage = image.image;
          Size size = Size(myImage.width.toDouble(), myImage.height.toDouble());
          completer.complete(size);
        },
      ),
    );
    return completer.future;
  }
}

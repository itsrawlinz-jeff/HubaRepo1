import 'dart:async';

import 'dart:ui';

import 'package:flutter/material.dart';
// import 'package:rxdart/rxdart.dart'; if you want to make use of PublishSubject, ReplaySubject or BehaviourSubject.
// make sure you have rxdart: as a dependency in your pubspec.yaml file to use the above import


class GetImageHeightBloc {
  final counterController = StreamController();  // create a StreamController or
  // final counterController = PublishSubject() or any other rxdart option;
  Stream get getCount => counterController.stream; // create a getter for our Stream
  // the rxdart stream controllers returns an Observable instead of a Stream

  void updateCount(String imgUrl) {
    getImageSizeFromUrl(imgUrl).then((value) {
      counterController.sink.add(value.height);
    }, onError: (error) {
      print('completed with error $error');
    });
     // add whatever data we want into the Sink
  }

  void dispose() {
    counterController.close(); // close our StreamController to avoid memory leak
  }


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

final getImageHeightBloc = GetImageHeightBloc();
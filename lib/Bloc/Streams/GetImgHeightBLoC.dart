import 'dart:async';
import 'dart:ui';

import 'package:dating_app/Bloc/Streams/GetImgHeightEvent.dart';
import 'package:flutter/material.dart';


class CounterBLoC {
  //double _counter = 200;

  // init and get StreamController
  final _counterStreamController = StreamController<double>();
  StreamSink<double> get counter_sink => _counterStreamController.sink;

  // expose data from stream
  Stream<double> get stream_counter => _counterStreamController.stream;

  final _counterEventController = StreamController<CounterEvent>();
  // expose sink for input events
  Sink<CounterEvent> get counter_event_sink => _counterEventController.sink;

  CounterBLoC() {
    _counterEventController.stream.listen(_count);
  }

  //_count(CounterEvent event) => counter_sink.add(++_counter);

  _count(CounterEvent event) {
    if (event is IncrementEvent) {
      //print('_count= ${MediaQuery.of(event.context).devicePixelRatio}');
      getImageSizeFromUrl(event.imgUrl).then((value) {
        print('image_height==${event.image_height}');
        double devicePixelRatio = MediaQuery.of(event.context).devicePixelRatio;
        double sCreenwidthDp = MediaQuery.of(event.context).size.width;
        print('sCreenwidthDp==$sCreenwidthDp');
        //double sCreenwidthPx = sCreenwidthDp * devicePixelRatio;
        double aspRatio = value.width / value.height;
        print('aspRatio==$aspRatio');//ScreenUtil.screenWidth;
        //print('sCreenwidthPx==$sCreenwidthPx');
        double reqHeighOfImg = sCreenwidthDp / aspRatio;
        counter_sink.add(reqHeighOfImg);
        //counter_sink.add(value.height / MediaQuery.of(event.context).devicePixelRatio);
      }, onError: (error) {
        print('completed with error $error');
      });
    }
  }

  dispose() {
    _counterStreamController.close();
    _counterEventController.close();
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

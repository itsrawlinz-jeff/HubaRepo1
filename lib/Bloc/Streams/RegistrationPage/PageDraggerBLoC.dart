import 'dart:async';

import 'PageDraggerEvent.dart';

class PageDraggerBLoC {
  final _keyBoardVisibleStreamController = StreamController<bool>.broadcast();
  StreamSink<bool> get keyBoardVisible_sink =>
      _keyBoardVisibleStreamController.sink;

  // expose data from stream
  Stream<bool> get stream_counter => _keyBoardVisibleStreamController.stream;

  final _keyBoardVisibleEventController = StreamController<PageDraggerEvent>();
  // expose sink for input events
  Sink<PageDraggerEvent> get enableDrag_sink =>
      _keyBoardVisibleEventController.sink;

  PageDraggerBLoC() {
    _keyBoardVisibleEventController.stream.listen(_enableDrag);
  }

  _enableDrag(PageDraggerEvent event) {
    print('_enableDrag');
    if (event is IfDragPageEvent) {
      print('event is IfDragPageEvent');
      print('toggleVal${event.isEnableDragWidgetVal}');

      keyBoardVisible_sink.add(event.isEnableDragWidgetVal);
    }
  }

  dispose() {
    _keyBoardVisibleStreamController.close();
    _keyBoardVisibleEventController.close();
  }
}

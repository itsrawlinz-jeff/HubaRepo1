import 'dart:async';

import 'OnFetchEvent.dart';

class OnFetchFinishedBLoC {
  final _onFetchFinishedStreamController = StreamController<bool>.broadcast();
  StreamSink<bool> get onFetchFinished_sink =>
      _onFetchFinishedStreamController.sink;

  Stream<bool> get stream_counter => _onFetchFinishedStreamController.stream;

  final _onFetchEventController =
      StreamController<OnFetchEvent>();
  Sink<OnFetchEvent> get onFetchFinished_visible_event_sink =>
      _onFetchEventController.sink;

  OnFetchFinishedBLoC() {
    _onFetchEventController.stream.listen(_onFetchFinished);
  }

  _onFetchFinished(OnFetchEvent event) {
    print('_onFetchFinished');
    if (event is OnFetchFinishedEvent) {
      print('event is OnFetchFinishedEvent');
      print('toggleVal${event.fetchFinished}');

      onFetchFinished_sink.add(event.fetchFinished);
    }
  }

  dispose() {
    _onFetchFinishedStreamController.close();
    _onFetchEventController.close();
  }
}

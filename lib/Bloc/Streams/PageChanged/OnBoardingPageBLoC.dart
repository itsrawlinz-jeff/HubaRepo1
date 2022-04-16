import 'dart:async';

import 'OnBoardingPageEvent.dart';

class OnBoardingPageBLoC {
  final _onBoardingPageStreamController = StreamController<int>.broadcast();
  StreamSink<int> get onBoardingPage_sink =>
      _onBoardingPageStreamController.sink;

  Stream<int> get stream_counter => _onBoardingPageStreamController.stream;

  final _onBoardingPageEventController =
      StreamController<OnBoardingPageEvent>();
  Sink<OnBoardingPageEvent> get onBoardingPage_visible_event_sink =>
      _onBoardingPageEventController.sink;

  OnBoardingPageBLoC() {
    _onBoardingPageEventController.stream.listen(_onBoardingPage);
  }

  _onBoardingPage(OnBoardingPageEvent event) {
    print('_onBoardingPage');
    if (event is OnBoardingPageChangedEvent) {
      print('event is ToggleKeyBoardVisEvent');
      print('toggleVal${event.pageIndex}');

      onBoardingPage_sink.add(event.pageIndex);
    }
  }

  dispose() {
    _onBoardingPageStreamController.close();
    _onBoardingPageEventController.close();
  }
}

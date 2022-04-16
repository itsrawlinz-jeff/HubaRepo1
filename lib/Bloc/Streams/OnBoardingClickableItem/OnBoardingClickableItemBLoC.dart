import 'dart:async';

import 'OnBoardingClickableItemEvent.dart';

class OnBoardingClickableItemBLoC {
  final _onBoardingClickableItemStreamController = StreamController<int>.broadcast();
  StreamSink<int> get onBoardingClickableItem_sink =>
      _onBoardingClickableItemStreamController.sink;

  // expose data from stream
  Stream<int> get stream_counter => _onBoardingClickableItemStreamController.stream;

  final _onBoardingClickableItemEventController = StreamController<OnBoardingClickableItemEvent>();
  // expose sink for input events
  Sink<OnBoardingClickableItemEvent> get onboarding_itemclicked_event_sink =>
      _onBoardingClickableItemEventController.sink;

  OnBoardingClickableItemBLoC() {
    _onBoardingClickableItemEventController.stream.listen(_onBoardingClickableItem);
  }
  
  _onBoardingClickableItem(OnBoardingClickableItemEvent event) {
    print('_onBoardingClickableItem');
    if (event is OneItemClickedEvent) {
      print('event is OneItemClickedEvent');
      print('toggleVal${event.clickedId}');

      onBoardingClickableItem_sink.add(event.clickedId);
    }
  }

  dispose() {
    _onBoardingClickableItemStreamController.close();
    _onBoardingClickableItemEventController.close();
  }
}

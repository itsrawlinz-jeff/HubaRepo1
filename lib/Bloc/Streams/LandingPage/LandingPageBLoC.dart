import 'dart:async';

import 'package:dating_app/Bloc/Streams/LandingPage/LandingPageEvent.dart';
import 'package:dating_app/Models/ui/LandingPageBlocResp.dart';

class SwitchChangedBLoC {
  final _switchChangedStreamController = StreamController<LandingPageBlocResp>.broadcast();
  StreamSink<LandingPageBlocResp> get switchChanged_sink =>
      _switchChangedStreamController.sink;

  // expose data from stream
  Stream<LandingPageBlocResp> get stream_counter => _switchChangedStreamController.stream;

  final _switchChangedEventController = StreamController<LandingPageEvent>();
  // expose sink for input events
  Sink<LandingPageEvent> get switch_changed_event_sink =>
      _switchChangedEventController.sink;

  SwitchChangedBLoC() {
    _switchChangedEventController.stream.listen(_switchChanged);
  }

  //_count(SwitchChangedEvent event) => switchChanged_sink.add(++_counter);
  _switchChanged(LandingPageEvent event) {
    if (event is SwitchChangedEvent) {
      print('event is SwitchChangedEvent');
      print('toggleVal${event.toggleVal}');
      LandingPageBlocResp landingPageBlocResp = new LandingPageBlocResp();
      landingPageBlocResp.isSwitched = event.toggleVal;
      if (event.toggleVal) {
        landingPageBlocResp.childhLTPcurrentPage = 0;
      } else {
        landingPageBlocResp.childhLTPcurrentPage = 1;
      }
      switchChanged_sink.add(landingPageBlocResp);
      //switchChanged_sink.add(event.toggleVal);
    }
  }

  dispose() {
    _switchChangedStreamController.close();
    _switchChangedEventController.close();
  }
}

import 'package:flutter/material.dart';

abstract class LandingPageEvent {
  const LandingPageEvent();
}

class SwitchChangedEvent extends LandingPageEvent {
  final bool toggleVal;
  const SwitchChangedEvent(this.toggleVal);
}

// class DecrementEvent extends CounterEvent{}

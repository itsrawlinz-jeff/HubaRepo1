import 'package:flutter/material.dart';

abstract class CounterEvent {
  const CounterEvent();
}

class IncrementEvent extends CounterEvent {
  final String imgUrl;
  final BuildContext context;
  final double image_height;
  const IncrementEvent(this.imgUrl, this.context, this.image_height);
}

// class DecrementEvent extends CounterEvent{}

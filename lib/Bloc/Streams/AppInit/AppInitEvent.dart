import 'package:flutter/material.dart';

abstract class AppInitEvent {
  const AppInitEvent();
}

class AppInitializedEvent extends AppInitEvent {
  final BuildContext buildContext;
  const AppInitializedEvent(this.buildContext);
}

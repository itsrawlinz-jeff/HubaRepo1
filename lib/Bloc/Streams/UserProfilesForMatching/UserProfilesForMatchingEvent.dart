import 'package:flutter/material.dart';

abstract class UserProfilesForMatchingEvent {
  const UserProfilesForMatchingEvent();
}

class UserProfilesFetchedEvent extends UserProfilesForMatchingEvent {
  final BuildContext buildContext;
  const UserProfilesFetchedEvent(this.buildContext);
}

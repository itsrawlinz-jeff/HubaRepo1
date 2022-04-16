


import 'package:dating_app/Models/ui/NavigationData.dart';

abstract class NavigationDataEvent {
  const NavigationDataEvent();
}

class NavigationDataAddedEvent extends NavigationDataEvent {
  final NavigationData navigationData;
  const NavigationDataAddedEvent(this.navigationData);
}

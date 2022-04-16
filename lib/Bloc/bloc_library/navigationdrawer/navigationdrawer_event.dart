

import 'package:dating_app/Models/ui/NavigationData.dart';
import 'package:equatable/equatable.dart';

abstract class NavigationdrawerEvent extends Equatable {
  const NavigationdrawerEvent();
}

class NavDrawer extends NavigationdrawerEvent {
  final NavigationData navigationData;

  const NavDrawer(this.navigationData);

  @override
  List<Object> get props => [navigationData];
}

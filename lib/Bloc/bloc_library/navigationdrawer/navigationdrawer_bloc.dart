
import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dating_app/Bloc/bloc_library/navigationdrawer/navigationdrawer_event.dart';
import 'package:dating_app/Bloc/bloc_library/navigationdrawer/navigationdrawer_state.dart';

class NavigationdrawerBloc
    extends Bloc<NavigationdrawerEvent, NavigationdrawerState> {
  NavigationdrawerBloc();

  @override
  NavigationdrawerState get initialState => NavigationdrawerInitial();

  @override
  Stream<NavigationdrawerState> mapEventToState(
    NavigationdrawerEvent event,
  ) async* {
    yield NavigationdrawerLoading();
    if (event is NavDrawer) {
      final navigationData = (event.navigationData);
      yield NavigationdrawerLoaded(navigationData);
    }
  }

  @override
  void dispose() {
    this.dispose();
  }
}

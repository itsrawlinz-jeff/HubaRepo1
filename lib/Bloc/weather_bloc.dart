import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dating_app/Bloc/Actions/ImagePostBlocActions.dart';
import './bloc.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final ImagePostBlocActions imagePostBlocActions;

  WeatherBloc(this.imagePostBlocActions);

  @override
  WeatherState get initialState => WeatherInitial();

  @override
  Stream<WeatherState> mapEventToState(
    WeatherEvent event,
  ) async* {
    yield WeatherLoading();
    if (event is GetWeather) {
      final imageSize =
          await imagePostBlocActions.getImageSizeFromUrl(event.imageUrl);
      print('imageSize.height==${imageSize.height}');
      yield WeatherLoaded(imageSize);
    }
  }

  @override
  void dispose() {
    this.dispose();
  }
}

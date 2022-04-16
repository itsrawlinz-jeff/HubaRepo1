import 'package:equatable/equatable.dart';

abstract class WeatherEvent extends Equatable {
  const WeatherEvent();
}

class GetWeather extends WeatherEvent {
  final String imageUrl;

  const GetWeather(this.imageUrl);

  @override
  List<Object> get props => [imageUrl];
}

class GetDetailedWeather extends WeatherEvent {
  final String imageUrl;

  const GetDetailedWeather(this.imageUrl);

  @override
  List<Object> get props => [imageUrl];
}

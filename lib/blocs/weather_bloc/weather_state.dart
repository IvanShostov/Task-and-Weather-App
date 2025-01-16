part of 'weather_bloc.dart';

class WeatherState {
  final Weather? weather;
  final bool isLoading;
  final String? error;

  const WeatherState({
    this.weather,
    this.isLoading = false,
    this.error,
  });

  factory WeatherState.initial() {
    return const WeatherState(isLoading: false);
  }

  WeatherState copyWith({
    Weather? weather,
    bool? isLoading,
    String? error,
  }) {
    return WeatherState(
      weather: weather ?? this.weather,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

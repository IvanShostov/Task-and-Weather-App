import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:task_weather_app/data/models/model_weather.dart';
import 'package:task_weather_app/data/repositories/weather_repository.dart';

part 'weather_event.dart';
part 'weather_state.dart';

/// WeatherBloc manages the state and events related to weather information.
class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherRepository repository;

  /// Constructor initializes the bloc with the initial state and sets up event handlers.
  WeatherBloc(this.repository) : super(WeatherState.initial()) {
    // Register event handlers
    on<FetchWeatherEvent>(_fetchWeatherByCity);
    on<FetchWeatherByLocationEvent>(_fetchWeatherByLocation);
  }

  /// Handles fetching weather data by city name.
  Future<void> _fetchWeatherByCity(
      FetchWeatherEvent event, Emitter<WeatherState> emit) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final weather = await repository.fetchWeatherByCity(event.city);
      emit(state.copyWith(weather: weather, isLoading: false));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  /// Handles fetching weather data by the user's current location.
  Future<void> _fetchWeatherByLocation(
      FetchWeatherByLocationEvent event, Emitter<WeatherState> emit) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final weather = await repository.fetchWeatherByLocation();
      emit(state.copyWith(weather: weather, isLoading: false));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }
}

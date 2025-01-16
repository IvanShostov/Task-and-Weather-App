import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import '../models/model_weather.dart';

/// WeatherRepository handles fetching weather data from the OpenWeatherMap API.
class WeatherRepository {
  /// Your OpenWeatherMap API key.
  final String apiKey = "a0289dd6b0c16cdf32a935313b5db2ac";

  /// Fetches weather data by city name.
  ///
  /// Throws an exception if the HTTP request fails.
  Future<Weather> fetchWeatherByCity(String city) async {
    final url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Weather.fromJson(data);
    } else {
      throw Exception('Failed to fetch weather');
    }
  }

  /// Fetches weather data based on the user's current location.
  ///
  /// Throws an exception if location services are disabled or permissions are denied.
  Future<Weather> fetchWeatherByLocation() async {
    final position = await _getCurrentPosition();
    final url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?lat=${position.latitude}&lon=${position.longitude}&appid=$apiKey&units=metric');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Weather.fromJson(data);
    } else {
      throw Exception('Failed to fetch weather');
    }
  }

  /// Retrieves the current geographical position of the user.
  ///
  /// Throws an exception if location services are disabled or permissions are denied.
  Future<Position> _getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    // Check location permissions.
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // Request permissions if denied.
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are permanently denied.
      throw Exception(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // Get the current position.
    return await Geolocator.getCurrentPosition();
  }
}

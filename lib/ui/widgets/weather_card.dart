import 'package:flutter/material.dart';
import 'package:task_weather_app/data/models/model_weather.dart';

/// WeatherCard displays detailed weather information.
class WeatherCard extends StatelessWidget {
  final Weather weather;

  const WeatherCard({super.key, required this.weather});

  /// Determines the appropriate weather icon based on the description.
  String _getWeatherIcon(String description) {
    if (description.contains('clear sky')) {
      return 'assets/png/sun.png';
    } else if (description.contains('cloud')) {
      return 'assets/png/cloudy.png';
    } else if (description.contains('rain')) {
      return 'assets/png/rain.png';
    } else if (description.contains('snow')) {
      return 'assets/png/snow.png';
    } else {
      return 'assets/png/storm.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              _getWeatherIcon(weather.description.toLowerCase()),
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 16),
            Text(
              "${weather.city}, ${weather.country}",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "Temperature: ${weather.temperature.toStringAsFixed(1)}°C",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              "Feels Like: ${weather.feelsLike.toStringAsFixed(1)}°C",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              "Description: ${weather.description}",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              "Humidity: ${weather.humidity}%",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              "Wind Speed: ${weather.windSpeed.toStringAsFixed(1)} m/s",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              "Pressure: ${weather.pressure} hPa",
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

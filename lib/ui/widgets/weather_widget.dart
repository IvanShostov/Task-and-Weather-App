import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_weather_app/blocs/weather_bloc/weather_bloc.dart';
import 'package:task_weather_app/ui/widgets/toggle_weather_button.dart';
import 'package:task_weather_app/ui/widgets/weather_card.dart';

/// WeatherWidget manages the visibility and display of the WeatherCard.
class WeatherWidget extends StatefulWidget {
  const WeatherWidget({super.key});

  @override
  WeatherWidgetState createState() => WeatherWidgetState();
}

class WeatherWidgetState extends State<WeatherWidget> {
  bool _isCardVisible = false;

  @override
  void initState() {
    super.initState();
    // Fetch weather data based on current location when the widget initializes.
    context.read<WeatherBloc>().add(FetchWeatherByLocationEvent());
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        AnimatedPositioned(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          top: 16,
          left: _isCardVisible ? 16 : -screenWidth * 0.8,
          child: BlocBuilder<WeatherBloc, WeatherState>(
            builder: (context, state) {
              if (state.isLoading) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(),
                  ),
                );
              } else if (state.error != null) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "Error: ${state.error}",
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                );
              } else if (state.weather == null) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text("Weather data is unavailable."),
                  ),
                );
              }

              final weather = state.weather!;

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  WeatherCard(weather: weather),
                  ToggleWeatherButton(
                    isCardVisible: _isCardVisible,
                    onTap: () {
                      setState(() {
                        _isCardVisible = !_isCardVisible;
                      });
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

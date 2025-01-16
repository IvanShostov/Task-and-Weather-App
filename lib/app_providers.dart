import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:task_weather_app/blocs/category_bloc/category_bloc.dart';
import 'package:task_weather_app/blocs/task_bloc/task_bloc.dart';
import 'package:task_weather_app/blocs/weather_bloc/weather_bloc.dart';
import 'package:task_weather_app/data/models/model_task.dart';
import 'package:task_weather_app/data/repositories/weather_repository.dart';

/// AppProviders sets up the necessary Bloc providers for the application.
class AppProviders extends StatelessWidget {
  final Widget child;
  final Box<Task> taskBox;
  final Box<String> categoriesBox;

  const AppProviders({
    super.key,
    required this.child,
    required this.taskBox,
    required this.categoriesBox,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Provides TaskBloc to manage task-related state and events.
        BlocProvider(
          create: (context) => TaskBloc(taskBox),
        ),
        // Provides WeatherBloc to manage weather-related state and events.
        BlocProvider(
          create: (context) => WeatherBloc(WeatherRepository()),
        ),
        // Provides CategoryBloc to manage category-related state and events.
        BlocProvider(
          create: (context) => CategoryBloc(categoriesBox),
        ),
      ],
      child: child,
    );
  }
}

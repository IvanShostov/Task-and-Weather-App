import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:task_weather_app/app_providers.dart';
import 'package:task_weather_app/ui/screens/task_list_screen.dart';
import 'package:task_weather_app/data/models/model_task.dart';

/// The main entry point of the application.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  // Register Hive adapters.
  Hive.registerAdapter(TaskAdapter());

  // Open Hive boxes for tasks and categories.
  final taskBox = await Hive.openBox<Task>('tasks');
  final categoriesBox = await Hive.openBox<String>('categories');

  runApp(MyApp(taskBox: taskBox, categoriesBox: categoriesBox));
}

/// MyApp sets up the application with necessary providers and routes.
class MyApp extends StatelessWidget {
  final Box<Task> taskBox;
  final Box<String> categoriesBox;

  const MyApp({super.key, required this.taskBox, required this.categoriesBox});

  @override
  Widget build(BuildContext context) {
    return AppProviders(
      taskBox: taskBox,
      categoriesBox: categoriesBox,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Task and Weather App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const TaskListScreen(),
      ),
    );
  }
}

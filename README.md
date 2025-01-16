Task Weather App

Description

Task Weather App is a Flutter application designed to help users manage their tasks efficiently while displaying current weather information. The app utilizes the BLoC pattern for state management, adheres to SOLID principles, and ensures data persistence using Hive.

Features 

Task Management: Add, delete, and mark tasks as completed with titles and descriptions.
Categories: Organize tasks into customizable categories like Work, Personal, etc.
Filtering: Filter tasks by status (completed/incomplete) and category.
Weather Integration: Fetch and display current weather using the OpenWeatherMap API.
Data Persistence: Save tasks and categories locally using Hive to retain data between sessions.


Justification for Network Library Choice 

The http package was chosen for handling network operations in Task Weather App due to its simplicity, lightweight nature, and ease of integration with Flutter and BLoC. It provides a straightforward API for making HTTP requests, which is sufficient for fetching weather data from the OpenWeatherMap API without adding unnecessary complexity.

Dependencies

flutter_bloc: For implementing the BLoC pattern.
hive & hive_flutter: For local data storage and persistence.
http: For network requests to fetch weather data.
geolocator: To access the device's current location for weather data.
meta: Provides annotations that can be used by static analysis tool
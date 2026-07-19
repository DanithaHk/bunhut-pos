import 'dart:developer' as developer;

class AppLogger {

  static void log(
      String message, {
        String name = 'APP',
      }) {
    developer.log(
      message,
      name: name,
    );
  }

  static void error(
      String message, {
        Object? error,
        String name = 'ERROR',
      }) {
    developer.log(
      message,
      name: name,
      error: error,
    );
  }
}
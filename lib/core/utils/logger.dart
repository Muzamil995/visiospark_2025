import 'package:logger/logger.dart';

class AppLogger {
  static late Logger _logger;

  static void init() {
    _logger = Logger(
      printer: PrettyPrinter(
        methodCount: 2,
        errorMethodCount: 8,
        lineLength: 120,
        colors: true,
        printEmojis: true,
        dateTimeFormat: DateTimeFormat.none,
      ),
    );
  }

  static void debug(String message, [dynamic data]) {
    if (data != null) {
      _logger.d('$message: $data');
    } else {
      _logger.d(message);
    }
  }

  static void info(String message, [dynamic data]) {
    if (data != null) {
      _logger.i('$message: $data');
    } else {
      _logger.i(message);
    }
  }

  static void warning(String message, [dynamic data]) {
    if (data != null) {
      _logger.w('$message: $data');
    } else {
      _logger.w(message);
    }
  }

  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  static void success(String message, [dynamic data]) {
    if (data != null) {
      _logger.i('✅ SUCCESS: $message: $data');
    } else {
      _logger.i('✅ SUCCESS: $message');
    }
  }
}

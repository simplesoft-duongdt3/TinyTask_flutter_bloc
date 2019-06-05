import 'package:flutter_app/data/SecurityData.dart';
import 'package:flutter_app/domain/Logger.dart';
import 'package:sentry/sentry.dart';

class SentryLogger extends Logger {
  final SentryClient _sentry = new SentryClient(
      dsn: SecurityData.SENTRY_DSN);

  @override
  Future<void> log(String something) async {
    print(something);
  }

  @override
  Future<void> logError(error, stackTrace) async {
    // Print the exception to the console
    print('Caught error: $error');
    if (isInDebugMode) {
      // Print the full stacktrace in debug mode
      print(stackTrace);
      return;
    } else {
      // Send the Exception and Stacktrace to Sentry in Production mode
      _sentry.captureException(
        exception: error,
        stackTrace: stackTrace,
      );
    }
  }

  bool get isInDebugMode {
    // Assume you're in production mode
    bool inDebugMode = false;

    // Assert expressions are only evaluated during development. They are ignored
    // in production. Therefore, this code only sets `inDebugMode` to true
    // in a development environment.
    assert(inDebugMode = true);

    return inDebugMode;
  }
}

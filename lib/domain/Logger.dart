abstract class Logger {
  Future<void> logError(dynamic error, dynamic stackTrace);
  Future<void> log(String something);
}
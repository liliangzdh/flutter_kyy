import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

class MyLogger {
  static init() {
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((LogRecord rec) {
      print('${rec.level.name}: ${rec.time}: ${rec.message}');
    });
  }

  static Logger log;

  getLogger() {
    return log;
  }

  static Logger getInstance(String my) {
    init();
    log = new Logger(my);
    return log;
  }
}

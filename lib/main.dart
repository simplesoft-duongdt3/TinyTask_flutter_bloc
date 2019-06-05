import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app/domain/Logger.dart';
import 'package:flutter_app/presentation/PresentationDependencyInjectRegister.dart';
import 'package:flutter_app/presentation/screen/SplashScreen.dart';
import 'package:kiwi/kiwi.dart' as kiwi;

import 'data/DataDependencyInjectRegister.dart';
import 'package:sentry/sentry.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final kiwi.Container diResolver = kiwi.Container();
void main() async {
  await setupDi();

  Logger _logger = diResolver.resolve();
  BlocSupervisor.delegate = SimpleBlocDelegate();
  FlutterError.onError = (FlutterErrorDetails details) {
    if (isInDebugMode) {
      // In development mode, simply print to console.
      FlutterError.dumpErrorToConsole(details);
    } else {
      // In production mode, report to the application zone to report to
      // Sentry.
      Zone.current.handleUncaughtError(details.exception, details.stack);
    }
  };

  runZoned<Future<void>>(() async {
    runApp(MyApp());
  }, onError: (error, stackTrace) {
    _logger.logError(error, stackTrace);
  });
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

Future<void> setupDi() async {
  var diRegisters = [
    DataDependencyInjectRegister(),
    PresentationDependencyInjectRegister(),
  ];
  for (var di in diRegisters) {
    await di.register(diResolver);
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tiny Task',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: SplashScreen(),
    );
  }
}

class SimpleBlocDelegate extends BlocDelegate {

  Logger _logger = diResolver.resolve();

  @override
  void onEvent(Bloc bloc, Object event) {
    super.onEvent(bloc, event);
    print(event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }

  @override
  void onError(Bloc bloc, Object error, StackTrace stacktrace) {
    super.onError(bloc, error, stacktrace);
    _logger.logError(error, stacktrace);
  }
}

import 'package:falla/main_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);  await Firebase.initializeApp();
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  runApp(MainApp());
}

final GlobalKey<ScaffoldMessengerState> messengerKey =
    GlobalKey<ScaffoldMessengerState>();

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}



class _MainAppState extends State<MainApp> {
  RateMyApp rateMyApp = RateMyApp();

  @override
void initState() {
  super.initState();
  _initializationSequence();
}

Future<void> _initializationSequence() async {
  await WidgetsBinding.instance.endOfFrame; 
  if (!mounted) return;

  await rateMyApp.init();

  await Future.delayed(const Duration(seconds: 1));
  FlutterNativeSplash.remove();

  if (mounted && rateMyApp.shouldOpenDialog) {
    final localContext = context; 
    rateMyApp.showRateDialog(localContext);
  }
}


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: messengerKey,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
      ),
      home: MainScreen(),
      builder: (context, child) {
        final brightness = MediaQuery.of(context).platformBrightness;
        SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle(
            statusBarIconBrightness: brightness == Brightness.dark
                ? Brightness.light
                : Brightness.dark,
          ),
        );
        return child!;
      },
    );
  }
}

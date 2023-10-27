import 'package:firebase/util/firebase_options.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';

import 'firebase/firebase_remot_config.dart';
import 'firebase/firebase_service.dart';

FirebaseAnalytics analytics = FirebaseAnalytics.instance;
FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;
String? message;
late String? result;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
  await FirebaseService().initNotification();
  await FirebaseRemoteConfigService().initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final remoteConfig = FirebaseRemoteConfigService();
  @override
  void initState() {
    message = remoteConfig.welcomeMessage;
    _onConfigUpdate();
    super.initState();
  }

  int _counter = 0;

  Future<void> _onConfigUpdate() async {
    _remoteConfig.onConfigUpdated.listen((value) async {
      await _remoteConfig.fetchAndActivate();
      final updatedStringValue =
          _remoteConfig.getString(FirebaseRemoteConfigKeys.welcomeMessage);
      setState(() {
        message = updatedStringValue;
      });

      print('Updated String Value: $updatedStringValue');
      debugPrint('updated config');
    });
  }

  void _incrementCounter() async {
    await remoteConfig.fetchAndActivate();
    analytics.logBeginCheckout(
        value: 10.0,
        currency: 'USD',
        items: [
          AnalyticsEventItem(
              itemName: 'Socks', itemId: 'xjw73ndnw', price: 10.0),
        ],
        coupon: '10PERCENTOFF');
    // FirebaseCrashlytics.instance.crash();
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(message ?? ""),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

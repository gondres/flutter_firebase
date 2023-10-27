import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';

class FirebaseRemoteConfigService {
  FirebaseRemoteConfigService._()
      : _remoteConfig = FirebaseRemoteConfig.instance; // MODIFIED

  static FirebaseRemoteConfigService? _instance; // NEW
  factory FirebaseRemoteConfigService() =>
      _instance ??= FirebaseRemoteConfigService._(); // NEW

  final FirebaseRemoteConfig _remoteConfig;

  String get welcomeMessage =>
      _remoteConfig.getString(FirebaseRemoteConfigKeys.welcomeMessage);

  Future<void> _setConfigSettings() async => _remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 1),
          minimumFetchInterval: const Duration(seconds: 1),
        ),
      );

  Future<void> _setDefaults() async => _remoteConfig.setDefaults(
        const {
          FirebaseRemoteConfigKeys.welcomeMessage:
              'Hey there, this message is coming from local defaults.',
        },
      );
  Future<void> fetchAndActivate() async {
    bool updated = await _remoteConfig.fetchAndActivate();

    if (updated) {
      debugPrint('The config has been updated.');
    } else {
      debugPrint('The config is not updated..');
    }
  }

  Future<String?> onConfigUpdate() async {
    String? message = FirebaseRemoteConfigService().welcomeMessage;
    _remoteConfig.onConfigUpdated.listen((event) async {
      await _remoteConfig.fetchAndActivate();
      final updatedStringValue =
          _remoteConfig.getString(FirebaseRemoteConfigKeys.welcomeMessage);
      message = updatedStringValue;
      print('Updated String Value: $updatedStringValue');
      debugPrint('updated config');
    });
    return message;
  }

  Future<void> initialize() async {
    await _setConfigSettings();
    await _setDefaults();
    await onConfigUpdate();
    await fetchAndActivate();
  }
}

class FirebaseRemoteConfigKeys {
  static const String welcomeMessage = 'welcome_message';
}

import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print('Message Id: ${message.messageId}');
  print('Title: ${message.data["title"]}');
  print('Body: ${message.notification?.body}');
  print('Payload: ${message.data}');
}
class FirebaseService { final _firebaseMessaging = FirebaseMessaging.instance;



  void handleMessage(RemoteMessage? message) {
    if (message == null) return;
    // navigatorKey.currentState
    //     ?.pushNamed(NotificationScreen.route, arguments: message);
  }

  Future initPushNotifications() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
  }

  Future<void> initNotification() async {
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();
    print('Token ${fCMToken}');
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    initPushNotifications();
  }}

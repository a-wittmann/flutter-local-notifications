import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final NotificationService _notificationService =
      NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('logo');
  
  
    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid, 
            macOS: null);
  
   await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }


   Future selectNotification(String payload) async {
      //Handle notification tapped logic here
   }

}

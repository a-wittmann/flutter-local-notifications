import 'package:demo/notification_service.dart';
import 'package:demo/scheduledNotification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:permission_handler/permission_handler.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // for scheduled notifications
  await _requestPermissions();
  tz.initializeTimeZones();
  tz.setLocalLocation(
      tz.getLocation('Europe/Berlin')); // Set the timezone to Germany
  await ScheduledNotificationService().init();
  // for normal notifications
  await NotificationService().init();
  runApp(const MyApp());
}

Future<void> _requestPermissions() async {
  if (await Permission.scheduleExactAlarm.request().isGranted) {
    print('SCHEDULE_EXACT_ALARM permission granted');
    // The permission was granted
  } else {
    print('SCHEDULE_EXACT_ALARM permission denied');
    // The permission was denied
    // Optionally, handle the case where permission is denied
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo Local Notifications',
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
  int _counter = 0;
  NotificationService notificationService = NotificationService();
  ScheduledNotificationService scheduledNotificationService =
      ScheduledNotificationService();
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
    _showNotification();
  }

  Future<void> _showNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'channel1',
      'demo channel',
      channelDescription: 'channel for demo app',
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await notificationService.flutterLocalNotificationsPlugin.show(
        _counter,
        "Counter incremented!",
        "Counter is now: $_counter",
        platformChannelSpecifics);
  }

  Future<void> _scheduleNotification() async {
    DateTime scheduledTime = DateTime.now().add(const Duration(seconds: 5));
    print(scheduledTime);
    await scheduledNotificationService.flutterLocalNotificationsPlugin
        .zonedSchedule(
            _counter,
            'Scheduled Notification',
            'This is a scheduled notification.',
            tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
            const NotificationDetails(
                android: AndroidNotificationDetails(
                    'full screen channel id', 'full screen channel name',
                    channelDescription: 'full screen channel description',
                    priority: Priority.high,
                    importance: Importance.high,
                    fullScreenIntent: true)),
            androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime);
  }

  void _killAllNotifications() {
    notificationService.flutterLocalNotificationsPlugin.cancelAll();
    scheduledNotificationService.cancelAllNotifications();
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
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            TextButton.icon(
              label: const Text('Delete all Notifications'),
              onPressed: _killAllNotifications,
              icon: const Icon(Icons.delete),
            ),
            const SizedBox(height: 20),
            TextButton.icon(
              label: const Text('Schedule Notification'),
              onPressed: _scheduleNotification,
              icon: const Icon(Icons.schedule),
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

import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'chat_screen.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';

import 'my_user.dart';
import 'name_generator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: 'chat-app-hands-on',
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await _initUserConfig();

  runApp(const MyApp());
}

Future<void> _initUserConfig() async {
  final sp = await SharedPreferences.getInstance();
  var myUserId = sp.getString(MyUser.userIdKey);
  if (myUserId == null) {
    final initialMyUserId = const Uuid().v4();
    await sp.setString(MyUser.userIdKey, initialMyUserId);
  }
  myUserId ??= sp.getString(MyUser.userIdKey);

  var name = sp.getString(MyUser.nameKey);
  if (name == null) {
    final initialName = generateName(myUserId!);
    await sp.setString(MyUser.nameKey, initialName);
  }
  name ??= sp.getString(MyUser.nameKey);

  final myUser = MyUser.instance;
  myUser.name = name;
  myUser.userId = myUserId;
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ChatScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: const ChatScreen(),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _incrementCounter,
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add),
      // ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

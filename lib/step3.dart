import 'package:bubble/bubble.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'chat_content.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';

import 'my_user.dart';
import 'name_generator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: kIsWeb ? null : 'chat-app-hands-on',
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

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _mainRef = FirebaseDatabase.instance.ref().child('chat_contents');
  final _textController = TextEditingController();
  final _scrollController = ScrollController();

  final chatContents = <ChatContent>[];

  @override
  void initState() {
    super.initState();
    _mainRef.onChildAdded.listen((event) {
      _onAdded(event);
    });
  }

  void _onAdded(DatabaseEvent event) {
    final chatContent = ChatContent.fromSnapshot(event.snapshot);
    setState(() {
      chatContents.add(chatContent);
      SchedulerBinding.instance.addPostFrameCallback(
        (timeStamp) => _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 500),
          curve: Curves.fastOutSlowIn,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          primaryFocus?.unfocus();
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: SingleChildScrollView(
                reverse: true,
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).viewInsets.bottom),
                child: Container(
                  color: const Color.fromARGB(165, 0, 203, 210),
                  height: MediaQuery.of(context).size.height,
                  child: ListView.builder(
                    controller: _scrollController,
                    itemBuilder: (context, index) {
                      final message = chatContents[index];
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, bottom: 4.0, top: 8.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                message.userName,
                              ),
                            ),
                          ),
                          Card(
                            margin: const EdgeInsets.all(16.0),
                            child: Text(
                              message.message,
                            ),
                          ),
                        ],
                      );
                    },
                    itemCount: chatContents.length,
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8.0),
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.text,
                      minLines: 1,
                      maxLines: 1,
                      onSubmitted: (_) async => await _sendMessage(context),
                      controller: _textController,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () async {
                      await _sendMessage(context);
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _sendMessage(BuildContext context) async {
    final chatContent = ChatContent(
        id: '',
        message: _textController.text,
        userId: MyUser.instance.userId ?? '',
        userName: MyUser.instance.name ?? 'no name');
    await _mainRef.push().set(chatContent.toJson());
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('追加しました。'),
    ));
    _textController.clear();
  }
}

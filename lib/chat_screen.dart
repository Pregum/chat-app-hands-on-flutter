import 'package:chat_app/my_user.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:bubble/bubble.dart';
import 'package:flutter/services.dart';

import 'chat_content.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _mainRef = FirebaseDatabase.instance.ref().child('chat_contents');
  final _textController = TextEditingController();

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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(
              child: TextField(
                keyboardType: TextInputType.text,
                minLines: 1,
                maxLines: 1,
                // onSubmitted: (_) async => await _sendMessage(context),
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
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(bottom: 8.0),
              color: const Color.fromARGB(165, 0, 203, 210),
              child: ListView.builder(
                itemBuilder: (context, index) {
                  final message = chatContents[index];
                  return Column(
                    children: [
                      if (!message.isMine)
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 8.0, bottom: 4.0, top: 4.0),
                          child: Text(message.userName),
                        ),
                      Bubble(
                        margin: const BubbleEdges.only(
                          top: 10.0,
                          left: 8.0,
                          right: 8.0,
                        ),
                        padding: const BubbleEdges.symmetric(
                          horizontal: 12.0,
                          vertical: 12.0,
                        ),
                        alignment: message.isMine
                            ? Alignment.topRight
                            : Alignment.topLeft,
                        nip: message.isMine
                            ? BubbleNip.rightTop
                            : BubbleNip.leftTop,
                        color: message.isMine
                            ? const Color.fromRGBO(255, 255, 199, 1.0)
                            : null,
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
        ],
      ),
    );
  }

  Future<void> _sendMessage(BuildContext context) async {
    final chatContent = ChatContent(
        id: '',
        message: _textController.text,
        userId: MyUser.instance.userId ?? '');
    await _mainRef.push().set(chatContent.toJson());
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('追加しました。'),
    ));
    _textController.clear();
  }
}

import 'package:chat_app/my_user.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

class ChatContent {
  String id;
  String message;
  DateTime createdAt;
  String userId;
  String userName;

  ChatContent({
    required this.id,
    required this.message,
    required this.userId,
    String? userName,
    DateTime? createdAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        userName = userName ?? 'no name';

  factory ChatContent.fromSnapshot(DataSnapshot data) {
    final rawData = Map<String, dynamic>.from(data.value as Map);
    final id = data.key ?? '';
    final message = rawData['message'] as String? ?? '';
    final userId = rawData['user_id'] as String? ?? '';
    final rawCreatedAt = rawData['created_at'] as int? ?? 0;
    final userName = rawData['user_name'] as String? ?? 'unknown name';
    final createdAt = DateTime.fromMillisecondsSinceEpoch(rawCreatedAt);
    return ChatContent(
      id: id,
      message: message,
      userId: userId,
      userName: userName,
      createdAt: createdAt,
    );
  }

  Map<String, Object> toJson() {
    return {
      'id': id,
      'message': message,
      'user_id': userId,
      'user_name': userName,
      'created_at': createdAt.millisecondsSinceEpoch,
    };
  }
}

extension ChatContentEx on ChatContent {
  bool get isMine {
    return userId == MyUser.instance.userId;
  }

  String toCreatedStr() {
    final formatter = DateFormat('yyyy-MM-dd HH:mm');
    return formatter.format(createdAt);
  }
}

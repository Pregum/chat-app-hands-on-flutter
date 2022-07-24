import 'package:chat_app/my_user.dart';
import 'package:firebase_database/firebase_database.dart';

class ChatContent {
  String id;
  String message;
  DateTime createdAt;
  String userId;

  ChatContent({
    required this.id,
    required this.message,
    required this.userId,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory ChatContent.fromSnapshot(DataSnapshot data) {
    final rawData = data.value as Map<String, Object>;
    final id = rawData['id'] as String? ?? '';
    final message = rawData['message'] as String? ?? '';
    final userId = rawData['user_id'] as String? ?? '';
    final rawCreatedAt = rawData['created_at'] as int? ?? 0;
    final createdAt = DateTime.fromMicrosecondsSinceEpoch(rawCreatedAt);
    return ChatContent(
      id: id,
      message: message,
      userId: userId,
      createdAt: createdAt,
    );
  }

  Map<String, Object> toJson() {
    return {
      'id': id,
      'message': message,
      'user_id': userId,
      'created_at': createdAt.millisecondsSinceEpoch
    };
  }
}

extension ChatContentEx on ChatContent {
  bool get isMine {
    return userId == MyUser.instance.userId;
  }
}

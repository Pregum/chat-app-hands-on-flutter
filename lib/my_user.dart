class MyUser {
  static MyUser? _ins;
  static MyUser get instance => (_ins ??= MyUser._internal());

  static const String userIdKey = 'userId';
  static const String nameKey = 'name';

  MyUser._internal();

  String? userId;
  String? name;
}

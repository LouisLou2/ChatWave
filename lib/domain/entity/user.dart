import 'package:isar/isar.dart';
part 'user.g.dart';

@collection
class User{
  Id id = Isar.autoIncrement;

  @Index(unique: true,replace: true)
  int userId;

  String name;

  @Index(unique: true,replace: true)
  String email;

  User({required this.userId,required this.name,required this.email});

  @override
  String toString() {
    return 'User{userId: $userId, name: $name, email: $email}';
  }
}
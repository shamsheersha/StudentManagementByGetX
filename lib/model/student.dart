import 'package:hive/hive.dart';
part 'student.g.dart';

@HiveType(typeId: 0)
class Student {
  @HiveField(0)
  String name;

  @HiveField(1)
  String age;

  @HiveField(2)
  String studentClass;

  @HiveField(3)
  String gender;

  @HiveField(4)
  String? imagePath;

  Student(
      {required this.name,
      required this.age,
      required this.gender,
      this.imagePath,
      required this.studentClass});
}

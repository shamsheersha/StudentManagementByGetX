import 'dart:developer';

import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:student_app/model/student.dart';

class StudentController extends GetxController{
  final Box<Student> studentBox = Hive.box<Student>('students');
  var students = <Student>[].obs;
  var filteredStudents = <Student>[].obs;

  @override
  void onInit(){
    loadStudents();
    super.onInit();
  }

  loadStudents(){
    var box = Hive.box<Student>('students');
    students.assignAll(box.values.toList());
  }

  getStudentKey(int index){
    var box = Hive.box<Student>('students');

    if(index < 0 || index >= box.length){
      log('Index out of range : $index');
      return null;
    }
    return box.keyAt(index);
  }

  addStudent(Student student){
    var box = Hive.box<Student>('students');
    box.add(student);
    students.add(student);
  }

  updateStudents(int index, Student student){
    var box = Hive.box<Student>('students');

    box.putAt(index, student);
  }

  deleteStudentByKey(dynamic key){
    var box = Hive.box<Student>('students');

    if(box.containsKey(key)){
      box.delete(key);
      
    }else{
      log('Key Not Found');
    }
    loadStudents();
  }

  searchStudents(String query) {
    if (query.isEmpty) {
      filteredStudents
          .assignAll(students); // Show all students if query is empty
    } else {
      var lowercaseQuery = query.toLowerCase();
      var result = students.where(
          (student) => student.name.toLowerCase().contains(lowercaseQuery));
      filteredStudents.assignAll(result.toList()); // Filter students by name
    }
  }
}
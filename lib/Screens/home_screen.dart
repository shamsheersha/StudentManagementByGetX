import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:student_app/Screens/add_dataScreen.dart';
import 'package:student_app/controllers/check_search.dart';
import 'package:student_app/controllers/search_controller.dart';
import 'package:student_app/controllers/student_controller.dart';

import 'package:student_app/Screens/edit_user.dart';

import 'package:student_app/Screens/students_all_details.dart';
import 'package:student_app/controllers/theme_controller.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final SearchFieldController searchFieldController =
      Get.put(SearchFieldController());

  final StudentController studentController = Get.put(StudentController());

  final CheckSearchController checkSearchController =
      Get.put(CheckSearchController());

  bool isGridView = false;

  final TextEditingController searchController = TextEditingController();
  final ThemeController themeController1 = Get.put(ThemeController());
  final ThemeController themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.blue[400],
          actions: [
            GetBuilder<ThemeController>(builder: (_){
              return Switch(value: themeController.themeMode == ThemeMode.dark, onChanged: (value){
                themeController.toggleTheme(value);
              },activeColor: Colors.white,);
            }),
            IconButton(
                onPressed: () {
                  checkSearchController.isSearch.value =
                      !checkSearchController.isSearch.value;
                  searchController.text = '';
                },
                icon: const Icon(Icons.search))
          ],
          title: const Center(
              child: Text(
            '            Student Information',
            style: TextStyle(fontWeight: FontWeight.w700),
          )),
        ),
        body: Obx(() {
          return Column(
            children: [
              !checkSearchController.isSearch.value
                  ? const SizedBox.shrink()
                  : Padding(
                      padding: const EdgeInsets.all(15),
                      child: TextField(
                        onChanged: (query) {
                          studentController
                              .searchStudents(searchController.text);
                        },
                        controller: searchController,
                        decoration: InputDecoration(
                          hintText: 'SEARCH HERE',
                          prefixIcon: const Icon(Icons.search),
                          filled: true,
                          fillColor: Colors.grey[200],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.all(16.0),
                        ),
                      ),
                    ),
              Expanded(
                  child: studentController.students.isEmpty
                      ? Center(
                          child: Text('Student list is empty'),
                        )
                      : ListView.builder(
                          itemCount: checkSearchController.isSearch.value
                              ? studentController.filteredStudents.length
                              : studentController.students.length,
                          itemBuilder: (context, index) {
                            final student = checkSearchController.isSearch.value
                                ? studentController.filteredStudents[index]
                                : studentController.students[index];
                            final studentKey =
                                studentController.getStudentKey(index);

                            // Handle null keys
                            if (studentKey == null) {
                              return SizedBox.shrink();
                            }
                            return Padding(
                              padding: const EdgeInsets.all(8),
                              child: Card(
                                color: Colors.grey[300],
                                child: ListTile(
                                  onTap: () {
                                    Get.to(StudentsDetails(student: student));
                                  },
                                  title: Text(student.name),
                                  subtitle: Text(student.gender),
                                  leading: CircleAvatar(
                                      backgroundImage: student.imagePath != null
                                          ? FileImage(
                                              File(student.imagePath!),
                                            ) as ImageProvider
                                          : AssetImage(
                                              'assets/585e4bf3cb11b227491c339a.png')),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            Get.to(EditStudent(
                                                student: student,
                                                studentKey: studentKey));
                                          },
                                          icon: Icon(Icons.edit)),
                                      IconButton(
                                          onPressed: () {
                                            onDeleteStudent(index);
                                            if (checkSearchController
                                                .isSearch.value) {
                                              Get.off(HomeScreen());
                                            }
                                          },
                                          icon: Icon(Icons.delete))
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ))
            ],
          );
        }),
        floatingActionButton: checkSearchController.isSearch.value
            ? null
            : FloatingActionButton(
                onPressed: () {
                  Get.to(()=>AddDataScreen());
                },
                child: Icon(Icons.add),
              ));
  }

  void onDeleteStudent(int index) {
    final studentKey = studentController.getStudentKey(index);
    if (studentKey != null) {
      studentController.deleteStudentByKey(studentKey);
    }

    // Update the search results if applicable
    if (checkSearchController.isSearch.value) {
      checkSearchController.isSearch.value = false;
      searchController.text = '';
      studentController.searchStudents('');
    }
  }
}

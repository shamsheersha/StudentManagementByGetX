import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:student_app/controllers/student_controller.dart';
import 'package:student_app/model/student.dart';
import 'package:student_app/Screens/home_screen.dart';


class AddDataScreen extends StatefulWidget {
  const AddDataScreen({Key? key});

  @override
  State<AddDataScreen> createState() => AddDataScreenState();
}

class AddDataScreenState extends State<AddDataScreen> {
  final StudentController studentController = Get.put(StudentController());
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController userClassController = TextEditingController();
  final TextEditingController userAgeController = TextEditingController();
  final TextEditingController userGenderController = TextEditingController();
  final ImagePicker picker = ImagePicker();



  File? _image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[200],
        title: const Center(
          child: Text(
            "ADD STUDENT DATA",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.9),
          child: Column(
            children: [
              const Row(
                children: [
                  Text(
                    "Add New Student",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 19,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 35,
              ),
              CircleAvatar(
                radius: 50,
                backgroundImage: _image != null
                    ? FileImage(_image!) as ImageProvider
                    : const AssetImage('assets/585e4bf3cb11b227491c339a.png'),
              ),
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.blue[200])),
                onPressed: _getImage,
                child: const Text(
                  'Pick Image',
                  style: TextStyle(color: Colors.black, fontSize: 12),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: userNameController,
                decoration: InputDecoration(
                  hintText: " Enter Full Name",
                  labelText: "Name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: userAgeController,
                
                decoration: InputDecoration(
                  hintText: " Enter Age",
                  labelText: " Age",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: userClassController,
                
                decoration: InputDecoration(
                  hintText: " Enter Class",
                  labelText: " Class",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: userGenderController,
                
                decoration: InputDecoration(
                  hintText: "Enter Gender ",
                  labelText: " Gender",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
              const SizedBox(
                height: 35,
              ),
              const Row(
                children: [
                  SizedBox(
                    width: 20,
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  const SizedBox(
                    width: 70,
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.red[100],
                    ),
                    onPressed: () {
                      userNameController.clear();
                      userAgeController.clear();
                      userClassController.clear();
                      userGenderController.clear();
                      setState(() {
                        _image = null;
                      });
                    },
                    child: Text(
                      "Clear Data",
                      style: TextStyle(color: Colors.red[900]),
                    ),
                  ),
                  const SizedBox(
                    width: 40,
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.green[100],
                    ),
                    onPressed: () async {
                      final userName = userNameController.text;
                      final userAge = userAgeController.text;
                      final userClass = userClassController.text;
                      final userGender = userGenderController.text;

                      if (userName.isEmpty ||
                          userAge.isEmpty ||
                          userClass.isEmpty ||
                          userGender.isEmpty) {
                        _showSnackBar(
                             'Please fill all details', Colors.red);
                            return;
                          }
                        final student = Student(
                            name: userName,
                            age: userAge,
                            gender: userGender,
                            studentClass: userClass,
                            imagePath: _image?.path);

                        studentController.addStudent(student);
                        
                       Get.offAll(()=>  HomeScreen());
                      
                    },
                    child: Text(
                      "Save Data",
                      style: TextStyle(color: Colors.green[400]),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSnackBar( String message, Color color) {
    Get.snackbar('Notification', message,backgroundColor: color,duration:const Duration(seconds: 2));

  }

  Future<void> _getImage() async {
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = pickedFile != null ? File(pickedFile.path) : null;
    });
  }
}

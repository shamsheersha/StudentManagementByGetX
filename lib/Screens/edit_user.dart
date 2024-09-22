import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:student_app/controllers/student_controller.dart';
import 'package:student_app/model/student.dart';
import 'package:student_app/Screens/home_screen.dart';

class EditStudent extends StatefulWidget {
  final studentKey;
  final Student student;
  const EditStudent({Key? key, required this.student, required this.studentKey})
      : super(key: key);

  @override
  State<EditStudent> createState() => _EditStudentState();
}

class _EditStudentState extends State<EditStudent> {
  final StudentController studentController = Get.put(StudentController());
  File? _image;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController userAgeController = TextEditingController();
  final TextEditingController userClassController = TextEditingController();
  final TextEditingController userGenderController = TextEditingController();
  bool _validateName = false;
  bool _validateAge = false;
  bool _validateClass = false;
  bool _validateGender = false;
  @override
  void initState() {
    setState(() {
      userNameController.text = widget.student.name ?? '';
      userClassController.text = widget.student.age ?? '';
      userAgeController.text = widget.student.age ?? '';
      userGenderController.text = widget.student.gender ?? '';

      if (widget.student.imagePath != null) {
        _image = File(widget.student.imagePath!);
      } else {
        _image = null;
      }
    });
    super.initState();
  }

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
              CircleAvatar(
                backgroundImage: _image != null
                    ? FileImage(_image!) as ImageProvider
                    : const AssetImage('assets/student11.jpg'),
                radius: 50,
              ),
              ElevatedButton(
                onPressed: _getImage
                //////////
                ,
                child: const Text('Pick Image'),
              ),
              const SizedBox(
                height: 35,
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
                      userNameController.text = "";
                      userAgeController.text = "";
                      userClassController.text = "";
                      userGenderController.text = "";
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
                      backgroundColor: const Color.fromARGB(255, 203, 200, 230),
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
                        _showSnackBar(context, 'Please fill add details',Colors.red);
                        return;
                      }
                      final user = Student(
                          name: userName,
                          age: userAge,
                          gender: userGender,
                          studentClass: userClass,
                          imagePath: _image?.path);
                      studentController.updateStudents(widget.studentKey, user);
                      _showSnackBar(context, 'Data Saved',Colors.black);
                      Get.offAll(()=>  HomeScreen());
                    },
                    child: const Text(
                      "Updata Data",
                      style: TextStyle(color: Color.fromARGB(255, 15, 44, 206)),
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

  void _showSnackBar(BuildContext context, String message,Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _getImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if(pickedFile != null){
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }
}

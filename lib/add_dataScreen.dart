import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:student_app/model/user.dart';
import 'package:student_app/myHome_page.dart';
import 'package:student_app/services/user_services.dart';

class AddDataScreen extends StatefulWidget {
  const AddDataScreen({Key? key});

  @override
  State<AddDataScreen> createState() => AddDataScreenState();
}

class AddDataScreenState extends State<AddDataScreen> {
  var _userNameController = TextEditingController();
  var _userAgeController = TextEditingController();
  var _userClassController = TextEditingController();
  var _userGenderController = TextEditingController();
  bool _validateName = false;
  bool _validateAge = false;
  bool _validateClass = false;
  bool _validateGender = false;

  final _userService = UserService();
  File? _image;
  final ImagePicker _picker = ImagePicker();

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
              Row(
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
                    : const AssetImage('assets/student11.jpg'),
              ),
              ElevatedButton(
                onPressed: _getImage,
                child: const Text('Pick Image'),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _userNameController,
                onChanged: (value) {
                  setState(() {
                    _validateName = value.isEmpty;
                  });
                },
                decoration: InputDecoration(
                  errorText: _validateName ? "Name cant't be Empty" : null,
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
                controller: _userAgeController,
                onChanged: (value) {
                  setState(() {
                    _validateAge = value.isEmpty;
                  });
                },
                decoration: InputDecoration(
                  errorText: _validateAge ? "Age cant't be Empty" : null,
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
                controller: _userClassController,
                onChanged: (value) {
                  setState(() {
                    _validateClass = value.isEmpty;
                  });
                },
                decoration: InputDecoration(
                  errorText: _validateClass ? "Class cant't be Empty" : null,
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
                controller: _userGenderController,
                onChanged: (value) {
                  setState(() {
                    _validateGender = value.isEmpty;
                  });
                },
                decoration: InputDecoration(
                  errorText: _validateGender ? "Gender cant't be Empty" : null,
                  hintText: "Enter Gender ",
                  labelText: " Gender",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
              SizedBox(
                height: 35,
              ),
              Row(
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
                      _userNameController.text = "";
                      _userAgeController.text = "";
                      _userClassController.text = "";
                      _userGenderController.text = "";
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
                      print(" Good Data Can Save Now");

                      setState(
                        () {
                          _userNameController.text.isEmpty
                              ? _validateName = true
                              : _validateName = false;

                          _userAgeController.text.isEmpty
                              ? _validateAge = true
                              : _validateAge = false;

                          _userClassController.text.isEmpty
                              ? _validateClass = true
                              : _validateClass = false;

                          _userGenderController.text.isEmpty
                              ? _validateGender = true
                              : _validateGender = false;
                        },
                      );
                      if (_validateName == false &&
                          _validateAge == false &&
                          _validateClass == false &&
                          _validateGender == false) {
                        _showSnackBar(context, 'Data Saved Successfully',);

                        var _user = User();
                        _user.name = _userNameController.text;
                        _user.studentclass = _userClassController.text;
                        _user.age = _userAgeController.text;
                        _user.gender = _userGenderController.text;
                        _user.image = _image?.path;
                        var result = await _userService.SaveUser(_user);
                        print(result);
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (ctx) {
                          return MyHome();
                        }), (route) => false);
                      }
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

  void _showSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: color,
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _getImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = pickedFile != null ? File(pickedFile.path) : null;
    });
  }
}

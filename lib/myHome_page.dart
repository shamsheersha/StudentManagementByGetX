import 'dart:io';
import 'package:flutter/material.dart';
import 'package:student_app/add_dataScreen.dart';
import 'package:student_app/db_helper/repository.dart';
import 'package:student_app/edit_user.dart';
import 'package:student_app/model/user.dart';
import 'package:student_app/services/user_services.dart';
import 'package:student_app/students_all_details.dart';

class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  bool isGridView = false;
  var _searchController = TextEditingController();
  final _userService = UserService();
  final _userService1 = Repository();

  final ValueNotifier<List<User>> notifier = ValueNotifier<List<User>>([]);
  @override
  void initState() {
    getAllUserDetails('');

    super.initState();
  }

  var length = 0;
  getAllUserDetails(String s) async {
    _searchController.text = s;
    List<Map> users = await _userService1.searchRecords(s);
    notifier.value = [];
    print(users);
    users.forEach((user) {
      setState(() {
        var userModel = User();
        userModel.id = user['id'];
        userModel.name = user['name'];
        userModel.studentclass = user['studentclass'];
        userModel.age = user['age'];
        userModel.gender = user['gender'];
        userModel.image = user['image'];
        notifier.value.add(userModel);
        length = notifier.value.length;
      });
    });
    print(length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.tealAccent[400],
        title: const Center(
          child: Text("Student Information"),
        ),
      ),
      body: length != 0
          ? Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: TextField(
                    onChanged: (value) {
                      getAllUserDetails(value);
                    },
                    controller: _searchController,
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
                //  GridView Button--------------------------------------
                IconButton(
                  icon: Icon(isGridView ? Icons.list : Icons.grid_on),
                  onPressed: () {
                    setState(() {
                      isGridView = !isGridView;
                    });
                  },
                ),
                ValueListenableBuilder(
                    valueListenable: notifier,
                    builder: (context, userList, child) {
                      return Expanded(
                        child: isGridView
                            // GridView----------------------------------
                            ? GridView.builder(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 8.0,
                                  mainAxisSpacing: 8.0,
                                ),
                                itemCount: userList.length,
                                itemBuilder: (context, index) {
                                  return Card(
                                    child: ListTile(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (ctx) {
                                              return StudetsDetails(
                                                user: userList[index],
                                              );
                                            },
                                          ),
                                        );
                                      },
                                      title: Column(
                                        children: [
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Text(
                                            userList[index].name ?? '',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          //+++++++++
                                          IconButton(
                                            onPressed: () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (ctx) {
                                                    return EditUser(
                                                      user: userList[index],
                                                    );
                                                  },
                                                ),
                                              );
                                            },
                                            icon: const Icon(
                                              Icons.edit,
                                              color: Colors.teal,
                                            ),
                                          ),

                                          //  delete button---------------------------------------
                                          IconButton(
                                            onPressed: () {
                                              _deleteFormDialog(
                                                  context, userList[index].id);
                                            },
                                            icon: const Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ),
                                          )
                                        ],
                                      ),
                                      leading: CircleAvatar(
                                        backgroundImage: userList[index]
                                                    .image !=
                                                null
                                            ? FileImage(
                                                File(userList[index].image!),
                                              ) as ImageProvider
                                            : AssetImage(
                                                'test/asset/SPLAH.jpg'),
                                      ),
                                      trailing: Column(
                                        mainAxisSize: MainAxisSize.min,
                                      ),
                                    ),
                                  );
                                },
                              )
                            //ListView-----------------------------------------------------------
                            : ListView.builder(
                                itemCount: userList.length,
                                itemBuilder: (context, index) {
                                  return Card(
                                    child: ListTile(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (ctx) {
                                              return StudetsDetails(
                                                user: userList[index],
                                              );
                                            },
                                          ),
                                        );
                                      },
                                      title: Text(
                                        userList[index].name ?? '',
                                      ),
                                      subtitle: Text(
                                        userList[index].gender ?? '',
                                      ),

                                      //Circle Avatar with Image--------------------------
                                      leading: CircleAvatar(
                                        backgroundImage:
                                            userList[index].image != null
                                                ? FileImage(File(
                                                        userList[index].image!))
                                                    as ImageProvider
                                                : const AssetImage(
                                                    'test/asset/SPLAH.jpg'),
                                      ),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (ctx) {
                                                    return EditUser(
                                                      user: userList[index],
                                                    );
                                                  },
                                                ),
                                              );
                                            },
                                            icon: const Icon(
                                              Icons.edit,
                                              color: Colors.teal,
                                            ),
                                          ),

                                          //  delete button---------------------------------------
                                          IconButton(
                                            onPressed: () {
                                              _deleteFormDialog(
                                                  context, userList[index].id);
                                            },
                                            icon: const Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                      );
                    }),
              ],
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),

                  //Search Field-----------------------------------------------
                  child: TextField(
                    onChanged: (value) {
                      getAllUserDetails(value);
                    },
                    controller: _searchController,
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
                const Expanded(
                  child: Center(
                    child: Text("empty"),
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => goToAddStudentPage(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  // going to new pageand showing snackbar function-----------------------------
  goToAddStudentPage(context) {
    Navigator.of(context)
        .push(
      MaterialPageRoute(
        builder: (ctx) => const AddDataScreen(),
      ),
    )
        .then((data) {
      if (data != null) {
        getAllUserDetails("");
        _showSnackBar(context, "User Details Added Success");
      }
    });
  }

  //showdialig function------------------------------------------
  _deleteFormDialog(BuildContext context, userId) {
    return showDialog(
        context: context,
        builder: (param) {
          return AlertDialog(
            actions: [
              Column(
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("!!!Aleart!!!"),
                      SizedBox(
                        height: 100,
                      )
                    ],
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        width: 30,
                      ),

                      //data deleting button---------------------------------------
                      TextButton(
                          style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.red),
                          onPressed: () async {
                            var result =
                                await _userService.deleteUser("users", userId);
                            // print(result);
                            if (result != null) {
                              Navigator.of(context).pop();

                              getAllUserDetails('');

                              _showSnackBar(context, 'Data Deleted');
                            }
                          },
                          child: const Text("Delete")),
                      const SizedBox(
                        width: 20,
                      ),
                      //cancel button---------------------------------------------------------
                      TextButton(
                          style: TextButton.styleFrom(
                              foregroundColor: Colors.blue,
                              backgroundColor:
                                  const Color.fromARGB(255, 201, 216, 201)),
                          onPressed: () {
                            return Navigator.of(context).pop();
                          },
                          child: const Text("Cancel"))
                    ],
                  )
                ],
              ),
            ],
          );
        });
  }

  _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

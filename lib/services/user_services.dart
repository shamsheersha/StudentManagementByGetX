import 'package:student_app/db_helper/repository.dart';
import 'package:student_app/model/user.dart';

class UserService {
  late Repository _repository;
  UserService() {
    _repository = Repository();
  }
  //save user
  SaveUser(User user) async {
    return await _repository.insertData('user', user.userMap());
  }

  //Read All User
  readAllUsers() async {
    return await _repository.readData('user');
  }

  // Edit Users
  UpdateUser(User user) async {
    print(user.id);

    return await _repository.updateData('user', user.userMap(), user.id);
  }

  deleteUser(table, userId) async {
    //     return await _repository.deleteData('users', UserId);
    return await _repository.deleteDataById('user', userId);
  }
}

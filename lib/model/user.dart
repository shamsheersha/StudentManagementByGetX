class User {
  int? id;
  String? name;
  String? age;
  String? studentclass;
  String? gender;
  String? image;

  //get imageUrl => null;

  userMap() {
    var mapping = Map<String, dynamic>();
    // print(id);

    mapping["name"] = name!;
    mapping["age"] = age!;
    mapping["studentclass"] = studentclass!;
    mapping["gender"] = gender!;
    mapping["image"] = image;
    return mapping;
  }
}

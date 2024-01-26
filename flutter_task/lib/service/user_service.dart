import 'dart:convert';
import 'package:http/http.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_task/model/user_model.dart';

class UserService {
  String userUrl = 'https://reqres.in/api/users?page=2';

 Future<List<UserModel>> getUsers() async {
    Response response = await get(Uri.parse(userUrl));
    if (response.statusCode == 200) {
      final List result = jsonDecode(response.body)['data'];
      return result.map((e) => UserModel.fromJson(e)).toList();
    } else {
      throw Exception(response.reasonPhrase);
    }
  }
}
final userController=Provider<UserService>((ref)=>UserService());
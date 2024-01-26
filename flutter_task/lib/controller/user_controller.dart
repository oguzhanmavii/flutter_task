import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_task/model/user_model.dart';
import 'package:flutter_task/service/user_service.dart';


final UserController = FutureProvider<List<UserModel>>((ref) async {
  return ref.watch(userController).getUsers();
});
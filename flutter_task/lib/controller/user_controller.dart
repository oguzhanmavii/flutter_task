import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_task/model/user_model.dart';
import 'package:flutter_task/service/user_service.dart';

final userControllerProvider = Provider<UserService>((ref) {
  return UserService();
});

final UserController = FutureProvider<List<UserModel>>((ref) async {
  final userService = ref.watch(userControllerProvider);
  return userService.getUsers();
});
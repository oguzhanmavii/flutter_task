import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_task/model/user_model.dart';

class ProfilePage extends StatelessWidget {
  final UserModel user;

  const ProfilePage({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              SystemNavigator.pop();
            },
            icon: const Icon(Icons.logout, color: Colors.white),
          ),
        ],
        centerTitle: true,
        title: const Text('Profile'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
          const SizedBox(height: 200,),
            CircleAvatar(
              backgroundImage: NetworkImage(user.avatar.toString()),
              radius: 50,      
            ),
            const SizedBox(height: 16),
            Text(
              '${user.firstName} ${user.lastName}',
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Email: ${user.email}',
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}

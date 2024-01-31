import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_task/model/user_model.dart';
import 'package:flutter_task/view/profile_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controller/user_controller.dart';

class HomePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final container = ProviderContainer();
    //final userController = container.read(userControllerProvider);
    final allUsersFuture = container.read(UserController.future);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("UserList"),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'All Users'),
              Tab(text: 'Saved Users'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildUserListTab(context, allUsersFuture, ref),
            _buildSavedUsersTab(context),
          ],
        ),
      ),
    );
  }

  Widget _buildUserListTab(BuildContext context, Future<List<UserModel>> allUsersFuture, WidgetRef ref) {
    return FutureBuilder<List<UserModel>>(
      future: allUsersFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          List<UserModel> users = snapshot.data ?? [];
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              UserModel user = users[index];
              return ListTile(
                title: Text('${user.firstName} ${user.lastName}'),
                subtitle: Text('${user.email}'),
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(
                    user.avatar.toString(),
                  ),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.save),
                  onPressed: () {
                    _saveUser(context, user);
                    // Navigate to the Saved Users tab
                    DefaultTabController.of(context).animateTo(1);
                  },
                ),
                onTap:(){
                  Navigator.push(context,MaterialPageRoute(builder:(context)=>ProfilePage(user: user)));
                },
              );
            },
          );
        }
      },
    );
  }

  Widget _buildSavedUsersTab(BuildContext context) {
  return FutureBuilder<List<UserModel>>(
    future: _getSavedUsers(context),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        return Text('Error: ${snapshot.error}');
      } else {
        List<UserModel> savedUsers = snapshot.data ?? [];
        return savedUsers.isEmpty
            ?const Center(
                child: Text('No saved users.'),
              )
            : ListView.builder(
                itemCount: savedUsers.length,
                itemBuilder: (context, index) {
                  UserModel user = savedUsers[index];
                  return ListTile(
                    title: Text('${user.firstName} ${user.lastName}'),
                    subtitle: Text('${user.email}'),
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                        user.avatar.toString(),
                      ),
                    ),
                  );
                },
              );
      }
    },
  );
}

  Future<List<UserModel>> _getSavedUsers(BuildContext context) async {
    final container = ProviderContainer();
    final allUsers = await container.read(UserController.future);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedUsers = prefs.getStringList('saved_users');

    if (savedUsers != null) {
      List<UserModel> savedUsersList = [];

      for (UserModel user in allUsers) {
        if (savedUsers.contains(user.toJson().toString())) {
          savedUsersList.add(user);
        }
      }

      return savedUsersList;
    } else {
      return [];
    }
  }

  Future<void> _saveUser(BuildContext context, UserModel user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedUsers = prefs.getStringList('saved_users') ?? [];

    // Check if the user is already saved
    if (!savedUsers.contains(user.toJson().toString())) {
      savedUsers.add(user.toJson().toString());
      await prefs.setStringList('saved_users', savedUsers);
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${user.firstName} ${user.lastName} saved.'),
        ),
      );
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${user.firstName} ${user.lastName} is already saved.'),
        ),
      );
    }
  }
}
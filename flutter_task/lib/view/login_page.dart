import 'package:flutter/material.dart';
import 'package:flutter_task/service/login_service.dart';
import 'package:flutter_task/view/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  LoginService loginService = LoginService();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title:const Text('SignIn Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                hintText: 'Email',
              ),
            ),
            SizedBox(height: 20,),
            TextFormField(
              obscureText: true,
              controller: passwordController,
              decoration: InputDecoration( 
                hintText: 'Password',
              ),
            ),
            SizedBox(height: 40,),
            ElevatedButton(
              onPressed: () async {
                // Call the login function and wait for its result
                bool success = await loginService.login(
                  emailController.text.toString(),
                  passwordController.text.toString(),
                );

                if (success) {
                  // Navigate to HomePage on successful login
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()),
                  );
                } else {
                  // Handle unsuccessful login
                  // For example, show an error message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Login failed. Please check your credentials.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(child: Text('Login')),
              ),
            )
          ],
        ),
      ),
    );
  }
}

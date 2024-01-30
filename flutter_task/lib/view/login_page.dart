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
        title: const Text('Sign In Page'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 100),
              _buildHeaderImage(),
              SizedBox(height: 20),
              _buildTextField("Email", Icons.email, emailController),
              SizedBox(height: 20),
              _buildTextField("Password", Icons.lock, passwordController, isPassword: true),
              SizedBox(height: 40),
              _buildLoginButton(),
              SizedBox(height: 100), // A little extra space at the bottom
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderImage() {
    return Image.asset(
      'assets/reqres.png',
      height: 150,
      width: 150,
      fit: BoxFit.contain,
    );
  }

  Widget _buildTextField(String hintText, IconData icon, TextEditingController controller, {bool isPassword = false}) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: hintText,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return ElevatedButton(
      onPressed: () async {
        bool success = await loginService.login(
          emailController.text.toString(),
          passwordController.text.toString(),
        );

        if (success) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Login failed. Please check your credentials.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      style: ElevatedButton.styleFrom(
        primary: Colors.orange,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Text(
          'Login',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

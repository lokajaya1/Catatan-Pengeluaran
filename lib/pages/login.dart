import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/bottom.dart';
import 'package:flutter_application_1/components/app_button.dart';
import 'package:flutter_application_1/components/app_text_field.dart';
import 'package:get_storage/get_storage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void login() {
    String username = usernameController.text;
    String password = passwordController.text;

    if (username != 'admin' || password != 'admin') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Username atau Password Salah"),
        ),
      );
      return;
    }
    final box = GetStorage();
    box.write('username', usernameController.text);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (builder) => Bottom()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Catatan Pengeluaran",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                "Silahkan Login",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              AppTextField(
                label: "Username",
                controller: usernameController,
                textColor: Colors.black,
                labelColor: Colors.grey,
                borderColor: Colors.grey,
              ),
              const SizedBox(height: 16),
              AppTextField(
                label: "Password",
                controller: passwordController,
                textColor: Colors.black,
                labelColor: Colors.grey,
                borderColor: Colors.grey,
                obscureText: true,
              ),
              const SizedBox(height: 40),
              AppButton(
                text: "Login",
                color: Colors.blue,
                onPressed: () {
                  login();
                },
                textColor: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

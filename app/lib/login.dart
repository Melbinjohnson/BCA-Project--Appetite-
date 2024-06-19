import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:apettite/user_home.dart';
import 'package:apettite/user_register.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const Login());
}

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController uname = TextEditingController();
  TextEditingController pwd = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> loginUser() async {
    try {
      final sh = await SharedPreferences.getInstance();
      String unames = uname.text.toString();
      String pwds = pwd.text.toString();
      String url = sh.getString("url").toString();

      var response = await http.post(
        Uri.parse('$url/api/login'),
        body: {
          'username': unames,
          'password': pwds,
        },
      );

      var jsonData = json.decode(response.body);
      String userType = jsonData['usertype'].toString();

      if (userType == "user") {
        String lid = jsonData['login_id'].toString();
        sh.setString("lid", lid);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => UserHome()),
        );
      } else {
        // Handle login failure, show error message or take appropriate action
        print("Login failed");
      }
    } catch (e) {
      // Handle other errors that may occur during the HTTP request
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/ip.png',
                    height: 250,
                    width: 250,
                    fit: BoxFit.cover,
                  ),
                  const Text(
                    "LOGIN",
                    style: TextStyle(
                      fontSize: 36,
                      color: Color(0xC50E3760),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFF1F1F1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 15,
                      ),
                      child: TextFormField(
                        controller: uname,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your username';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Username',
                          prefixIcon: Icon(Icons.person),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFF1F1F1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 15,
                      ),
                      child: TextFormField(
                        controller: pwd,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                        obscureText: true,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Password',
                          prefixIcon: Icon(Icons.lock),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: MaterialButton(
                          color: Color(0xC50E3760),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState?.validate() ?? false) {
                              await loginUser();
                            }
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(15.0),
                            child: Text(
                              "LOGIN",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 50),
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have an account?"),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => user_register()),
                            );
                          },
                          child: const Text(
                            "Register",
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

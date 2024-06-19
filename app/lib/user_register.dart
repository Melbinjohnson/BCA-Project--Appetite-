import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:apettite/login.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


void main() {
  runApp(user_register());
}

class user_register extends StatefulWidget {
  const user_register({super.key});

  @override
  State<user_register> createState() => _user_registerState();
}

class _user_registerState extends State<user_register> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: user_register_screen(),
    );
  }
}

class user_register_screen extends StatefulWidget {
  @override
  State<user_register_screen> createState() => _user_register_screenState();
}

class _user_register_screenState extends State<user_register_screen> {
  TextEditingController fn = TextEditingController();
  TextEditingController ln = TextEditingController();
  TextEditingController place = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController uname = TextEditingController();
  TextEditingController pwd = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Expanded(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/ip.png',
                        width: 200,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ],
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'SIGN UP',
                    style: TextStyle(
                      fontSize: 35,
                      color: const Color(0xC50E3760),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 5),
                  TextFormField(
                    controller: fn,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your firstname';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Firstname',
                      prefixIcon: Icon(Icons.person),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 1.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red), // Outline color for the focused state
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  TextFormField(
                    controller: ln,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your lastname';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Lastname',
                      prefixIcon: Icon(Icons.person),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 1.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red), // Outline color for the focused state
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),


                  TextFormField(
                    controller: phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      // Check if the entered value is a valid 10-digit phone number
                      if (value.length != 10 || !RegExp(r'^[0-9]+$').hasMatch(value)) {
                        return 'Please enter a valid 10-digit phone number';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Phone',
                      prefixIcon: Icon(Icons.phone),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 1.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red), // Outline color for the focused state
                      ),
                    ),
                  ),

                  const SizedBox(height: 5),
                  TextFormField(
                    controller: email,
                    validator: (value) {
                      if (value == null || value.isEmpty || !value.contains('@')) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Email',
                      prefixIcon: Icon(Icons.email),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 1.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red), // Outline color for the focused state
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),

                  TextFormField(
                    controller: place,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your place';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Place',
                      prefixIcon: Icon(Icons.place_outlined),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 1.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red), // Outline color for the focused state
                      ),
                    ),
                  ),

                  const SizedBox(height: 5),
                  TextFormField(
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
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 1.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red), // Outline color for the focused state
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  TextFormField(
                    controller: pwd,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Password',
                      prefixIcon: Icon(Icons.lock),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 1.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red), // Outline color for the focused state
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: MaterialButton(
                          color: const Color(0xC50E3760),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState?.validate() ?? false) {
                              final sh = await SharedPreferences.getInstance();
                              String fns = fn.text.toString();
                              String lns = ln.text.toString();
                              String places = place.text.toString();
                              String phones = phone.text.toString();
                              String unames = uname.text.toString();
                              String pwds = pwd.text.toString();
                              String emails = email.text.toString();
                              String url = sh.getString("url").toString();

                              var data = await http.post(Uri.parse(url + "/api/user_register"),
                                body: {
                                  'fn': fns,
                                  'ln': lns,
                                  'place': places,
                                  'place': places,
                                  'phone': phones,
                                  'username': unames,
                                  'password': pwds,
                                  'email': emails,
                                },
                              );
                              var jasondata = json.decode(data.body);
                              String status = jasondata['status'].toString();
                              if (status == "success") {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => Login()));
                              } else {
                                print("error");
                              }
                            }
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                              "REGISTER",
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'dart:convert';
import 'package:apettite/user_home.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class UserDetailsForFoodProvide extends StatefulWidget {
  final String request_id;

  const UserDetailsForFoodProvide({Key? key, required this.request_id}) : super(key: key);

  @override
  State<UserDetailsForFoodProvide> createState() => _UserDetailsForFoodProvideState();
}

class _UserDetailsForFoodProvideState extends State<UserDetailsForFoodProvide> {
  final TextEditingController place = TextEditingController();
  final TextEditingController foods = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ProvideScreen(request_id: widget.request_id),
    );
  }
}

class ProvideScreen extends StatefulWidget {
  final String request_id;

  const ProvideScreen({Key? key, required this.request_id}) : super(key: key);

  @override
  State<ProvideScreen> createState() => _ProvideScreenState();
}

class _ProvideScreenState extends State<ProvideScreen> {
  final TextEditingController place = TextEditingController();
  final TextEditingController foods = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/ip.png',
              height: 200,
              width: 200,
              fit: BoxFit.cover,
            ),
            const Text(
              "PROVIDE FOOD",
              style: TextStyle(
                fontSize: 36,
                color: Color(0xC50E3760),
                fontWeight: FontWeight.w700,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF1F1F1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 15,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: place,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your Place';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Drop Your Place',
                          prefixIcon: Icon(Icons.place), // Place icon
                        ),
                      ),
                      TextFormField(
                        controller: foods,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the Number of Foods';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Drop the Number of Foods',
                          prefixIcon: Icon(Icons.foggy), // Foods icon
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
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
                        String places = place.text.toString();
                        String food = foods.text.toString();
                        // Get your API URL from SharedPreferences or any other source
                        String url = sh.getString("url").toString();
                        // Get other necessary data from SharedPreferences
                        String lids = sh.getString("lid").toString();

                        var data = await http.post(
                          Uri.parse(url + "/api/user_provide_food"),
                          body: {
                            'places': places,
                            'foods': food,
                            'lid': lids,
                            'request_id': widget.request_id
                          },
                        );
                        var jsonData = json.decode(data.body);
                        String status = jsonData['status'].toString();
                        if (status == "success") {
                          // Navigate to UserDetailsForFoodProvide if needed
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UserHome(),
                            ),
                          );
                        } else {
                          print("error");
                        }
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        "send",
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
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     print('Floating Action Button Pressed');
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //         builder: (context) => ViewComplaints(),
      //       ),
      //     );
      //   },
      //   child: const Icon(Icons.messenger),
      //   backgroundColor: const Color(0xFF7C49CE),
      // ),
    );
  }
}

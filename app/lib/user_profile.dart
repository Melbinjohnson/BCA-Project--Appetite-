import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: UserProfilePage(),
    );
  }
}

class UserProfilePage extends StatefulWidget {
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
  // TextEditingController fn = TextEditingController();
  // TextEditingController ln = TextEditingController();
  // TextEditingController place = TextEditingController();
  // TextEditingController email = TextEditingController();
  // TextEditingController phone = TextEditingController();
  // TextEditingController uname = TextEditingController();
  // TextEditingController pwd = TextEditingController();
}

class _UserProfilePageState extends State<UserProfilePage> {
  TextEditingController fnameController = TextEditingController();
  TextEditingController lnameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController placeController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Call your method to fetch user profile data here
    // For simplicity, I'm using some sample data
    loadMessages();
  }

  Future<void> loadMessages() async {
    try {
      final pref = await SharedPreferences.getInstance();
      String ip = pref.getString("url") ?? "";
      String categoryUrl = ip + "/api/userviewprofile";
      String lid = pref.getString("lid").toString();
      print(lid);

      var data = await http.post(Uri.parse(categoryUrl), body: {'lids': lid});
      // var data = await http.get(Uri.parse(categoryUrl), headers: {'lids': lid});
      var jsonData = json.decode(data.body);
      String status = jsonData['status'];

      if (status == "ok") {
        setState(() {
          var messageData = List<Map<String, dynamic>>.from(jsonData['data']);
          fnameController.text = messageData[0]['fname'] ?? 'Unknown';
          lnameController.text = messageData[0]['lname'];
          phoneController.text = messageData[0]['phone'];
          placeController.text = messageData[0]['place'];
          emailController.text = messageData[0]['email'];
        });
      } else {
        // Handle error status if needed
      }
    } catch (e) {
      print("Error loading messages: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Profile"),
        backgroundColor:Color(0xC50E3760),

      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Card(
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "MY PROFILE",
                      style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xC50E3760),
                        shadows: [
                          Shadow(
                            color: Color(0xFF00AE9D8C),
                            offset: Offset(3, 3),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.0),
                    buildTextField("Firstname", fnameController, Icons.person),
                    buildTextField("Lastname", lnameController, Icons.person),
                    buildTextField("Phone", phoneController, Icons.call),
                    buildTextField("Place", placeController, Icons.place),
                    buildTextField("Email", emailController, Icons.email),
                    ElevatedButton(
                      onPressed: () async {
                          final sh = await SharedPreferences.getInstance();
                          String fns = fnameController.text.toString();
                          String lns = lnameController.text.toString();
                          String places = phoneController.text.toString();
                          String phones = placeController.text.toString();
                          String emails = emailController.text.toString();
                          String url = sh.getString("url").toString();
                          String lids = sh.getString("lid").toString();
                          var data = await http.post(Uri.parse(url + "/api/user_update_profile"),
                            body: {
                              'fn': fns,
                              'ln': lns,
                              'place': places,
                              'place': places,
                              'phone': phones,
                              'email': emails,
                              'lid': lids,
                            },
                          );
                          var jasondata = json.decode(data.body);
                          String status = jasondata['status'].toString();
                          if (status == "success") {
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => UserProfilePage()));
                          } else {
                            print("error");
                          }

                      }, child: Text("update"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  Widget buildTextField(String hintText, TextEditingController controller, IconData icon) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
    );
  }


}







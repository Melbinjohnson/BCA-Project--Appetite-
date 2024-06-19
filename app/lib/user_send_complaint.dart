import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:apettite/user_view_complaints.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const user_send_complaint());
}

class user_send_complaint extends StatefulWidget {
  const user_send_complaint({Key? key}) : super(key: key);

  @override
  State<user_send_complaint> createState() => _user_send_complaintState();
}

class _user_send_complaintState extends State<user_send_complaint> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: complaint_screen(),
    );
  }
}

class complaint_screen extends StatefulWidget {
  const complaint_screen({Key? key}) : super(key: key);

  @override
  State<complaint_screen> createState() => _complaint_screenState();
}

class _complaint_screenState extends State<complaint_screen> {
  TextEditingController complaint = TextEditingController();
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
              "SEND COMPLAINT",
              style: TextStyle(
                fontSize: 36,
                color: const Color(0xC50E3760),
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
                  child: TextFormField(
                    controller: complaint,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your Complaint';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Drop Your Complaint',
                      prefixIcon:
                      Icon(Icons.messenger_outline), // Password icon
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
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
                        String complaints = complaint.text.toString();
                        String url = sh.getString("url").toString();
                        String lids = sh.getString("lid").toString();

                        var data = await http.post(
                          Uri.parse(url + "/api/user_send_complaint"),
                          body: {
                            'complaint': complaints,
                            'lid': lids,
                          },
                        );
                        var jasondata = json.decode(data.body);
                        String status = jasondata['status'].toString();
                        if (status == "success") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => user_send_complaint(),
                            ),
                          );
                        } else {
                          print("error");
                        }
                      }
                    },
                    child: const Padding(
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your FAB functionality here
          print('Floating Action Button Pressed');
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ViewComplaints(),
            ),
          );
        },
        child: const Icon(Icons.messenger),
        backgroundColor: const Color(0xC50E3760),
      ),
    );
  }
}

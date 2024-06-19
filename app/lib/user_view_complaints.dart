import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:apettite/main.dart';
import 'package:apettite/user_home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


class ViewComplaints extends StatefulWidget {
  @override
  _ViewComplaintsState createState() => _ViewComplaintsState();
}

class _ViewComplaintsState extends State<ViewComplaints> {
  List<Map<String, dynamic>> messageData = [];

  _ViewComplaintsState() {
    loadMessages();
  }

  Future<void> loadMessages() async {
    try {
      final pref = await SharedPreferences.getInstance();
      String ip = pref.getString("url") ?? "";
      String categoryUrl = ip + "/api/user_view_complaints";
      String lid = pref.getString("lid").toString();

      var data = await http.post(Uri.parse(categoryUrl), body: {'lids': lid});

      var jsonData = json.decode(data.body);
      String status = jsonData['status'];

      if (status == "ok") {
        setState(() {
          messageData = List<Map<String, dynamic>>.from(jsonData['data']);
        });
      } else {
        // Handle error status if needed
      }
    } catch (e) {
      print("Error loading messages: $e");
      // Handle any errors that occur during the HTTP request.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("View Complaints"),
        backgroundColor: Color(0xC50E3760),
      ),
        body: Container(

        // color:  Color(0xFFBCA0E5), // Set your desired background color here for the body


        child: WillPopScope(
    child: SafeArea(
          child: Stack(
            children: [
              // Inside the ListView.builder
              ListView.builder(
                itemCount: messageData.length,
                itemBuilder: (BuildContext context, int index) {
                  final desc = messageData[index]['complaint'] ?? 'Unknown';
                  final reply = messageData[index]['reply'];
                  final date = messageData[index]['date'];
                  return GestureDetector(
                    onTap: () {
                      // _showDetailsPopup(index);
                    },
                    child: Card(
                      elevation: 2.0,
                      margin: EdgeInsets.symmetric(vertical: 8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Complaints: $desc",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              "Reply :$reply",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              "Date :$date",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        onWillPop: () async {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => UserHome()),
          );
          return true;
        },
      ),
        ),
    );
  }
}

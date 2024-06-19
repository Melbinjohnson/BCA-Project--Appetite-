import 'package:flutter/material.dart';
import 'package:apettite/user_home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class user_view_food extends StatefulWidget {
  @override
  _user_view_foodState createState() => _user_view_foodState();
}

class _user_view_foodState extends State<user_view_food> {
  List<Map<String, dynamic>> messageData = [];

  _user_view_foodState() {
    loadMessages();
  }

  Future<void> loadMessages() async {
    try {
      final pref = await SharedPreferences.getInstance();
      String lid = pref.getString("lid").toString();

      String ip = pref.getString("url") ?? "";
      String categoryUrl = ip + "/api/user_view_food";

      var data = await http.post(Uri.parse(categoryUrl), body: {'lid':lid});

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
        title: Text("View Food "),
        backgroundColor: Color(0xC50E3760),
      ),
      body: Container(
        child: WillPopScope(
          child: SafeArea(
            child: Stack(
              children: [
                ListView.builder(
                  itemCount: messageData.length,
                  itemBuilder: (BuildContext context, int index) {
                    final rname = messageData[index]['rname'] ?? 'Unknown';
                    final Food = messageData[index]['food'] ?? '';
                    final Details = messageData[index]['details'];
                    final Quantity = messageData[index]['quantity'];
                    final Date = messageData[index]['rdate'];
                    final Status = messageData[index]['rstatus'];
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
                                "Food: $Food",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                "Food: $Food",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                "Details :$Details",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                "Quantity :$Quantity",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                "Date :$Date",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                "Status :$Status",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 16),
                              ElevatedButton.icon(
                                onPressed: () async {
                                  // Accept logic
                                  final sh = await SharedPreferences.getInstance();
                                  String url = sh.getString("url").toString();
                                  String lids = sh.getString("lid").toString();

                                  var data = await http.post(
                                    Uri.parse(url + "/api/user_make_request"),
                                    body: {
                                      'fooddetails_id': messageData[index]['fooddetails_id'].toString(),
                                      'quantity': messageData[index]['quantity'].toString(),
                                      'lid': lids,
                                    },
                                  );
                                  var jasondata = json.decode(data.body);
                                  String status = jasondata['status'].toString();
                                  if (status == "success") {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => user_view_food(),
                                      ),
                                    );
                                  } else {
                                    print("error");
                                  }                                      // Reject logic
                                  print("Reject pressed");
                                },
                                icon: Icon(Icons.request_quote_sharp),
                                label: Text("Send Request"),
                              ),
                              // Add an icon button and handle its tap
                              // IconButton(
                              //   icon: Column(
                              //     children: [
                              //       Icon(
                              //
                              //         Icons.app_registration_sharp,
                              //         size: 36, // Adjust the size as needed
                              //       ),
                              //       Text(
                              //         "Make Appointment",
                              //         style: TextStyle(
                              //           fontSize: 12,
                              //         ),
                              //       ),
                              //     ],
                              //   ),
                              //   onPressed: () {
                              //     // Handle button tap
                              //     Navigator.push(
                              //       context,
                              //       MaterialPageRoute(builder: (context) => UserHome()),
                              //     );
                              //   },
                              // ),
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
                context, MaterialPageRoute(builder: (context) => UserHome()));
            return true;
          },
        ),
      ),
    );
  }
}

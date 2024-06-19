import 'package:flutter/material.dart';
import 'package:apettite/user_home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class my_food_request extends StatefulWidget {
  @override
  _my_food_requestState createState() => _my_food_requestState();
}

class _my_food_requestState extends State<my_food_request> {
  List<Map<String, dynamic>> messageData = [];
  String baseUrl = ''; // Set your server's base URL here

  _my_food_requestState() {
    loadMessages();
  }

  Future<void> loadMessages() async {
    try {
      final pref = await SharedPreferences.getInstance();
      String ip = pref.getString("url") ?? "";
      String categoryUrl = ip + "/api/my_food_request";
      baseUrl = ip; // Update the baseUrl with the IP address dynamically
      String lid = pref.getString("lid").toString();

      var data = await http.post(Uri.parse(categoryUrl), body: {
        'lid': lid,
      });

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
        title: Text("View My Request"),
        backgroundColor: Color(0xC50E3760),
      ),
      body: WillPopScope(
        child: SafeArea(
          child: Stack(
            children: [
              ListView.builder(
                itemCount: messageData.length,
                itemBuilder: (BuildContext context, int index) {
                  final food = messageData[index]['food'] ?? 'Unknown';
                  final type = messageData[index]['type'] ?? '';
                  final quantity = messageData[index]['quantity'] ?? '';
                  final date = messageData[index]['date'] ?? '';
                  final status = messageData[index]['rstatus'] ?? '';
                  // final filePath = messageData[index]['uploadfile'];
                  //
                  // String imageUrl = baseUrl + "/" + messageData[index]["uploadfile"];

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
                              "food :$food",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              "type :$type",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              "quantity :$quantity",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              "Date :$date",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              "Status :$status",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            // CircleAvatar(
                            //   radius: 60,
                            //   backgroundImage: NetworkImage(imageUrl),
                            // ),
                            if (messageData[index]['rstatus'].toString() == "pending")

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton.icon(
                                    onPressed: () async {
                                      // Accept logic
                                      final sh = await SharedPreferences.getInstance();
                                      String url = sh.getString("url").toString();
                                      String lids = sh.getString("lid").toString();

                                      var data = await http.post(
                                        Uri.parse(url + "/api/user_accpet"),
                                        body: {
                                          'request_id': messageData[index]['request_id'].toString(),
                                          'lid': lids,
                                        },
                                      );
                                      var jasondata = json.decode(data.body);
                                      String status = jasondata['status'].toString();
                                      if (status == "success") {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => my_food_request(),
                                          ),
                                        );
                                      } else {
                                        print("error");
                                      }
                                      print("Accept pressed");
                                    },
                                    icon: Icon(Icons.check),
                                    label: Text("Accept"),
                                  ),
                                  ElevatedButton.icon(
                                    onPressed: () async {
                                      // Accept logic
                                      final sh = await SharedPreferences.getInstance();
                                      String url = sh.getString("url").toString();
                                      String lids = sh.getString("lid").toString();

                                      var data = await http.post(
                                        Uri.parse(url + "/api/user_reject"),
                                        body: {
                                          'request_id': messageData[index]['request_id'].toString(),
                                          'lid': lids,
                                        },
                                      );
                                      var jasondata = json.decode(data.body);
                                      String status = jasondata['status'].toString();
                                      if (status == "success") {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => my_food_request(),
                                          ),
                                        );
                                      } else {
                                        print("error");
                                      }                                      // Reject logic
                                      print("Reject pressed");
                                    },
                                    icon: Icon(Icons.close),
                                    label: Text("Reject"),
                                  ),
                                ],
                              ),
                            if (messageData[index]['rstatus'].toString() == "accept")

                              ElevatedButton.icon(
                                onPressed: () async {
                                  // Accept logic
                                  final sh = await SharedPreferences.getInstance();
                                  String url = sh.getString("url").toString();
                                  String lids = sh.getString("lid").toString();

                                  var data = await http.post(
                                    Uri.parse(url + "/api/user_dispatch"),
                                    body: {
                                      'request_id': messageData[index]['request_id'].toString(),
                                      'lid': lids,
                                    },
                                  );
                                  var jasondata = json.decode(data.body);
                                  String status = jasondata['status'].toString();
                                  if (status == "success") {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => my_food_request(),
                                      ),
                                    );
                                  } else {
                                    print("error");
                                  }                                      // Reject logic
                                  print("dispatch pressed");
                                },
                                icon: Icon(Icons.send_time_extension),
                                label: Text("dispatch"),
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
              context, MaterialPageRoute(builder: (context) => UserHome()));
          return true;
        },
      ),
    );
  }
}

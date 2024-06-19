import 'package:apettite/user_details_for_food_provide.dart';
import 'package:flutter/material.dart';
import 'package:apettite/user_home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class user_view_request extends StatefulWidget {
  @override
  _user_view_requestState createState() => _user_view_requestState();
}

class _user_view_requestState extends State<user_view_request> {
  List<Map<String, dynamic>> messageData = [];

  _user_view_requestState() {
    loadMessages();
  }

  Future<void> loadMessages() async {
    try {
      final pref = await SharedPreferences.getInstance();
      String ip = pref.getString("url") ?? "";
      String categoryUrl = ip + "/api/user_view_request";
      String lid = pref.getString("lid").toString();

      var data = await http.post(Uri.parse(categoryUrl), body: {
        'lid':lid,
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

  void _showAdvocateDetailsDialog(Map<String, dynamic> advocateData) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Request Details"),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Food: ${advocateData['food'] ?? 'Unknown'}"),
              Text("Type: ${advocateData['type'] ?? 'Unknown'}"),
              Text("Quantity: ${advocateData['quantity'] ?? 'Unknown'}"),
              Text("Date: ${advocateData['date'] ?? 'Unknown'}"),
              Text("Status: ${advocateData['rstatus'] ?? 'Unknown'}"),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserDetailsForFoodProvide(request_id:advocateData['request_id'].toString()),
                        ),
                      );


                      // _makePhoneCall(advocateData['phone'].toString());
                    },
                    icon: Icon(Icons.add_circle),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Close"),
            ),
          ],
        );
      },
    );
  }
  //
  // void _makePhoneCall(String phoneNumber) async {
  //   if (phoneNumber != null && phoneNumber.isNotEmpty) {
  //     String url = 'tel:$phoneNumber';
  //     print(phoneNumber);
  //     print(url);
  //     try {
  //       await launch(url);
  //     } catch (e) {
  //       // Handle the exception
  //       print('Could not launch $url: $e');
  //     }
  //   } else {
  //     // Handle null or empty phone number
  //     print('Invalid phone number');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Requests"),
        backgroundColor: Color(0xC50E3760),
      ),
      body: Container(
        color: Color(0xFFFFFFFF),
        child: WillPopScope(
          child: SafeArea(
            child: Stack(
              children: [
                ListView.builder(
                  itemCount: messageData.length,
                  itemBuilder: (BuildContext context, int index) {
                    final advocateData = messageData[index];
                    return GestureDetector(
                      onTap: () {
                        _showAdvocateDetailsDialog(advocateData);
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
                                "Food: ${advocateData['food'] ?? 'Unknown'}",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                "Quantity: ${advocateData['quantity'] ?? 'Unknown'}",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                "Date: ${advocateData['date'] ?? 'Unknown'}",
                              ),
                              SizedBox(height: 8),
                              Text(
                                "Status: ${advocateData['rstatus'] ?? 'Unknown'}",
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



































// import 'package:flutter/material.dart';
// import 'package:health_care/user_home.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
//
// import 'package:url_launcher/url_launcher.dart';
//
// class view_advocates extends StatefulWidget {
//   @override
//   _view_advocatesState createState() => _view_advocatesState();
// }
//
// class _view_advocatesState extends State<view_advocates> {
//   List<Map<String, dynamic>> messageData = [];
//
//   _view_advocatesState() {
//     loadMessages();
//   }
//
//   Future<void> loadMessages() async {
//     try {
//       final pref = await SharedPreferences.getInstance();
//       // String lid = pref.getString("lid").toString();
//
//       String ip = pref.getString("url") ?? "";
//       String categoryUrl = ip + "/api/user_view_appointment";
//
//       var data = await http.post(Uri.parse(categoryUrl), body: {});
//
//       var jsonData = json.decode(data.body);
//       String status = jsonData['status'];
//
//       if (status == "ok") {
//         setState(() {
//           messageData = List<Map<String, dynamic>>.from(jsonData['data']);
//         });
//       } else {
//         // Handle error status if needed
//       }
//     } catch (e) {
//       print("Error loading messages: $e");
//       // Handle any errors that occur during the HTTP request.
//     }
//   }
//
//   void _showAdvocateDetailsDialog(Map<String, dynamic> advocateData) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text("Appointment Details"),
//           content: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text("Doctor Name: ${advocateData['dr_name'] ?? 'Unknown'}"),
//               Text("Phone: ${advocateData['phone'] ?? 'Unknown'}"),
//               Text("Email: ${advocateData['email'] ?? 'Unknown'}"),
//
//               Text("Date: ${advocateData['date'] ?? 'Unknown'}"),
//               Text("status: ${advocateData['status'] ?? 'Unknown'}"),
//               SizedBox(height: 16),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//
//                   IconButton(
//                     onPressed: () {
//                       _makePhoneCall(advocateData['phone'].toString());
//                     },
//                     icon: Icon(Icons.phone),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text("Close"),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   void _makePhoneCall(String phoneNumber) async {
//     if (phoneNumber != null && phoneNumber.isNotEmpty) {
//       String url = 'tel:$phoneNumber';
//       print(phoneNumber);
//       print(url);
//       try {
//         await launch(url);
//       } catch (e) {
//         // Handle the exception
//         print('Could not launch $url: $e');
//       }
//     } else {
//       // Handle null or empty phone number
//       print('Invalid phone number');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Appointments"),
//         backgroundColor: Color(0xFFBCA0E5),
//       ),
//       body: Container(
//         color: Color(0xFFBCA0E5),
//         child: WillPopScope(
//           child: SafeArea(
//             child: Stack(
//               children: [
//                 ListView.builder(
//                   itemCount: messageData.length,
//                   itemBuilder: (BuildContext context, int index) {
//                     final advocateData = messageData[index];
//                     return GestureDetector(
//                       onTap: () {
//                         _showAdvocateDetailsDialog(advocateData);
//                       },
//                       child: Card(
//                         elevation: 2.0,
//                         margin: EdgeInsets.symmetric(vertical: 8.0),
//                         child: Padding(
//                           padding: const EdgeInsets.all(16.0),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 "Doctor: ${advocateData['dr_name'] ?? 'Unknown'}",
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 16,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ],
//             ),
//           ),
//           onWillPop: () async {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => UserHome()),
//             );
//             return true;
//           },
//         ),
//       ),
//     );
//   }
// }

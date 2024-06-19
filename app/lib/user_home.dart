// import 'package:aambulance_tracking/drawer2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'drawer.dart';
import 'login.dart';

class UserHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("APETTITE"),
      ),
      drawer: Drawerclass(),
      body: WillPopScope(
        child: SafeArea(
          child: Container(

           child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Welcome user ,',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
                Text(
                      'Donate a variety of non-perishable items spanning all food groups, including canned vegetables, fruits, whole grains, lean proteins, and healthy snacks. Avoid overly sugary or unhealthy options, and consider any special dietary needs. Prioritize nutrient-dense foods that are easy to prepare, and consult local organizations for specific preferences or requirements.',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.black,
                  ),
                ),
                // Your image goes here
                Container(
                  width: 350,
                  height: 350,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/ip.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 1), // Add some space between image and text
                // Your text goes here

              ],
            ),
          ),
        ),
        onWillPop: () async {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Login()));
          return true;
        },

      ),
    );
  }
}


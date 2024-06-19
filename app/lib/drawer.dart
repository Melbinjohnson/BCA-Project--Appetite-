import 'package:apettite/my_food_details.dart';
import 'package:apettite/my_food_request.dart';
import 'package:apettite/user_profile.dart';
import 'package:apettite/user_send_complaint.dart';
import 'package:apettite/user_view_food.dart';
import 'package:apettite/user_view_request.dart';
import 'package:flutter/material.dart';
import 'package:apettite/login.dart';
import 'package:apettite/user_home.dart';
// import 'package:untitled2/user_manage_cases.dart';
// import 'package:untitled2/user_ongoing_cases.dart';
// import 'package:untitled2/user_send_complaint.dart';
// import 'package:untitled2/user_view_advocates.dart';
// import 'package:untitled2/user_view_law_details.dart';



class Drawerclass extends StatelessWidget {
  const Drawerclass({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xC50E3760),
            ),
            child: Text(
              "APETTITE",
              style: TextStyle(color: Colors.black, fontSize: 24),
            ),
          ),
          // ListTile(
          //   leading: IconButton(
          //       onPressed: () {},
          //       icon: const Icon(
          //         Icons.email,
          //         size: 30,
          //       )),
          //   title: const Text(
          //     "View Messages",
          //     style: TextStyle(fontSize: 20),
          //   ),
          //   onTap: () {
          //     Navigator.push(context,
          //         MaterialPageRoute(builder: (context) => FirstPage()));
          //   },
          // ),
          ListTile(
              leading: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.person,
                    size: 30,
                  )),
              title: const Text(
                "PROFILE",
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => UserProfilePage()));
              }
          ),

          ListTile(
              leading: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.fastfood_sharp,
                    size: 30,
                  )),
              title: const Text(
                "View Food Details",
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => user_view_food()));
              }
          ),
          ListTile(
              leading: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.comment_outlined,
                    size: 30,
                  )),
              title: const Text(
                "Complaints",
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => user_send_complaint()));
              }
          ),
          ListTile(
              leading: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.call_missed_outgoing_outlined,
                    size: 30,
                  )),
              title: const Text(
                "View Request",
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => user_view_request()));
              }
          ),

          ListTile(
              leading: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.foggy,
                    size: 30,
                  )),
              title: const Text(
                "my food",
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => my_food_details()));
              }
          ),



          ListTile(
            leading: IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.food_bank,
                  size: 30,
                )),
            title: const Text(
              "view my food",
              style: TextStyle(fontSize: 20),
            ),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => my_food_request()));
            },
          ),

          ListTile(
            leading: IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.logout,
                  size: 30,
                )),
            title: const Text(
              "Logout",
              style: TextStyle(fontSize: 20),
            ),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Login()));
            },
          ),

        ],
      ),
    );
  }
}
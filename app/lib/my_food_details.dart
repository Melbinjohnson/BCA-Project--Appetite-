import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const my_food_details());
}

class my_food_details extends StatefulWidget {
  const my_food_details({Key? key}) : super(key: key);

  @override
  State<my_food_details> createState() => _my_food_detailsState();
}

class _my_food_detailsState extends State<my_food_details> {
  final TextEditingController det = TextEditingController();
  final TextEditingController food = TextEditingController();
  final TextEditingController qty = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ProvideScreen(),
    );
  }
}

class ProvideScreen extends StatefulWidget {
  const ProvideScreen({Key? key}) : super(key: key);

  @override
  State<ProvideScreen> createState() => _ProvideScreenState();
}

class _ProvideScreenState extends State<ProvideScreen> {
  final TextEditingController det = TextEditingController();
  final TextEditingController food = TextEditingController();
  final TextEditingController qty = TextEditingController();
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
              "ADD FOOD TO SHARE",
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
                        controller: food,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your food';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Drop Your food',
                          prefixIcon: Icon(Icons.foggy), // Place icon
                        ),
                      ),
                      TextFormField(
                        controller: det,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter details';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Drop the details',
                          prefixIcon: Icon(Icons.details), // Foods icon
                        ),
                      ),
                      TextFormField(
                        controller: qty,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Quantity';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Drop the Quantity',
                          prefixIcon: Icon(Icons.confirmation_num_outlined), // Foods icon
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
                        String foods = food.text.toString();
                        String dets = det.text.toString();
                        String qtys = qty.text.toString();
                        String url = sh.getString("url").toString();
                        String lids = sh.getString("lid").toString();

                        var data = await http.post(
                          Uri.parse(url + "/api/my_food"),
                          body: {
                            'qtys': qtys,
                            'dets': dets,
                            'foods': foods,
                            'lid': lids,
                          },
                        );
                        var jsonData = json.decode(data.body);
                        String status = jsonData['status'].toString();
                        if (status == "success") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => my_food_details(),
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

import 'package:flutter/material.dart';
import 'package:apettite/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController ip = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                "APETTITE",
                style: TextStyle(
                  fontSize: 36,
                  color: Color(0xC50E3760),
                  fontWeight: FontWeight.w700,
                ),
              ),
              Image.asset(
                'assets/ip.png',
                height: 250,
                width: 250,
                fit: BoxFit.cover,
              ),
              TextFormField(
                controller: ip,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an IP address';
                  }
                  // Add custom IP address validation logic if needed
                  return null;
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Drop Your IP",
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red), // Outline color for the focused state
                  ),
                ),

              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    String ips = ip.text.toString();
                    final sh = await SharedPreferences.getInstance();
                    sh.setString("url", "http://" + ips);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Login()),
                    );
                  }
                },
                child: Text("GET STARTED"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

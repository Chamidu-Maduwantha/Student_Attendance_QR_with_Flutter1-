import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _database = FirebaseDatabase.instance.reference();
  User? user;
  bool detailsFilled = false; // A flag to check if details have been filled
  String studentName = '';

  Future<void> _signOut() async {
    await _auth.signOut();
  }

  Future<void> _checkDetails() async {
    user = _auth.currentUser;
    if (user != null) {
      DatabaseReference studentRef =
          _database.child('students').child(user!.uid);

      // Add an event listener to listen for changes
      studentRef.onValue.listen((event) {
        DataSnapshot snapshot = event.snapshot;
        Map<dynamic, dynamic>? data = snapshot.value as Map<dynamic, dynamic>?;

        studentName = data?['email'];

        if (data != null) {
          // Check if the 'detailsFilled' flag exists in the data
          if (data['detailsFilled'] == true) {
            setState(() {
              detailsFilled = true;
            });
          }
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _checkDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: _signOut,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Welcome, $studentName!', // Display the student's name here
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            if (!detailsFilled) // Show the details form if they haven't been filled
              ElevatedButton(
                onPressed: () {
                  // Navigate to the details form page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailsFormPage(),
                    ),
                  );
                },
                child: Text('Fill Details'),
              ),
          ],
        ),
      ),
    );
  }
}

class DetailsFormPage extends StatefulWidget {
  const DetailsFormPage({Key? key}) : super(key: key);

  @override
  _DetailsFormPageState createState() => _DetailsFormPageState();
}

class _DetailsFormPageState extends State<DetailsFormPage> {
  final DatabaseReference _database = FirebaseDatabase.instance.reference();
  final TextEditingController _universityController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  Future<void> _saveDetails() async {
    // Save the details to Firebase Realtime Database
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await _database.child('students').child(user.uid).update({
        'university': _universityController.text,
        'id': _idController.text,
        'email': _emailController.text,
        'detailsFilled': true, // Set the flag to true after filling the details
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('University Name:'),
            TextFormField(
              controller: _universityController,
              decoration:
                  InputDecoration(hintText: 'Enter your university name'),
            ),
            Text('University ID:'),
            TextFormField(
              controller: _idController,
              decoration: InputDecoration(hintText: 'Enter your university ID'),
            ),
            Text('Email:'),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(hintText: 'Enter your email'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Save the details and navigate back to the home screen
                _saveDetails();
                Navigator.pop(context);
              },
              child: Text('Save Details'),
            ),
          ],
        ),
      ),
    );
  }
}

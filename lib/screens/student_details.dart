import 'package:flutter/material.dart';

class StudentDetailsPage extends StatelessWidget {
  final String universityId;
  final String name;
  final String email;

  StudentDetailsPage({
    required this.universityId,
    required this.name,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Details'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (universityId.isNotEmpty) Text('University ID: $universityId'),
            if (name.isNotEmpty) Text('Name: $name'),
            if (email.isNotEmpty) Text('Email: $email'),
          ],
        ),
      ),
    );
  }
}

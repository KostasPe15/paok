import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:paok/data/notifiers.dart';
import 'package:paok/views/pages/welcome_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController controllerTitle = TextEditingController();
  TextEditingController controllerDescription = TextEditingController();
  DateTime selectedDate = DateTime.now();

  @override
  void dispose() {
    controllerTitle.dispose();
    controllerDescription.dispose();
    super.dispose();
  }

  Future<void> uploadTaskToDb() async {
    try {
      final data = await FirebaseFirestore.instance.collection("tasks").add({
        "title": controllerTitle.text.trim(),
        "description": controllerDescription.text.trim(),
        "date": FieldValue.serverTimestamp(),
        "color": "#005216",
      });
      print(data);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50.0,
            backgroundImage: AssetImage('assets/images/PAOK_BASKETBALL.jpg'),
          ),
          SizedBox(height: 20.0),
          FilledButton(
            onPressed: () {
              selectedPageNotifier.value = 0;
              FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return WelcomePage();
                  },
                ),
              );
            },
            style: FilledButton.styleFrom(
              minimumSize: Size(double.infinity, 40.0),
            ),
            child: Text('Logout'),
          ),
          TextField(
            controller: controllerTitle,
            decoration: InputDecoration(
              hintText: 'Title',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
            ),
            onEditingComplete: () {
              setState(() {});
            },
          ),
          SizedBox(height: 10.0),
          TextField(
            controller: controllerDescription,
            decoration: InputDecoration(
              hintText: 'Description',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
            ),
            onEditingComplete: () {
              setState(() {});
            },
          ),
          FilledButton(
            onPressed: () async {
              await uploadTaskToDb();
            },
            style: FilledButton.styleFrom(
              minimumSize: Size(double.infinity, 40.0),
            ),
            child: Text('Add'),
          ),
        ],
      ),
    );
  }
}

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:paok/data/notifiers.dart';
import 'package:paok/views/pages/welcome_page.dart';
import 'package:uuid/uuid.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController controllerTitle = TextEditingController();
  TextEditingController controllerDescription = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;
  File? file;

  @override
  void dispose() {
    controllerTitle.dispose();
    controllerDescription.dispose();
    super.dispose();
  }

  Future<File?> selectImage() async {
    final imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      return File(file.path);
    }
    return null;
  }

  Future<void> uploadTaskToDb() async {
    showDialog(
      context: context,
      builder: (context) {
        return Center(child: CircularProgressIndicator());
      },
    );
    try {
      final id = const Uuid().v4();
      final imageRef = FirebaseStorage.instance.ref('images').child(id);

      final uploadTask = imageRef.putFile(file!);
      final taskSnapshot = await uploadTask;

      final imageURL = await taskSnapshot.ref.getDownloadURL();
      print(imageURL);

      final data = await FirebaseFirestore.instance.collection("tasks").add({
        "title": controllerTitle.text.trim(),
        "description": controllerDescription.text.trim(),
        "imageURL": imageURL,
      });
      print(data);
      Navigator.of(context).pop();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CircleAvatar(
                  radius: 50.0,
                  backgroundImage: AssetImage(
                    'assets/images/PAOK_BASKETBALL.jpg',
                  ),
                ),
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
                  child: Text('Logout'),
                ),
              ],
            ),
            Text('Signed in as:'),
            Text(auth.currentUser?.email as String),
            SizedBox(height: 40.0),
            Divider(color: Colors.teal),
            Text('Add a new card', style: TextStyle(fontSize: 30)),
            SizedBox(height: 20.0),
            GestureDetector(
              onTap: () async {
                final image = await selectImage();
                setState(() {
                  file = image;
                });
              },
              child: DottedBorder(
                // borderType: BorderType.RRect,
                // radius: const Radius.circular(10),
                // dashPattern: const [10, 4],
                // strokeCap: StrokeCap.round,
                child: Container(
                  width: double.infinity,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child:
                      file != null
                          ? Image.file(file!)
                          : const Center(
                            child: Icon(Icons.camera_alt_outlined, size: 40),
                          ),
                ),
              ),
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
            SizedBox(height: 30.0),
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
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:paok/views/pages/course_page.dart';
import 'package:paok/views/widgets/container_widget.dart';
import 'package:paok/views/widgets/hero_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseFirestore.instance.collection("tasks").get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 10.0),
                HeroWidget(title: 'Flutter', nextPage: CoursePage()),
                ...List.generate(snapshot.data!.docs.length, (index) {
                  return ContainerWidget(
                    title: snapshot.data!.docs[index].data()["title"],
                    description:
                        snapshot.data!.docs[index].data()["description"],
                    imageURL: snapshot.data!.docs[index].data()["imageURL"],
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:paok/data/constants.dart';
import 'package:paok/views/pages/course_page.dart';
import 'package:paok/views/widgets/container_widget.dart';
import 'package:paok/views/widgets/hero_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> list = [
      KValue.keyConcepts,
      KValue.basicLayout,
      KValue.cleanUI,
      KValue.fixBugs,
    ];
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10.0),
            HeroWidget(title: 'Flutter', nextPage: CoursePage()),
            ...List.generate(list.length, (index) {
              return ContainerWidget(
                title: list.elementAt(index),
                description: 'You signed in',
              );
            }),
          ],
        ),
      ),
    );
  }
}

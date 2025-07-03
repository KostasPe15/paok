import 'package:flutter/material.dart';

import '../../data/constants.dart';

class ContainerWidget extends StatelessWidget {
  const ContainerWidget({
    super.key,
    required this.title,
    required this.description,
    required this.imageURL,
  });

  final String title;
  final String description;
  final imageURL;

  @override
  Widget build(BuildContext context) {
    String image = '';
    print(image);
    print(imageURL);
    if (imageURL == null) {
      image =
          'https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/2048px-No_image_available.svg.png';
    } else {
      image = imageURL;
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(top: 10.0),
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Text(title, style: KTextStyle.titleTealText),
                      Text(description, style: KTextStyle.descriptionText),
                    ],
                  ),
                  new Image.network(image, width: 100, height: 100),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

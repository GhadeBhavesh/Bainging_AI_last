import 'package:flutter/material.dart';
import 'package:ai_assistent/constants/app_textstyle.dart';
import 'package:ai_assistent/constants/color_constants.dart';
import 'package:ai_assistent/data/card_data.dart';
import 'package:ai_assistent/widgets/my_card.dart';

import '../main.dart';

class CardScreen extends StatelessWidget {
  const CardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(20),
          child: ListView.separated(
              shrinkWrap: true,
              itemCount: myCards.length,
              separatorBuilder: (context, index) {
                return SizedBox(
                  height: 20,
                );
              },
              itemBuilder: (context, index) {
                return MyCard(
                  card: myCards[index],
                );
              }),
        ),
        CircleAvatar(
          radius: 40,
          child: Icon(Icons.add, size: 50),
        ),
        SizedBox(height: 10),
        Text(
          "Add Card",
          style: ApptextStyle.LISTTILE_TITLE,
        )
      ],
    );
  }
}

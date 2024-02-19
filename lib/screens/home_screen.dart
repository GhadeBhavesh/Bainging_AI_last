import 'package:flutter/material.dart';
import 'package:ai/constants/app_textstyle.dart';
import 'package:ai/constants/color_constants.dart';
import 'package:ai/data/card_data.dart';
import 'package:ai/data/transaction_data.dart';
import 'package:ai/widgets/my_card.dart';
import 'package:ai/widgets/transaction_card.dart';

import '../main.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.all(0.1),
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/back.jpg"), fit: BoxFit.cover),
            ),
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 200,
                  child: ListView.separated(
                      physics: ClampingScrollPhysics(),
                      separatorBuilder: (context, index) {
                        return SizedBox(
                          width: 10,
                        );
                      },
                      itemCount: myCards.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return MyCard(
                          card: myCards[index],
                        );
                      }),
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  "Recent Transactions",
                  style: ApptextStyle.BODY_TEXT,
                ),
                SizedBox(
                  height: 15,
                ),
                ListView.separated(
                    itemCount: myTransactions.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    separatorBuilder: (context, index) {
                      return SizedBox(
                        height: 10,
                      );
                    },
                    itemBuilder: (context, index) {
                      return TransactionCard(
                          transaction: myTransactions[index]);
                    })
              ],
            ),
          ),
        ));
  }
}

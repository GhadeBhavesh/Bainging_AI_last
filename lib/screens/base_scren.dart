import 'package:flutter/material.dart';
import 'package:ai_assistent/constants/color_constants.dart';
import 'package:ai_assistent/screens/home_Screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'card_screen.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({Key? key}) : super(key: key);

  @override
  _BaseScreenState createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: HomeScreen(),
      ),
    );
  }
}

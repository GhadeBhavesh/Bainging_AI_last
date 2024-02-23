import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ai/constants/app_textstyle.dart';
import 'package:ai/data/transaction_data.dart';
import 'dart:ui' as ui;

class TransactionCard extends StatelessWidget {
  final TransactionModel transaction;
  const TransactionCard({Key? key, required this.transaction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String name;
    final String category;
    final String location;
    final double rating;
    final Color startColor;
    final Color endColor;
    final double _borderRadius = 24;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          children: <Widget>[
            Container(
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(_borderRadius),
                gradient: LinearGradient(
                    colors: [Colors.redAccent, Colors.red],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight),
                boxShadow: [
                  BoxShadow(
                    color: Colors.red,
                    blurRadius: 12,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              top: 0,
              child: CustomPaint(
                size: Size(100, 150),
                painter: CustomCardShapePainter(
                    _borderRadius, Colors.redAccent, Colors.red),
              ),
            ),
            Positioned.fill(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Image.asset(
                      transaction.avatar,
                      height: 54,
                      width: 54,
                    ),
                    flex: 2,
                  ),
                  Expanded(
                    flex: 4,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Text(
                            transaction.name,
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Avenir',
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                        Text(
                          transaction.currentBalance,
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Avenir',
                          ),
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.family_restroom_rounded,
                              color: Colors.white,
                              size: 16,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Flexible(
                              child: Text(
                                transaction.month,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Avenir',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        // Text(
                        //   items[index].rating.toString(),
                        //   style: TextStyle(
                        //       color: Colors.white,
                        //       fontFamily: 'Avenir',
                        //       fontSize: 18,
                        //       fontWeight: FontWeight.w700),
                        // ),
                        // RatingBar(rating: items[index].rating),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomCardShapePainter extends CustomPainter {
  final double radius;
  final Color startColor;
  final Color endColor;

  CustomCardShapePainter(this.radius, this.startColor, this.endColor);

  @override
  void paint(Canvas canvas, Size size) {
    var radius = 24.0;

    var paint = Paint();
    paint.shader = ui.Gradient.linear(
        Offset(0, 0), Offset(size.width, size.height), [
      HSLColor.fromColor(startColor).withLightness(0.8).toColor(),
      endColor
    ]);

    var path = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width - radius, size.height)
      ..quadraticBezierTo(
          size.width, size.height, size.width, size.height - radius)
      ..lineTo(size.width, radius)
      ..quadraticBezierTo(size.width, 0, size.width - radius, 0)
      ..lineTo(size.width - 1.5 * radius, 0)
      ..quadraticBezierTo(-radius, 2 * radius, 0, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

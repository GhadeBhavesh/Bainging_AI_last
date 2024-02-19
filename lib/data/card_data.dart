import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ai/constants/color_constants.dart';

class CardModel {
  String cardNumber;
  String expDate;
  String cvv;
  Color cardColor;
  CardModel({
    required this.cardNumber,
    required this.cvv,
    required this.expDate,
    required this.cardColor,
  });
}

List<CardModel> myCards = [
  CardModel(
    cardNumber: "****  ****  ****  1234",
    cvv: "**4",
    expDate: "12/28",
    cardColor: kPrimaryColorss,
  ),
  CardModel(
    cardNumber: "****  ****  ****  4321",
    cvv: "**1",
    expDate: "01/26",
    cardColor: kSecondaryColor,
  ),
];

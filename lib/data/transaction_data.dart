import 'package:flutter/material.dart';

class TransactionModel {
  String name;
  String avatar;
  String currentBalance;
  String month;
  String changePercentageIndicator;
  String changePercentage;
  Color color;
  // String description;
  TransactionModel({
    required this.avatar,
    required this.changePercentage,
    required this.changePercentageIndicator,
    required this.currentBalance,
    required this.month,
    required this.name,
    required this.color,
    // required this.description,
  });
}

List<TransactionModel> myTransactions = [
  TransactionModel(
    avatar: "assets/icons/avatar5.png",
    currentBalance: "4 times Transation",
    changePercentage: "0.41%",
    changePercentageIndicator: "up",
    month: "Dad",
    name: "Shivam Thakur",
    color: Colors.green,
  ),
  TransactionModel(
    avatar: "assets/icons/avatar.png",
    currentBalance: "3 times Transation",
    changePercentageIndicator: "down",
    changePercentage: "4.54%",
    month: "Mom",
    name: "Sakshi Thakur",
    color: Colors.orange,
  ),
  TransactionModel(
    avatar: "assets/icons/avatar5.png",
    currentBalance: "2 times Transation",
    changePercentage: "1.27%",
    changePercentageIndicator: "down",
    month: "Brother",
    name: "Soham Thakur",
    color: Colors.red,
  ),
  TransactionModel(
    avatar: "assets/icons/avatar.png",
    currentBalance: "1 times Transation",
    changePercentageIndicator: "up",
    changePercentage: "3.09%",
    month: "Sister",
    name: "Sonali Thakur",
    color: Colors.deepPurple,
  ),
];

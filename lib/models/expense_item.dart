import 'package:flutter/material.dart';

class ExpenseItems {
  final String name;
  final String amount;
  final DateTime dateTime;

  const ExpenseItems({
    required this.name,
    required this.amount,
    required this.dateTime,
  });
}

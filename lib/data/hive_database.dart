import 'dart:math';

import 'package:expense_tracker_app/models/expense_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';

class HiveDataBase {
  //reference our box
  final _myBox = Hive.box("expense_database");

  //write data
  void saveData(List<ExpenseItems> allExpense) {
    List<List<dynamic>> allExpensesFormatted = [];

    for (var expense in allExpense) {
      //convert each expenseItem into a list of storeable types(strings, dateTime)
      List<dynamic> expenseFormatted = [
        expense.name,
        expense.amount,
        expense.dateTime,
      ];
      allExpensesFormatted.add(expenseFormatted);
    }

    //finally lets store in our database
    _myBox.put("ALL_EXPENSES", allExpensesFormatted);
  }

  //read data
  List<ExpenseItems> readData() {
    //Data is stored in hive as a list of strings & dateTime,
    //so lets convert our saved data into ExpenseItem objects

    List savedExpenses = _myBox.get("ALL_EXPENSES") ?? [];
    List<ExpenseItems> allExpenses = [];

    for (int i = 0; i < savedExpenses.length; i++) {
      //collect individual expense data
      String name = savedExpenses[i][0];
      String amount = savedExpenses[i][1];
      DateTime dateTime = savedExpenses[i][2];

      //create expenseItem
      ExpenseItems expense = ExpenseItems(name: name, amount: amount, dateTime: dateTime);

      //add expense to overall list of expenses
      allExpenses.add(expense);
    }
    return allExpenses;
  }
}

import 'package:expense_tracker_app/Date_Time/date_time_helper.dart';
import 'package:expense_tracker_app/models/expense_item.dart';
import 'package:flutter/material.dart';

class ExpenseData {
  // list of all expenses
  List<ExpenseItems> overallExpenseList = [];

  //get expense list

  List<ExpenseItems> getAllExpenseList() {
    return overallExpenseList;
  }

  // add new expense
  void addNewExpense(ExpenseItems newExpense) {
    overallExpenseList.add(newExpense);
  }

  // delete expense
  void deleteExpense(ExpenseItems expense) {
    overallExpenseList.remove(expense);
  }

  // get weekday(Mon, Tue etc) from dateTime object
  String getDayName(DateTime dateTime) {
    switch(dateTime.weekday) {
      case 1:
    return "Mon";
      case 2:
        return "Tue";
      case 3:
        return "Wed";
      case 4:
        return "Thu";
      case 5:
        return "Fri";
      case 6:
        return "Sat";
      case 7:
        return "Sun";
      default:
        return "";
    }
  }

  // get the date for start of week

  DateTime startOfWeekDate () {
    DateTime? startOfWeek;

    //get today's date
    DateTime today = DateTime.now();

  // go backwards from today to find sunday
  for(int i = 0; i < 7; i++) {
    if (getDayName(today.subtract(Duration(days: i))) == 'Sun') {
      startOfWeek = today.subtract(Duration(days: i));
      break;
    }
  }
  return startOfWeek!;
  }


  Map<String,double> calculateDailyExpenseSummary() {
  Map<String,double> dailyExpenseSummary ={
  // date(yyyymmdd) : amountTotalForDay
  };

  for(var expense in overallExpenseList) {
    String date = convertDateTimeToString(expense.dateTime);
    double amount = double.parse(expense.amount);
    
    if(dailyExpenseSummary.containsKey(date)){
      double currentAmount = dailyExpenseSummary[date]!;
      currentAmount += amount;
      dailyExpenseSummary[date] = currentAmount;
  }
    else {
      dailyExpenseSummary.addAll({date : amount});
  }
  }
  return dailyExpenseSummary;
  }

}
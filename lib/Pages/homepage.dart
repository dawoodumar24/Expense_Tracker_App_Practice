import 'dart:math';

import 'package:expense_tracker_app/Components/expense_summary.dart';
import 'package:expense_tracker_app/data/expense_data.dart';
import 'package:expense_tracker_app/models/expense_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Components/expense_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final newExpenseNameController = TextEditingController();
  final newExpenseDollarController = TextEditingController();
  final newExpenseCentsController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //prepare data on startup
    Provider.of<ExpenseData>(context, listen: false).prepareData();
  }

  void addNewExpense() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add new Expense"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: newExpenseNameController,
              decoration: InputDecoration(
                hintText: "Expense name",
              ),),
              Row(children: [
                //dollars
                Expanded(
                  child: TextField(
                    controller: newExpenseDollarController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: "Dollars",
                    ),
                  ),
                ),

                //cents
                Expanded(
                  child: TextField(
                    controller: newExpenseCentsController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: "Cents",
                    ),
                  ),
                )
              ],)
            ],
          ),
          actions: [
            MaterialButton(onPressed: save, child: Text('save')),
            MaterialButton(onPressed: cancel, child: Text('cancel')),
          ],
        );
      },
    );
  }

  //delete expense
  void deleteExpense(ExpenseItems expense) {
    Provider.of<ExpenseData>(context, listen: false).deleteExpense(expense);
  }

  void save() {
    if (
    newExpenseNameController.text.isNotEmpty &&
        newExpenseDollarController.text.isNotEmpty &&
        newExpenseCentsController.text.isNotEmpty
    ) {
      String amount = '${newExpenseDollarController
          .text}.${newExpenseCentsController.text}';

      ExpenseItems newExpense = ExpenseItems(
        name: newExpenseNameController.text,
        amount: amount,
        dateTime: DateTime.now(),
      );
      Provider.of<ExpenseData>(context, listen: false).addNewExpense(
          newExpense);
    }
      Navigator.pop(context);
      clear();
    }


  void cancel() {
    Navigator.pop(context);
    clear();
  }

  void clear() {
    newExpenseDollarController.clear();
    newExpenseCentsController.clear();
    newExpenseNameController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseData>(
      builder: (context, value, child) {
        return Scaffold(
          backgroundColor: Colors.grey,
          floatingActionButton: FloatingActionButton(
            onPressed: addNewExpense,
            child: Icon(Icons.add),
            backgroundColor: Colors.black,
          ),
          body: ListView(
            children: [
              //weekly summary
            ExpenseSummary(startOfWeek: value.startOfWeekDate()),

              SizedBox(height: 20,),
              //expense list
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: value.getAllExpenseList().length,
                itemBuilder: (context, index) {
                  return ExpenseTile(
                    name: value.getAllExpenseList()[index].name,
                    amount: value.getAllExpenseList()[index].amount,
                    dateTime: value.getAllExpenseList()[index].dateTime,
                    deleteTapped: (p0)=> deleteExpense(value.getAllExpenseList()[index]),
                  );
                },
              ),
            ],
          )
        );
      },
    );
  }
}

import 'package:expense_tracker/models/expense_item.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveDataBase {
  //reference to the box
  final _myBox = Hive.box("expense_database");
  //write data
  void saveData(List<ExpenseItem> allExpense) {
    /*

   hive can only strings and dateTime, and not custom objects like ExpenseItem
   so lets convert our list of ExpenseItem to a list of strings

   allExpense =

   [
    ExpenseItem(name / amount / dateTime )
    ...

   ]

   ->

    [
      [name, amount, dateTime]
      ...
    ]

   */

    List<List<dynamic>> allExpensesFormatted = [];

    for (ExpenseItem expense in allExpense) {
      allExpensesFormatted
          .add([expense.name, expense.amount, expense.dateTime]);
    }

    //finally store in the database
    _myBox.put("all_expenses", allExpensesFormatted);
  }
  //read data
  /*
  Data is stored in hive as a list of strings + dateTime, lets convert it back to a list of ExpenseItem

  savedData = 
  [
    [name, amount, dateTime]
    ...
  ]

  ->

  [
    ExpenseItem(name / amount / dateTime)
    ...
  ]


  */

  List<ExpenseItem> readData() {
    List savedData = _myBox.get("all_expenses") ?? [];
    List<ExpenseItem> allExpenses = [];
    for (List<dynamic> expense in savedData) {
      allExpenses.add(ExpenseItem(
          name: expense[0], amount: expense[1], dateTime: expense[2]));
    } 
    return allExpenses;
  }
}

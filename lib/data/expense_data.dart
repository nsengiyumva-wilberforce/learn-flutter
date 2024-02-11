import 'package:expense_tracker/data/hive_database.dart';
import 'package:expense_tracker/datetime/date_time_helper.dart';
import 'package:expense_tracker/models/expense_item.dart';
import 'package:flutter/material.dart';

class ExpenseData extends ChangeNotifier{
  //list of all the expenses
  List<ExpenseItem> overallExpenseList = [];
  //get the expense list
  List<ExpenseItem> getAllExpenseList() {
    return overallExpenseList;
  }

  //prepare data to display
  final db = HiveDataBase();
  void prepareData(){
    //if there exists data in the database, load it
    if(db.readData().isNotEmpty){
      overallExpenseList = db.readData();
  }
  }

  //add a new expense
  void addNewExpense(ExpenseItem expenseItem) {
    overallExpenseList.add(expenseItem);

    notifyListeners();
    db.saveData(overallExpenseList);
  }

  //delete an expense
  void deleteExpense(ExpenseItem expenseItem) {
    overallExpenseList.remove(expenseItem);

    notifyListeners();
    db.saveData(overallExpenseList);
  }

  //get the weekday (mon, tue, wed, etc.) from dateTime object
  String getDayName(DateTime dateTime) {
    switch (dateTime.weekday) {
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
        return '';
    }
  }

  //get the date for the start of the week (sunday)
  DateTime startOfWeek() {
    DateTime startOfWeek = DateTime.now();

    //get today's date
    DateTime today = DateTime.now();

    //get backwards from today to find sunday
    for (int i = 0; i < 7; i++) {
      if(getDayName(today.subtract(Duration(days: i))) == "Sun"){
        startOfWeek = today.subtract(Duration(days: i));
      }
    }

    return startOfWeek;
  }

  /*
  convert overall list of expenses into a daily expense summary

  e.g.

  overallExpenseList = 
  [
    [ food, 2023/01/30, $10 ],
    [ had, 2023/01/30, $15 ],
    [ drinks, 2023/01/30, $1 ],
    [ food, 2023/01/30, $10 ],
    [ food, 2023/01/30, $10 ],
    [ had, 2023/01/30, $15 ],
    [ drinks, 2023/01/30, $1 ],
    [ food, 2023/01/30, $10 ],
    [ food, 2023/01/30, $10 ],
    [ had, 2023/01/30, $15 ],
    [ drinks, 2023/01/30, $1 ],
    [ food, 2023/01/30, $10 ],
    [ food, 2023/01/30, $10 ],
    [ had, 2023/01/30, $15 ],
    [ drinks, 2023/01/30, $1 ],
    [ food, 2023/01/30, $10 ],
  ]

  ]

  ->

  DailayExpenseSummary = 
  [
    [ 20230130: $25 ],
    [ 20230131: $30 ],
    [ 20230201: $40 ],
    [ 20230202: $20 ],
    [ 20230203: $10 ],
    [ 20230204: $5 ],
    [ 20230205: $100 ],
  ]

  */

  Map<String, double> calculateDailyExpenseSummary(){
    Map<String, double> dailyExpenseSummary = {
      // date (yyyymmdd) : amountTotalForDay
    };

    for (var expense in overallExpenseList) {
      String date = convertDateTimeToString(expense.dateTime);
      if(dailyExpenseSummary.containsKey(date)){
        dailyExpenseSummary[date] = dailyExpenseSummary[date]! + double.parse(expense.amount);
      }else{
        dailyExpenseSummary[date] = double.parse(expense.amount);
      }
    }

    return dailyExpenseSummary;
  }
}

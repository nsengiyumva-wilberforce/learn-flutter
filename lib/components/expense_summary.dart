import 'package:expense_tracker/bar%20graph/bar_graph.dart';
import 'package:expense_tracker/data/expense_data.dart';
import 'package:expense_tracker/datetime/date_time_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExpenseSummary extends StatelessWidget {
  final DateTime startOfWeek;
  const ExpenseSummary({super.key, required this.startOfWeek});

  //calculate the max amount for the bar graph
  double calculateMax(
      ExpenseData value,
      String sunday,
      String monday,
      String tuesday,
      String wednesday,
      String thursday,
      String friday,
      String saturday) {
    double? max = 100;
    List<double> values = [
      value.calculateDailyExpenseSummary()[sunday] ?? 0,
      //monday
      value.calculateDailyExpenseSummary()[monday] ?? 0,
      //tuesday
      value.calculateDailyExpenseSummary()[tuesday] ?? 0,
      //wednesday
      value.calculateDailyExpenseSummary()[wednesday] ?? 0,
      //thursday
      value.calculateDailyExpenseSummary()[thursday] ?? 0,
      //friday
      value.calculateDailyExpenseSummary()[friday] ?? 0,
      //saturday
      value.calculateDailyExpenseSummary()[saturday] ?? 0,
    ];

    // sort from the smallest to the largest
    values.sort((a, b) => a.compareTo(b));

    //get the larget amount which should be the last element in the list
    max = values.last * 1.1;

    //if max is 0, set it to 100
    if (max == 0) {
      max = 100;
    }

    return max;
  }

  //calculate weekly total
  String calculateWeekTotal(
      ExpenseData value,
      String sunday,
      String monday,
      String tuesday,
      String wednesday,
      String thursday,
      String friday,
      String saturday) {
    List<double> values = [
      value.calculateDailyExpenseSummary()[sunday] ?? 0,
      //monday
      value.calculateDailyExpenseSummary()[monday] ?? 0,
      //tuesday
      value.calculateDailyExpenseSummary()[tuesday] ?? 0,
      //wednesday
      value.calculateDailyExpenseSummary()[wednesday] ?? 0,
      //thursday
      value.calculateDailyExpenseSummary()[thursday] ?? 0,
      //friday
      value.calculateDailyExpenseSummary()[friday] ?? 0,
      //saturday
      value.calculateDailyExpenseSummary()[saturday] ?? 0,
    ];

    double total = 0;
    for (int i = 0; i < values.length; i++) {
      total += values[i];
    }

    return total.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    //get yyyyddmm for each day of the week
    String sunday =
        convertDateTimeToString(startOfWeek.add(const Duration(days: 0)));
    String monday =
        convertDateTimeToString(startOfWeek.add(const Duration(days: 1)));
    //tuesday
    String tuesday =
        convertDateTimeToString(startOfWeek.add(const Duration(days: 2)));
    //wednesday
    String wednesday =
        convertDateTimeToString(startOfWeek.add(const Duration(days: 3)));
    //thursday
    String thursday =
        convertDateTimeToString(startOfWeek.add(const Duration(days: 4)));
    //friday
    String friday =
        convertDateTimeToString(startOfWeek.add(const Duration(days: 5)));
    //saturday
    String saturday =
        convertDateTimeToString(startOfWeek.add(const Duration(days: 6)));
    return Consumer<ExpenseData>(
        builder: (context, value, child) => Column(children: [
              //week total
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: Row(
                  children: [
                    const Text(
                      "Week Total:",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                        "\$${calculateWeekTotal(value, sunday, monday, tuesday, wednesday, thursday, friday, saturday)}")
                  ],
                ),
              ),

              //bar graph
              SizedBox(
                height: 200,
                child: MyBarGraph(
                  sunAmount: value.calculateDailyExpenseSummary()[sunday] ?? 0,
                  monAmount: value.calculateDailyExpenseSummary()[monday] ?? 0,
                  tueAmount: value.calculateDailyExpenseSummary()[tuesday] ?? 0,
                  wedAmount:
                      value.calculateDailyExpenseSummary()[wednesday] ?? 0,
                  thurAmount:
                      value.calculateDailyExpenseSummary()[thursday] ?? 0,
                  friAmount: value.calculateDailyExpenseSummary()[friday] ?? 0,
                  satAmount:
                      value.calculateDailyExpenseSummary()[saturday] ?? 0,
                  maxY: 100,
                ),
              ),
            ]));
  }
}

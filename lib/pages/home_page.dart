import 'package:expense_tracker/components/expense_summary.dart';
import 'package:expense_tracker/components/expense_tile.dart';
import 'package:expense_tracker/data/expense_data.dart';
import 'package:expense_tracker/models/expense_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //text controllers
  final newExpenseNameController = TextEditingController();
  final newExpenseDollarAmountController = TextEditingController();
  final newExpenseCentAmountController = TextEditingController();

  @override
  void initState() {
    super.initState();

    //prepare data
    Provider.of<ExpenseData>(context, listen: false).prepareData();
  }

  //add a new expense
  void addNewExpense() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Add New Expense"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  //expense name
                  TextField(
                    controller: newExpenseNameController,
                    decoration: const InputDecoration(
                        labelText: "Expense Name", hintText: "Expense Name"),
                  ),
                  //expense amount
                  Row(
                    children: [
                      //dollars

                      Expanded(
                        child: TextField(
                          controller: newExpenseDollarAmountController,
                          keyboardType: TextInputType.number,
                          decoration:
                              const InputDecoration(hintText: "Dollars"),
                        ),
                      ),

                      //cents
                      Expanded(
                        child: TextField(
                          controller: newExpenseCentAmountController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(hintText: "Cents"),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              actions: [
                //save button
                MaterialButton(onPressed: save, child: const Text("Save")),
                //cancel button
                MaterialButton(onPressed: cancel, child: const Text("Cancel")),
              ],
            ));
  }

  //delete an expense
  void deleteExpense(ExpenseItem expenseItem) {
    Provider.of<ExpenseData>(context, listen: false).deleteExpense(expenseItem);
  }

  //save
  void save() {
    //check if dollar or cent is empty and make it a 0
    if (newExpenseDollarAmountController.text.isEmpty) {
      newExpenseDollarAmountController.text = "0";
    }
    //put the collars and cents together
    String amount =
        '${newExpenseDollarAmountController.text}.${newExpenseCentAmountController.text}';

    Provider.of<ExpenseData>(context, listen: false).addNewExpense(ExpenseItem(
        name: newExpenseNameController.text,
        amount: amount,
        dateTime: DateTime.now()));

    //clear the text fields
    clear();

    //close the dialog
    Navigator.of(context).pop();
  }

  void clear() {
    newExpenseNameController.clear();
    newExpenseDollarAmountController.clear();
    newExpenseCentAmountController.clear();
  }

  //cancel
  void cancel() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseData>(
        builder: (context, value, child) => Scaffold(
            backgroundColor: Colors.grey[300],
            floatingActionButton: FloatingActionButton(
              onPressed: addNewExpense,
              backgroundColor: Colors.black,
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
            body: ListView(children: [
              const SizedBox(
                height: 10,
              ),
              //weekly summary
              ExpenseSummary(startOfWeek: value.startOfWeek()),

              const SizedBox(
                height: 20,
              ),

              //expense list
              ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: value.getAllExpenseList().length,
                  itemBuilder: (context, index) => ExpenseTile(
                        amount: value.getAllExpenseList()[index].amount,
                        name: value.getAllExpenseList()[index].name,
                        dateTime: value.getAllExpenseList()[index].dateTime,
                        deleteTapped: (p0) => deleteExpense(
                            value.getAllExpenseList()[index]),
                      ))
            ])));
  }
}

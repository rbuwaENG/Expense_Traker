import 'package:expense_app/Pages/expense_item.dart';
import 'package:expense_app/data/expense_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class homePage extends StatefulWidget {
  const homePage({super.key});

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  final newExpenseNameController = TextEditingController();
  final newExpenseAmountController = TextEditingController();
  void addNewExpense() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
                title: Text('Add New Expense'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: newExpenseNameController,
                      decoration: InputDecoration(
                        labelText: 'Expense Name',
                      ),
                    ),
                    TextField(
                      controller: newExpenseAmountController,
                      decoration: InputDecoration(
                        labelText: 'Expense Amount',
                      ),
                    ),
                  ],
                ),
                actions: [
                  MaterialButton(
                    onPressed: Save,
                    child: Text('Save'),
                  ),
                  MaterialButton(
                    onPressed: Cancel,
                    child: Text('Cancel'),
                  )
                ]));
  }

  void Save() {
    //create a new expense item
    ExpenseItem newExpense = ExpenseItem(
        name: newExpenseNameController.text,
        amount: newExpenseAmountController.text,
        date: DateTime.now());
    Provider.of<ExpenseData>(context, listen: false).addNewExpense(newExpense);
    Navigator.pop(context);
  }

  void Cancel() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseData>(
      builder: (context, value, child) => Scaffold(
          backgroundColor: Colors.grey[300],
          floatingActionButton: FloatingActionButton(
            onPressed: addNewExpense,
            child: Icon(Icons.add),
          ),
          body: ListView.builder(
              itemCount: value.getAllExpenseList().length,
              itemBuilder: (context, index) => ListTile(
                    title: Text(value.getAllExpenseList()[index].name),
                  ))),
    );
  }
}

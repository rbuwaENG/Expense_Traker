import 'package:expense_app/Pages/expense_item.dart';
import 'package:expense_app/components/expense_summary.dart';
import 'package:expense_app/components/expense_tile.dart';
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
  final newExpenseRupeesAmountController = TextEditingController();
  final newExpenseCentsAmountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    //read data from hive
    Provider.of<ExpenseData>(context, listen: false).prepareData();
  }

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
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: newExpenseRupeesAmountController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Rupees',
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            controller: newExpenseCentsAmountController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Cents',
                            ),
                          ),
                        )
                      ],
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

  //delete espense
  void deleteExpense(ExpenseItem expense) {
    Provider.of<ExpenseData>(context, listen: false).deleteExpense(expense);
  }

  void Save() {
    if (newExpenseCentsAmountController.text.isNotEmpty &&
        newExpenseRupeesAmountController.text.isNotEmpty &&
        newExpenseNameController.text.isNotEmpty) {
      String amount = newExpenseRupeesAmountController.text +
          '.' +
          newExpenseCentsAmountController.text;
      //create a new expense item
      ExpenseItem newExpense = ExpenseItem(
          name: newExpenseNameController.text,
          amount: amount,
          date: DateTime.now());
      Provider.of<ExpenseData>(context, listen: false)
          .addNewExpense(newExpense);
    }

    Navigator.pop(context);
    clear();
  }

  void Cancel() {
    Navigator.pop(context);
    clear();
  }

  void clear() {
    newExpenseNameController.clear();
    newExpenseRupeesAmountController.clear();
    newExpenseCentsAmountController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseData>(
      builder: (context, value, child) => Scaffold(
          backgroundColor: Colors.grey[300],
          floatingActionButton: FloatingActionButton(
            onPressed: addNewExpense,
            backgroundColor: Colors.black,
            child: Icon(Icons.add),
          ),
          body: ListView(
            children: [
              //weekly summery
              ExpenseSummary(startOfweek: value.startOfWeekDate()),

              //space
              const SizedBox(
                height: 20,
              ),
              //list of all expense
              ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: value.getAllExpenseList().length,
                  itemBuilder: (context, index) => ExpenseTile(
                        name: value.getAllExpenseList()[index].name,
                        amount: value.getAllExpenseList()[index].amount,
                        date: value.getAllExpenseList()[index].date,
                        deleteTapped: (p0) =>
                            deleteExpense(value.getAllExpenseList()[index]),
                      ))
            ],
          )),
    );
  }
}

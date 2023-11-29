import 'package:expense_app/Pages/expense_item.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveDatabase {
  //refrence our box
  final _myBox = Hive.box('expense_databse');

  // weite data to hive
  void saveData(List<ExpenseItem> allExpense) {
    List<List<dynamic>> allExpensesFormatted = [];
    for (var expense in allExpense) {
      List<dynamic> expenseFormatted = [
        expense.name,
        expense.amount,
        expense.date,
      ];
      allExpensesFormatted.add(expenseFormatted);
    }
    _myBox.put('all_expense', allExpensesFormatted);
  }
  //read data from hive

  List<ExpenseItem> readData() {
    List savedExpenses = _myBox.get('all_expense') ?? [];
    List<ExpenseItem> allExpense = [];

    for (int i = 0; i < savedExpenses.length; i++) {
      String name = savedExpenses[i][0];
      String amount = savedExpenses[i][1];
      DateTime date = savedExpenses[i][2];

      //expense item
      ExpenseItem expenseItem =
          ExpenseItem(name: name, amount: amount, date: date);

      //add to list
      allExpense.add(expenseItem);
    }
    return allExpense;
  }
}

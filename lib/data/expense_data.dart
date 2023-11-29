import 'package:expense_app/Pages/expense_item.dart';
import 'package:expense_app/data/hive_database.dart';
import 'package:expense_app/datetime/date_time_helper.dart';
import 'package:flutter/material.dart';

class ExpenseData extends ChangeNotifier {
  //list of all expense
  List<ExpenseItem> overallExpenseList = [];

  //get expense list
  List<ExpenseItem> getAllExpenseList() {
    return overallExpenseList;
  }

  final db = HiveDatabase();
  //prepare data to display
  void prepareData() {
    if (db.readData().isNotEmpty) {
      overallExpenseList = db.readData();
    }
  }

  //add new expense
  void addNewExpense(ExpenseItem newExpense) {
    overallExpenseList.add(newExpense);
    notifyListeners();
    db.saveData(overallExpenseList);
  }

  //delete expense
  void deleteExpense(ExpenseItem expense) {
    overallExpenseList.remove(expense);
    notifyListeners();
    db.saveData(overallExpenseList);
  }

  //get weekday from a dataTime object
  String getDayName(DateTime dateTime) {
    switch (dateTime.weekday) {
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thur';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      case 7:
        return 'Sun';
      default:
        return ' ';
    }
  }

  //get the data for the start of the week
  DateTime startOfWeekDate() {
    DateTime? startOfWeek;

    //get the current date
    DateTime today = DateTime.now();

    //get backwards from today to find the start of the week
    for (int i = 0; i < 7; i++) {
      if (getDayName(today.subtract(Duration(days: i))) == 'Sun') {
        startOfWeek = today.subtract(Duration(days: i));
      }
    }
    return startOfWeek!;
  }

  Map<String, double> calculateDailyExpenseSummary() {
    Map<String, double> dailyExpenseSummary = {};

    for (var expense in overallExpenseList) {
      String date = convertDateTimeToString(expense.date);
      double amount = double.parse(expense.amount);

      if (dailyExpenseSummary.containsKey(date)) {
        double courrentAmount = dailyExpenseSummary[date]!;
        courrentAmount = courrentAmount + amount;
      } else {
        dailyExpenseSummary.addAll({date: amount});
      }
    }
    return dailyExpenseSummary;
  }

  //get the data for the end of the week
}

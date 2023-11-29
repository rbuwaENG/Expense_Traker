import 'package:expense_app/bar%20graph/bar_graph.dart';
import 'package:expense_app/data/expense_data.dart';
import 'package:expense_app/datetime/date_time_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExpenseSummary extends StatelessWidget {
  final DateTime startOfweek;
  const ExpenseSummary({super.key, required this.startOfweek});

  //calculate max amount in bar graph
  double calculateMaxAmount(
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
      value.calculateDailyExpenseSummary()[monday] ?? 0,
      value.calculateDailyExpenseSummary()[tuesday] ?? 0,
      value.calculateDailyExpenseSummary()[wednesday] ?? 0,
      value.calculateDailyExpenseSummary()[thursday] ?? 0,
      value.calculateDailyExpenseSummary()[friday] ?? 0,
      value.calculateDailyExpenseSummary()[saturday] ?? 0,
    ];

    //sort from smallest to largest
    values.sort();

    max = values.last * 1.1;

    return max == 0 ? 100 : max;
  }

  //canculate the week total
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
      value.calculateDailyExpenseSummary()[monday] ?? 0,
      value.calculateDailyExpenseSummary()[tuesday] ?? 0,
      value.calculateDailyExpenseSummary()[wednesday] ?? 0,
      value.calculateDailyExpenseSummary()[thursday] ?? 0,
      value.calculateDailyExpenseSummary()[friday] ?? 0,
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
    String sunday =
        convertDateTimeToString(startOfweek.add(const Duration(days: 0)));
    String monday =
        convertDateTimeToString(startOfweek.add(const Duration(days: 1)));
    String tuesday =
        convertDateTimeToString(startOfweek.add(const Duration(days: 2)));
    String wednesday =
        convertDateTimeToString(startOfweek.add(const Duration(days: 3)));
    String thursday =
        convertDateTimeToString(startOfweek.add(const Duration(days: 4)));
    String friday =
        convertDateTimeToString(startOfweek.add(const Duration(days: 5)));
    String saturday =
        convertDateTimeToString(startOfweek.add(const Duration(days: 6)));
    return Consumer<ExpenseData>(
      builder: (context, value, child) => Column(
        children: [
          //week total
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Row(
              children: [
                Text('Week Total:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    )),
                Text('Rs ' +
                    calculateWeekTotal(value, sunday, monday, tuesday,
                        wednesday, thursday, friday, saturday)),
              ],
            ),
          ),

          SizedBox(
            height: 200,
            child: MyBarGraph(
              maxY: 100,
              sunAmount: value.calculateDailyExpenseSummary()[sunday] ?? 0,
              monAmount: value.calculateDailyExpenseSummary()[monday] ?? 0,
              tueAmount: value.calculateDailyExpenseSummary()[tuesday] ?? 0,
              wedAmount: value.calculateDailyExpenseSummary()[wednesday] ?? 0,
              thuAmount: value.calculateDailyExpenseSummary()[thursday] ?? 0,
              friAmount: value.calculateDailyExpenseSummary()[friday] ?? 0,
              satAmount: value.calculateDailyExpenseSummary()[saturday] ?? 0,
            ),
          ),
        ],
      ),
    );
  }
}

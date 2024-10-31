import 'package:flutter/material.dart';
import 'package:third_app/widget/chart/chart.dart';
import 'package:third_app/widget/expenses_list/expenses_list.dart';
import 'package:third_app/models/expense.dart';
import 'package:third_app/widget/new_expense.dart';

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({super.key});

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  final List<Expense> _registeredExpenses = [
    Expense(
        title: "Flutter Course",
        amount: 10000,
        date: DateTime.now(),
        category: Category.work),
    Expense(
        title: "Cinema",
        amount: 1000,
        date: DateTime.now(),
        category: Category.leisure)
  ];

  void _addExpense(Expense newExpense) {
    setState(() {
      _registeredExpenses.add(newExpense);
    });
  }

  void _removeExpense(Expense expense) {
    final expenseIndex = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
            label: "Undo",
            onPressed: () {
              setState(() {
                _registeredExpenses.insert(expenseIndex, expense);
              });
            }),
        content: const Text("Expense deleted.")));
  }

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
        useSafeArea: true,
        isScrollControlled: true,
        context: context,
        builder: (ctx) => NewExpense(_addExpense));
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final heigth = MediaQuery.of(context).size.height;
    Widget mainContent =
        const Center(child: Text("No expenses found. Start adding some!"));

    if (_registeredExpenses.isNotEmpty) {
      mainContent = ExpensesList(
        expenses: _registeredExpenses,
        onRemoveExpense: _removeExpense,
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Expense Tracker"),
        actions: [
          IconButton(
              onPressed: _openAddExpenseOverlay, icon: const Icon(Icons.add))
        ],
      ),
      body: width < 600
          ? Column(
              children: [
                Chart(expenses: _registeredExpenses),
                Expanded(child: mainContent)
              ],
            )
          : Row(
              children: [
                Expanded(child: Chart(expenses: _registeredExpenses)),
                Expanded(child: mainContent)
              ],
            ),
    );
  }
}

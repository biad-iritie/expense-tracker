import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:third_app/models/expense.dart';

final formatter = DateFormat.yMd();

class NewExpense extends StatefulWidget {
  NewExpense(this.onAddExpense, {super.key});

  final void Function(Expense expense) onAddExpense;
  @override
  State<NewExpense> createState() => _NewExpenseState();
}

class _NewExpenseState extends State<NewExpense> {
  var _titleController = TextEditingController();
  var _amountController = TextEditingController();
  DateTime? _selectedDate;
  Category _selectedCategory = Category.leisure;
  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    // final lastDate = DateTime(now.year - 1, now.month, now.day);

    final pickedDate = await showDatePicker(
        context: context, firstDate: firstDate, lastDate: now);
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void handleCategory() {}
  void _submitExpenseData() {
    final enteredAmount = int.tryParse(_amountController.text);
    final amountIsInvalid = (enteredAmount == null || enteredAmount <= 0);
    if (_titleController.text.trim().isEmpty ||
        amountIsInvalid ||
        _selectedDate == null) {
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: const Text("Invalid Input"),
                content: const Text(
                    "Please make sure a valid title, amount, date and category was entered."),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                      },
                      child: const Text("Ok !"))
                ],
              ));
      return;
    }

    Expense newExpense = Expense(
        title: _titleController.text,
        amount: enteredAmount,
        date: _selectedDate!,
        category: _selectedCategory);
    widget.onAddExpense(newExpense);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final keyBoardSpace = MediaQuery.of(context).viewInsets.bottom;
    return LayoutBuilder(
      builder: (ctx, constraints) {
        final width = constraints.maxWidth;
        return SizedBox(
          height: double.infinity,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 48, 16, keyBoardSpace + 16),
              child: Column(
                children: [
                  if (width >= 600)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _titleController,
                            maxLength: 50,
                            decoration: const InputDecoration(
                              label: Text("Title"),
                            ),
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: TextField(
                            controller: _amountController,
                            maxLength: 10,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              prefixText: "CFA ",
                              label: Text("Amount"),
                            ),
                          ),
                        ),
                      ],
                    )
                  else
                    TextField(
                      controller: _titleController,
                      maxLength: 50,
                      decoration: const InputDecoration(
                        label: Text("Title"),
                      ),
                    ),
                  if (width >= 600)
                    Row(
                      children: [
                        DropdownButton(
                            value: _selectedCategory,
                            items: Category.values
                                .map(
                                  (category) => DropdownMenuItem(
                                    value: category,
                                    child: Text(category.name.toUpperCase()),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              if (value == null) {
                                return;
                              }
                              setState(() {
                                _selectedCategory = value;
                              });
                            }),
                        const SizedBox(height: 24),
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(_selectedDate == null
                                  ? "No date selected"
                                  : formatter.format(_selectedDate!)),
                              IconButton(
                                  onPressed: _presentDatePicker,
                                  icon: const Icon(Icons.calendar_month))
                            ],
                          ),
                        )
                      ],
                    )
                  else
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _amountController,
                            maxLength: 10,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              prefixText: "CFA ",
                              label: Text("Amount"),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(_selectedDate == null
                                  ? "No date selected"
                                  : formatter.format(_selectedDate!)),
                              IconButton(
                                  onPressed: _presentDatePicker,
                                  icon: const Icon(Icons.calendar_month))
                            ],
                          ),
                        )
                      ],
                    ),
                  const SizedBox(height: 16),
                  if (width >= 600)
                    Row(
                      children: [
                        const Spacer(),
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("Cancel")),
                        ElevatedButton(
                            onPressed: _submitExpenseData,
                            child: const Text("Save expense")),
                      ],
                    )
                  else
                    Row(
                      children: [
                        DropdownButton(
                            value: _selectedCategory,
                            items: Category.values
                                .map(
                                  (category) => DropdownMenuItem(
                                    value: category,
                                    child: Text(category.name.toUpperCase()),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              if (value == null) {
                                return;
                              }
                              setState(() {
                                _selectedCategory = value;
                              });
                            }),
                        const Spacer(),
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("Cancel")),
                        ElevatedButton(
                            onPressed: _submitExpenseData,
                            child: const Text("Save expense")),
                      ],
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

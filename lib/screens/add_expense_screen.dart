import 'package:flutter/material.dart';

import '../models/expense.dart';

class AddExpenseScreen extends StatefulWidget {
  final Expense? existingExpense;

  const AddExpenseScreen({super.key, this.existingExpense});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  final List<String> _categories = [
    'Food',
    'Transport',
    'Bills',
    'Fun',
    'Other',
  ];

  String _selectedCategory = 'Food';

  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();

    final existing = widget.existingExpense;
    if (existing != null) {
      _nameController.text = existing.name;
      _amountController.text = existing.amount.toString();
      _selectedCategory = existing.category;
      _selectedDate = existing.date;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existingExpense != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Edit Expense' : 'New Expense')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Name',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),

            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                hintText: 'e.g., Lunch at cafe',
              ),
              autofocus: true,
            ),

            const SizedBox(height: 24),

            const Text(
              'Amount',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),

            TextField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                hintText: '0.00',
                prefixText: 'AFN ',
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Category',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ..._categories.map((cat) {
                  return ChoiceChip(
                    label: Text(cat),
                    selected: _selectedCategory == cat,
                    onSelected: (_) {
                      setState(() {
                        _selectedCategory = cat;
                      });
                    },
                  );
                }),
              ],
            ),

            const SizedBox(height: 24),

            const Text(
              'Date',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),

            OutlinedButton.icon(
              onPressed: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2030),
                );

                if (picked != null) {
                  setState(() {
                    _selectedDate = picked;
                  });
                }
              },
              icon: const Icon(Icons.calendar_today, size: 18),
              label: Text(
                '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
              ),
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveExpense,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  isEditing ? 'Save Changes' : 'Save Expense',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveExpense() {
    final name = _nameController.text.trim();
    final amountText = _amountController.text.trim();

    if (name.isEmpty) return;

    final amount = double.tryParse(amountText);

    if (amount == null || amount <= 0) return;

    final expense = Expense(
      id: widget.existingExpense?.id ?? 0,
      name: name,
      amount: amount,
      category: _selectedCategory,
      date: _selectedDate,
    );

    Navigator.pop(context, expense);
  }
}

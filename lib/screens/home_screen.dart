import 'package:flutter/material.dart';

import '../models/expense.dart';
import '../services/expense_storage.dart';
import '../theme/app_theme.dart';
import '../widgets/expense_card.dart';
import '../widgets/empty_state.dart';
import 'add_expense_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Expense> expenses = [];

  int _nextId = 1;

  @override
  void initState() {
    super.initState();
    _loadExpenses();
  }

  Future<void> _loadExpenses() async {
    final loaded = await ExpenseStorage.loadExpenses();

    setState(() {
      expenses = loaded;

      if (expenses.isNotEmpty) {
        _nextId = expenses.map((e) => e.id).reduce((a, b) => a > b ? a : b) + 1;
      }
    });
  }

  Future<void> _addExpense() async {
    final newExpense = await Navigator.push<Expense>(
      context,
      MaterialPageRoute(builder: (_) => const AddExpenseScreen()),
    );

    if (newExpense != null) {
      setState(() {
        expenses.add(
          Expense(
            id: _nextId++,
            name: newExpense.name,
            amount: newExpense.amount,
            category: newExpense.category,
            date: newExpense.date,
          ),
        );
      });

      ExpenseStorage.saveExpenses(expenses);
    }
  }

  void _removeExpense(int index) {
    final removedExpense = expenses[index];
    final removedIndex = index;

    setState(() {
      expenses.removeAt(index);
    });

    ExpenseStorage.saveExpenses(expenses);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Expense Deleted'),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'UNDO',
          onPressed: () {
            setState(() {
              expenses.insert(removedIndex, removedExpense);
            });

            ExpenseStorage.saveExpenses(expenses);
          },
        ),
      ),
    );
  }

  Future<void> _confirmDelete(int index) async {
    final expense = expenses[index];

    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Expense?'),
        content: Text('Are you sure you want to delete "${expense.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),

          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (shouldDelete == true) {
      _removeExpense(index);
    }
  }

  Future<void> _editExpense(int index) async {
    final updated = await Navigator.push<Expense>(
      context,
      MaterialPageRoute(
        builder: (_) => AddExpenseScreen(existingExpense: expenses[index]),
      ),
    );

    if (updated == null) return;

    setState(() {
      expenses[index] = updated;
    });

    await ExpenseStorage.saveExpenses(expenses);
  }

  double get _total {
    return expenses.fold(0.0, (sum, e) => sum + e.amount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Expense Tracker')),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.gold.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppTheme.gold.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'TOTAL SPENT',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.textSecondary,
                      letterSpacing: 1,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'AFN ${_total.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.gold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            child: expenses.isEmpty
                ? const EmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.only(top: 8, bottom: 80),
                    itemCount: expenses.length,
                    itemBuilder: (context, index) {
                      final expense = expenses[index];

                      return ExpenseCard(
                        expense: expense,
                        onEdit: () => _editExpense(index),
                        onDelete: () => _confirmDelete(index),
                        onTap: () => _editExpense(index),
                      );
                    },
                  ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _addExpense,
        child: const Icon(Icons.add),
      ),
    );
  }
}

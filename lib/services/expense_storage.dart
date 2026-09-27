import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/expense.dart';

class ExpenseStorage {
  static const String _key = 'expenses';

  static Future<void> saveExpenses(List<Expense> expenses) async {
    final prefs = await SharedPreferences.getInstance();

    final List<Map<String, dynamic>> expenseMaps = expenses
        .map(
          (expense) => {
            'id': expense.id,
            'name': expense.name,
            'amount': expense.amount,
            'category': expense.category,
            'date': expense.date.toIso8601String(),
          },
        )
        .toList();

    final String jsonString = jsonEncode(expenseMaps);

    await prefs.setString(_key, jsonString);
  }

  static Future<List<Expense>> loadExpenses() async {
    final prefs = await SharedPreferences.getInstance();

    final String? jsonString = prefs.getString(_key);

    if (jsonString == null) return [];

    final List<dynamic> decoded = jsonDecode(jsonString);

    return decoded
        .map(
          (map) => Expense(
            id: map['id'],
            name: map['name'],
            amount: (map['amount'] as num).toDouble(),
            category: map['category'],
            date: DateTime.parse(map['date']),
          ),
        )
        .toList();
  }
}

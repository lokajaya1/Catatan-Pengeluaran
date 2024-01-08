import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_application_1/pages/edit.dart';
import 'package:flutter_application_1/pages/tambah_pengeluaran.dart';

class BudgetPage extends StatefulWidget {
  @override
  _BudgetPageState createState() => _BudgetPageState();
}

class _BudgetPageState extends State<BudgetPage> {
  double budgetAmount = 0;
  double totalExpense = 0;
  List<Map<String, dynamic>> pengeluaranList = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    dynamic response = await Supabase.instance.client
        .from('expense2')
        .select<List<Map<String, dynamic>>>();
    setState(() {
      pengeluaranList = response;
    });
  }

  List<Map<String, dynamic>> getExpensesByMonth() {
    return pengeluaranList.where((expense) {
      DateTime expenseDate = DateTime.parse(expense['date']);
      return expenseDate.month == DateTime.now().month &&
          expenseDate.year == DateTime.now().year;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Budgeting',
          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTotalBudgetCard(),
            SizedBox(height: 16),
            _buildTotalExpenseCard(),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _navigateToSetBudgetPage();
              },
              child: Text('Set Budget'),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalBudgetCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Total Budget',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          Text(
            'Rp ${budgetAmount.toStringAsFixed(0)}',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalExpenseCard() {
    double totalExpenseAmount = calculateTotalExpense();

    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Total Pengeluaran",
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          Text(
            "Rp ${totalExpenseAmount.toStringAsFixed(0)}",
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  double calculateTotalExpense() {
    return pengeluaranList.fold(0.0, (double previousValue, expense) {
      return previousValue + (expense['amount'] as double);
    });
  }

  void _navigateToSetBudgetPage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SetBudgetPage()),
    );

    if (result != null) {
      setState(() {
        budgetAmount = result;
      });
    }
  }

  void _navigateToExpensePage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ExpensePage()),
    );

    if (result != null) {
      setState(() {
        totalExpense += result.amount;
      });
    }
  }
}

class SetBudgetPage extends StatefulWidget {
  @override
  _SetBudgetPageState createState() => _SetBudgetPageState();
}

class _SetBudgetPageState extends State<SetBudgetPage> {
  TextEditingController _budgetController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Set Budget'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _budgetController,
              decoration: InputDecoration(labelText: 'Enter Budget Amount'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _setBudget();
              },
              child: Text('Set Budget'),
            ),
          ],
        ),
      ),
    );
  }

  void _setBudget() {
    double newBudget = double.tryParse(_budgetController.text) ?? 0;

    if (newBudget > 0) {
      Navigator.pop(context, newBudget);
    } else {
      // Show error message or handle invalid input
    }
  }
}

class ExpensePage extends StatefulWidget {
  @override
  _ExpensePageState createState() => _ExpensePageState();
}

class _ExpensePageState extends State<ExpensePage> {
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Expense'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _amountController,
              decoration: InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _saveExpense();
              },
              child: Text('Save Expense'),
            ),
          ],
        ),
      ),
    );
  }

  void _saveExpense() {
    String description = _descriptionController.text;
    double amount = double.tryParse(_amountController.text) ?? 0;

    if (description.isNotEmpty && amount > 0) {
      Navigator.pop(context, Expense(description: description, amount: amount));
    } else {
      // Show error message or handle invalid input
    }
  }
}

class Expense {
  final String description;
  final double amount;

  Expense({required this.description, required this.amount});
}

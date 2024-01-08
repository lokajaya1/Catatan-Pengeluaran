import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/colors.dart';
import 'package:flutter_application_1/pages/edit.dart';
import 'package:flutter_application_1/pages/tambah_pengeluaran.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> pengeluaranList = [];
  DateTime selectedMonth = DateTime.now();

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
      return expenseDate.month == selectedMonth.month &&
          expenseDate.year == selectedMonth.year;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light().copyWith(
        primaryColor: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
          ),
        ),
        colorScheme: ColorScheme.fromSwatch()
      ),
      home: Scaffold(
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Catatan\nPengeluaran",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                _buildMonthPicker(),
                _buildAddExpenseButton(),
                _buildExpenseList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMonthPicker() {
    return Row(
      children: [
        IconButton(
          icon: Icon(Icons.keyboard_arrow_left),
          onPressed: () {
            setState(() {
              selectedMonth = DateTime(
                selectedMonth.year,
                selectedMonth.month - 1,
              );
            });
          },
        ),
        Text(
          '${_getMonthName(selectedMonth.month)} ${selectedMonth.year}',
          style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        IconButton(
          icon: Icon(Icons.keyboard_arrow_right),
          onPressed: () {
            setState(() {
              selectedMonth = DateTime(
                selectedMonth.year,
                selectedMonth.month + 1,
              );
            });
          },
        ),
      ],
    );
  }

  String _getMonthName(int month) {
    switch (month) {
      case 1:
        return 'Januari';
      case 2:
        return 'Februari';
      case 3:
        return 'Maret';
      case 4:
        return 'April';
      case 5:
        return 'Mei';
      case 6:
        return 'Juni';
      case 7:
        return 'Juli';
      case 8:
        return 'Agustus';
      case 9:
        return 'September';
      case 10:
        return 'Oktober';
      case 11:
        return 'November';
      case 12:
        return 'Desember';
      default:
        return '';
    }
  }

  Widget _buildAddExpenseButton() {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => TambahPengeluaranPage(),
            ),
          ).then((value) {
            fetchData();
          });
        },
        child: Text("Tambah Pengeluaran"),
        style: ElevatedButton.styleFrom(
        ),
      ),
    );
  }

  Widget _buildTotalExpenseCard() {
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
            "Rp ${calculateTotalExpense()}",
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

  Widget _buildExpenseList() {
    List<Map<String, dynamic>> filteredExpenses = getExpensesByMonth();

    return Column(
      children: [
        _buildTotalExpenseCard(),
        SizedBox(height: 10),
        Text(
          "Daftar Pengeluaran",
          style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        SizedBox(height: 10),
        ...filteredExpenses.map(
          (pengeluaran) => Card(
            elevation: 3,
            margin: EdgeInsets.symmetric(vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: _buildExpenseItem(pengeluaran),
          ),
        ),
      ],
    );
  }

  Widget _buildExpenseItem(Map<String, dynamic> pengeluaran) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pengeluaran['description'],
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Rp ${pengeluaran['amount']}",
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Tanggal: ${formatDate(pengeluaran['date'])}",
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.edit,
                      color: Colors.orange,
                    ),
                    onPressed: () async {
                      Navigator.of(context)
                          .push(
                        MaterialPageRoute(
                          builder: (ctx) => EditPage(
                            id: pengeluaran['id'],
                            description: pengeluaran['description'],
                            amount: pengeluaran['amount'].toString(),
                          ),
                        ),
                      )
                          .then((value) {
                        fetchData();
                      });
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    onPressed: () async {
                      await Supabase.instance.client
                          .from('expense2')
                          .delete()
                          .match({"id": pengeluaran['id']});
                      fetchData();
                    },
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  String formatDate(String dateTime) {
    DateTime parsedDate = DateTime.parse(dateTime);
    return "${parsedDate.day} ${_getMonthName(parsedDate.month)} ${parsedDate.year}";
  }

  String calculateTotalExpense() {
    double total = 0;
    for (var expense in pengeluaranList) {
      total += expense['amount'];
    }
    return total.toString();
  }
}

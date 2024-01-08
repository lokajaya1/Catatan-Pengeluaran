import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/budget.dart';
import 'package:flutter_application_1/pages/home.dart';
import 'package:flutter_application_1/pages/login.dart';
import 'package:flutter_application_1/pages/tambah_pengeluaran.dart';
import 'package:flutter_application_1/pages/kategori.dart';
import 'package:flutter_application_1/components/colors.dart';
import 'package:get_storage/get_storage.dart';

class Bottom extends StatefulWidget {
  @override
  _BottomState createState() => _BottomState();
}

class _BottomState extends State<Bottom> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getCurrentPage(),
      floatingActionButton: _buildFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      backgroundColor: AppColors.light100,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 8.0,
        color: AppColors.light100, // Change background color
        child: Container(
          height: 60.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(
                  Icons.home,
                  color: _currentIndex == 0
                      ? AppColors.blue60 // Change selected color
                      : Colors.grey,
                ),
                onPressed: () {
                  _updateIndex(0);
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.wallet, // Ganti dengan ikon yang sesuai
                  color: _currentIndex == 1
                      ? AppColors.blue60 // Warna saat terpilih
                      : Colors.grey, // Warna saat tidak terpilih
                ),
                onPressed: () {
                  _updateIndex(1);
                },
              ),
              SizedBox(width: 40.0),
              IconButton(
                icon: Icon(
                  Icons.category,
                  color: _currentIndex == 3
                      ? AppColors.blue60 // Change selected color
                      : Colors.grey,
                ),
                onPressed: () {
                  _updateIndex(3);
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.logout,
                  color: Colors.red,
                ),
                onPressed: () {
                  final box = GetStorage();
                  box.remove('username');
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (ctx) => LoginPage()),
                      (route) => false);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getCurrentPage() {
    switch (_currentIndex) {
      case 0:
        return HomePage();
      case 1:
        return BudgetPage();
      case 2:
        return TambahPengeluaranPage();
      case 3:
        return KategoriPage();
      default:
        return HomePage();
    }
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        _updateIndex(2);
      },
      child: Icon(Icons.add, size: 32, color: AppColors.light100),
      backgroundColor: AppColors.blue60,
      elevation: 2,
    );
  }

  void _updateIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}

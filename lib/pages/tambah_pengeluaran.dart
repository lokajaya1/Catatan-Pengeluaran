import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/app_button.dart';
import 'package:flutter_application_1/components/app_text_field.dart';
import 'package:flutter_application_1/pages/bottom.dart';
import 'package:flutter_application_1/pages/home.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TambahPengeluaranPage extends StatefulWidget {
  @override
  _TambahPengeluaranPageState createState() => _TambahPengeluaranPageState();
}

class _TambahPengeluaranPageState extends State<TambahPengeluaranPage> {
  final TextEditingController keteranganController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  DateTime? selectedDate;
  String? selectedCategory;

  void resetForm() {
    keteranganController.clear();
    amountController.clear();
    selectedDate = null;
    selectedCategory = null;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light().copyWith(
        primaryColor: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        colorScheme:
            ColorScheme.fromSwatch().copyWith(secondary: Colors.blueAccent),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            "Catat Pengeluaran",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => Bottom()),
              );
            },
          ),
        ),
        body: Container(
          padding: EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                AppTextField(
                  controller: keteranganController,
                  label: "Keterangan",
                ),
                SizedBox(height: 20),
                AppTextField(
                  controller: amountController,
                  label: "Jumlah Pengeluaran",
                ),
                SizedBox(height: 20),
                ListTile(
                  title: Text(
                    'Tanggal',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  subtitle: selectedDate != null
                      ? Text(
                          '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        )
                      : Text(
                          'Pilih Tanggal',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: selectedDate ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );

                    if (pickedDate != null && pickedDate != selectedDate) {
                      setState(() {
                        selectedDate = pickedDate;
                      });
                    }
                  },
                ),
                SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  items: [
                    DropdownMenuItem(
                      value: 'Makan',
                      child: Text('Makan'),
                    ),
                    DropdownMenuItem(
                      value: 'Belanja',
                      child: Text('Belanja'),
                    ),
                    DropdownMenuItem(
                      value: 'Tagihan',
                      child: Text('Tagihan'),
                    ),
                    DropdownMenuItem(
                      value: 'Lainnya',
                      child: Text('Lainnya'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Kategori',
                  ),
                ),
                SizedBox(height: 20),
                AppButton(
                  onPressed: () async {
                    if (selectedDate != null && selectedCategory != null) {
                      await Supabase.instance.client.from('expense2').insert({
                        'amount': int.parse(amountController.text),
                        'description': keteranganController.text,
                        'date': selectedDate!.toIso8601String(),
                        'category': selectedCategory,
                      });
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (_) => Bottom()));
                    } else {
                      print('Please select a date and category');
                    }
                  },
                  text: "Simpan",
                  color: Colors.blue,
                ),
                SizedBox(height: 10),
                AppButton(
                  text: "Reset",
                  color: Colors.grey.shade200,
                  textColor: Colors.black,
                  onPressed: () {
                    resetForm();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

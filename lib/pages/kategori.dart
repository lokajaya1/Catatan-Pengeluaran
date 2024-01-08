import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/app_button.dart';
import 'package:flutter_application_1/components/app_text_field.dart';
import 'package:flutter_application_1/pages/bottom.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class KategoriPage extends StatefulWidget {
  @override
  _KategoriPageState createState() => _KategoriPageState();
}

class _KategoriPageState extends State<KategoriPage> {
  final TextEditingController namaKategoriController = TextEditingController();

  void resetForm() {
    namaKategoriController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(), // Change to light theme
      home: Scaffold(
               appBar: AppBar(
          title: Text(
            "Tambah Kategori",
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
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 50,
                ),
                AppTextField(
                  controller: namaKategoriController,
                  label: "Nama Kategori",
                ),
                const SizedBox(
                  height: 20,
                ),
                AppButton(
                  onPressed: () async {
                    if (namaKategoriController.text.isNotEmpty) {
                      await Supabase.instance.client
                          .from('kategori_pengeluaran')
                          .insert({
                        'nama_kategori': namaKategoriController.text,
                      });

                      // Optional: Add any navigation or UI updates after saving the category

                      // Reset the form
                      resetForm();
                    } else {
                      // Handle case where category name is empty
                      print('Nama Kategori tidak boleh kosong');
                    }
                  },
                  text: "Simpan",
                  color: Colors.blue, // Change button color
                ),
                SizedBox(
                  height: 5,
                ),
                AppButton(
                  text: "Reset",
                  color: Colors.grey.shade200,
                  textColor: Colors.black,
                  onPressed: () {
                    resetForm();
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "Data Kategori Pengeluaran",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black, // Change text color
                  ),
                ),
                FutureBuilder(
                  future: Supabase.instance.client
                      .from('kategori_pengeluaran')
                      .select()
                      .execute(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text("Error: ${snapshot.error}");
                    } else if (!snapshot.hasData ||
                        snapshot.data!.data == null) {
                      return Text("No data available");
                    } else {
                      List<dynamic> categories = snapshot.data!.data!;
                      return Column(
                        children: categories.map((category) {
                          return Card(
                            elevation: 3,
                            margin: EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 16,
                            ),
                            child: ListTile(
                              title: Text(category['nama_kategori']),
                              // Add more fields if needed
                            ),
                          );
                        }).toList(),
                      );
                    }
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

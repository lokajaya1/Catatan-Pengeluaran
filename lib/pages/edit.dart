import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/app_button.dart';
import 'package:flutter_application_1/components/app_text_field.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditPage extends StatefulWidget {
  final String description;
  final String amount;
  final int id;

  const EditPage({
    Key? key,
    required this.amount,
    required this.description,
    required this.id,
  }) : super(key: key);

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  TextEditingController keteranganController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    keteranganController.text = widget.description;
    amountController.text = widget.amount;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light().copyWith( // Use light theme
        primaryColor: Colors.blue, colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.blueAccent), // Set the accent color
      ),
      home: Scaffold(
        body: Container(
          padding: EdgeInsets.all(20),
          color: Colors.white, // Set the background color
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Edit Page",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.black, // Set the text color
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.black, // Set the icon color
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                AppTextField(
                  controller: keteranganController,
                  label: "Keterangan",
                ),
                const SizedBox(
                  height: 20,
                ),
                AppTextField(
                  controller: amountController,
                  label: "Jumlah Pengeluaran",
                ),
                const SizedBox(
                  height: 20,
                ),
                // Date Picker
                ListTile(
                  title: Text(
                    'Tanggal',
                    style: TextStyle(
                      color: Colors.black, // Set the text color
                      fontSize: 16,
                    ),
                  ),
                  subtitle: selectedDate != null
                      ? Text(
                          '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
                          style: TextStyle(
                            color: Colors.black, // Set the text color
                          ),
                        )
                      : Text(
                          'Pilih Tanggal',
                          style: TextStyle(
                            color: Colors.black, // Set the text color
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
                const SizedBox(
                  height: 20,
                ),
                AppButton(
                  text: "Simpan",
                  color: Colors.blue, // Set the button color
                  onPressed: () async {
                    // Use selectedDate in your Supabase update
                    await Supabase.instance.client.from('expense2').update(
                      {
                        'description': keteranganController.text,
                        'amount': amountController.text,
                        'date': selectedDate?.toIso8601String(),
                      },
                    ).match(
                      {'id': widget.id},
                    );
                    Navigator.of(context).pop();
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

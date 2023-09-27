import 'package:flutter/material.dart';
import 'package:flutter_sertifikasi/DatabaseHandler/database_instance.dart';
import 'package:intl/intl.dart';

class CreatePemasukan extends StatefulWidget {
  const CreatePemasukan({Key? key}) : super(key: key);

  @override
  State<CreatePemasukan> createState() => _CreatePemasukanState();
}

class _CreatePemasukanState extends State<CreatePemasukan> {
  DatabaseInstance databaseInstance = DatabaseInstance();
  TextEditingController tanggalController = TextEditingController();
  TextEditingController nominalController = TextEditingController();
  TextEditingController keteranganController = TextEditingController();
  int _value = 1;

  @override
  void initState() {
    // TODO: implement initState
    databaseInstance.database();
    // tanggalController.text = "01-01-2021";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Input Pemasukan Anda"),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Tanggal"),
            TextField(
              controller: tanggalController,
              readOnly: true,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2050),
                );
                if (pickedDate != null) {
                  String formatDate =
                      DateFormat('dd-MM-yyyy').format(pickedDate);
                  setState(() {
                    tanggalController.text = formatDate;
                  });
                } else {
                  tanggalController.text = "";
                }
              },
            ),
            SizedBox(
              height: 8,
            ),
            Text("Tipe Transaksi"),
            ListTile(
              title: Text("Pemasukan"),
              leading: Radio(
                  groupValue: _value,
                  value: 1,
                  onChanged: (value) {
                    setState(() {
                      _value = int.parse(value.toString());
                    });
                  }),
            ),
            SizedBox(
              height: 8,
            ),
            Text("Nominal"),
            TextField(
              controller: nominalController,
            ),
            SizedBox(
              height: 8,
            ),
            Text("Keterangan"),
            TextField(
              controller: keteranganController,
            ),
            SizedBox(
              height: 8,
            ),
            Container(
              width: 1000,
              child: Container(
                width: 1000,
                child: ElevatedButton(
                  onPressed: () {
                    tanggalController.text =
                        "01-01-2021"; // Set tanggal ke "01-01-2021"
                    nominalController.text = ""; // Kosongkan isian nominal
                    keteranganController.text =
                        ""; // Kosongkan isian keterangan
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.amber,
                  ),
                  child: Text("Reset"),
                ),
              ),
            ),
            Container(
              width: 1000,
              child: ElevatedButton(
                  onPressed: () async {
                    int idInsert = await databaseInstance.insert({
                      'tanggal': tanggalController.text,
                      'type': _value,
                      'nominal': nominalController.text,
                      'keterangan': keteranganController.text,
                    });
                    print("sudah masuk : " + idInsert.toString());
                    Navigator.pop(context);
                  },
                  child: Text("Simpan")),
            ),
            Container(
              width: 1000,
              child: ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                  ),
                  child: Text("Kembali")),
            ),
          ],
        ),
      )),
    );
  }
}

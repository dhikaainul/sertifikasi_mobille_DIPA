import 'package:flutter/material.dart';
import 'package:flutter_sertifikasi/DatabaseHandler/database_instance.dart';
import 'package:flutter_sertifikasi/Model/transaksi_model.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DatabaseInstance? databaseInstance;

  Future _refresh() async {
    setState(() {});
  }

  @override
  void initState() {
    databaseInstance = DatabaseInstance();
    initDatabase();
    super.initState();
  }

  Future initDatabase() async {
    await databaseInstance!.database();
    setState(() {});
  }

  showAlertDialog(BuildContext contex, int idTransaksi) {
    Widget okButton = TextButton(
      child: Text("Yakin"),
      onPressed: () {
        //delete disini
        databaseInstance!.hapus(idTransaksi);
        Navigator.of(contex, rootNavigator: true).pop();
        setState(() {});
      },
    );

    AlertDialog alertDialog = AlertDialog(
      title: Text("Peringatan !"),
      content: Text("Anda yakin akan menghapus ?"),
      actions: [okButton],
    );

    showDialog(
        context: contex,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail Cash Flow"),
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: SafeArea(
            child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            FutureBuilder<List<TransaksiModel>?>(
                future: databaseInstance?.getAll(),
                builder: (context, snapshot) {
                  print('HASIL : ' + snapshot.data.toString());
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text("Loading");
                  } else {
                    if (snapshot.hasData) {
                      return Expanded(
                        child: ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            final transaction = snapshot.data![index];
                            final isPemasukan = transaction.type == 1;

                            return Card(
                              elevation:
                                  3, // Atur elevasi kartu sesuai keinginan Anda
                              margin: EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 16),
                              child: ListTile(
                                leading: isPemasukan
                                    ? Icon(Icons.arrow_back,
                                        color: Colors.green)
                                    : Icon(Icons.arrow_forward_rounded,
                                        color: Colors.red),
                                title: Text("Nominal: ${transaction.nominal}"),
                                subtitle:
                                    Text("Tanggal: ${transaction.tanggal}"),
                                trailing: Text(
                                    "Keterangan: ${transaction.keterangan}"),
                              ),
                            );
                          },
                        ),
                      );
                    } else {
                      return Text("Tidak ada data");
                    }
                  }
                })
          ],
        )),
      ),
    );
  }
}

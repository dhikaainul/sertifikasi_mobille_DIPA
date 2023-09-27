import 'package:flutter/material.dart';
import 'package:flutter_sertifikasi/DatabaseHandler/database_instance.dart';
import 'package:flutter_sertifikasi/Screens/create_pemasukan.dart';
import 'package:flutter_sertifikasi/Screens/create_pengeluaran.dart';
import 'package:flutter_sertifikasi/Screens/daftarpemasukanpengeluaran.dart';
import 'package:flutter_sertifikasi/Screens/pengaturan.dart';

class Beranda extends StatefulWidget {
  const Beranda({Key? key}) : super(key: key);

  @override
  State<Beranda> createState() => _BerandaState();
}

class _BerandaState extends State<Beranda> {
  DatabaseInstance? databaseTotalTransaksi;

  Future _refresh() async {
    setState(() {});
  }

  @override
  void initState() {
    databaseTotalTransaksi = DatabaseInstance();
    initDatabase();
    super.initState();
  }

  Future initDatabase() async {
    await databaseTotalTransaksi!.database();
    setState(() {});
  }

  showAlertDialog(BuildContext contex, int idTransaksi) {
    Widget okButton = TextButton(
      child: Text("Yakin"),
      onPressed: () {
        //delete disini
        databaseTotalTransaksi!.hapus(idTransaksi);
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
      appBar: AppBar(title: Center(child: Text("Rangkuman Bulan Ini"))),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              FutureBuilder(
                  future: databaseTotalTransaksi!.totalPengeluaran(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text(
                        "-",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            foreground: Paint()..color = Colors.red),
                        textAlign: TextAlign.center,
                      );
                    } else {
                      if (snapshot.hasData) {
                        return Text(
                          "Total Pengeluaran : Rp. ${snapshot.data.toString()}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              foreground: Paint()..color = Colors.red),
                          textAlign: TextAlign.center,
                        );
                      } else {
                        return Text("");
                      }
                    }
                  }),
              FutureBuilder(
                  future: databaseTotalTransaksi!.totalPemasukan(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text(
                        "-",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            foreground: Paint()..color = Colors.green),
                        textAlign: TextAlign.center,
                      );
                    } else {
                      if (snapshot.hasData) {
                        return Text(
                          "Total Pemasukan : Rp. ${snapshot.data.toString()}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              foreground: Paint()..color = Colors.green),
                          textAlign: TextAlign.center,
                        );
                      } else {
                        return Text("");
                      }
                    }
                  }),
              SizedBox(
                height: 20,
              ),
              Container(
                padding: const EdgeInsets.only(top: 5),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  child: Image.asset(
                    'assets/images/diagram.jpg',
                    width: 700,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  children: <Widget>[
                    Column(
                      children: [
                        Container(
                          height: 180,
                          child: Card(
                            elevation: 15,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            CreatePemasukan()));
                              },
                              splashColor: Colors.lightBlueAccent,
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10.0),
                                      child: Image.asset(
                                        'assets/images/salary.png',
                                        height: 100,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            margin: const EdgeInsets.only(
                                left: 20.0, right: 20.0, top: 5.0, bottom: 10),
                          ),
                        ),
                        Text(
                          'Tambah Pemasukan',
                          style: TextStyle(fontSize: 12.0),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                          height: 180,
                          child: Card(
                            elevation: 15,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CreatePengeluaran(),
                                  ),
                                );
                              },
                              splashColor: Colors.lightBlueAccent,
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10.0),
                                      child: Image.asset(
                                        'assets/images/income.png',
                                        height: 100,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            margin: const EdgeInsets.only(
                                left: 20.0, right: 20.0, top: 5.0, bottom: 10),
                          ),
                        ),
                        Text(
                          'Tambah Pengeluaran',
                          style: TextStyle(fontSize: 12.0),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                          height: 180,
                          child: Card(
                            elevation: 15,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MyHomePage(),
                                  ),
                                );
                              },
                              splashColor: Colors.lightBlueAccent,
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10.0),
                                      child: Image.asset(
                                        'assets/images/research.png',
                                        height: 100,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            margin: const EdgeInsets.only(
                                left: 20.0, right: 20.0, top: 5.0, bottom: 10),
                          ),
                        ),
                        Text(
                          'Detail Cash Flow',
                          style: TextStyle(fontSize: 12.0),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                          height: 180,
                          child: Card(
                            elevation: 15,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Profil(),
                                  ),
                                );
                              },
                              splashColor: Colors.lightBlueAccent,
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10.0),
                                      child: Image.asset(
                                        'assets/images/gear.png',
                                        height: 100,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            margin: const EdgeInsets.only(
                                left: 20.0, right: 20.0, top: 5.0, bottom: 10),
                          ),
                        ),
                        Text(
                          'Pengaturan',
                          style: TextStyle(fontSize: 12.0),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

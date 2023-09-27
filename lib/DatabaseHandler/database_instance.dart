import 'dart:io';
import 'package:flutter_sertifikasi/Model/transaksi_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseInstance {
  final String databaseName = "dika3.db";
  final int databaseVersion = 2;

  // Atribut di Model Transaksi
  final String namaTabel = 'totalpemasukanpengeluaran3';
  final String id = 'id';
  final String type = 'type';
  final String tanggal = 'tanggal';
  final String nominal = 'nominal';
  final String keterangan = 'keterangan';

  Database? _database;
  Future<Database> database() async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory databaseDirectory = await getApplicationDocumentsDirectory();
    String path = join(databaseDirectory.path, databaseName);
    print('database init');
    return openDatabase(path, version: databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE ${namaTabel} ($id INTEGER PRIMARY KEY, $tanggal TEXT NULL, $type INTEGER, $nominal INTEGER, $keterangan TEXT NULL)');
  }

  Future<List<TransaksiModel>?> getAll() async {
    final data = await _database?.query(namaTabel);
    List<TransaksiModel>? result =
        data?.map((e) => TransaksiModel.fromJson(e)).toList();
    return result;
  }

  Future<int> insert(Map<String, dynamic> row) async {
    final query = await _database!.insert(namaTabel, row);
    return query;
  }

  Future<int> totalPemasukan() async {
    final query = await _database?.rawQuery(
        "SELECT SUM(nominal) as total FROM $namaTabel WHERE type = 1");

    if (query != null && query.isNotEmpty) {
      final totalString = query.first['total'].toString();
      if (totalString.isNotEmpty) {
        final totalDouble = double.tryParse(totalString);
        if (totalDouble != null) {
          return totalDouble.toInt();
        } else {
          // Penanganan jika nilai tidak dapat di-parse sebagai double
          return 0; // Atau nilai default yang sesuai
        }
      }
    }
    // Penanganan jika query null, kosong, atau nilai total kosong
    return 0; // Atau nilai default yang sesuai
  }

  Future<int> totalPengeluaran() async {
    final query = await _database?.rawQuery(
        "SELECT SUM(nominal) as total FROM $namaTabel WHERE type = 2");

    if (query != null && query.isNotEmpty) {
      final totalString = query.first['total'].toString();
      if (totalString.isNotEmpty) {
        final totalDouble = double.tryParse(totalString);
        if (totalDouble != null) {
          return totalDouble.toInt();
        } else {
          // Penanganan jika nilai tidak dapat di-parse sebagai double
          return 0; // Atau nilai default yang sesuai
        }
      }
    }
    // Penanganan jika query null, kosong, atau nilai total kosong
    return 0; // Atau nilai default yang sesuai
  }

  Future<int> hapus(idTransaksi) async {
    final query = await _database!
        .delete(namaTabel, where: '$id = ?', whereArgs: [idTransaksi]);

    return query;
  }

  Future<int> update(int idTransaksi, Map<String, dynamic> row) async {
    final query = await _database!
        .update(namaTabel, row, where: '$id = ?', whereArgs: [idTransaksi]);
    return query;
  }
}

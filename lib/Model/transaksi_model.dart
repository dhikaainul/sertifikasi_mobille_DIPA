class TransaksiModel {
  /*
  tipe
  1 -> pemasukan
  2 -> pengeluaran
  */
  int? id, type, nominal;
  String? keterangan, tanggal;
  TransaksiModel(
      {this.id, this.type, this.nominal, this.keterangan, this.tanggal});

  factory TransaksiModel.fromJson(Map<String, dynamic> json) {
    return TransaksiModel(
        id: json['id'],
        type: json['type'],
        nominal: json['nominal'],
        keterangan: json['keterangan'],
        tanggal: json['tanggal']);
  }
}

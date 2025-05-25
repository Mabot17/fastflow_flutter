class TransaksiModel {
  final int id;
  final String noFaktur;
  final String tanggal;
  final double totalBayar;
  final String caraBayar;

  TransaksiModel({
    required this.id,
    required this.noFaktur,
    required this.tanggal,
    required this.totalBayar,
    required this.caraBayar,
  });

  factory TransaksiModel.fromMap(Map<String, dynamic> map) {
    return TransaksiModel(
      id: map['id'] as int,
      noFaktur: map['no_faktur'] ?? '',
      tanggal: map['tanggal'] ?? '',
      totalBayar: (map['total_bayar'] as num).toDouble(),
      caraBayar: map['cara_bayar'] ?? '',
    );
  }
}
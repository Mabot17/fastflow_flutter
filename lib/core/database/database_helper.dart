import 'package:sqflite/sqflite.dart';
import 'dart:async';
import '/core/services/storage_service.dart'; // Import StorageService
import 'package:intl/intl.dart'; // Add intl package for date formatting

class DatabaseHelper {
  final StorageService _storage = StorageService(); // Pakai StorageService
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  Database? _database;

  // Getter database untuk memastikan kita dapat mengakses DB yang aktif
  Future<Database> get database async {
    if (_database == null) {
       throw Exception('Database belum diinisialisasi. Pastikan untuk membuka database terlebih dahulu.');
    }
    return _database!;
  }

  // Membuka database dari path yang disimpan atau baru
  Future<Database> openDatabaseFromPath(String path) async {
    await closeDatabase(); // Tutup db sebelumnya jika ada
    _database = await openDatabase(path);
    return _database!;
  }

  // Init koneksi berdasarkan koneksi DB di path yang sudah disimpan
  Future<void> initDatabaseOffline() async {
    final savedPath = await _storage.read('offline_db_path');
    if (savedPath != null) {
      try {
        await openDatabaseFromPath(savedPath);
        print("✅ [Database] Opened from saved path: $savedPath");

        // ✅ Cek apakah tabel 'transaksi' sudah ada
        final existingTables = await getAllTables();

        if (!existingTables.contains('transaksi') || !existingTables.contains('transaksi_detail')) {
          print("ℹ️ [Database] Beberapa tabel belum ada. Membuat tabel...");
          await createTables();
          await insertDummyDataPerTriwulan();
        } else {
          print("✅ [Database] Semua tabel sudah tersedia, skip create.");
        }

        print("Tabel List: $existingTables");
      } catch (e) {
        print("❌ [Database] Failed to open saved DB: $e");
      }
    } else {
      print("ℹ️ [Database] No saved path found");
    }
  }


  // Untuk mengakses database saat sudah terbuka
  Database? get currentDatabase => _database;

  // Menutup database yang terbuka
  Future<void> closeDatabase() async {
    await _database?.close();
    _database = null;
  }

  // Fungsi untuk mengambil semua tabel yang ada di database
  Future<List<String>> getAllTables() async {
    final db = await database; // Pastikan database sudah terbuka
    final result = await db.rawQuery('SELECT name FROM sqlite_master WHERE type="table"');
    return result.map((table) => table['name'] as String).toList();
  }

  // Fungsi umum untuk mengambil data dari tabel tertentu secara dinamis
  Future<List<Map<String, dynamic>>> getDataFromTable(String tableName) async {
    final db = await database;
    return await db.query(tableName);
  }

  // Fungsi untuk menambah data ke tabel tertentu secara dinamis
  Future<int> insertData(String tableName, Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert(tableName, data);
  }

  // Fungsi untuk menghapus data berdasarkan ID dari tabel tertentu
  Future<int> deleteData(String tableName, String idColumn, int id) async {
    final db = await database;
    return await db.delete(tableName, where: '$idColumn = ?', whereArgs: [id]);
  }

  // --- New Methods for Laporan Penjualan ---

  // Helper to format date for queries
  String _formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  // Helper to format month for queries
  String _formatMonth(DateTime date) {
    return DateFormat('yyyy-MM').format(date);
  }

  // Get transactions for a specific date
  Future<List<Map<String, dynamic>>> getTransactionsByDate(DateTime date) async {
    final db = await database;
    // Use only the date part for comparison (yyyy-MM-dd)
    final dateStr = DateFormat('yyyy-MM-dd').format(date);
    // Log for debugging
    print('[DatabaseHelper] Querying transactions for date: $dateStr');
    return await db.rawQuery('''
      SELECT t.*, SUM(td.qty) as total_items
      FROM transaksi t
      JOIN transaksi_detail td ON t.id = td.id_transaksi
      WHERE date(t.tanggal, 'localtime') = date(?, 'localtime')
      GROUP BY t.id
      ORDER BY t.tanggal DESC
    ''', [dateStr]);
  }

  // Get transactions for a specific month (individual transactions)
  // This method is used by the new monthly transactions list view
  Future<List<Map<String, dynamic>>> getTransactionsByMonth(DateTime date) async {
    final db = await database;
    final monthStr = _formatMonth(date);
    return await db.rawQuery('''
      SELECT t.*, SUM(td.qty) as total_items
      FROM transaksi t
      JOIN transaksi_detail td ON t.id = td.id_transaksi
      WHERE strftime('%Y-%m', t.tanggal) = ?
      GROUP BY t.id
      ORDER BY t.tanggal DESC
    ''', [monthStr]);
  }

  // Get transactions for a date range
  Future<List<Map<String, dynamic>>> getTransactionsByDateRange(DateTime startDate, DateTime endDate) async {
    final db = await database;
    final startDateStr = _formatDate(startDate);
    final endDateStr = _formatDate(endDate);
     return await db.rawQuery('''
      SELECT t.*, SUM(td.qty) as total_items
      FROM transaksi t
      JOIN transaksi_detail td ON t.id = td.id_transaksi
      WHERE date(t.tanggal) BETWEEN ? AND ?
      GROUP BY t.id
      ORDER BY t.tanggal DESC
    ''', [startDateStr, endDateStr]);
  }

  // --- New method for Monthly Aggregation ---
  Future<List<Map<String, dynamic>>> getMonthlyAggregatedSales(int year) async {
      final db = await database;
      return await db.rawQuery('''
        SELECT
          strftime('%Y-%m', tanggal) as sale_month,
          SUM(total_bayar) as monthly_total_sales,
          SUM(td.qty) as monthly_total_items
        FROM transaksi t
        JOIN transaksi_detail td ON t.id = td.id_transaksi
        WHERE strftime('%Y', tanggal) = ?
        GROUP BY sale_month
        ORDER BY sale_month DESC
      ''', [year.toString()]);
  }


  // Calculate total sales for a specific date
  Future<double> getTotalSalesByDate(DateTime date) async {
    final db = await database;
    final dateStr = _formatDate(date);
    final result = await db.rawQuery('''
      SELECT SUM(total_bayar) as total
      FROM transaksi
      WHERE date(tanggal) = ?
    ''', [dateStr]);
    return (result.first['total'] as double?) ?? 0.0;
  }

  // Calculate total sales for a specific month
  // This method is kept but the monthly tab will use the new aggregation method
  Future<double> getTotalSalesByMonth(DateTime date) async {
    final db = await database;
    final monthStr = _formatMonth(date);
    final result = await db.rawQuery('''
      SELECT SUM(total_bayar) as total
      FROM transaksi
      WHERE strftime('%Y-%m', tanggal) = ?
    ''', [monthStr]);
    return (result.first['total'] as double?) ?? 0.0;
  }

  // Calculate total sales for a date range
  Future<double> getTotalSalesByDateRange(DateTime startDate, DateTime endDate) async {
    final db = await database;
    final startDateStr = _formatDate(startDate);
    final endDateStr = _formatDate(endDate);
    final result = await db.rawQuery('''
      SELECT SUM(total_bayar) as total
      FROM transaksi
      WHERE date(tanggal) BETWEEN ? AND ?
    ''', [startDateStr, endDateStr]);
    return (result.first['total'] as double?) ?? 0.0;
  }

   // Calculate total items sold for a specific date
  Future<int> getTotalItemsSoldByDate(DateTime date) async {
    final db = await database;
    final dateStr = _formatDate(date);
    final result = await db.rawQuery('''
      SELECT SUM(td.qty) as total
      FROM transaksi t
      JOIN transaksi_detail td ON t.id = td.id_transaksi
      WHERE date(t.tanggal) = ?
    ''', [dateStr]);
    return (result.first['total'] as int?) ?? 0;
  }

  // Calculate total items sold for a specific month
  // This method is kept but the monthly tab will use the new aggregation method
  Future<int> getTotalItemsSoldByMonth(DateTime date) async {
    final db = await database;
    final monthStr = _formatMonth(date);
    final result = await db.rawQuery('''
      SELECT SUM(td.qty) as total
      FROM transaksi t
      JOIN transaksi_detail td ON t.id = td.id_transaksi
      WHERE strftime('%Y-%m', t.tanggal) = ?
    ''', [monthStr]);
    return (result.first['total'] as int?) ?? 0;
  }

  // Calculate total items sold for a date range
  Future<int> getTotalItemsSoldByDateRange(DateTime startDate, DateTime endDate) async {
    final db = await database;
    final startDateStr = _formatDate(startDate);
    final endDateStr = _formatDate(endDate);
    final result = await db.rawQuery('''
      SELECT SUM(td.qty) as total
      FROM transaksi t
      JOIN transaksi_detail td ON t.id = td.id_transaksi
      WHERE date(t.tanggal) BETWEEN ? AND ?
    ''', [startDateStr, endDateStr]);
    return (result.first['total'] as int?) ?? 0;
  }


  Future<void> createTables() async {
    final db = await database;

    await db.execute('''
      CREATE TABLE IF NOT EXISTS transaksi (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        no_faktur TEXT UNIQUE,
        tanggal TEXT,
        total_bayar REAL,
        cara_bayar TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS transaksi_detail (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        id_transaksi INTEGER,
        produk_id INTEGER,
        produk_barcode TEXT,
        produk_nama TEXT,
        produk_sku TEXT,
        produk_plu TEXT,
        harga REAL,
        qty INTEGER,
        total REAL,
        url_image TEXT,
        FOREIGN KEY (id_transaksi) REFERENCES transaksi(id) ON DELETE CASCADE
      )
    ''');

    print("✅ [Database] Tabel transaksi & transaksi_detail berhasil dicek/dibuat.");
  }

  Future<void> insertDummyDataPerTriwulan() async {
    final db = await database;

    final List<int> bulanList = [1, 4, 7, 10]; // Januari, April, Juli, Oktober
    int transaksiCounter = 1;

    for (int bulan in bulanList) {
      for (int i = 1; i <= 20; i++) {
        String noFaktur = 'F2025${transaksiCounter.toString().padLeft(4, '0')}';
        String tanggal = DateTime(2025, bulan, (i % 28) + 1).toIso8601String();
        double totalBayar = 15000 + i * 500;
        String caraBayar = i % 3 == 0 ? 'QRIS' : i % 2 == 0 ? 'Cash' : 'Debit';

        // Insert transaksi
        int transaksiId = await db.insert('transaksi', {
          'no_faktur': noFaktur,
          'tanggal': tanggal,
          'total_bayar': totalBayar,
          'cara_bayar': caraBayar,
        });

        // Detail: 2 produk per transaksi
        for (int j = 0; j < 2; j++) {
          int qty = 1 + j;
          double harga = 7000 + (j * 150);
          double total = harga * qty;

          await db.insert('transaksi_detail', {
            'id_transaksi': transaksiId,
            'produk_id': j + 1,
            'produk_barcode': 'BRCD-${transaksiCounter * 10 + j}',
            'produk_nama': 'Produk Triwulan ${j + 1}',
            'produk_sku': 'SKU${j + 1}',
            'produk_plu': 'PLU${j + 1}',
            'harga': harga,
            'qty': qty,
            'total': total,
            'url_image': '',
          });
        }

        transaksiCounter++;
      }
    }

    print("✅ [Database] 80 data dummy transaksi (20 per 3 bulan) berhasil dimasukkan.");
  }
}

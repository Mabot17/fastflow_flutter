const String menuJson = '''
{
  "sections": [
    {
      "title": "Master",
      "items": [
        { "title": "Produk", "icon": "shopping_bag", "route": "/products_global" },
        { "title": "Kategori", "icon": "category", "route": "/categories" }
      ]
    },
    {
      "title": "Transaksi",
      "items": [
        { "title": "POS", "icon": "point_of_sale", "route": "/pos" }
      ]
    },
    {
      "title": "Laporan",
      "items": [
        { "title": "Laporan POS", "icon": "bar_chart", "route": "/report_pos" },
        { "title": "Laporan dashboard", "icon": "show_chart", "route": "/laporan_dashboard" },
        { "title": "Laporan Penjualan", "icon": "show_chart", "route": "/laporan_penjualan" }
      ]
    }
  ]
}
''';
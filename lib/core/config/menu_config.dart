const String menuJson = '''
{
  "sections": [
    {
      "title": "Master",
      "items": [
        { "title": "Produk", "icon": "shopping_bag", "route": "/products" },
        { "title": "Produk Global", "icon": "shopping_bag", "route": "/products_global" },
        { "title": "Scan Produk", "icon": "shopping_bag", "route": "/scan_produk" },
        { "title": "Satuan", "icon": "straighten", "route": "/units" },
        { "title": "Kategori", "icon": "category", "route": "/categories" },
        { "title": "Customer", "icon": "person", "route": "/customer" }
      ]
    },
    {
      "title": "Transaksi",
      "items": [
        { "title": "Order Penjualan", "icon": "receipt_long", "route": "/sales_orders" },
        { "title": "POS", "icon": "point_of_sale", "route": "/pos" },
        { "title": "Penjualan Produk", "icon": "shopping_cart", "route": "/product_sales" }
      ]
    },
    {
      "title": "Laporan",
      "items": [
        { "title": "Laporan Order", "icon": "assessment", "route": "/report_orders" },
        { "title": "Laporan POS", "icon": "bar_chart", "route": "/report_pos" },
        { "title": "Laporan Penjualan", "icon": "show_chart", "route": "/report_sales" },
        { "title": "Laporan Produk", "icon": "show_chart", "route": "/report_sales" }
      ]
    }
  ]
}
''';
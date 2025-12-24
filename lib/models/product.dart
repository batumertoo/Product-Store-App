class Product {
  final String barcodeNo;
  final String productName;
  final String category;
  final double unitPrice;
  final int taxRate;
  final double price;
  final int? stockInfo;

  Product({
    required this.barcodeNo,
    required this.productName,
    required this.category,
    required this.unitPrice,
    required this.taxRate,
    required this.price,
    this.stockInfo,
  });

  Map<String, dynamic> toMap() {
    return {
      'BarcodeNo': barcodeNo,
      'ProductName': productName,
      'Category': category,
      'UnitPrice': unitPrice,
      'TaxRate': taxRate,
      'Price': price,
      'StockInfo': stockInfo,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      barcodeNo: map['BarcodeNo'] as String,
      productName: map['ProductName'] as String,
      category: map['Category'] as String,
      unitPrice: map['UnitPrice'] as double,
      taxRate: map['TaxRate'] as int,
      price: map['Price'] as double,
      stockInfo: map['StockInfo'] as int?,
    );
  }

  Product copyWith({
    String? barcodeNo,
    String? productName,
    String? category,
    double? unitPrice,
    int? taxRate,
    double? price,
    int? stockInfo,
  }) {
    return Product(
      barcodeNo: barcodeNo ?? this.barcodeNo,
      productName: productName ?? this.productName,
      category: category ?? this.category,
      unitPrice: unitPrice ?? this.unitPrice,
      taxRate: taxRate ?? this.taxRate,
      price: price ?? this.price,
      stockInfo: stockInfo ?? this.stockInfo,
    );
  }
}
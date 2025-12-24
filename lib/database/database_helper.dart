import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/product.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('products.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE ProductTable (
        BarcodeNo TEXT PRIMARY KEY,
        ProductName TEXT NOT NULL,
        Category TEXT NOT NULL,
        UnitPrice REAL NOT NULL,
        TaxRate INTEGER NOT NULL,
        Price REAL NOT NULL,
        StockInfo INTEGER
      )
    ''');

    // Insert sample data
    await _insertSampleData(db);
  }

  Future<void> _insertSampleData(Database db) async {
    final sampleProducts = [
      {
        'BarcodeNo': '1234567890',
        'ProductName': 'Apple iPhone 15',
        'Category': 'Electronics',
        'UnitPrice': 999.99,
        'TaxRate': 18,
        'Price': 1179.99,
        'StockInfo': 25
      },
      {
        'BarcodeNo': '2345678901',
        'ProductName': 'Samsung Galaxy S24',
        'Category': 'Electronics',
        'UnitPrice': 899.99,
        'TaxRate': 18,
        'Price': 1061.99,
        'StockInfo': 30
      },
      {
        'BarcodeNo': '3456789012',
        'ProductName': 'Sony WH-1000XM5 Headphones',
        'Category': 'Audio',
        'UnitPrice': 349.99,
        'TaxRate': 18,
        'Price': 412.99,
        'StockInfo': 50
      },
      {
        'BarcodeNo': '4567890123',
        'ProductName': 'Nike Air Max 270',
        'Category': 'Footwear',
        'UnitPrice': 150.00,
        'TaxRate': 8,
        'Price': 162.00,
        'StockInfo': 100
      },
      {
        'BarcodeNo': '5678901234',
        'ProductName': 'Adidas Ultraboost 22',
        'Category': 'Footwear',
        'UnitPrice': 180.00,
        'TaxRate': 8,
        'Price': 194.40,
        'StockInfo': 75
      },
      {
        'BarcodeNo': '6789012345',
        'ProductName': 'Dell XPS 13 Laptop',
        'Category': 'Electronics',
        'UnitPrice': 1299.99,
        'TaxRate': 18,
        'Price': 1533.99,
        'StockInfo': 15
      },
      {
        'BarcodeNo': '7890123456',
        'ProductName': 'Logitech MX Master 3S Mouse',
        'Category': 'Accessories',
        'UnitPrice': 99.99,
        'TaxRate': 18,
        'Price': 117.99,
        'StockInfo': 200
      },
      {
        'BarcodeNo': '8901234567',
        'ProductName': 'Coca-Cola 6 Pack',
        'Category': 'Beverages',
        'UnitPrice': 5.99,
        'TaxRate': 8,
        'Price': 6.47,
        'StockInfo': 500
      },
      {
        'BarcodeNo': '9012345678',
        'ProductName': 'Organic Avocados (4 pack)',
        'Category': 'Food',
        'UnitPrice': 7.99,
        'TaxRate': 0,
        'Price': 7.99,
        'StockInfo': 150
      },
      {
        'BarcodeNo': '0123456789',
        'ProductName': 'Levi\'s 501 Jeans',
        'Category': 'Clothing',
        'UnitPrice': 69.99,
        'TaxRate': 8,
        'Price': 75.59,
        'StockInfo': 80
      },
      {
        'BarcodeNo': '1111111111',
        'ProductName': 'PlayStation 5 Console',
        'Category': 'Electronics',
        'UnitPrice': 499.99,
        'TaxRate': 18,
        'Price': 589.99,
        'StockInfo': 10
      },
      {
        'BarcodeNo': '2222222222',
        'ProductName': 'Kindle Paperwhite',
        'Category': 'Electronics',
        'UnitPrice': 139.99,
        'TaxRate': 18,
        'Price': 165.19,
        'StockInfo': 60
      },
      {
        'BarcodeNo': '3333333333',
        'ProductName': 'Starbucks Coffee Beans 1kg',
        'Category': 'Food',
        'UnitPrice': 24.99,
        'TaxRate': 8,
        'Price': 26.99,
        'StockInfo': 120
      },
      {
        'BarcodeNo': '4444444444',
        'ProductName': 'Ray-Ban Aviator Sunglasses',
        'Category': 'Accessories',
        'UnitPrice': 159.99,
        'TaxRate': 18,
        'Price': 188.79,
        'StockInfo': 45
      },
      {
        'BarcodeNo': '5555555555',
        'ProductName': 'The North Face Backpack',
        'Category': 'Accessories',
        'UnitPrice': 89.99,
        'TaxRate': 8,
        'Price': 97.19,
        'StockInfo': 70
      },
    ];

    for (var product in sampleProducts) {
      await db.insert('ProductTable', product);
    }
  }

  Future<void> insertProduct(Product product) async {
    final db = await database;
    await db.insert(
      'ProductTable',
      product.toMap(),
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  Future<List<Product>> getAllProducts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('ProductTable');
    return List.generate(maps.length, (i) => Product.fromMap(maps[i]));
  }

  Future<Product?> getProductByBarcode(String barcodeNo) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'ProductTable',
      where: 'BarcodeNo = ?',
      whereArgs: [barcodeNo],
    );

    if (maps.isEmpty) return null;
    return Product.fromMap(maps.first);
  }

  Future<void> updateProduct(Product product) async {
    final db = await database;
    await db.update(
      'ProductTable',
      product.toMap(),
      where: 'BarcodeNo = ?',
      whereArgs: [product.barcodeNo],
    );
  }

  Future<void> deleteProduct(String barcodeNo) async {
    final db = await database;
    await db.delete(
      'ProductTable',
      where: 'BarcodeNo = ?',
      whereArgs: [barcodeNo],
    );
  }

  Future close() async {
    final db = await database;
    db.close();
  }
}
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
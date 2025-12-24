import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../database/database_helper.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  Product? _searchedProduct;
  bool _isLoading = false;
  String _searchQuery = '';

  List<Product> get products => _searchQuery.isEmpty ? _products : _filteredProducts;
  Product? get searchedProduct => _searchedProduct;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;

  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<void> loadProducts() async {
    _isLoading = true;
    notifyListeners();

    try {
      _products = await _dbHelper.getAllProducts();
      _searchedProduct = null;
      if (_searchQuery.isNotEmpty) {
        _filterProducts(_searchQuery);
      }
    } catch (e) {
      debugPrint('Error loading products: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  void filterByBarcode(String query) {
    _searchQuery = query.trim();
    _searchedProduct = null;

    if (_searchQuery.isEmpty) {
      _filteredProducts = [];
    } else {
      _filterProducts(_searchQuery);
    }

    notifyListeners();
  }

  void _filterProducts(String query) {
    _filteredProducts = _products.where((product) {
      return product.barcodeNo.contains(query);
    }).toList();
  }

  Future<bool> searchByBarcode(String barcodeNo) async {
    try {
      _searchedProduct = await _dbHelper.getProductByBarcode(barcodeNo);
      notifyListeners();
      return _searchedProduct != null;
    } catch (e) {
      debugPrint('Error searching product: $e');
      return false;
    }
  }

  Future<String?> addProduct(Product product) async {
    try {
      await _dbHelper.insertProduct(product);
      await loadProducts();
      return null;
    } catch (e) {
      if (e.toString().contains('UNIQUE constraint failed')) {
        return 'A product with this barcode already exists!';
      }
      return 'Error adding product: $e';
    }
  }

  Future<String?> updateProduct(Product product) async {
    try {
      await _dbHelper.updateProduct(product);
      await loadProducts();
      return null;
    } catch (e) {
      return 'Error updating product: $e';
    }
  }

  Future<String?> deleteProduct(String barcodeNo) async {
    try {
      await _dbHelper.deleteProduct(barcodeNo);
      await loadProducts();
      return null;
    } catch (e) {
      return 'Error deleting product: $e';
    }
  }

  void clearSearch() {
    _searchedProduct = null;
    _searchQuery = '';
    _filteredProducts = [];
    notifyListeners();
  }
}
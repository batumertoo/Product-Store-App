import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../models/product.dart';
import 'product_form_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final TextEditingController _barcodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().loadProducts();
    });

    // Add listener for real-time filtering
    _barcodeController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _barcodeController.removeListener(_onSearchChanged);
    _barcodeController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    context.read<ProductProvider>().filterByBarcode(_barcodeController.text);
  }

  void _searchProduct() async {
    final barcode = _barcodeController.text.trim();
    if (barcode.isEmpty) {
      _showMessage('Please enter a barcode');
      return;
    }

    final provider = context.read<ProductProvider>();
    final found = await provider.searchByBarcode(barcode);

    if (!found && mounted) {
      _showAddProductDialog(barcode);
    }
  }

  void _showAddProductDialog(String barcode) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Product Not Found'),
        content: const Text('Would you like to add a new product?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _navigateToAddProduct(barcode);
            },
            child: const Text('Add Product'),
          ),
        ],
      ),
    );
  }

  void _navigateToAddProduct([String? barcode]) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductFormScreen(initialBarcode: barcode),
      ),
    );

    if (result == true) {
      _barcodeController.clear();
      if (mounted) {
        context.read<ProductProvider>().clearSearch();
      }
    }
  }

  void _navigateToEditProduct(Product product) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductFormScreen(product: product),
      ),
    );

    if (result == true && mounted) {
      context.read<ProductProvider>().clearSearch();
    }
  }

  void _deleteProduct(Product product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: Text('Are you sure you want to delete "${product.productName}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final error = await context.read<ProductProvider>().deleteProduct(product.barcodeNo);
              if (mounted) {
                if (error == null) {
                  _showMessage('Product deleted successfully');
                } else {
                  _showMessage(error);
                }
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Manager'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(child: _buildProductList()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddProduct(),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey[100],
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _barcodeController,
              decoration: InputDecoration(
                labelText: 'Search by Barcode',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.qr_code),
                suffixIcon: context.watch<ProductProvider>().searchQuery.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _barcodeController.clear();
                    context.read<ProductProvider>().clearSearch();
                  },
                )
                    : null,
              ),
              keyboardType: TextInputType.number,
              onSubmitted: (_) => _searchProduct(),
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton.icon(
            onPressed: _searchProduct,
            icon: const Icon(Icons.search),
            label: const Text('Search'),
          ),
        ],
      ),
    );
  }

  Widget _buildProductList() {
    return Consumer<ProductProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final productsToShow = provider.searchedProduct != null
            ? [provider.searchedProduct!]
            : provider.products;

        if (productsToShow.isEmpty) {
          if (provider.searchQuery.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.search_off, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    'No products found with barcode "${provider.searchQuery}"',
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            );
          }
          return const Center(
            child: Text('No products found. Add your first product!'),
          );
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 600) {
              return _buildDataTable(productsToShow);
            } else {
              return _buildListView(productsToShow);
            }
          },
        );
      },
    );
  }

  Widget _buildDataTable(List<Product> products) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Barcode')),
            DataColumn(label: Text('Product Name')),
            DataColumn(label: Text('Category')),
            DataColumn(label: Text('Unit Price')),
            DataColumn(label: Text('Tax Rate')),
            DataColumn(label: Text('Price')),
            DataColumn(label: Text('Stock')),
            DataColumn(label: Text('Actions')),
          ],
          rows: products.map((product) {
            final isHighlighted = context.watch<ProductProvider>().searchedProduct?.barcodeNo == product.barcodeNo;
            return DataRow(
              color: MaterialStateProperty.resolveWith<Color?>(
                    (states) => isHighlighted ? Colors.yellow[100] : null,
              ),
              cells: [
                DataCell(Text(product.barcodeNo)),
                DataCell(Text(product.productName)),
                DataCell(Text(product.category)),
                DataCell(Text('\$${product.unitPrice.toStringAsFixed(2)}')),
                DataCell(Text('${product.taxRate}%')),
                DataCell(Text('\$${product.price.toStringAsFixed(2)}')),
                DataCell(Text(product.stockInfo?.toString() ?? 'N/A')),
                DataCell(
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, size: 20),
                        onPressed: () => _navigateToEditProduct(product),
                        tooltip: 'Edit',
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                        onPressed: () => _deleteProduct(product),
                        tooltip: 'Delete',
                      ),
                    ],
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildListView(List<Product> products) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        final isHighlighted = context.watch<ProductProvider>().searchedProduct?.barcodeNo == product.barcodeNo;

        return Card(
          color: isHighlighted ? Colors.yellow[100] : null,
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        product.productName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _navigateToEditProduct(product),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteProduct(product),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                _buildInfoRow('Barcode:', product.barcodeNo),
                _buildInfoRow('Category:', product.category),
                _buildInfoRow('Unit Price:', '\$${product.unitPrice.toStringAsFixed(2)}'),
                _buildInfoRow('Tax Rate:', '${product.taxRate}%'),
                _buildInfoRow('Price:', '\$${product.price.toStringAsFixed(2)}'),
                _buildInfoRow('Stock:', product.stockInfo?.toString() ?? 'N/A'),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
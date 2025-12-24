import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/product_provider.dart';

class ProductFormScreen extends StatefulWidget {
  final Product? product;
  final String? initialBarcode;

  const ProductFormScreen({
    super.key,
    this.product,
    this.initialBarcode,
  });

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _barcodeController;
  late final TextEditingController _nameController;
  late final TextEditingController _categoryController;
  late final TextEditingController _unitPriceController;
  late final TextEditingController _taxRateController;
  late final TextEditingController _priceController;
  late final TextEditingController _stockController;

  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.product != null;

    _barcodeController = TextEditingController(
      text: widget.product?.barcodeNo ?? widget.initialBarcode ?? '',
    );
    _nameController = TextEditingController(text: widget.product?.productName ?? '');
    _categoryController = TextEditingController(text: widget.product?.category ?? '');
    _unitPriceController = TextEditingController(
      text: widget.product?.unitPrice.toString() ?? '',
    );
    _taxRateController = TextEditingController(
      text: widget.product?.taxRate.toString() ?? '',
    );
    _priceController = TextEditingController(
      text: widget.product?.price.toString() ?? '',
    );
    _stockController = TextEditingController(
      text: widget.product?.stockInfo?.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _barcodeController.dispose();
    _nameController.dispose();
    _categoryController.dispose();
    _unitPriceController.dispose();
    _taxRateController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  void _saveProduct() async {
    if (!_formKey.currentState!.validate()) return;

    final product = Product(
      barcodeNo: _barcodeController.text.trim(),
      productName: _nameController.text.trim(),
      category: _categoryController.text.trim(),
      unitPrice: double.parse(_unitPriceController.text.trim()),
      taxRate: int.parse(_taxRateController.text.trim()),
      price: double.parse(_priceController.text.trim()),
      stockInfo: _stockController.text.trim().isEmpty
          ? null
          : int.parse(_stockController.text.trim()),
    );

    final provider = context.read<ProductProvider>();
    String? error;

    if (_isEditing) {
      error = await provider.updateProduct(product);
    } else {
      error = await provider.addProduct(product);
    }

    if (mounted) {
      if (error == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_isEditing
                ? 'Product updated successfully'
                : 'Product added successfully'),
          ),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Product' : 'Add Product'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _barcodeController,
                decoration: const InputDecoration(
                  labelText: 'Barcode Number *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.qr_code),
                ),
                enabled: !_isEditing,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Barcode is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Product Name *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.shopping_bag),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Product name is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(
                  labelText: 'Category *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Category is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _unitPriceController,
                decoration: const InputDecoration(
                  labelText: 'Unit Price *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.attach_money),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Unit price is required';
                  }
                  final price = double.tryParse(value.trim());
                  if (price == null || price <= 0) {
                    return 'Please enter a valid positive price';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _taxRateController,
                decoration: const InputDecoration(
                  labelText: 'Tax Rate (%) *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.percent),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Tax rate is required';
                  }
                  final rate = int.tryParse(value.trim());
                  if (rate == null || rate < 0 || rate > 100) {
                    return 'Please enter a valid tax rate (0-100)';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(
                  labelText: 'Final Price *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.price_check),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Price is required';
                  }
                  final price = double.tryParse(value.trim());
                  if (price == null || price <= 0) {
                    return 'Please enter a valid positive price';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _stockController,
                decoration: const InputDecoration(
                  labelText: 'Stock Information (Optional)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.inventory),
                  helperText: 'Leave empty if not available',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value != null && value.trim().isNotEmpty) {
                    final stock = int.tryParse(value.trim());
                    if (stock == null || stock < 0) {
                      return 'Stock must be a non-negative number';
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Padding(
                        padding: EdgeInsets.all(16),
                        child: Text('Cancel'),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _saveProduct,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(_isEditing ? 'Update' : 'Save'),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
# mobileprogrammingproject4

# Product Manager App

A cross-platform Flutter application for managing products with barcode scanning, real-time search, and automatic price calculation.

## Features

### Core Functionality
- ✅ **Add, Edit, Delete Products** - Full CRUD operations for product management
- ✅ **Barcode Search** - Search products by barcode number with real-time filtering
- ✅ **Automatic Price Calculation** - Final price automatically calculated from unit price and tax rate
- ✅ **Stock Management** - Track product inventory with optional stock information
- ✅ **Responsive Design** - Adapts to mobile (list view) and desktop (table view) screens

### Key Features
- **Real-time Filtering**: As you type a barcode, the list instantly filters matching products
- **Numeric Barcode Validation**: Ensures barcodes contain only numbers
- **Tax Rate Support**: Calculate final prices with customizable tax rates (0-100%)
- **Cross-platform Database**: Works on Android, iOS, Windows, macOS, Linux, and Web
- **Sample Data**: Pre-loaded with 15 sample products for testing

## Screenshots

### Main Screen
- Product list with search functionality
- Real-time filtering as you type
- Responsive layout (cards on mobile, table on desktop)

### Add/Edit Product
- Form validation for all fields
- Automatic price calculation
- Barcode number restricted to digits only

## Installation

### Prerequisites
- Flutter SDK (3.0 or higher)
- Dart SDK (3.0 or higher)

### Dependencies
Add these to your `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  sqflite: ^2.3.0
  sqflite_common_ffi: ^2.3.0
  path: ^1.8.3
  provider: ^6.1.1

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0
```

### Setup

1. **Clone or create the project**
```bash
flutter create product_manager
cd product_manager
```

2. **Add dependencies**
```bash
flutter pub add sqflite sqflite_common_ffi path provider
```

3. **Project Structure**
```
lib/
├── main.dart
├── init_desktop.dart
├── init_mobile.dart
├── init_web.dart
├── models/
│   └── product.dart
├── database/
│   └── database_helper.dart
├── providers/
│   └── product_provider.dart
└── screens/
    ├── main_screen.dart
    └── product_form_screen.dart
```

4. **Run the app**
```bash
flutter run
```

## Usage

### Adding a Product
1. Click the **+** floating action button
2. Enter product details:
   - Barcode Number (numbers only)
   - Product Name
   - Category
   - Unit Price
   - Tax Rate (%)
   - Stock Information (optional)
3. Final price is automatically calculated
4. Click **Save**

### Searching Products
- **Real-time Search**: Start typing a barcode in the search field to filter products
- **Exact Search**: Enter complete barcode and click "Search" button
- **Clear Search**: Click the X button or clear the text field

### Editing a Product
1. Click the edit icon (✏️) on any product
2. Modify the fields (barcode cannot be changed)
3. Click **Update**

### Deleting a Product
1. Click the delete icon (🗑️) on any product
2. Confirm deletion in the dialog

## Database Schema

### ProductTable
| Column | Type | Constraints |
|--------|------|-------------|
| BarcodeNo | TEXT | PRIMARY KEY |
| ProductName | TEXT | NOT NULL |
| Category | TEXT | NOT NULL |
| UnitPrice | REAL | NOT NULL |
| TaxRate | INTEGER | NOT NULL |
| Price | REAL | NOT NULL |
| StockInfo | INTEGER | OPTIONAL |

## Platform Support

| Platform | Database Backend | Status |
|----------|-----------------|--------|
| Android | SQLite (native) | ✅ Supported |
| iOS | SQLite (native) | ✅ Supported |
| Windows | SQLite (FFI) | ✅ Supported |
| macOS | SQLite (FFI) | ✅ Supported |
| Linux | SQLite (FFI) | ✅ Supported |
| Web | IndexedDB | ✅ Supported |

## Sample Data

The app comes pre-loaded with 15 sample products across various categories:
- Electronics (iPhone, Samsung Galaxy, PlayStation 5, etc.)
- Footwear (Nike, Adidas)
- Accessories (Sunglasses, Backpack, Mouse)
- Food & Beverages (Coffee, Avocados, Coca-Cola)
- Clothing (Levi's Jeans)

**Note**: Sample data is only inserted on first app launch. To reset:
- Uninstall and reinstall the app, or
- Clear app data from device settings

## Price Calculation

The app automatically calculates the final price using the formula:

```
Final Price = Unit Price × (1 + Tax Rate ÷ 100)
```

**Examples**:
- Unit Price: $100, Tax Rate: 10% → Final Price: $110.00
- Unit Price: $50, Tax Rate: 8% → Final Price: $54.00
- Unit Price: $75, Tax Rate: 0% → Final Price: $75.00

## Technical Details

### State Management
- **Provider** pattern for reactive state management
- Separates business logic from UI

### Database
- **sqflite** for mobile platforms (Android/iOS)
- **sqflite_common_ffi** for desktop platforms (Windows/macOS/Linux)
- **IndexedDB** for web platform (via sqflite_common_ffi_web)

### Form Validation
- Required field validation
- Numeric validation for prices and tax rates
- Barcode format validation (numbers only)
- Stock quantity validation (non-negative integers)

## Troubleshooting

### Database not creating
- Check platform-specific initialization in `init_*.dart` files
- Ensure proper imports in `main.dart`

### Sample data not appearing
- Sample data only loads on first database creation
- Try uninstalling and reinstalling the app

### Search not working
- Ensure barcode field has focus
- Check that products exist in database

## Future Enhancements

Potential features for future versions:
- [ ] Barcode scanner integration (camera)
- [ ] Export/Import data (CSV, Excel)
- [ ] Product categories management
- [ ] Low stock alerts
- [ ] Product images
- [ ] Multi-currency support
- [ ] Sales tracking
- [ ] Reports and analytics

## License

This project is open source and available for educational purposes.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## Support

For issues or questions, please open an issue in the repository.

---

**Built with Flutter 💙**

# mobileprogrammingproject4
Batuhan Mert Yücetürk 42067670192
Kemal Furkan Saygılı 26923770332

# Product Manager App (barcode_product_app)

A cross-platform Flutter application for managing products with barcode search, real-time filtering, and automatic price calculation. Built with Flutter 3.0+ and Material Design 3.

## Features

### Core Functionality
- ✅ **Add, Edit, Delete Products** - Full CRUD operations for product management
- ✅ **Barcode Search** - Search products by barcode number with real-time filtering
- ✅ **Automatic Price Calculation** - Final price automatically calculated from unit price and tax rate
- ✅ **Stock Management** - Track product inventory with optional stock information
- ✅ **Responsive Design** - Adapts to mobile (list view) and desktop (table view) screens

### Key Features
- **Real-time Filtering**: As you type a barcode, the list instantly filters matching products using a reactive listener
- **Search Result Highlighting**: Found products are highlighted with a yellow background for easy identification
- **Numeric Barcode Validation**: Ensures barcodes contain only numbers using regex validation
- **Tax Rate Support**: Calculate final prices with customizable tax rates (0-100%)
- **Responsive Layout**: Automatically switches between card view (mobile, <600px) and table view (desktop, ≥600px)
- **Cross-platform Database**: Works on Android, iOS, Windows, macOS, Linux, and Web with platform-specific implementations
- **Sample Data**: Pre-loaded with 15 sample products across various categories for testing
- **Material Design 3**: Modern UI with Material 3 theming and deep purple color scheme

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
The project uses the following dependencies (defined in `pubspec.yaml`):

```yaml
dependencies:
  flutter:
    sdk: flutter
  sqflite: ^2.3.0           # SQLite for mobile platforms
  sqflite_common_ffi: ^2.3.0+1  # SQLite for desktop/web platforms
  path: ^1.8.3              # Path manipulation
  provider: ^6.1.1          # State management

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0     # Code linting
```

### Setup

1. **Clone the repository**
```bash
git clone https://github.com/batumertoo/Product-Store-App.git
cd Product-Store-App
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Run the app**
```bash
# For mobile/desktop
flutter run

# For web
flutter run -d chrome

# For specific platform
flutter run -d windows
flutter run -d macos
flutter run -d linux
```

## Usage

### Adding a Product
1. Click the **+** floating action button
2. Enter product details:
   - **Barcode Number** (numbers only, required)
   - **Product Name** (required)
   - **Category** (required)
   - **Unit Price** (required, positive decimal)
   - **Tax Rate (%)** (required, 0-100)
   - **Final Price** (auto-calculated and read-only)
   - **Stock Information** (optional, non-negative integer)
3. Final price is automatically calculated as: `Unit Price × (1 + Tax Rate ÷ 100)`
4. Click **Save** to add the product

### Searching Products
- **Real-time Filtering**: Start typing a barcode in the search field to instantly filter products as you type
- **Exact Search**: Enter complete barcode and click "Search" button to highlight the exact match
- **Clear Search**: Click the X button or clear the text field to reset the view
- **Visual Feedback**: Searched products are highlighted with a yellow background

### Editing a Product
1. Click the edit icon (✏️) on any product (blue edit button)
2. Modify the fields (note: barcode cannot be changed)
3. Final price recalculates automatically when unit price or tax rate changes
4. Click **Update** to save changes

### Deleting a Product
1. Click the delete icon (🗑️) on any product (red delete button)
2. Confirm deletion in the dialog
3. Product is permanently removed from the database

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

| Category | Products | Count |
|----------|----------|-------|
| Electronics | iPhone 15, Samsung Galaxy S24, PlayStation 5, Dell XPS 13, Kindle Paperwhite | 5 |
| Audio | Sony WH-1000XM5 Headphones | 1 |
| Footwear | Nike Air Max 270, Adidas Ultraboost 22 | 2 |
| Accessories | Logitech MX Master 3S Mouse, Ray-Ban Sunglasses, North Face Backpack | 3 |
| Food & Beverages | Coca-Cola 6 Pack, Organic Avocados, Starbucks Coffee Beans | 3 |
| Clothing | Levi's 501 Jeans | 1 |

**Sample Products Details:**
- Barcodes range from `1234567890` to `5555555555`
- Prices range from $5.99 (Coca-Cola) to $1299.99 (Dell XPS 13)
- Tax rates vary: 0% (fresh food), 8% (footwear/clothing/beverages), 18% (electronics/accessories)
- All products include stock information (10-500 units)

**Note**: Sample data is only inserted on first app launch when the database is created. To reset:
- **Option 1**: Uninstall and reinstall the app
- **Option 2**: Clear app data from device settings
- **Option 3**: Delete the database file manually (location varies by platform)

## Price Calculation

The app automatically calculates the final price using the formula:

```
Final Price = Unit Price × (1 + Tax Rate ÷ 100)
```

**Examples**:
- Unit Price: $100, Tax Rate: 10% → Final Price: $110.00
- Unit Price: $50, Tax Rate: 8% → Final Price: $54.00
- Unit Price: $75, Tax Rate: 0% → Final Price: $75.00

**Implementation Details:**
- Calculation happens in real-time using `TextEditingController` listeners
- The price field is read-only and auto-updates when unit price or tax rate changes
- Result is formatted to 2 decimal places for currency display
- Validation ensures unit price is positive and tax rate is between 0-100

## Key Features Implementation

### Real-time Search Filtering
- Uses `TextEditingController.addListener()` to detect text changes
- Filters products where barcode contains the search query
- Updates UI reactively through Provider's `notifyListeners()`
- Displays "No products found" message when filter returns empty results

### Responsive Layout
```dart
LayoutBuilder(
  builder: (context, constraints) {
    if (constraints.maxWidth > 600) {
      return _buildDataTable(productsToShow);  // Desktop view
    } else {
      return _buildListView(productsToShow);   // Mobile view
    }
  },
)
```

### Conditional Platform Initialization
The app uses Dart's conditional imports to load the correct initialization file:
```dart
import 'init_desktop.dart' if (dart.library.js_interop) 'init_web.dart';
```
- On web: Loads `init_web.dart` (uses IndexedDB)
- On desktop/mobile: Loads `init_desktop.dart` (uses SQLite with FFI for desktop)

### Highlight Found Products
When a product is found via search, it's highlighted with a yellow background:
```dart
color: MaterialStateProperty.resolveWith<Color?>(
  (states) => isHighlighted ? Colors.yellow[100] : null,
)
```

## Technical Details

### Architecture
- **Package Name**: `barcode_product_app`
- **State Management**: Provider pattern with `ChangeNotifier` for reactive state management
- **Design Pattern**: Separation of concerns with models, providers, database, and UI layers
- **UI Framework**: Material Design 3 with responsive layout

### Project Structure
```
lib/
├── main.dart                  # App entry point with conditional imports
├── init_desktop.dart          # Desktop/mobile database initialization
├── init_mobile.dart           # Mobile-specific (currently unused, delegated to init_desktop)
├── init_web.dart              # Web platform initialization
├── models/
│   └── product.dart           # Product data model with serialization
├── database/
│   └── database_helper.dart   # SQLite database operations & sample data
├── providers/
│   └── product_provider.dart  # State management & business logic
└── screens/
    ├── main_screen.dart       # Main product list with search
    └── product_form_screen.dart  # Add/Edit product form
```

### State Management
- **Provider** pattern for reactive state management
- `ProductProvider` extends `ChangeNotifier` for UI updates
- Separates business logic from UI layer
- Efficient rebuilds with `Consumer` and `context.watch()`

### Database Implementation
The app uses conditional platform-specific database initialization:

1. **Mobile (Android/iOS)**: Uses native `sqflite` without additional initialization
2. **Desktop (Windows/macOS/Linux)**: Uses `sqflite_common_ffi` with FFI initialization
3. **Web**: Uses IndexedDB through `sqflite_common_ffi_web` (automatic)

The conditional import in `main.dart` uses Dart's conditional compilation:
```dart
import 'init_desktop.dart' if (dart.library.js_interop) 'init_web.dart';
```

### Responsive Design
- **Breakpoint**: 600px width
- **Mobile View** (<600px): Card-based list with vertical scrolling
- **Desktop View** (≥600px): Data table with horizontal scrolling
- Uses `LayoutBuilder` to detect screen width and adapt UI

### Form Validation
- **Required field validation** for barcode, name, category, unit price, and tax rate
- **Numeric validation** for prices (positive decimals) and tax rates (0-100 integers)
- **Barcode format validation** using regex: `^[0-9]+$` (numbers only)
- **Stock quantity validation**: Non-negative integers or empty (optional)
- **Real-time price calculation** using text controller listeners

## Troubleshooting

### Database not creating
- **Desktop platforms**: Ensure `sqflite_common_ffi` is properly installed
- **Check initialization**: Verify platform-specific initialization in `init_desktop.dart` or `init_web.dart`
- **Permissions**: On mobile, ensure app has storage permissions (usually automatic)

### Sample data not appearing
- Sample data only loads on first database creation
- Try uninstalling and reinstalling the app to recreate the database
- Check for errors in the console/debug output

### Search not working
- Ensure barcode field has focus before typing
- Check that products exist in database (they should load on startup)
- Verify the barcode contains only numbers (letters will not match)

### Build errors
- Run `flutter pub get` to ensure all dependencies are installed
- For desktop platforms, ensure you have the necessary build tools:
  - **Windows**: Visual Studio with C++ development tools
  - **macOS**: Xcode and command-line tools
  - **Linux**: CMake, Ninja, GTK development libraries
- Clear build cache: `flutter clean && flutter pub get`

### Real-time filtering not responding
- Check that `TextEditingController` listener is properly attached
- Verify the `ProductProvider` is properly registered in the widget tree
- Ensure `notifyListeners()` is called in the provider methods

## Future Enhancements

Potential features for future versions:
- [ ] **Barcode scanner integration** - Use camera to scan physical barcodes
- [ ] **Export/Import data** - CSV, Excel, or JSON format support
- [ ] **Category management** - Add, edit, delete product categories
- [ ] **Low stock alerts** - Notifications when inventory runs low
- [ ] **Product images** - Add photos for each product
- [ ] **Multi-currency support** - Support for different currencies and exchange rates
- [ ] **Sales tracking** - Record and track product sales
- [ ] **Reports and analytics** - Generate sales reports, inventory analysis, and trends
- [ ] **Batch operations** - Update or delete multiple products at once
- [ ] **User authentication** - Multi-user support with login system
- [ ] **Dark mode** - Theme switching between light and dark modes
- [ ] **Print functionality** - Print product labels or inventory lists
- [ ] **Cloud sync** - Backup and sync data across devices

## License

This project is open source and available for educational purposes.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## Support

For issues or questions, please open an issue in the repository.

---

**Built with Flutter 💙**

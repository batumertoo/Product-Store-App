// init_desktop.dart - For mobile and desktop platforms
import 'dart:io';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void initializeDatabase() {
  // Initialize FFI for desktop platforms (Windows, Linux, macOS)
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
  // On Android/iOS, sqflite works natively without initialization
  // No action needed for mobile platforms
}
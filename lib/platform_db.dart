import 'package:flutter/foundation.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

/// Desktop targets use sqflite FFI; web uses [sqflite_common_ffi_web] (see database_helper).
bool get useSqliteFfi =>
    !kIsWeb &&
    (defaultTargetPlatform == TargetPlatform.windows ||
        defaultTargetPlatform == TargetPlatform.linux ||
        defaultTargetPlatform == TargetPlatform.macOS);

/// Must run before any DB access (main.dart and integration tests).
Future<void> configureSqliteForPlatform() async {
  if (kIsWeb) {
    // SharedWorker is flaky on GitHub Pages project sites (/repo/ subpath).
    databaseFactory = createDatabaseFactoryFfiWeb(
      noWebWorker: true,
      options: SqfliteFfiWebOptions(
        sqlite3WasmUri: Uri.base.resolve('sqlite3.wasm'),
      ),
    );
    return;
  }
  if (useSqliteFfi) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
}

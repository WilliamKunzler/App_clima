import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Future<Database> getDatabase() async {
  String caminhoBanco = join(await getDatabasesPath(), 'clima.db');

  return openDatabase(
    caminhoBanco,
    version: 1,
    onCreate: (db, version) async {
      await db.execute('CREATE TABLE clima('
          'id INTEGER PRIMARY KEY AUTOINCREMENT, '
          'city TEXT'
          ')');
    },
  );
}

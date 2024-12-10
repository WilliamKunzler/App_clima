import 'dart:io';

import 'package:clima/database/dao/climadao.dart';
import 'package:clima/screens/clima.dart';
import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows || Platform.isLinux) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  debugPrint(findall().toString());
  runApp(MaterialApp(
    home: ClimaTempo(),
    debugShowCheckedModeBanner: false,
  ));
}

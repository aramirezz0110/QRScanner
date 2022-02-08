import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:qr_reader/models/scan_model.dart';
export 'package:qr_reader/models/scan_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBProvider {
  static Database? _database;
  static final DBProvider db = DBProvider._();
  DBProvider._();
  Future<Database> get database async {
    //en caso de que exista la base de datos
    if (_database != null) return _database!;
    //en caso de que no, crear la base de datos
    _database = await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    //path de almacenamiento de la base de datos
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    //para unir pedazos de url
    final path = join(documentsDirectory.path, 'ScansDB.db');
    print(path);
    //crear base de datos
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      //QUERY para la creacion de la tabla
      await db.execute('''
          CREATE TABLE Scans(
            id INTEGER PRIMARY KEY,
            tipo TEXT,
            valor TEXT
          )
      ''');
    });
  }

  //PARA AGREGAR UN NUEVO REGISTRO, forma 1
  Future<int> nuevoScanRaw(ScanModel nuevoScan) async {
    //desestructuracion
    final id = nuevoScan.id;
    final tipo = nuevoScan.tipo;
    final valor = nuevoScan.valor;
    //verificar la base de datos
    final db = await database;
    final res = await db.rawInsert('''
      INSERT INTO Scans(id, tipo, valor)
        VALUES ($id, '$tipo', '$valor')
    ''');
    return res;
  }

  //PARA AGREGAR UN NUEVO REGISTRO, forma 2
  Future<int> nuevoScan(ScanModel nuevoScan) async {
    final db = await database;
    final res = await db.insert('Scans', nuevoScan.toJson());
    //res es el id del ultimo registro
    return res;
  }

  //OBTENER UN REGISTRO POR ID
  Future<ScanModel> getScanById(int id) async {
    final db = await database;
    //'id=?' ? hace referencia a los 'whereArgs:[]'
    final res = await db.query(
      'Scans',
      where: 'id=?',
      whereArgs: [id],
    );
    return res.isNotEmpty ? ScanModel.fromJson(res.first) : null!;
  }

  //OBTENER TODOS LOS REGISTROS
  Future<List<ScanModel>> getTodosLosScans() async {
    final db = await database;
    //solo el nombre de la tabla para obtener todos los registros
    final res = await db.query('Scans');
    return res.isNotEmpty ? res.map((s) => ScanModel.fromJson(s)).toList() : [];
  }

  //OBTENER TODOS LOS REGISTROS POR TIPO
  Future<List<ScanModel>> getScansPorTipo(String tipo) async {
    final db = await database;
    //solo el nombre de la tabla para obtener todos los registros
    final res = await db.rawQuery('''
      SELECT * FROM Scans WHERE tipo = '$tipo'
    ''');
    return res.isNotEmpty ? res.map((s) => ScanModel.fromJson(s)).toList() : [];
  }

  //PARA ACTUALIZAR UN REGISTRO
  Future<int> updateScan(ScanModel nuevoScan) async {
    final db = await database;
    final res = await db.update(
      'Scans',
      nuevoScan.toJson(),
      where: 'id=?',
      whereArgs: [nuevoScan.id],
    );
    //res es el id del ultimo registro
    return res;
  }

  //BORRAR REGISTRO POR ID
  Future<int> deleteScan(int id) async {
    final db = await database;
    final res = await db.delete('Scans', where: 'id=?', whereArgs: [id]);
    return res;
  }

  //BORRAR TODOS LOS REGISTROS
  Future<int> deleteAllScans() async {
    final db = await database;
    final res = await db.delete('Scans');
    return res;
  }
}

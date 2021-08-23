import 'package:sqflite/sqflite.dart';
import 'package:visiting_card_holder/models/contact_model.dart';
import 'package:path/path.dart' as path;

class DBSQLite {
  static final String _createTableContact = '''create table $tableContact(
  $colContactId integer primary key,
  $colContactName text not null,
  $colContactDesignation text not null,
  $colContactCompany text not null,
  $colContactAddress text not null,
  $colContactEmail text not null,
  $colContactPhone text not null,
  $colContactWeb text not null
  $colContactFavorite text not null)''';

  static Future<Database> _open() async {
    final rootPath = await getDatabasesPath();
    final dbPath = path.join(rootPath, 'contact.db');
    return openDatabase(dbPath, version: 3, onCreate: (db, version) async {
      await db.execute(_createTableContact);
    }, onUpgrade: (db, oldVersion, newVersion) async {
      if (newVersion == 3) {
        await db.execute(
            'alter table $tableContact add column $colContactImage  text');
        await db.execute(
            'alter table $tableContact add column $colContactFavorite  integer not null default 0');
      }
    });
  }

  static Future<int> insertNewContact(ContactModel contactModel) async {
    final db = await _open();
    return db.insert(tableContact, contactModel.toMap());
  }

  static Future<List<ContactModel>> getAllContacts() async {
    final db = await _open();
    final mapList = await db.query(tableContact);
    return List.generate(
        mapList.length, (index) => ContactModel.fromMap(mapList[index]));
  }

  static Future<ContactModel> getContactById(int id) async {
    final db = await _open();
    final mapList = await db
        .query(tableContact, where: '$colContactId = ? ', whereArgs: [id]);
    return ContactModel.fromMap(mapList.first);
  }

  static Future<List<ContactModel>> getFavouriteContacts() async {
    final db = await _open();
    final mapList = await db
        .query(tableContact, where: '$colContactFavorite = ? ', whereArgs: [1]);
    return List.generate(
        mapList.length, (index) => ContactModel.fromMap(mapList[index]));
  }

  static Future<int> deleteContact(int id) async {
    final db = await _open();
    return db
        .delete(tableContact, where: '$colContactId = ? ', whereArgs: [id]);
  }

  static Future<int> updateFavorite(int id, int value) async {
    final db = await _open();
    return db.update(tableContact, {colContactFavorite: value},
        where: '$colContactId = ? ', whereArgs: [id]);
  }
}

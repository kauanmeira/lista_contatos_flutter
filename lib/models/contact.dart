import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

final String contactTable = "contactTable";
final String idColumn = "idColumn";
final String nomeColumn = "nomeColumn";
final String emailColumn = "emailColumn";
final String phoneColumn = "phoneColumn";
final String imgColumn = "imgColumn";

class ContactHelper {
  static final ContactHelper _instance = ContactHelper.internal();

  factory ContactHelper() => _instance;

  ContactHelper.internal();

  static Database? _db;

  Future<Database> get db async {
    if (_db != null && _db!.isOpen) {
      return _db!;
    } else {
      _db = await initDb();
      return _db!;
    }
  }

  Future<Database> initDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'contacts.db');

    return await openDatabase(path, version: 1,
        onCreate: (Database db, int newerVersion) async {
      await db.execute('''
        CREATE TABLE $contactTable (
          $idColumn INTEGER PRIMARY KEY,
          $nomeColumn TEXT,
          $emailColumn TEXT,
          $phoneColumn TEXT,
          $imgColumn TEXT
        )
      ''');
    });
  }

  Future<Contact> saveContact(Contact contact) async {
    Database dbContact = await db;
    contact.id = await dbContact.insert(contactTable, contact.toMap());
    return contact;
  }

  Future<Contact?> getContact(int id) async {
    Database dbContact = await db;
    List<Map<String, dynamic>> maps = await dbContact.query(contactTable,
        columns: [idColumn, nomeColumn, emailColumn, phoneColumn, imgColumn],
        where: '$idColumn = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return Contact.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> deleteContact(int id) async {
    Database dbContact = await db;
    return await dbContact
        .delete(contactTable, where: '$idColumn = ?', whereArgs: [id]);
  }

  Future<int> updateContact(Contact contact) async {
    Database dbContact = await db;
    return await dbContact.update(contactTable, contact.toMap(),
        where: '$idColumn', whereArgs: [contact.id]);
  }

  Future<List<Contact>> getAllContacts() async {
    Database dbContact = await db;
    List<Map<String, dynamic>> listMap =
        await dbContact.rawQuery('SELECT * FROM $contactTable');
    List<Contact> listContact = [];
    for (Map<String, dynamic> m in listMap) {
      listContact.add(Contact.fromMap(m));
    }
    return listContact;
  }

  Future<int?> getNumber() async {
    Database dbContact = await db;
    return Sqflite.firstIntValue(
        await dbContact.rawQuery('SELECT COUNT (*) FROM $contactTable'));
  }

  Future close() async {
    Database dbContact = await db;
    dbContact.close();
  }
}

class Contact {
  int? id;
  String nome;
  String email;
  String phone;
  String img;

  Contact({
    this.id = 0,
    this.nome = '',
    this.email = '',
    this.phone = '',
    this.img = '',
  });

  Contact.fromMap(Map<String, dynamic> map)
      : id = map[idColumn],
        nome = map[nomeColumn],
        email = map[emailColumn],
        phone = map[phoneColumn],
        img = map[imgColumn];

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      nomeColumn: nome,
      emailColumn: email,
      phoneColumn: phone,
      imgColumn: img,
    };
    if (id != null) {
      map[idColumn] = id;
    }
    return map;
  }

  @override
  String toString() {
    return 'Contact(id: $id, nome: $nome, email: $email, phone: $phone, img: $img)';
  }
}

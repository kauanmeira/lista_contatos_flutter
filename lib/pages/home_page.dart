import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lista_contatos/models/contact.dart';
import 'package:path/path.dart';
import 'package:flutter/painting.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ContactHelper helper = ContactHelper();

  List<Contact> contacts = [];

  @override
  void initState() {
    super.initState();
    helper.getAllContacts().then((list) {
      setState(() {
        contacts = list;
      });
    });
  }

  Future<void> _initData() async {
    Contact c = Contact(
      nome: 'Kauan meira',
      email: 'kauan@gmail.com',
      phone: '17988214036',
      img: 'imgtest',
    );

    await helper.saveContact(c);

    helper.getAllContacts().then((list) {
      print(list);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contatos'),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(10.0),
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          return _contactCard(context, index);
        },
      ),
    );
  }

  Widget _contactCard(BuildContext context, int index) {
    return GestureDetector(
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Row(children: [
          Container(
            width: 80.0,
            height: 80.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                  image: contacts[index].img != null
                      ? FileImage(File(contacts[index].img))
                      : AssetImage('lib/images/image.pgn')
                          as ImageProvider<Object>),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  contacts[index].nome ?? '',
                  style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
                ),
                Text(
                  contacts[index].email ?? '',
                  style: TextStyle(fontSize: 18.0),
                ),
                Text(
                  contacts[index].phone ?? '',
                  style: TextStyle(fontSize: 18.0),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}

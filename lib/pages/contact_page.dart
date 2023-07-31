import 'dart:io';
import 'package:flutter/material.dart';
import '../models/contact.dart';

class ContactPage extends StatefulWidget {
  final Contact contact;

  ContactPage({required this.contact});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  bool _userEdited = false;
  late Contact _editedContact;

  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.contact == null) {
      _editedContact = Contact();
    } else {
      _editedContact = Contact.fromMap(widget.contact.toMap());
    }
    _nomeController.text = _editedContact.nome;
    _emailController.text = _editedContact.email;
    _phoneController.text = _editedContact.phone;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text(_editedContact.nome.isNotEmpty
            ? _editedContact.nome
            : 'Novo Contato'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.save),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: [
            GestureDetector(
              child: Container(
                width: 140.0,
                height: 140.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.black,
                    width: 4.0,
                  ),
                  image: DecorationImage(
                    image: _getImageProvider(),
                  ),
                ),
              ),
            ),
            TextField(
              controller: _nomeController,
              decoration: InputDecoration(labelText: 'Nome'),
              onChanged: (text) {
                _userEdited = true;
                setState(() {
                  _editedContact.nome = text;
                });
              },
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
              onChanged: (text) {
                _userEdited = true;
                _editedContact.email = text;
              },
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: 'Telefone'),
              onChanged: (text) {
                _userEdited = true;
                _editedContact.phone = text;
              },
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
      ),
    );
  }

  ImageProvider<Object> _getImageProvider() {
    if (_editedContact.img != null && _editedContact.img.isNotEmpty) {
      File imageFile = File(_editedContact.img);
      if (imageFile.existsSync()) {
        return FileImage(imageFile);
      }
    }
    return AssetImage('lib/images/image.png');
  }
}

import 'package:flutter/material.dart';
import 'package:lista_contatos/pages/contact_page.dart';
import 'package:lista_contatos/pages/home_page.dart';

import 'models/contact.dart';

void main() {
  runApp(MaterialApp(
    home: ContactPage(contact: Contact()),
    debugShowCheckedModeBanner: false,
  ));
}

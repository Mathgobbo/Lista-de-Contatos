import 'dart:io';

import 'package:flutter/material.dart';
import 'package:listadecontatos/helpers/contact_helper.dart';
import 'package:image_picker/image_picker.dart';

class ContactPage extends StatefulWidget {

  final Contact contact;

  ContactPage({this.contact});

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {

  Contact _edittedContact;
  bool _userEdited = false;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _nameFocus = FocusNode();

  @override
  void initState() {
    super.initState();

    if(widget.contact == null){
      _edittedContact = new Contact();
    }else{
      _edittedContact = Contact.fromMap(widget.contact.toMap());
      _nameController.text = _edittedContact.name;
      _emailController.text = _edittedContact.email;
      _phoneController.text = _edittedContact.phone;
    }
  }

  Future<bool> _requestPop(){
    if(_userEdited){
      showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text('Descartar Alterações?'),
            content: Text("Se sair as alterações serão perdidas"),
            actions: <Widget>[
              FlatButton(
                child: Text("Cancelar"),
                onPressed: (){
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text("Sim"),
                onPressed: (){
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              )
            ],
          );
        }
      );
      return Future.value(false);
    }else{
      return Future.value(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: Text(_edittedContact.name ?? "Novo Contato"),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed:(){
            if(_edittedContact.name != null && _edittedContact.name.isNotEmpty){
              Navigator.pop(context, _edittedContact);
            } else{
              FocusScope.of(context).requestFocus(_nameFocus);
            }
          },
          child: Icon(Icons.save),
          backgroundColor: Colors.red,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              GestureDetector(
                onTap: (){
                  final picker = ImagePicker();
                  picker.getImage(source: ImageSource.camera).then((file){
                    if(file == null){
                      return;
                    }else{
                      setState(() {
                        _edittedContact.img = file.path;
                      });
                    }
                  });
                },
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                        image: _edittedContact.img != null ?
                        FileImage(File(_edittedContact.img)) :
                        AssetImage("images/meme.JPG")
                    ),
                  ),
                ),
              ),
              TextField(
                controller: _nameController,
                focusNode: _nameFocus,
                decoration: InputDecoration(
                    labelText: "Nome"
                ),
                onChanged: (text){
                  _userEdited = true;
                  setState(() {
                    _edittedContact.name = text;
                  });
                },
              ),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                    labelText: "Email"
                ),
                keyboardType: TextInputType.emailAddress,
                onChanged: (text){
                  _userEdited = true;
                  _edittedContact.email = text;

                },
              ),
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(
                    labelText: "Telefone"
                ),
                keyboardType: TextInputType.phone,
                onChanged: (text){
                  _userEdited = true;
                  _edittedContact.phone = text;

                },
              ),
            ],
          ),
        ),
      ),
    );
  }




}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pbkdf2_dart/pbkdf2_dart.dart';
import 'package:crypto/crypto.dart';
import 'utils.dart';

class EnterPasswordState extends State<EnterPassword>{
  String _password;

  _confirmPassword() async{
    var gen = new PBKDF2(hash: sha256);
    var secureKey = gen.generateKey(_password, "salt", 1000, 32);

    var _storage = FlutterSecureStorage();
    String value = await _storage.read(key: 'hivepassword');


    var secureKeyStr = Utils.keyToString(secureKey);

    if(secureKeyStr==value){
      Navigator.pushNamed(context, '/notespage',arguments: {});
    }
    else{
      _showAlert(context);
    }
  }

  void _showAlert(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("wrong password"),
          content: Text("Try Again"),
        )
    );
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Confirm Identity'),
        backgroundColor: Colors.orange,
      ),
      body:Column(
        children: <Widget>[
          Text('Enter password'),
          TextFormField(
            onChanged: (value)=>_password=value,
            obscureText: true,
          ),

          FlatButton(
            onPressed: _confirmPassword,
            child: Text('confirm'),
            color: Colors.orange,
          )
        ],
      ),
    );
  }
}

class EnterPassword extends StatefulWidget{
  @override
  EnterPasswordState createState()=>EnterPasswordState();
}
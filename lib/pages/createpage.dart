import 'package:flutter/material.dart';
import 'package:family_tree/database/database.dart';
import 'package:family_tree/models/treemember.dart';
import 'package:flutter/services.dart';

class CreatePage extends StatefulWidget {
  @override
  _CreatePageState createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _name = TextEditingController();
  String _msg = '';
  Color color;

  _start() async {
    String name = _name.text.toLowerCase();
    var table = await DBProvider.db.checkIfTableExists(name);
    if (table == false) {
      DBProvider.db.createNewTable(
        name,
        TreeMember(name, null, 1),
      );
      setState(() {
        _msg = "Family Created!";
        color = Colors.black;
      });
    } else {
      print('Exists');
      setState(() {
        _msg = "Family Already Exists!";
        color = Colors.red;
      });
    }
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        _msg = "";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Family"),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Container(
          alignment: Alignment(0, 0),
          decoration: new BoxDecoration(
            gradient: new LinearGradient(
                colors: [
                  const Color(0xFF3366FF),
                  const Color(0xFF00CCFF),
                ],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp),
          ),
          child: Padding(
            padding: EdgeInsets.all(50),
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        icon: Icon(Icons.person),
                        hintText: 'What is your family name?',
                        labelText: 'Name',
                      ),
                      controller: _name,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(
                            RegExp("[a-zA-Z\u00C0-\u017F ]")),
                        FilteringTextInputFormatter.singleLineFormatter,
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        //print(_name.text.replaceAll(new RegExp(r"\s+"), ""));
                        if (_formKey.currentState.validate()) {
                          _start();
                        }
                      },
                      child: Text(
                        'Submit',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text(
                      _msg,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, color: color),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

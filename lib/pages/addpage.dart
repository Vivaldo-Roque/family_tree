import 'package:flutter/material.dart';
import 'package:family_tree/database/database.dart';
import 'package:family_tree/models/treemember.dart';
import 'package:flutter/services.dart';

class AddPage extends StatefulWidget {
  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _name = TextEditingController();
  TextEditingController _name2 = TextEditingController();
  int _selected;
  String _selected1;
  bool safe = false, married = false, dialog = false, safeNode = false;
  Color color;
  String msg = '';

  checkName(String table, String name) async {
    final res = await DBProvider.db.checkIfNameExists(table, name);
    setState(() {
      dialog = res;
    });
  }

  safeNodeStatus(String table) async {
    var res = await DBProvider.db.getMembers(table);
    if (res.length > 1) {
      setState(() {
        safeNode = true;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Members"),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Form(
            key: _formKey,
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
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
                padding: EdgeInsets.all(10),
                child: Container(
                  height: 550,
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (married == false)
                            TextFormField(
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                icon: Icon(Icons.person),
                                hintText: 'What is your name?',
                                labelText: 'Child',
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
                          if (married == true)
                            TextFormField(
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                icon: Icon(Icons.person),
                                hintText: 'What is your name?',
                                labelText: 'Husband',
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
                          Padding(padding: EdgeInsets.all(10),),
                          married == true
                              ? TextFormField(
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    icon: Icon(Icons.person),
                                    hintText: 'What is your name?',
                                    labelText: 'Wife',
                                  ),
                                  controller: _name2,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Please enter some text';
                                    }
                                    return null;
                                  },
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.allow(
                                        RegExp("[a-zA-Z\u00C0-\u017F ]")),
                                    FilteringTextInputFormatter
                                        .singleLineFormatter,
                                  ],
                                )
                              : Container(),
                          Padding(padding: EdgeInsets.all(10)),
                          Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Married',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Checkbox(
                                      value: married,
                                      onChanged: (v) {
                                        setState(() {
                                          married = v;
                                        });
                                      }),
                                ],
                              ),
                              Padding(padding: EdgeInsets.all(10)),
                              Row(
                                children: [
                                  Text(
                                    'Choose family: ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  FutureBuilder(
                                      future: DBProvider.db.getFamilies(),
                                      builder: (context, ss) {
                                        if (ss.data == null) {
                                          return Container(
                                            child: Text(
                                              'No Data!',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          );
                                        } else {
                                          return Flexible(
                                            child: DropdownButton(
                                              value: _selected1,
                                              items: ss.data.map<
                                                      DropdownMenuItem<String>>(
                                                  (e) {
                                                String response = e['name'];
                                                return DropdownMenuItem(
                                                  child: new Text(response),
                                                  value: response,
                                                );
                                              }).toList(),
                                              onChanged: (value) {
                                                setState(() {
                                                  _selected1 = value;
                                                  safe = true;
                                                  safeNodeStatus(value);
                                                });
                                                print(_selected1);
                                              },
                                            ),
                                          );
                                        }
                                      }),
                                ],
                              ),
                              safeNode == true
                                  ? Row(
                                      children: [
                                        Text(
                                          'Choose parent: ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        FutureBuilder(
                                            future: safe == true
                                                ? DBProvider.db
                                                    .getMembers(_selected1)
                                                : null,
                                            builder: (context, ss) {
                                              if (ss.data == null) {
                                                return Container(
                                                  child: Text(
                                                    'No Data!',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                );
                                              } else {
                                                var data = List.from(ss.data)
                                                  ..removeAt(0);
                                                return Flexible(
                                                  child: DropdownButton(
                                                    value: _selected,
                                                    items: data.map<
                                                        DropdownMenuItem<
                                                            int>>((e) {
                                                      TreeMember treemember =
                                                          TreeMember.fromJson(
                                                              e);
                                                      return DropdownMenuItem(
                                                        child: new Text(
                                                            treemember.name
                                                                .toString()),
                                                        value: treemember.id,
                                                      );
                                                    }).toList(),
                                                    onChanged: (value) {
                                                      setState(() {
                                                        _selected = value;
                                                      });
                                                      print(_selected);
                                                    },
                                                  ),
                                                );
                                              }
                                            }),
                                      ],
                                    )
                                  : Container(),
                            ],
                          ),
                          Padding(padding: EdgeInsets.all(10)),
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState.validate() &&
                                  _selected1 != null &&
                                  (_selected != null || _selected == null)) {
                                if (married == false) {
                                  checkName(_selected1,
                                      _name.text.toLowerCase().trim());
                                  Future.delayed(Duration(seconds: 3), () {
                                    dialog == true
                                        ? showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: Text(
                                                "Alert",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              content: Text(
                                                "${_name.text.toLowerCase().trim()} already exists!",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              actions: [
                                                RaisedButton(
                                                    child: Text(
                                                      "back",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    }),
                                                RaisedButton(
                                                    child: Text(
                                                      "Insert",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    onPressed: () {
                                                      DBProvider.db.insertMember(
                                                          TreeMember(
                                                              _name.text
                                                                  .toLowerCase()
                                                                  .trim(),
                                                              _selected),
                                                          _selected1);
                                                      Navigator.pop(context);
                                                    })
                                              ],
                                            ),
                                          )
                                        : safeNode == false
                                            ? DBProvider.db.insertMember(
                                                TreeMember(
                                                    _name.text
                                                        .toLowerCase()
                                                        .trim(),
                                                    1),
                                                _selected1)
                                            : DBProvider.db.insertMember(
                                                TreeMember(
                                                    _name.text
                                                        .toLowerCase()
                                                        .trim(),
                                                    _selected),
                                                _selected1);
                                  });
                                } else if (married == true) {
                                  var res =
                                      "${_name.text.toLowerCase().trim()} * ${_name2.text.toLowerCase().trim()}";
                                  checkName(_selected1, res);
                                  Future.delayed(Duration(seconds: 3), () {
                                    dialog == true
                                        ? showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: Text(
                                                "Alert",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              content: Text(
                                                "$res already exists!",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              actions: [
                                                RaisedButton(
                                                    child: Text(
                                                      "back",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    }),
                                                RaisedButton(
                                                    child: Text(
                                                      "Insert",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    onPressed: () {
                                                      DBProvider.db
                                                          .insertMember(
                                                              TreeMember(res,
                                                                  _selected),
                                                              _selected1);
                                                      Navigator.pop(context);
                                                    })
                                              ],
                                            ),
                                          )
                                        : safeNode == false
                                            ? DBProvider.db.insertMember(
                                                TreeMember(res, 1), _selected1)
                                            : DBProvider.db.insertMember(
                                                TreeMember(res, _selected),
                                                _selected1);
                                  });
                                }
                                setState(() {
                                  msg = 'Added!';
                                  color = Colors.red;
                                  Future.delayed(Duration(seconds: 3), () {
                                    setState(() {
                                      msg = '';
                                      color = Colors.red;
                                    });
                                  });
                                });
                              } else {
                                setState(() {
                                  msg =
                                      'Attention fill in and check everything';
                                  color = Colors.red;
                                });
                              }
                            },
                            child: Text(
                              'Submit',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Text(
                            msg,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, color: color),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

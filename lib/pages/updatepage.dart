import 'package:family_tree/database/database.dart';
import 'package:family_tree/models/treemember.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:family_tree/tools/string_extension.dart';

class UpdatePage extends StatefulWidget {
  @override
  _UpdatePageState createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  String _selected1;
  bool show = false;

  var refreshKey = GlobalKey<RefreshIndicatorState>();

  Future<Null> getdata() async {
    setState(() {
    });
    refreshKey.currentState.show();
    Future.delayed(Duration(seconds: 3));
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Update Members'),
        ),
        body: Container(
          alignment: Alignment(0,0),
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Choose family: ',style: TextStyle(fontWeight: FontWeight.bold),),
                    FutureBuilder(
                        future: DBProvider.db.getFamilies(),
                        builder: (context, ss) {
                          if (ss.data == null) {
                            return Container(child: Text('No data!',style: TextStyle(fontWeight: FontWeight.bold),),);
                          } else {
                            return Flexible(
                              child: DropdownButton(
                                value: _selected1,
                                items: ss.data.map<DropdownMenuItem<String>>((e) {
                                  String response = e['name'];
                                  return DropdownMenuItem(
                                    child: new Text(response),
                                    value: response,
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _selected1 = value;
                                  });
                                },
                              ),
                            );
                          }
                        }),
                    ElevatedButton(
                        child: Text('Show Results',style: TextStyle(fontWeight: FontWeight.bold),),
                        onPressed: () {
                          setState(() {
                            if (_selected1 != null) {
                              show = true;
                            }
                          });
                        }),
                  ],
                ),
              ),
              Padding(padding: EdgeInsets.all(10)),
              RefreshIndicator(
                key: refreshKey,
                onRefresh: () => getdata(),
                child: show == true
                    ? FutureBuilder(
                    future: DBProvider.db.getMembers(_selected1),
                    builder: (context, ss) {
                        if (ss.connectionState == ConnectionState.waiting && !ss.hasData) {
                          return Container(child: Text('No data!',style: TextStyle(fontWeight: FontWeight.bold),),);
                        } else {
                          var data = List.from(ss.data)..removeAt(0);
                          return ListView.builder(
                              shrinkWrap: true,
                              itemCount: data.length,
                              itemBuilder: (context, item) {
                                TreeMember treemember =
                                    TreeMember.fromJson(data[item]);
                                return Card(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.people),
                                      Text(
                                        treemember.name,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Row(
                                        children: [
                                          RaisedButton(
                                            child: Text(
                                              "Update",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.green),
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          Update(
                                                            table: _selected1,
                                                            treeMember:
                                                                treemember,
                                                          )));
                                            },
                                          ),
                                          Spacer(),
                                          RaisedButton(
                                            child: Text(
                                              "Delete",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.red),
                                            ),
                                            onPressed: () {
                                              DBProvider.db.removeMember(
                                                  treemember, _selected1);
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              });
                        }
                      })
                    : Container(),
              ),
            ],
          ),
        ));
  }
}

class Update extends StatefulWidget {
  final TreeMember treeMember;
  final table;

  Update({this.treeMember, this.table});

  @override
  _UpdateState createState() => _UpdateState();
}

class _UpdateState extends State<Update> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _name1 = TextEditingController();
  TextEditingController _name2 = TextEditingController();
  int _child;
  String table, msg = '';
  Color color = Colors.green;
  TreeMember treeMember;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    table = widget.table;
    treeMember = widget.treeMember;
    _child = widget.treeMember.c;

    if (treeMember.name.split(" * ").length == 2) {
      _name1.text = treeMember.name.split(" * ")[0].capitalizeFirstofEach;
      _name2.text = treeMember.name.split(" * ")[1].capitalizeFirstofEach;
    } else {
      _name1.text = treeMember.name;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Container(
            alignment: Alignment(0, 0),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
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
            child: Container(
              color: Colors.white,
              height: 300,
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      treeMember.name.split(" * ").length == 2
                          ? TextFormField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          icon: Icon(Icons.person),
                          hintText: 'What is your name?',
                          labelText: 'Husband',
                        ),
                        controller: _name1,
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
                      )
                          : Container(),
                      treeMember.name.split(" * ").length == 2
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
                          FilteringTextInputFormatter.singleLineFormatter,
                        ],
                      )
                          : Container(),
                      treeMember.name.split(" * ").length != 2
                          ? TextFormField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          icon: Icon(Icons.person),
                          hintText: 'What is your name?',
                          labelText: 'Name',
                        ),
                        controller: _name1,
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
                      )
                          : Container(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Choose parent: ',style: TextStyle(fontWeight: FontWeight.bold),),
                          FutureBuilder(
                              future: DBProvider.db.getMembers(table),
                              builder: (context, ss) {
                                if (ss.data == null) {
                                  return Container(child: Text('No data!',style: TextStyle(fontWeight: FontWeight.bold),),);
                                } else {
                                  return Flexible(
                                    child: DropdownButton(
                                      value: _child,
                                      items: ss.data.map<DropdownMenuItem<int>>((e) {
                                        TreeMember treemember = TreeMember.fromJson(e);
                                        return DropdownMenuItem(
                                          child: new Text(treemember.name.toString()),
                                          value: treemember.id,
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          _child = value;
                                        });
                                      },
                                    ),
                                  );
                                }
                              }),
                        ],
                      ),
                      ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState.validate() && _child != null) {
                              if (widget.treeMember.name.split(' * ').length == 2) {
                                var res =
                                    "${_name1.text.toLowerCase().trim()} * ${_name2.text.toLowerCase().trim()}";
                                treeMember.name = res;
                                treeMember.c = _child;
                                DBProvider.db.updateMember(table, treeMember);
                              } else {
                                treeMember.name = _name1.text;
                                treeMember.c = _child;
                                DBProvider.db.updateMember(table, treeMember);
                              }
                              setState(() {
                                msg = "Updated!";
                              });
                              Future.delayed(Duration(seconds: 3), () {
                                setState(() {
                                  msg = "";
                                });
                              });
                            }
                          },
                          child: Text('Update')),
                      Text(
                        msg,
                        style: TextStyle(fontWeight: FontWeight.bold, color: color),
                      ),
                    ],
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

class UpdateFamilies extends StatefulWidget {
  @override
  _UpdateFamiliesState createState() => _UpdateFamiliesState();
}

class _UpdateFamiliesState extends State<UpdateFamilies> {
  var refreshKey = GlobalKey<RefreshIndicatorState>();

  Future<Null> getdata() async {
    //refreshKey.currentState.show();
    setState(() {});
    Future.delayed(
      Duration(seconds: 3),
    );
    return null;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Families'),
      ),
      body: Container(
        alignment: Alignment(0,0),
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
        child: RefreshIndicator(
          key: refreshKey,
          onRefresh: () => getdata(),
          child: Container(
              alignment: Alignment(0, -1),
              child: FutureBuilder(
                future: DBProvider.db.getFamilies(),
                builder: (context, ss) {
                  if (ss.data == null) {
                    return Container();
                  } else {
                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: ss.data.length,
                        itemBuilder: (context, item) {
                          var data = ss.data[item]['name'];
                          return Card(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.people),
                                Text(
                                  data,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Row(
                                  children: [
                                    RaisedButton(
                                      child: Text(
                                        "Update",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => NewDataFamily(table: data,)));
                                      },
                                    ),
                                    Spacer(),
                                    RaisedButton(
                                      child: Text(
                                        "Delete",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red),
                                      ),
                                      onPressed: () {
                                        DBProvider.db.deleteTable(data);
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        });
                  }
                },
              )),
        ),
      ),
    );
  }
}

class NewDataFamily extends StatefulWidget {
  final table;

  NewDataFamily({this.table});

  @override
  _NewDataFamilyState createState() => _NewDataFamilyState();
}

class _NewDataFamilyState extends State<NewDataFamily> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _name1 = TextEditingController();

  String table, msg = '';
  Color color = Colors.green;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    table = widget.table;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Container(
            alignment: Alignment(0, 0),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
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
            child: Container(
              color: Colors.white,
              height: 300,
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                          icon: Icon(Icons.person),
                          border: OutlineInputBorder(),
                          hintText: 'What is your family name?',
                          labelText: 'Family Name',
                        ),
                        controller: _name1,
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
                      ElevatedButton(
                          onPressed: () {
                            DBProvider.db.renameTable(widget.table, _name1.text.toLowerCase().trim());
                              setState(() {
                                msg = "Updated!";
                              });
                              Future.delayed(Duration(seconds: 3), () {
                                setState(() {
                                  msg = "";
                                });
                              });
                          },
                          child: Text('Update')),
                      Text(
                        msg,
                        style: TextStyle(fontWeight: FontWeight.bold, color: color),
                      ),
                    ],
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

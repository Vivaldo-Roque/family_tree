import 'package:flutter/material.dart';
import 'package:family_tree/pages/treeview.dart';
import 'addpage.dart';
import 'createpage.dart';
import 'editpage.dart';
import 'package:gedcom/gedcom.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  var testData = '''
  0 @I25@ INDI
  1 NAME Thomas Trask /Wetmore/ Sr
  1 SEX M
  1 BIRT
    2 DATE 13 March 1866
    2 PLAC St. Mary's Bay, Digby, Nova Scotia
    2 SOUR Social Security application
  1 NATU
    2 NAME Thomas T. Wetmore
    2 DATE 26 October 1888
    2 PLAC Norwich, New London, Connecticut
    2 AGE 22 years
    2 COUR New London County Court of Common Pleas
    2 SOUR court record from National Archives
  1 OCCU Antiques Dealer
  1 DEAT
    2 NAME Thomas Trask Wetmore
    2 DATE 17 February 1947
    2 PLAC New London, New London, Connecticut
    2 AGE 80 years, 11 months, 4 days
    2 CAUS Heart Attack
    2 SOUR New London Death Records
  1 FAMC @F11@
  1 FAMS @F6@
  1 FAMS @F12@
''';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final parser = GedcomParser();
    final root = parser.parse(testData);
    print(root.toGedcomString(recursive: true));

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Family Tree"),
        centerTitle: true,
      ),
      body: Container(
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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RaisedButton(
                color: Colors.white,
                child: Text("Start", style: TextStyle(fontWeight: FontWeight.bold),),
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => LoadTree()));
                },
              ),
              RaisedButton(
                color: Colors.white,
                child: Text("Create", style: TextStyle(fontWeight: FontWeight.bold),),
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => CreatePage()));
                },
              ),
              RaisedButton(
                color: Colors.white,
                child: Text("Add", style: TextStyle(fontWeight: FontWeight.bold),),
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => AddPage()));
                },
              ),
              RaisedButton(
                color: Colors.white,
                child: Text("Update",style: TextStyle(fontWeight: FontWeight.bold),),
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => EditPage()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
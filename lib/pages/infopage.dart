import 'package:family_tree/models/treemember.dart';
import 'package:flutter/material.dart';
import 'package:family_tree/tools/string_extension.dart';

class InfoPage extends StatefulWidget {
  final TreeMember treeMember;
  final String txt1;

  InfoPage({this.treeMember, this.txt1});

  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Info'),
      ),
      body: Container(
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
        child: Column(
          children: [
            Row(
              children: [
                widget.txt1.split(" * ").length == 2
                    ? Expanded(
                        child: Card(
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Husband: ${widget.txt1.split(" * ")[0].capitalizeFirstofEach}",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                        ),
                      )
                    : Expanded(
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Name: ${widget.txt1.capitalizeFirstofEach}",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                widget.txt1.split(" * ").length == 2
                    ? Expanded(
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Wife: ${widget.txt1.split(" * ")[1].capitalizeFirstofEach}",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      )
                    : Container(),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(10),
            ),
            MyEditableText(
              text: 'Bio\nFull name: Vivaldo Cristóvão Roque',
              textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            ),
          ],
        ),
      ),
    );
  }
}

class MyEditableText extends StatefulWidget {
  final String text;
  final TextStyle textStyle;

  MyEditableText({this.text, this.textStyle});

  @override
  _MyEditableTextState createState() => _MyEditableTextState();
}

class _MyEditableTextState extends State<MyEditableText> {
  TextEditingController _textEditingController = TextEditingController();
  bool isEditing = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _textEditingController.text = widget.text;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: isEditing == false
          ? InkWell(
              onTap: () {
                setState(() {
                  isEditing = !isEditing;
                });
              },
              child: Card(
                child: Text(
                  _textEditingController.text,
                  textAlign: TextAlign.center,
                  style: widget.textStyle,
                ),
              ),
            )
          : TextField(
              controller: _textEditingController,
              style: widget.textStyle,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(border: OutlineInputBorder()),
              onEditingComplete: () {
                setState(() {
                  isEditing = !isEditing;
                });
              },
            ),
    );
  }
}

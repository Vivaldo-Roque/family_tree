import 'package:family_tree/models/treemember.dart';
import 'package:family_tree/pages/infopage.dart';
import 'package:flutter/material.dart';
import 'package:family_tree/tools/string_extension.dart';

class GetNodeText extends StatefulWidget {
  final String txt1;
  final TreeMember treeMember;

  GetNodeText({this.txt1, this.treeMember});

  @override
  _GetNodeTextState createState() => _GetNodeTextState();
}

class _GetNodeTextState extends State<GetNodeText> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => InfoPage(
                  txt1: widget.txt1,
                  treeMember: widget.treeMember,
                )));
      },
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            BoxShadow(color: Colors.blue[100], spreadRadius: 1),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            widget.txt1.split(" * ").length == 2
                ? Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text(
                              "${widget.txt1.split(" * ")[0].capitalizeFirstofEach}"),
                          Icon(
                            Icons.people,
                            size: 40,
                          ),
                        ],
                      ),
                    ),
                  )
                : Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text("${widget.txt1.capitalizeFirstofEach}"),
                          Icon(
                            Icons.people,
                            size: 40,
                          ),
                        ],
                      ),
                    ),
                  ),
            widget.txt1.split(" * ").length == 2
                ? Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text(
                              "${widget.txt1.split(" * ")[1].capitalizeFirstofEach}"),
                          Icon(
                            Icons.people,
                            size: 40,
                          ),
                        ],
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}

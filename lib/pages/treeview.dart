import 'package:family_tree/database/database.dart';
import 'package:family_tree/models/treemember.dart';
import 'package:flutter/material.dart';
import 'package:graphview/GraphView.dart';
import 'package:family_tree/pages/getnodetext.dart';

class LoadTree extends StatefulWidget {
  @override
  _LoadTreeState createState() => _LoadTreeState();
}

class _LoadTreeState extends State<LoadTree> {
  String _selected1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        alignment: Alignment(0, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Choose family: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  FutureBuilder(
                      future: DBProvider.db.getFamilies(),
                      builder: (context, ss) {
                        if (ss.data == null) {
                          return Container(
                            child: Text(
                              "No Data!",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          );
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
                      child: Text(
                        'Load Tree',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        setState(() {
                          if (_selected1 != null) {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => TreeViewPage(
                                      familyName: _selected1,
                                    )));
                          }
                        });
                      }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TreeViewPage extends StatefulWidget {
  final String familyName;

  TreeViewPage({this.familyName});

  @override
  _GraphViewPageState createState() => _GraphViewPageState();
}

class _GraphViewPageState extends State<TreeViewPage> {
  final Graph graph = Graph();
  BuchheimWalkerConfiguration builder = BuchheimWalkerConfiguration();
  List<Node> node = [];
  List<Edge> edge = [];
  List<Map> family = [];

  List<Node> generateNodes(List<Map> strings) {
    List<Node> list = [];

    for (int x = 0; x < strings.length; x++) {
      if (x == 0) {
        list.add(Node(
            GetNodeText(
              txt1: "Família ${strings[x]['name']}",
              treeMember: TreeMember.fromJson(strings[x]),
            ),
            key: Key("${strings[x]['id']}")));
      }
      list.add(Node(
          GetNodeText(
            txt1: strings[x]['name'],
            treeMember: TreeMember.fromJson(strings[x]),
          ),
          key: Key("${strings[x]['id']}")));
    }

    return list;
  }

  findChild(List list) {
    List<Edge> edge = [];
    for (var map1 in list) {
      for (var map in list) {
        if (map.containsKey("c")) {
          if (map["c"] == map1["id"]) {
            edge.add(Edge(graph.getNodeUsingKey(Key(map1['id'].toString())),
                graph.getNodeUsingKey(Key(map['id'].toString()))));
          }
        }
      }
    }
    return edge;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tree"),
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
        child: FutureBuilder(
          future: DBProvider.db.getMembers(widget.familyName),
          builder: (context, ss) {
            if (ss.data == null) {
              return Center(
                child: Container(
                  alignment: Alignment(0, 0),
                  color: Colors.grey,
                  height: 200,
                  width: 200,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'SEM DADOS NA BASE DE DADOS',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      CircularProgressIndicator(),
                    ],
                  ),
                ),
              );
            } else {
              family = ss.data;
              node = generateNodes(family);

              graph.addNodes(node);

              edge = findChild(family);

              graph.addEdges(edge);

              builder
                ..siblingSeparation = (50)
                ..levelSeparation = (100)
                ..subtreeSeparation = (100)
                ..orientation =
                    (BuchheimWalkerConfiguration.ORIENTATION_TOP_BOTTOM);
              return Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: InteractiveViewer(
                      constrained: false,
                      scaleEnabled: true,
                      boundaryMargin: EdgeInsets.all(100),
                      minScale: 0.01,
                      maxScale: 5.6,
                      child: GraphView(
                        graph: graph,
                        algorithm: BuchheimWalkerAlgorithm(
                          builder,
                          TreeEdgeRenderer(builder),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}

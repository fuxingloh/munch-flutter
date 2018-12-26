import 'package:flutter/material.dart';
import 'package:munch_app/api/munch_data.dart';

class RIPPage extends StatefulWidget {
  const RIPPage({Key key, this.place}) : super(key: key);

  final Place place;

  @override
  State<StatefulWidget> createState() => RIPPageState(place);
}

class RIPPageState extends State<RIPPage> {
  RIPPageState(this.place);

  final Place place;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("RIP Page")),
      body: ListView(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:munch_app/pages/discover/discover_header.dart';

class DiscoverPage extends StatelessWidget {
  DiscoverPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DiscoverHeaderBar(),
        Expanded(
          child: ListView(),
        )
      ],
    );
  }
}

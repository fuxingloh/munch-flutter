import 'package:flutter/material.dart';
import 'package:munch_app/styles/buttons.dart';
import 'package:munch_app/styles/colors.dart';
import 'package:munch_app/styles/separators.dart';
import 'package:munch_app/styles/texts.dart';

class TastebudPage extends StatelessWidget {
  TastebudPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MunchColors.white,
        title: MunchButton.text(
          "Primary Button",
          style: MunchButtonStyle.primary,
          onPressed: () {},
        ),
      ),
      body: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.all(24.0),
        children: <Widget>[
          const Text("Heading 1", style: MTextStyle.h1),
          const SeparatorWidget(),
          const Text("Heading 2", style: MTextStyle.h2),
          const SeparatorWidget(),
          const Text("Heading 3", style: MTextStyle.h3),
          const Text("Heading 4", style: MTextStyle.h4),
          const Text("Heading 5", style: MTextStyle.h5),
          const Text("Heading 6", style: MTextStyle.h6),
          const SeparatorWidget(),
          const Text("Nav Header", style: MTextStyle.navHeader),
          const SeparatorWidget(),
          const Text("Large", style: MTextStyle.large),
          const Text("Regular", style: MTextStyle.regular),
          const Text("Small", style: MTextStyle.small),
          const SeparatorWidget(),
          const Text("Small Bold", style: MTextStyle.smallBold),
          const Text("Subtext", style: MTextStyle.subtext),
          Container(
            margin: EdgeInsets.only(top: 12, bottom: 12),
            alignment: Alignment.centerLeft,
            child: MunchButton.text(
              "Primary",
              style: MunchButtonStyle.primary,
              onPressed: () {},
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 12, bottom: 12),
            alignment: Alignment.centerLeft,
            child: MunchButton.text(
              "Extreme Long Ass Text Container Sizing Test",
              style: MunchButtonStyle.primary,
              onPressed: () {},
            ),
          ),
          SeparatorWidget(),
          Container(
            margin: EdgeInsets.only(top: 12, bottom: 12),
            alignment: Alignment.centerLeft,
            child: MunchButton.text(
              "Primary Outline",
              style: MunchButtonStyle.primaryOutline,
              onPressed: () {},
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 12, bottom: 12),
            alignment: Alignment.centerLeft,
            child: MunchButton.text(
              "Primary Small",
              style: MunchButtonStyle.primarySmall,
              onPressed: () {},
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 12, bottom: 12),
            alignment: Alignment.centerLeft,
            child:  MunchButton.text(
              "Secondary Long Test",
              style: MunchButtonStyle.secondary,
              onPressed: () {},
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 12, bottom: 12),
            alignment: Alignment.centerLeft,
            child: MunchButton.text(
              "Secondary Outline",
              style: MunchButtonStyle.secondaryOutline,
              onPressed: () {},
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 12, bottom: 12),
            alignment: Alignment.centerLeft,
            child: MunchButton.text(
              "Secondary Small",
              style: MunchButtonStyle.secondarySmall,
              onPressed: () {},
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 12, bottom: 12),
            alignment: Alignment.centerLeft,
            child: MunchButton.text(
              "Border",
              style: MunchButtonStyle.border,
              onPressed: () {},
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 12, bottom: 12),
            alignment: Alignment.centerLeft,
            child: MunchButton.text(
              "Border Small",
              style: MunchButtonStyle.borderSmall,
              onPressed: () {},
            )
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:munch_app/styles/colors.dart';
import 'package:munch_app/styles/elevations.dart';
import 'package:munch_app/styles/icons.dart';

class SearchHeaderBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: elevation1,
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(child: _SearchTextField()),
            _buildFilterButton(context)
          ],
        ),
      ),
    );
  }

  Widget _buildFilterButton(BuildContext context) {
    return IconButton(
      padding: const EdgeInsets.only(left: 16, right: 20),
      iconSize: 28,
      icon: const Icon(MunchIcons.search_header_filter),
      onPressed: () {},
    );
  }
}

class _SearchTextField extends StatelessWidget {
  static const TextStyle _textStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: MunchColors.black75,
  );

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        margin: EdgeInsets.only(top: 12, bottom: 12, left: 24),
        decoration: const BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          color: MunchColors.whisper100,
        ),
        child: Center(
          child: _buildTextField(context),
        ),
      ),
      Container(
        margin: EdgeInsets.only(top: 8, bottom: 8),
        child: IconButton(
          splashColor: Colors.white,
          padding: const EdgeInsets.only(left: 36, right: 16),
          iconSize: 20,
          icon: const Icon(MunchIcons.search_header_back),
          onPressed: () {},
        ),
      )
    ]);
  }

  TextField _buildTextField(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
          fillColor: Colors.white,
          contentPadding:
              EdgeInsets.only(left: 40, right: 24, top: 10, bottom: 10),
          border: InputBorder.none,
          hintText: 'Search "Chinese"',
          hintStyle: _textStyle),
    );
  }
}

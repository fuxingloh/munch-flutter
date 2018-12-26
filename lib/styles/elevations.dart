import 'package:flutter/material.dart';

// In css it's structure as such
// none|h-offset v-offset blur spread color

const elevation1 = [
  BoxShadow(
      offset: Offset(0, 1),
      blurRadius: 1,
      color: Color.fromRGBO(0, 0, 0, 0.12)),
  BoxShadow(
      offset: Offset(0, 1),
      blurRadius: 2,
      color: Color.fromRGBO(0, 0, 0, 0.24)),
];

const elevation2 = [
  BoxShadow(
      offset: Offset(0, 3),
      blurRadius: 6,
      color: Color.fromRGBO(0, 0, 0, 0.16)),
  BoxShadow(
      offset: Offset(0, 3),
      blurRadius: 6,
      color: Color.fromRGBO(0, 0, 0, 0.23)),
];

const elevation3 = [
  BoxShadow(
      offset: Offset(0, 10),
      blurRadius: 20,
      color: Color.fromRGBO(0, 0, 0, 0.19)),
  BoxShadow(
      offset: Offset(0, 6),
      blurRadius: 6,
      color: Color.fromRGBO(0, 0, 0, 0.23)),
];

const elevation4 = [
  BoxShadow(
      offset: Offset(0, 14),
      blurRadius: 28,
      color: Color.fromRGBO(0, 0, 0, 0.25)),
  BoxShadow(
      offset: Offset(0, 10),
      blurRadius: 10,
      color: Color.fromRGBO(0, 0, 0, 0.22)),
];

const elevation5 = [
  BoxShadow(
      offset: Offset(0, 19),
      blurRadius: 38,
      color: Color.fromRGBO(0, 0, 0, 0.30)),
  BoxShadow(
      offset: Offset(0, 15),
      blurRadius: 12,
      color: Color.fromRGBO(0, 0, 0, 0.22)),
];

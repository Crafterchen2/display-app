// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:display_app/widgets/empty.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:display_app/main.dart';

void main() {

  test("Empty.check(null) => false", () {
    assert(Empty.check(null) == false);
  });

  test("Empty.check(Empty()) => true", () {
    assert(Empty.check(Empty()) == true);
  });

  test("Empty.check(Text(\"text\")) => false", () {
    assert(Empty.check(Text("text")) is Empty == false);
  });

}

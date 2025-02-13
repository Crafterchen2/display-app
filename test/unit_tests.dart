import 'package:display_app/widgets/empty.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

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

  test("Empty.check(\"text\") => false", () {
    assert(Empty.check("text") is Empty == false);
  });

  test("Empty.check(4) => false", () {
    assert(Empty.check(4) is Empty == false);
  });
}

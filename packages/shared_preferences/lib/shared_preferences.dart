// Based on https://github.com/flutter/plugins/blob/shared_preferences-v2.0.0/packages/shared_preferences/shared_preferences/lib/shared_preferences.dart
// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

class SharedPreferences {
  SharedPreferences._(this._preferenceCache);

  static Completer<SharedPreferences>? _completer;

  static Future<SharedPreferences> getInstance() async {
    if (_completer == null) {
      final Completer<SharedPreferences> completer =
          Completer<SharedPreferences>();
      try {
        final preferencesMap = Map<String, Object>();
        completer.complete(SharedPreferences._(preferencesMap));
      } on Exception catch (e) {
        // If there's an error, explicitly return the future with an error.
        // then set the completer to null so we can retry.
        completer.completeError(e);
        final Future<SharedPreferences> sharedPrefsFuture = completer.future;
        _completer = null;
        return sharedPrefsFuture;
      }
      _completer = completer;
    }
    return _completer!.future;
  }

  // ignore: unused_field
  final Map<String, Object> _preferenceCache;

  String? getString(String key) => null;

  Future<bool> setString(String key, String value) {
    var completer = Completer<bool>();
    completer.complete(true);

    return completer.future;
  }

  Future<bool> remove(String key) {
    var completer = Completer<bool>();
    completer.complete(true);

    return completer.future;
  }
}

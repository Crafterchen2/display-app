import 'dart:io';

import 'package:pionixbox/data/models/session_info.dart';

///
///
abstract class AppRepo {
  ///
  ///
  ///
  Future<SessionInfo> getSessionInfo();

}
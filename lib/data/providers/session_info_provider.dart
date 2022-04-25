import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pionixbox/data/models/session_info.dart';

import 'app_repo_provider.dart';

final sessionInfoProvider =
    StreamProvider.autoDispose<SessionInfo>((ref) async* {
  final repo = ref.read(appRepoProvider);
  // yield await repo.getSessionInfo();
});

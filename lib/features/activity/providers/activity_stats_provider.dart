import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/activity.dart';
import 'activity_provider.dart';

final activityHistoryProvider = FutureProvider<List<Activity>>((ref) async {
  final repo = ref.read(activityRepositoryProvider);
  return await repo.getAllActivitySessions();
});
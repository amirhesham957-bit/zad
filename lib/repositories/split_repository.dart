import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/split_models.dart';

class SplitRepository {
  final List<SplitGroup> _groups = [
    SplitGroup(
      id: '1',
      name: 'رحلة الساحل',
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      members: [
        SplitMember(id: 'm1', name: 'أحمد (أنا)'),
        SplitMember(id: 'm2', name: 'سارة'),
        SplitMember(id: 'm3', name: 'خالد'),
      ],
      expenses: [
        SplitExpense(
          id: 'e1',
          description: 'بنزين',
          amount: 1200,
          paidBy: 'm1',
          splits: {'m1': 400, 'm2': 400, 'm3': 400},
          date: DateTime.now().subtract(const Duration(days: 2)),
        ),
        SplitExpense(
          id: 'e2',
          description: 'غداء سمك',
          amount: 2100,
          paidBy: 'm2',
          splits: {'m1': 700, 'm2': 700, 'm3': 700},
          date: DateTime.now().subtract(const Duration(days: 1)),
        ),
      ],
    ),
  ];

  Future<List<SplitGroup>> getGroups() async {
    await Future.delayed(const Duration(milliseconds: 800));
    return _groups;
  }

  Future<SplitGroup> getGroupById(String id) async {
    return _groups.firstWhere((g) => g.id == id);
  }
}

final splitRepositoryProvider = Provider((ref) => SplitRepository());

final splitGroupsProvider = FutureProvider((ref) {
  return ref.watch(splitRepositoryProvider).getGroups();
});

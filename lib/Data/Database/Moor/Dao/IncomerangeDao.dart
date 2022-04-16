import 'package:dating_app/Data/Database/Moor/Core/AppDatabase.dart';
import 'package:dating_app/Data/Database/Moor/Tables/Incomeranges.dart';
import 'package:moor/moor.dart';
import 'package:moor_flutter/moor_flutter.dart';

part 'IncomerangeDao.g.dart';

@UseDao(tables: [Incomeranges])
class IncomerangeDao extends DatabaseAccessor<AppDatabase>
    with _$IncomerangeDaoMixin {
  final AppDatabase db;

  IncomerangeDao(this.db) : super(db);

  Future<List<Incomerange>> getAllIncomeRanges() => select(incomeranges).get();
  Stream<List<Incomerange>> watchAllIncomeRanges() =>
      select(incomeranges).watch();
  Future insertIncomeRange(Insertable<Incomerange> incomeRange) =>
      into(incomeranges).insert(incomeRange);
  Future updateIncomeRange(Insertable<Incomerange> incomeRange) =>
      update(incomeranges).replace(incomeRange);
  Future deleteIncomeRange(Insertable<Incomerange> incomeRange) =>
      delete(incomeranges).delete(incomeRange);

  Future<Incomerange> getIncomerangeByOnlineId(int onlineId) {
    return (select(incomeranges)..where((t) => t.onlineid.equals(onlineId)))
        .get()
        .then((List<Incomerange> genderList) {
      if (genderList.length > 0) {
        return genderList[0];
      } else {
        return null;
      }
    }, onError: (error) {
      return null;
    });
  }

  Future updateAllIncomerange(
      List<IncomerangesCompanion> incomerangesCompanionList) async {
    await batch((b) {
      for (IncomerangesCompanion gsc in incomerangesCompanionList) {
        updateIncomeRange(gsc);
      }
    });
  }

  Future insertAllIncomerange(
      List<IncomerangesCompanion> incomerangesCompanionList) async {
    await batch((b) {
      b.insertAll(incomeranges, incomerangesCompanionList);
    });
  }

  Future<List<Incomerange>> getActiveIncomerangeList() {
    return (select(incomeranges)
          ..orderBy(
            ([
              (t) => OrderingTerm(expression: t.id, mode: OrderingMode.asc),
            ]),
          )
          ..where((t) => t.active.equals(true)))
        .get();
  }
}

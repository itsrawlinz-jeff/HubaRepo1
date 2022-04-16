import 'package:dating_app/Data/Database/Moor/Core/AppDatabase.dart';
import 'package:dating_app/Data/Database/Moor/Tables/Smokestatuses.dart';
import 'package:moor/moor.dart';
import 'package:moor_flutter/moor_flutter.dart';

part 'SmokestatusDao.g.dart';

@UseDao(tables: [Smokestatuses])
class SmokestatusDao extends DatabaseAccessor<AppDatabase>
    with _$SmokestatusDaoMixin {
  final AppDatabase db;

  SmokestatusDao(this.db) : super(db);

  Future<List<Smokestatuse>> getAllSmokeStatus() => select(smokestatuses).get();
  Stream<List<Smokestatuse>> watchAllSmokeStatus() =>
      select(smokestatuses).watch();
  Future insertSmokeStatus(Insertable<Smokestatuse> relationshipStatus) =>
      into(smokestatuses).insert(relationshipStatus);

  Future insertAllSmokeStatus(
      List<SmokestatusesCompanion> smokestatusesCompanionList) async {
    //await delete(smokestatuses).go();
    await batch((b) {
      b.insertAll(smokestatuses, smokestatusesCompanionList);
    });
  }

  Future updateAllSmokeStatus(
      List<SmokestatusesCompanion> smokestatusesCompanionList) async {
    await batch((b) {
      for (SmokestatusesCompanion smc in smokestatusesCompanionList) {
        updateSmokeStatus(smc);
      }
    });
  }

  Future updateSmokeStatus(Insertable<Smokestatuse> relationshipStatus) =>
      update(smokestatuses).replace(relationshipStatus);
  Future deleteSmokeStatus(Insertable<Smokestatuse> relationshipStatus) =>
      delete(smokestatuses).delete(relationshipStatus);

  Future<List<Smokestatuse>> getActiveSmokestatuseList() {
    return (select(smokestatuses)
          ..orderBy(
            ([
              (t) => OrderingTerm(expression: t.id, mode: OrderingMode.asc),
            ]),
          )
          ..where((t) => t.active.equals(true)))
        .get();
  }

  Future<Smokestatuse> getSmokestatuseByOnlineId(int onlineId) {
    print('running getSmokestatuseByOnlineId ');
    return (select(smokestatuses)..where((t) => t.onlineid.equals(onlineId)))
        .get()
        .then((List<Smokestatuse> smokestatuseList) {
      print('smokestatuseList length==${smokestatuseList.length}');
      if (smokestatuseList.length > 0) {
        return smokestatuseList[0];
      } else {
        return null;
      }
    }, onError: (error) {
      print('error==${error}');
      return null;
    });
  }

  Future<Smokestatuse> getSmokestatuseById(int id) {
    print('running getSmokestatuseByOnlineId ');
    return (select(smokestatuses)..where((t) => t.id.equals(id)))
        .get()
        .then((List<Smokestatuse> smokestatuseList) {
      print('smokestatuseList length==${smokestatuseList.length}');
      if (smokestatuseList.length > 0) {
        return smokestatuseList[0];
      } else {
        return null;
      }
    }, onError: (error) {
      print('error==${error}');
      return null;
    });
  }
}

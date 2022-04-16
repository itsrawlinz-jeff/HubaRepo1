import 'package:dating_app/Data/Database/Moor/Core/AppDatabase.dart';
import 'package:dating_app/Data/Database/Moor/Tables/Wantchildrenstatuses.dart';
import 'package:moor/moor.dart';
import 'package:moor_flutter/moor_flutter.dart';

part 'WantchildrenstatusDao.g.dart';

@UseDao(tables: [Wantchildrenstatuses])
class WantchildrenstatusDao extends DatabaseAccessor<AppDatabase>
    with _$WantchildrenstatusDaoMixin {
  final AppDatabase db;

  WantchildrenstatusDao(this.db) : super(db);

  Future<List<Wantchildrenstatuse>> getAllWantchildrenstatus() =>
      select(wantchildrenstatuses).get();
  Stream<List<Wantchildrenstatuse>> watchAllWantchildrenstatus() =>
      select(wantchildrenstatuses).watch();
  Future insertWantchildrenstatus(
          Insertable<Wantchildrenstatuse> wantChildrenStatus) =>
      into(wantchildrenstatuses).insert(wantChildrenStatus);
  Future updateWantchildrenstatus(
          Insertable<Wantchildrenstatuse> wantChildrenStatus) =>
      update(wantchildrenstatuses).replace(wantChildrenStatus);
  Future deleteWantchildrenstatus(
          Insertable<Wantchildrenstatuse> wantChildrenStatus) =>
      delete(wantchildrenstatuses).delete(wantChildrenStatus);

  Future<Wantchildrenstatuse> getWantchildrenstatuseByOnlineId(int onlineId) {
    return (select(wantchildrenstatuses)
          ..where((t) => t.onlineid.equals(onlineId)))
        .get()
        .then((List<Wantchildrenstatuse> wantchildrenstatuseList) {
      if (wantchildrenstatuseList.length > 0) {
        return wantchildrenstatuseList[0];
      } else {
        return null;
      }
    }, onError: (error) {
      return null;
    });
  }

  Future<Wantchildrenstatuse> getWantchildrenstatuseById(int id) {
    return (select(wantchildrenstatuses)..where((t) => t.id.equals(id)))
        .get()
        .then((List<Wantchildrenstatuse> wantchildrenstatuseList) {
      if (wantchildrenstatuseList.length > 0) {
        return wantchildrenstatuseList[0];
      } else {
        return null;
      }
    }, onError: (error) {
      return null;
    });
  }

  Future updateAllWantchildrenstatuse(
      List<WantchildrenstatusesCompanion>
          wantchildrenstatusesCompanionList) async {
    await batch((b) {
      for (WantchildrenstatusesCompanion gsc
          in wantchildrenstatusesCompanionList) {
        updateWantchildrenstatus(gsc);
      }
    });
  }

  Future insertAllWantchildrenstatuse(
      List<WantchildrenstatusesCompanion>
          wantchildrenstatusesCompanionList) async {
    await batch((b) {
      b.insertAll(wantchildrenstatuses, wantchildrenstatusesCompanionList);
    });
  }

  Future<List<Wantchildrenstatuse>> getActiveWantchildrenstatuseList() {
    return (select(wantchildrenstatuses)
          ..orderBy(
            ([
              (t) => OrderingTerm(expression: t.id, mode: OrderingMode.asc),
            ]),
          )
          ..where((t) => t.active.equals(true)))
        .get();
  }
}

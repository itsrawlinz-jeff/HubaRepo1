import 'package:dating_app/Data/Database/Moor/Core/AppDatabase.dart';
import 'package:dating_app/Data/Database/Moor/Tables/Drinkstatuses.dart';
import 'package:moor/moor.dart';
import 'package:moor_flutter/moor_flutter.dart';

part 'DrinkstatusDao.g.dart';

@UseDao(tables: [Drinkstatuses])
class DrinkstatusDao extends DatabaseAccessor<AppDatabase>
    with _$DrinkstatusDaoMixin {
  final AppDatabase db;

  DrinkstatusDao(this.db) : super(db);

  Future<List<Drinkstatuse>> getAllDrinkstatus() => select(drinkstatuses).get();
  Stream<List<Drinkstatuse>> watchAllDrinkstatus() =>
      select(drinkstatuses).watch();
  Future insertDrinkstatus(Insertable<Drinkstatuse> drinkStatus) =>
      into(drinkstatuses).insert(drinkStatus);
  Future updateDrinkstatus(Insertable<Drinkstatuse> drinkStatus) =>
      update(drinkstatuses).replace(drinkStatus);
  Future deleteDrinkstatus(Insertable<Drinkstatuse> drinkStatus) =>
      delete(drinkstatuses).delete(drinkStatus);

  Future<Drinkstatuse> getDrinkstatuseByOnlineId(int onlineId) {
    return (select(drinkstatuses)..where((t) => t.onlineid.equals(onlineId)))
        .get()
        .then((List<Drinkstatuse> drinkstatuseList) {
      if (drinkstatuseList.length > 0) {
        return drinkstatuseList[0];
      } else {
        return null;
      }
    }, onError: (error) {
      return null;
    });
  }

  Future<Drinkstatuse> getDrinkstatuseById(int id) {
    return (select(drinkstatuses)..where((t) => t.id.equals(id)))
        .get()
        .then((List<Drinkstatuse> drinkstatuseList) {
      if (drinkstatuseList.length > 0) {
        return drinkstatuseList[0];
      } else {
        return null;
      }
    }, onError: (error) {
      return null;
    });
  }

  Future updateAllDrinkstatuse(
      List<DrinkstatusesCompanion> drinkstatusesCompanionList) async {
    await batch((b) {
      for (DrinkstatusesCompanion gsc in drinkstatusesCompanionList) {
        updateDrinkstatus(gsc);
      }
    });
  }

  Future insertAllDrinkstatuse(
      List<DrinkstatusesCompanion> drinkstatusesCompanionList) async {
    await batch((b) {
      b.insertAll(drinkstatuses, drinkstatusesCompanionList);
    });
  }

  Future<List<Drinkstatuse>> getActiveDrinkstatuseList() {
    return (select(drinkstatuses)
          ..orderBy(
            ([
              (t) => OrderingTerm(expression: t.id, mode: OrderingMode.asc),
            ]),
          )
          ..where((t) => t.active.equals(true)))
        .get();
  }
}

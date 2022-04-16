import 'package:dating_app/Data/Database/Moor/Core/AppDatabase.dart';
import 'package:dating_app/Data/Database/Moor/Tables/Religions.dart';
import 'package:moor/moor.dart';
import 'package:moor_flutter/moor_flutter.dart';

part 'ReligionDao.g.dart';

@UseDao(tables: [Religions])
class ReligionDao extends DatabaseAccessor<AppDatabase> with _$ReligionDaoMixin {
  final AppDatabase db;

  ReligionDao(this.db) : super(db);

  Future<List<Religion>> getAllReligions() => select(religions).get();
  Stream<List<Religion>> watchAllReligions() => select(religions).watch();
  Future insertReligion(Insertable<Religion> religion) =>
      into(religions).insert(religion);
  Future updateReligion(Insertable<Religion> religion) =>
      update(religions).replace(religion);
  Future deleteReligion(Insertable<Religion> religion) =>
      delete(religions).delete(religion);

  Future<Religion> getReligionByOnlineId(int onlineId) {
    return (select(religions)..where((t) => t.onlineid.equals(onlineId)))
        .get()
        .then((List<Religion> religionList) {
      if (religionList.length > 0) {
        return religionList[0];
      } else {
        return null;
      }
    }, onError: (error) {
      return null;
    });
  }

  Future<Religion> getReligionById(int id) {
    return (select(religions)..where((t) => t.id.equals(id)))
        .get()
        .then((List<Religion> religionList) {
      if (religionList.length > 0) {
        return religionList[0];
      } else {
        return null;
      }
    }, onError: (error) {
      return null;
    });
  }

  Future updateAllReligion(List<ReligionsCompanion> religionsCompanionList) async {
    await batch((b) {
      for (ReligionsCompanion gsc in religionsCompanionList) {
        updateReligion(gsc);
      }
    });
  }

  Future insertAllReligion(List<ReligionsCompanion> religionsCompanionList) async {
    await batch((b) {
      b.insertAll(religions, religionsCompanionList);
    });
  }

  Future<List<Religion>> getActiveReligionList() {
    return (select(religions)
      ..orderBy(
        ([
              (t) => OrderingTerm(expression: t.id, mode: OrderingMode.asc),
        ]),
      )
      ..where((t) => t.active.equals(true)))
        .get();
  }
}

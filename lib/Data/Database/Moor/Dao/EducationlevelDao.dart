import 'package:dating_app/Data/Database/Moor/Core/AppDatabase.dart';
import 'package:dating_app/Data/Database/Moor/Tables/Educationlevels.dart';
import 'package:moor/moor.dart';
import 'package:moor_flutter/moor_flutter.dart';

part 'EducationlevelDao.g.dart';

@UseDao(tables: [Educationlevels])
class EducationLevelDao extends DatabaseAccessor<AppDatabase>
    with _$EducationLevelDaoMixin {
  final AppDatabase db;

  EducationLevelDao(this.db) : super(db);

  Future<List<Educationlevel>> getAllEducationLevels() =>
      select(educationlevels).get();
  Stream<List<Educationlevel>> watchAllEducationLevels() =>
      select(educationlevels).watch();
  Future insertEducationLevel(Insertable<Educationlevel> gender) =>
      into(educationlevels).insert(gender);
  Future updateEducationLevel(Insertable<Educationlevel> gender) =>
      update(educationlevels).replace(gender);
  Future deleteEducationLevel(Insertable<Educationlevel> gender) =>
      delete(educationlevels).delete(gender);

  Future<Educationlevel> getEducationlevelByOnlineId(int onlineId) {
    return (select(educationlevels)..where((t) => t.onlineid.equals(onlineId)))
        .get()
        .then((List<Educationlevel> educationlevelList) {
      if (educationlevelList.length > 0) {
        return educationlevelList[0];
      } else {
        return null;
      }
    }, onError: (error) {
      return null;
    });
  }

  Future<Educationlevel> getEducationlevelById(int id) {
    return (select(educationlevels)..where((t) => t.id.equals(id)))
        .get()
        .then((List<Educationlevel> educationlevelList) {
      if (educationlevelList.length > 0) {
        return educationlevelList[0];
      } else {
        return null;
      }
    }, onError: (error) {
      return null;
    });
  }

  Future updateAllEducationlevel(
      List<EducationlevelsCompanion> educationlevelsCompanionList) async {
    await batch((b) {
      for (EducationlevelsCompanion gsc in educationlevelsCompanionList) {
        updateEducationLevel(gsc);
      }
    });
  }

  Future insertAllEducationlevel(
      List<EducationlevelsCompanion> educationlevelsCompanionList) async {
    await batch((b) {
      b.insertAll(educationlevels, educationlevelsCompanionList);
    });
  }

  Future<List<Educationlevel>> getActiveEducationlevelList() {
    return (select(educationlevels)
          ..orderBy(
            ([
              (t) => OrderingTerm(expression: t.id, mode: OrderingMode.asc),
            ]),
          )
          ..where((t) => t.active.equals(true)))
        .get();
  }
}

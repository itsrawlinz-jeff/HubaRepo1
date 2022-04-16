import 'package:dating_app/Data/Database/Moor/Core/AppDatabase.dart';
import 'package:dating_app/Data/Database/Moor/Tables/Illnesss.dart';
import 'package:moor/moor.dart';
import 'package:moor_flutter/moor_flutter.dart';

part 'IllnessDao.g.dart';

@UseDao(tables: [Illnesss])
class IllnessDao extends DatabaseAccessor<AppDatabase> with _$IllnessDaoMixin {
  final AppDatabase db;

  IllnessDao(this.db) : super(db);

  Future<List<Illness>> getAllIllnesss() => select(illnesss).get();
  Stream<List<Illness>> watchAllIllnesss() => select(illnesss).watch();
  Future insertIllness(Insertable<Illness> illness) =>
      into(illnesss).insert(illness);
  Future updateIllness(Insertable<Illness> illness) =>
      update(illnesss).replace(illness);
  Future deleteIllness(Insertable<Illness> illness) =>
      delete(illnesss).delete(illness);

  Future<Illness> getIllnessByOnlineId(int onlineId) {
    return (select(illnesss)..where((t) => t.onlineid.equals(onlineId)))
        .get()
        .then((List<Illness> genderList) {
      if (genderList.length > 0) {
        return genderList[0];
      } else {
        return null;
      }
    }, onError: (error) {
      return null;
    });
  }

  Future<Illness> getIllnessById(int id) {
    return (select(illnesss)..where((t) => t.id.equals(id))).get().then(
        (List<Illness> illnessList) {
      if (illnessList.length > 0) {
        return illnessList[0];
      } else {
        return null;
      }
    }, onError: (error) {
      return null;
    });
  }

  Future updateAllIllness(List<IllnesssCompanion> illnesssCompanionList) async {
    await batch((b) {
      for (IllnesssCompanion gsc in illnesssCompanionList) {
        updateIllness(gsc);
      }
    });
  }

  Future insertAllIllness(List<IllnesssCompanion> illnesssCompanionList) async {
    await batch((b) {
      b.insertAll(illnesss, illnesssCompanionList);
    });
  }

  Future<List<Illness>> getActiveIllnessList() {
    return (select(illnesss)
          ..orderBy(
            ([
              (t) => OrderingTerm(expression: t.id, mode: OrderingMode.asc),
            ]),
          )
          ..where((t) => t.active.equals(true)))
        .get();
  }

  Future<List<Illness>> getIllnesssByName(String name) {
    String TAG = 'getIllnesssByName:';
    return (select(illnesss)
          ..where((t) =>
              t.name.upper().equals(name.toUpperCase()) |
              t.name.upper().like('${name.toUpperCase()}%')))
        .get()
        .then((List<Illness> illnessList) {
      if (illnessList.length > 0) {
        return illnessList;
      } else {
        return [];
      }
    }, onError: (error) {
      print(TAG + 'error==');
      print(error.toString());
      return [];
    });
  }
}

import 'package:dating_app/Data/Database/Moor/Core/AppDatabase.dart';
import 'package:dating_app/Data/Database/Moor/Tables/Hobbies.dart';
import 'package:moor/moor.dart';
import 'package:moor_flutter/moor_flutter.dart';

part 'HobbyDao.g.dart';

@UseDao(tables: [Hobbies])
class HobbyDao extends DatabaseAccessor<AppDatabase> with _$HobbyDaoMixin {
  final AppDatabase db;

  HobbyDao(this.db) : super(db);

  Future<List<Hobbie>> getAllHobbies() => select(hobbies).get();
  Stream<List<Hobbie>> watchAllHobbies() => select(hobbies).watch();
  Future insertHobbie(Insertable<Hobbie> ethnicitie) =>
      into(hobbies).insert(ethnicitie);
  Future updateHobbie(Insertable<Hobbie> ethnicitie) =>
      update(hobbies).replace(ethnicitie);
  Future deleteHobbie(Insertable<Hobbie> ethnicitie) =>
      delete(hobbies).delete(ethnicitie);

  Future<Hobbie> getHobbieByOnlineId(int onlineId) {
    return (select(hobbies)..where((t) => t.onlineid.equals(onlineId)))
        .get()
        .then((List<Hobbie> hobbieList) {
      if (hobbieList.length > 0) {
        return hobbieList[0];
      } else {
        return null;
      }
    }, onError: (error) {
      return null;
    });
  }

  Future<Hobbie> getHobbieById(int onlineId) {
    return (select(hobbies)..where((t) => t.id.equals(onlineId)))
        .get()
        .then((List<Hobbie> hobbieList) {
      if (hobbieList.length > 0) {
        return hobbieList[0];
      } else {
        return null;
      }
    }, onError: (error) {
      return null;
    });
  }

  Future updateAllHobbie(List<HobbiesCompanion> hobbiesCompanionList) async {
    await batch((b) {
      for (HobbiesCompanion gsc in hobbiesCompanionList) {
        updateHobbie(gsc);
      }
    });
  }

  Future insertAllHobbie(List<HobbiesCompanion> hobbiesCompanionList) async {
    await batch((b) {
      b.insertAll(hobbies, hobbiesCompanionList);
    });
  }

  Future<List<Hobbie>> getActiveHobbieList() {
    return (select(hobbies)
      ..orderBy(
        ([
              (t) => OrderingTerm(expression: t.id, mode: OrderingMode.asc),
        ]),
      )
      ..where((t) => t.active.equals(true)))
        .get();
  }

  Future<List<Hobbie>> getHobbiesByName(String name) {
    String TAG = 'getHobbiesByName:';
    return (select(hobbies)
      ..where((t) =>
      t.name.upper().equals(name.toUpperCase()) |
      t.name.upper().like('${name}%')))
        .get()
        .then((List<Hobbie> clientdataList) {
      if (clientdataList.length > 0) {
        return clientdataList;
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

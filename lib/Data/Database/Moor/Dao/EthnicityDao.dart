import 'package:dating_app/Data/Database/Moor/Core/AppDatabase.dart';
import 'package:dating_app/Data/Database/Moor/Tables/Ethnicities.dart';
import 'package:moor/moor.dart';
import 'package:moor_flutter/moor_flutter.dart';

part 'EthnicityDao.g.dart';

@UseDao(tables: [Ethnicities])
class EthnicityDao extends DatabaseAccessor<AppDatabase> with _$EthnicityDaoMixin {
  final AppDatabase db;

  EthnicityDao(this.db) : super(db);

  Future<List<Ethnicitie>> getAllEthnicities() => select(ethnicities).get();
  Stream<List<Ethnicitie>> watchAllEthnicities() => select(ethnicities).watch();
  Future insertEthnicitie(Insertable<Ethnicitie> ethnicitie) =>
      into(ethnicities).insert(ethnicitie);
  Future updateEthnicitie(Insertable<Ethnicitie> ethnicitie) =>
      update(ethnicities).replace(ethnicitie);
  Future deleteEthnicitie(Insertable<Ethnicitie> ethnicitie) =>
      delete(ethnicities).delete(ethnicitie);

  Future<Ethnicitie> getEthnicitieByOnlineId(int onlineId) {
    return (select(ethnicities)..where((t) => t.onlineid.equals(onlineId)))
        .get()
        .then((List<Ethnicitie> ethnicitieList) {
      if (ethnicitieList.length > 0) {
        return ethnicitieList[0];
      } else {
        return null;
      }
    }, onError: (error) {
      return null;
    });
  }

  Future<Ethnicitie> getEthnicitieById(int id) {
    return (select(ethnicities)..where((t) => t.id.equals(id)))
        .get()
        .then((List<Ethnicitie> ethnicitieList) {
      if (ethnicitieList.length > 0) {
        return ethnicitieList[0];
      } else {
        return null;
      }
    }, onError: (error) {
      return null;
    });
  }


  Future updateAllEthnicitie(
      List<EthnicitiesCompanion> ethnicitiesCompanionList) async {
    await batch((b) {
      for (EthnicitiesCompanion gsc in ethnicitiesCompanionList) {
        updateEthnicitie(gsc);
      }
    });
  }

  Future insertAllEthnicitie(
      List<EthnicitiesCompanion> ethnicitiesCompanionList) async {
    await batch((b) {
      b.insertAll(ethnicities, ethnicitiesCompanionList);
    });
  }

  Future<List<Ethnicitie>> getActiveEthnicitieList() {
    return (select(ethnicities)
      ..orderBy(
        ([
              (t) => OrderingTerm(expression: t.id, mode: OrderingMode.asc),
        ]),
      )
      ..where((t) => t.active.equals(true)))
        .get();
  }
}

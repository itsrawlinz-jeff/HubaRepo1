import 'package:dating_app/Data/Database/Moor/Core/AppDatabase.dart';
import 'package:dating_app/Data/Database/Moor/Tables/Services/Servicetrackers.dart';
import 'package:moor/moor.dart';
import 'package:moor_flutter/moor_flutter.dart';

part 'ServicetrackerDao.g.dart';

@UseDao(tables: [Servicetrackers])
class ServicetrackerDao extends DatabaseAccessor<AppDatabase>
    with _$ServicetrackerDaoMixin {
  final AppDatabase db;

  ServicetrackerDao(this.db) : super(db);

  Future<List<Servicetracker>> getAllServicetrackers() =>
      select(servicetrackers).get();
  Stream<List<Servicetracker>> watchAllServicetrackers() =>
      select(servicetrackers).watch();
  Future<int> insertServicetracker(Insertable<Servicetracker> servicetracker) =>
      into(servicetrackers).insert(servicetracker);
  Future<bool> updateServicetracker(
          Insertable<Servicetracker> servicetracker) =>
      update(servicetrackers).replace(servicetracker);
  Future deleteServicetracker(Insertable<Servicetracker> servicetracker) =>
      delete(servicetrackers).delete(servicetracker);

  Future<Servicetracker> getServicetrackerByOnlineId(int onlineId) {
    return (select(servicetrackers)..where((t) => t.onlineid.equals(onlineId)))
        .get()
        .then((List<Servicetracker> servicetrackerList) {
      if (servicetrackerList.length > 0) {
        return servicetrackerList[0];
      } else {
        return null;
      }
    }, onError: (error) {
      return null;
    });
  }

  Future updateAllServicetracker(
      List<ServicetrackersCompanion> servicetrackersCompanionList) async {
    await batch((b) {
      for (ServicetrackersCompanion gsc in servicetrackersCompanionList) {
        updateServicetracker(gsc);
      }
    });
  }

  Future insertAllServicetracker(
      List<ServicetrackersCompanion> servicetrackersCompanionList) async {
    await batch((b) {
      b.insertAll(servicetrackers, servicetrackersCompanionList);
    });
  }

  Future<List<Servicetracker>> getActiveServicetrackerList() {
    return (select(servicetrackers)
          ..orderBy(
            ([
              (t) => OrderingTerm(expression: t.id, mode: OrderingMode.asc),
            ]),
          )
          ..where((t) => t.active.equals(true)))
        .get();
  }

  Future<Servicetracker> getServicetrackerByName(String servicetrackerName) {
    return (select(servicetrackers)
          ..where((t) => t.name.equals(servicetrackerName)))
        .get()
        .then((List<Servicetracker> servicetrackerList) {
      if (servicetrackerList != null && servicetrackerList.length > 0) {
        return servicetrackerList[0];
      } else {
        return null;
      }
    }, onError: (error) {
      print('error==${error}');
      return null;
    });
  }
}

import 'package:dating_app/Data/Database/Moor/Core/AppDatabase.dart';
import 'package:dating_app/Data/Database/Moor/Tables/Somethingspecifics.dart';
import 'package:moor/moor.dart';
import 'package:moor_flutter/moor_flutter.dart';

part 'SomethingspecificDao.g.dart';

@UseDao(tables: [Somethingspecifics])
class SomethingspecificDao extends DatabaseAccessor<AppDatabase> with _$SomethingspecificDaoMixin {
  final AppDatabase db;

  SomethingspecificDao(this.db) : super(db);

  Future<List<Somethingspecific>> getAllSomethingspecifics() => select(somethingspecifics).get();
  Stream<List<Somethingspecific>> watchAllSomethingspecifics() => select(somethingspecifics).watch();
  Future insertSomethingspecific(Insertable<Somethingspecific> somethingspecific) =>
      into(somethingspecifics).insert(somethingspecific);
  Future updateSomethingspecific(Insertable<Somethingspecific> somethingspecific) =>
      update(somethingspecifics).replace(somethingspecific);
  Future deleteSomethingspecific(Insertable<Somethingspecific> somethingspecific) =>
      delete(somethingspecifics).delete(somethingspecific);

  Future<Somethingspecific> getSomethingspecificByOnlineId(int onlineId) {
    return (select(somethingspecifics)..where((t) => t.onlineid.equals(onlineId)))
        .get()
        .then((List<Somethingspecific> somethingspecificList) {
      if (somethingspecificList.length > 0) {
        return somethingspecificList[0];
      } else {
        return null;
      }
    }, onError: (error) {
      return null;
    });
  }

  Future updateAllSomethingspecific(List<SomethingspecificsCompanion> somethingspecificsCompanionList) async {
    await batch((b) {
      for (SomethingspecificsCompanion gsc in somethingspecificsCompanionList) {
        updateSomethingspecific(gsc);
      }
    });
  }

  Future insertAllSomethingspecific(List<SomethingspecificsCompanion> somethingspecificsCompanionList) async {
    await batch((b) {
      b.insertAll(somethingspecifics, somethingspecificsCompanionList);
    });
  }

  Future<List<Somethingspecific>> getActiveSomethingspecificList() {
    return (select(somethingspecifics)
      ..orderBy(
        ([
              (t) => OrderingTerm(expression: t.id, mode: OrderingMode.asc),
        ]),
      )
      ..where((t) => t.active.equals(true)))
        .get();
  }



}

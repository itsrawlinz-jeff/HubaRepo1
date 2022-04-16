import 'package:dating_app/Data/Database/Moor/Core/AppDatabase.dart';
import 'package:dating_app/Data/Database/Moor/Tables/Relationshipstatuses.dart';
import 'package:moor/moor.dart';
import 'package:moor_flutter/moor_flutter.dart';

part 'RelationshipstatusDao.g.dart';

@UseDao(tables: [Relationshipstatuses])
class RelationshipstatusDao extends DatabaseAccessor<AppDatabase>
    with _$RelationshipstatusDaoMixin {
  final AppDatabase db;

  RelationshipstatusDao(this.db) : super(db);

  Future<List<Relationshipstatuse>> getAllRelationshipStatus() =>
      select(relationshipstatuses).get();
  Stream<List<Relationshipstatuse>> watchAllRelationshipStatus() =>
      select(relationshipstatuses).watch();
  Future insertRelationshipStatus(
          Insertable<Relationshipstatuse> relationshipStatus) =>
      into(relationshipstatuses).insert(relationshipStatus);
  Future updateRelationshipStatus(
          Insertable<Relationshipstatuse> relationshipStatus) =>
      update(relationshipstatuses).replace(relationshipStatus);
  Future deleteRelationshipStatus(
          Insertable<Relationshipstatuse> relationshipStatus) =>
      delete(relationshipstatuses).delete(relationshipStatus);

  Future<Relationshipstatuse> getRelationshipstatuseByOnlineId(int onlineId) {
    return (select(relationshipstatuses)
          ..where((t) => t.onlineid.equals(onlineId)))
        .get()
        .then((List<Relationshipstatuse> relationshipstatuseList) {
      if (relationshipstatuseList.length > 0) {
        return relationshipstatuseList[0];
      } else {
        return null;
      }
    }, onError: (error) {
      return null;
    });
  }

  Future<Relationshipstatuse> getRelationshipstatuseById(int id) {
    return (select(relationshipstatuses)
      ..where((t) => t.id.equals(id)))
        .get()
        .then((List<Relationshipstatuse> relationshipstatuseList) {
      if (relationshipstatuseList.length > 0) {
        return relationshipstatuseList[0];
      } else {
        return null;
      }
    }, onError: (error) {
      return null;
    });
  }

  Future updateAllRelationshipstatuse(
      List<RelationshipstatusesCompanion>
          relationshipstatusesCompanionList) async {
    await batch((b) {
      for (RelationshipstatusesCompanion gsc
          in relationshipstatusesCompanionList) {
        updateRelationshipStatus(gsc);
      }
    });
  }

  Future insertAllRelationshipstatuse(
      List<RelationshipstatusesCompanion>
          relationshipstatusesCompanionList) async {
    await batch((b) {
      b.insertAll(relationshipstatuses, relationshipstatusesCompanionList);
    });
  }

  Future<List<Relationshipstatuse>> getActiveRelationshipstatuseList() {
    return (select(relationshipstatuses)
          ..orderBy(
            ([
              (t) => OrderingTerm(expression: t.id, mode: OrderingMode.asc),
            ]),
          )
          ..where((t) => t.active.equals(true)))
        .get();
  }
}

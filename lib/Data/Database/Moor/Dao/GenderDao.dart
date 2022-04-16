import 'package:dating_app/Data/Database/Moor/Core/AppDatabase.dart';
import 'package:dating_app/Data/Database/Moor/Tables/Genders.dart';
import 'package:moor/moor.dart';
import 'package:moor_flutter/moor_flutter.dart';

part 'GenderDao.g.dart';

@UseDao(tables: [Genders])
class GenderDao extends DatabaseAccessor<AppDatabase> with _$GenderDaoMixin {
  final AppDatabase db;

  GenderDao(this.db) : super(db);

  Future<List<Gender>> getAllGenders() => select(genders).get();
  Stream<List<Gender>> watchAllGenders() => select(genders).watch();
  Future insertGender(Insertable<Gender> gender) =>
      into(genders).insert(gender);
  Future updateGender(Insertable<Gender> gender) =>
      update(genders).replace(gender);
  Future deleteGender(Insertable<Gender> gender) =>
      delete(genders).delete(gender);

  Future<Gender> getGenderByOnlineId(int onlineId) {
    return (select(genders)..where((t) => t.onlineid.equals(onlineId)))
        .get()
        .then((List<Gender> genderList) {
      if (genderList.length > 0) {
        return genderList[0];
      } else {
        return null;
      }
    }, onError: (error) {
      return null;
    });
  }

  Future<Gender> getGenderById(int id) {
    return (select(genders)..where((t) => t.id.equals(id)))
        .get()
        .then((List<Gender> genderList) {
      if (genderList.length > 0) {
        return genderList[0];
      } else {
        return null;
      }
    }, onError: (error) {
      return null;
    });
  }


  Future updateAllGender(List<GendersCompanion> gendersCompanionList) async {
    await batch((b) {
      for (GendersCompanion gsc in gendersCompanionList) {
        updateGender(gsc);
      }
    });
  }

  Future insertAllGender(List<GendersCompanion> gendersCompanionList) async {
    await batch((b) {
      b.insertAll(genders, gendersCompanionList);
    });
  }

  Future<List<Gender>> getActiveGenderList() {
    return (select(genders)
          ..orderBy(
            ([
              (t) => OrderingTerm(expression: t.id, mode: OrderingMode.asc),
            ]),
          )
          ..where((t) => t.active.equals(true)))
        .get();
  }

  Future<List<Gender>> getMaleFemaleGenderOnlyList() {
    return customSelectQuery(
        'SELECT * FROM genders WHERE active = :active AND (LOWER(name) = LOWER(:namemale) or LOWER(name) = LOWER(:namefemale))  ORDER BY :orderBy',
        variables: [
          Variable.withBool(true),
          Variable.withString('Male'),
          Variable.withString('Female')
        ],
        readsFrom: {
          genders
        }).map((rows) => Gender.fromData(rows.data, db)).get();

    /* return (select(genders)
          ..orderBy(
            ([
              (t) => OrderingTerm(expression: t.id, mode: OrderingMode.asc),
            ]),
          )
          ..where((t) => t.active.equals(true))
          ..where((t) => t.name.equals('Male'))
          ..where((t) => t.name.equals('Female')))
        .get();*/
  }
}

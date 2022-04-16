import 'package:dating_app/Data/Database/Moor/Core/AppDatabase.dart';
import 'package:dating_app/Data/Database/Moor/JoinClasses/OnboardingsomethingspecificJoinClass.dart';
import 'package:dating_app/Data/Database/Moor/Tables/Onboardings.dart';
import 'package:dating_app/Data/Database/Moor/Tables/Onboardingsomethingspecifics.dart';
import 'package:dating_app/Data/Database/Moor/Tables/Somethingspecifics.dart';
import 'package:moor/moor.dart';
import 'package:moor_flutter/moor_flutter.dart';

part 'OnboardingsomethingspecificDao.g.dart';

@UseDao(tables: [
  Onboardingsomethingspecifics,
  Onboardings,
  Somethingspecifics,
])
class OnboardingsomethingspecificDao extends DatabaseAccessor<AppDatabase>
    with _$OnboardingsomethingspecificDaoMixin {
  final AppDatabase db;

  OnboardingsomethingspecificDao(this.db) : super(db);

  Future<List<Onboardingsomethingspecific>>
      getAllOnboardingsomethingspecific() =>
          select(onboardingsomethingspecifics).get();
  Stream<List<Onboardingsomethingspecific>>
      watchAllOnboardingsomethingspecific() =>
          select(onboardingsomethingspecifics).watch();
  Future<int> insertOnboardingsomethingspecific(
          Insertable<Onboardingsomethingspecific>
              onboardingsomethingspecific) =>
      into(onboardingsomethingspecifics).insert(onboardingsomethingspecific);
  Future<bool> updateOnboardingsomethingspecific(
          Insertable<Onboardingsomethingspecific>
              onboardingsomethingspecific) =>
      update(onboardingsomethingspecifics).replace(onboardingsomethingspecific);
  Future<int> deleteOnboardingsomethingspecific(
          Insertable<Onboardingsomethingspecific>
              onboardingsomethingspecific) =>
      delete(onboardingsomethingspecifics).delete(onboardingsomethingspecific);

  Future<int> countOnboardingsomethingspecific() async {
    return (await select(onboardingsomethingspecifics).get()).length;
  }

  Future<bool> isSomethingspecificInOnBoardingById(
      int somethingspecificId, int onboardingId) {
    return (select(onboardingsomethingspecifics)
          ..where((t) => t.onboarding.equals(onboardingId))
          ..where((t) => t.somethingspecifics.equals(somethingspecificId)))
        .get()
        .then((List<Onboardingsomethingspecific>
            onboardingsomethingspecificList) {
      if (onboardingsomethingspecificList.length > 0) {
        return true;
      } else {
        return false;
      }
    }, onError: (error) {
      return false;
    });
  }

  Future<Onboardingsomethingspecific> getSomethingspecificInOnBoardingById(
      int somethingspecificId, int onboardingId) {
    return (select(onboardingsomethingspecifics)
          ..where((t) => t.onboarding.equals(onboardingId))
          ..where((t) => t.somethingspecifics.equals(somethingspecificId)))
        .get()
        .then((List<Onboardingsomethingspecific>
            onboardingsomethingspecificList) {
      if (onboardingsomethingspecificList.length > 0) {
        return onboardingsomethingspecificList[0];
      } else {
        return null;
      }
    }, onError: (error) {
      return null;
    });
  }

  deleteAllOnboardingsomethingspecific() {
    String TAG = 'deleteAllOnboardingsomethingspecific:';
    try {
      return delete(onboardingsomethingspecifics).go();
    } catch (e) {
      print(TAG + ' error==');
      print(e.toString());
    }
  }

  Future<List<OnboardingsomethingspecificJoinClass>>
      getOnboardingsomethingspecificJoinClassByOnboardingId(int onboardingId) {
    String TAG = 'getOnboardingsomethingspecificJoinClassByOnboardingId:';
    var query = (select(onboardingsomethingspecifics)).join([
      leftOuterJoin(
          somethingspecifics,
          somethingspecifics.id
              .equalsExp(onboardingsomethingspecifics.somethingspecifics)),
      leftOuterJoin(onboardings,
          onboardings.id.equalsExp(onboardingsomethingspecifics.onboarding)),
    ])
      ..where(onboardings.id.equals(onboardingId));
    return query.get().then((typedData) {
      List<OnboardingsomethingspecificJoinClass>
          onboardingsomethingspecificJoinClassList = [];
      for (var onetypedData in typedData) {
        onboardingsomethingspecificJoinClassList
            .add(new OnboardingsomethingspecificJoinClass(
          somethingspecific: onetypedData.readTable(somethingspecifics),
          onboarding: onetypedData.readTable(onboardings),
          onboardingsomethingspecific:
              onetypedData.readTable(onboardingsomethingspecifics),
        ));
      }
      return onboardingsomethingspecificJoinClassList;
    }, onError: (error) {
      print(TAG + error);
      return [];
    });
  }
}

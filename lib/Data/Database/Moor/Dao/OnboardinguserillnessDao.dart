import 'package:dating_app/Data/Database/Moor/Core/AppDatabase.dart';
import 'package:dating_app/Data/Database/Moor/JoinClasses/OnboardinguserillnessJoinClass.dart';
import 'package:dating_app/Data/Database/Moor/Tables/Illnesss.dart';
import 'package:dating_app/Data/Database/Moor/Tables/Onboardings.dart';
import 'package:dating_app/Data/Database/Moor/Tables/Onboardinguserillnesss.dart';
import 'package:moor/moor.dart';
import 'package:moor_flutter/moor_flutter.dart';

part 'OnboardinguserillnessDao.g.dart';

@UseDao(tables: [
  Onboardinguserillnesss,
  Onboardings,
  Illnesss,
])
class OnboardinguserillnessDao extends DatabaseAccessor<AppDatabase>
    with _$OnboardinguserillnessDaoMixin {
  final AppDatabase db;

  OnboardinguserillnessDao(this.db) : super(db);

  Future<List<Onboardinguserillness>> getAllOnboardinguserillnesss() =>
      select(onboardinguserillnesss).get();
  Stream<List<Onboardinguserillness>> watchAllOnboardinguserillnesss() =>
      select(onboardinguserillnesss).watch();
  Future insertOnboardinguserillness(
          Insertable<Onboardinguserillness> onboardinguserillness) =>
      into(onboardinguserillnesss).insert(onboardinguserillness);
  Future updateOnboardinguserillness(
          Insertable<Onboardinguserillness> onboardinguserillness) =>
      update(onboardinguserillnesss).replace(onboardinguserillness);
  Future deleteOnboardinguserillness(
          Insertable<Onboardinguserillness> onboardinguserillness) =>
      delete(onboardinguserillnesss).delete(onboardinguserillness);

  Future<Onboardinguserillness> getIllnessByOnlineId(int onlineId) {
    return (select(onboardinguserillnesss)
          ..where((t) => t.onlineid.equals(onlineId)))
        .get()
        .then((List<Onboardinguserillness> onboardinguserillnessList) {
      if (onboardinguserillnessList.length > 0) {
        return onboardinguserillnessList[0];
      } else {
        return null;
      }
    }, onError: (error) {
      return null;
    });
  }

  Future updateAllIllness(
      List<OnboardinguserillnesssCompanion> illnesssCompanionList) async {
    await batch((b) {
      for (OnboardinguserillnesssCompanion gsc in illnesssCompanionList) {
        updateOnboardinguserillness(gsc);
      }
    });
  }

  Future insertAllIllness(
      List<OnboardinguserillnesssCompanion> illnesssCompanionList) async {
    await batch((b) {
      b.insertAll(onboardinguserillnesss, illnesssCompanionList);
    });
  }

  Future<bool> isIllnessInOnBoardingById(int illnessId, int onboardingId) {
    return (select(onboardinguserillnesss)
          ..where((t) => t.onboarding.equals(onboardingId))
          ..where((t) => t.illness.equals(illnessId)))
        .get()
        .then((List<Onboardinguserillness> onboardinguserillnessList) {
      if (onboardinguserillnessList.length > 0) {
        return true;
      } else {
        return false;
      }
    }, onError: (error) {
      return false;
    });
  }

  Future<Onboardinguserillness> getIllnessInOnBoardingById(
      int illnessId, int onboardingId) {
    return (select(onboardinguserillnesss)
          ..where((t) => t.onboarding.equals(onboardingId))
          ..where((t) => t.illness.equals(illnessId)))
        .get()
        .then((List<Onboardinguserillness> onboardinguserillnessList) {
      if (onboardinguserillnessList.length > 0) {
        return onboardinguserillnessList[0];
      } else {
        return null;
      }
    }, onError: (error) {
      return null;
    });
  }

  Future deleteAllOnboardinguserillnesssFuture(
      List<Onboardinguserillness> onboardinguserillnessList) async {
    await batch((b) {
      for (Onboardinguserillness smc in onboardinguserillnessList) {
        deleteOnboardinguserillnessFuture(smc);
      }
    });
  }

  Future<int> deleteOnboardinguserillnessFuture(
          Onboardinguserillness onboardinguserillness) =>
      delete(onboardinguserillnesss).delete(onboardinguserillness);

  deleteAllOnboardinguserillness() {
    String TAG = 'deleteAllOnboardinguserillness:';
    try {
      return delete(onboardinguserillnesss).go();
    } catch (e) {
      print(TAG + ' error==');
      print(e.toString());
    }
  }

  Future<List<OnboardinguserillnessJoinClass>>
      getOnboardinguserillnessJoinClassByOnboardingId(int onboardingId) {
    String TAG = 'getOnboardinginterestJoinClassByOnboardingId:';
    var query = (select(onboardinguserillnesss)).join([
      leftOuterJoin(
          illnesss, illnesss.id.equalsExp(onboardinguserillnesss.illness)),
      leftOuterJoin(onboardings,
          onboardings.id.equalsExp(onboardinguserillnesss.onboarding)),
    ])
      ..where(onboardings.id.equals(onboardingId));
    return query.get().then((typedData) {
      List<OnboardinguserillnessJoinClass> onboardinguserillnessJoinClassList =
          [];
      for (var onetypedData in typedData) {
        onboardinguserillnessJoinClassList
            .add(new OnboardinguserillnessJoinClass(
          illness: onetypedData.readTable(illnesss),
          onboarding: onetypedData.readTable(onboardings),
          onboardinguserillness: onetypedData.readTable(onboardinguserillnesss),
        ));
      }
      return onboardinguserillnessJoinClassList;
    }, onError: (error) {
      print(TAG + error);
      return [];
    });
  }
}

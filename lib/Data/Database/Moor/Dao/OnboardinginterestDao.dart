import 'package:dating_app/Data/Database/Moor/Core/AppDatabase.dart';
import 'package:dating_app/Data/Database/Moor/JoinClasses/OnboardinginterestJoinClass.dart';
import 'package:dating_app/Data/Database/Moor/Tables/Hobbies.dart';
import 'package:dating_app/Data/Database/Moor/Tables/Onboardinginterests.dart';
import 'package:dating_app/Data/Database/Moor/Tables/Onboardings.dart';
import 'package:moor/moor.dart';
import 'package:moor_flutter/moor_flutter.dart';

part 'OnboardinginterestDao.g.dart';

@UseDao(tables: [
  Onboardinginterests,
  Hobbies,
  Onboardings,
])
class OnboardinginterestDao extends DatabaseAccessor<AppDatabase>
    with _$OnboardinginterestDaoMixin {
  final AppDatabase db;

  OnboardinginterestDao(this.db) : super(db);

  Future<List<Onboardinginterest>> getAllOnboardinginterests() =>
      select(onboardinginterests).get();
  Stream<List<Onboardinginterest>> watchAllOnboardinginterests() =>
      select(onboardinginterests).watch();
  Future insertOnboardinginterest(
          Insertable<Onboardinginterest> onBoardingInterest) =>
      into(onboardinginterests).insert(onBoardingInterest);
  Future updateOnboardinginterest(
          Insertable<Onboardinginterest> onBoardingInterest) =>
      update(onboardinginterests).replace(onBoardingInterest);
  Future deleteOnboardinginterest(
          Insertable<Onboardinginterest> onBoardingInterest) =>
      delete(onboardinginterests).delete(onBoardingInterest);
  Future<int> countOnboardinginterestc() async {
    return (await select(onboardinginterests).get()).length;
  }

  Future<bool> isHobbyInOnBoardingById(int hobbieId, int onboardingId) {
    return (select(onboardinginterests)
          ..where((t) => t.onboarding.equals(onboardingId))
          ..where((t) => t.hobbie.equals(hobbieId)))
        .get()
        .then((List<Onboardinginterest> onboardinginterestList) {
      if (onboardinginterestList.length > 0) {
        return true;
      } else {
        return false;
      }
    }, onError: (error) {
      return false;
    });
  }

  Future<List<OnboardinginterestJoinClass>>
      getOnboardinginterestJoinClassByOnboardingId(int onboardingId) {
    String TAG = 'getOnboardinginterestJoinClassByOnboardingId:';
    var query = (select(onboardinginterests)).join([
      leftOuterJoin(hobbies, hobbies.id.equalsExp(onboardinginterests.hobbie)),
      leftOuterJoin(onboardings,
          onboardings.id.equalsExp(onboardinginterests.onboarding)),
    ])
      ..where(onboardings.id.equals(onboardingId));
    return query.get().then((typedData) {
      List<OnboardinginterestJoinClass> onboardinginterestJoinClassList = [];
      for (var onetypedData in typedData) {
        onboardinginterestJoinClassList.add(new OnboardinginterestJoinClass(
          hobbie: onetypedData.readTable(hobbies),
          onboarding: onetypedData.readTable(onboardings),
          onboardinginterest: onetypedData.readTable(onboardinginterests),
        ));
      }
      return onboardinginterestJoinClassList;
    }, onError: (error) {
      print(TAG + error);
      return [];
    });
  }

  Future<Onboardinginterest> getHobbyInOnBoardingById(
      int hobbieId, int onboardingId) {
    return (select(onboardinginterests)
          ..where((t) => t.onboarding.equals(onboardingId))
          ..where((t) => t.hobbie.equals(hobbieId)))
        .get()
        .then((List<Onboardinginterest> onboardinginterestList) {
      if (onboardinginterestList.length > 0) {
        return onboardinginterestList[0];
      } else {
        return null;
      }
    }, onError: (error) {
      return null;
    });
  }

  Future<Onboardinginterest> getOnboardinginterestById(
      int onboardinginterestId) {
    return (select(onboardinginterests)
          ..where((t) => t.id.equals(onboardinginterestId)))
        .get()
        .then((List<Onboardinginterest> onboardinginterestList) {
      if (onboardinginterestList.length > 0) {
        return onboardinginterestList[0];
      } else {
        return null;
      }
    }, onError: (error) {
      return null;
    });
  }

  deleteAllOnboardinginterest() {
    String TAG = 'deleteAllOnboardinginterest:';
    try {
      return delete(onboardinginterests).go();
    } catch (e) {
      print(TAG + ' error==');
      print(e.toString());
    }
  }
}

import 'package:dating_app/Data/Database/Moor/Core/AppDatabase.dart';
import 'package:dating_app/Data/Database/Moor/JoinClasses/OnboardingmoneyshemakesJoinClass.dart';
import 'package:dating_app/Data/Database/Moor/Tables/Incomeranges.dart';
import 'package:dating_app/Data/Database/Moor/Tables/Onboardingmoneyshemakes.dart';
import 'package:dating_app/Data/Database/Moor/Tables/Onboardings.dart';
import 'package:moor/moor.dart';
import 'package:moor_flutter/moor_flutter.dart';

part 'OnboardingmoneyshemakeDao.g.dart';

@UseDao(tables: [
  Onboardingmoneyshemakes,
  Onboardings,
  Incomeranges,
])
class OnboardingmoneyshemakeDao extends DatabaseAccessor<AppDatabase>
    with _$OnboardingmoneyshemakeDaoMixin {
  final AppDatabase db;

  OnboardingmoneyshemakeDao(this.db) : super(db);

  Future<List<Onboardingmoneyshemake>> getAllOnboardingmoneyshemakes() =>
      select(onboardingmoneyshemakes).get();
  Stream<List<Onboardingmoneyshemake>> watchAllOnboardingmoneyshemakes() =>
      select(onboardingmoneyshemakes).watch();
  Future insertOnboardingmoneyshemake(
          Insertable<Onboardingmoneyshemake> onBoardingMoneySheMake) =>
      into(onboardingmoneyshemakes).insert(onBoardingMoneySheMake);
  Future updateOnboardingmoneyshemake(
          Insertable<Onboardingmoneyshemake> onBoardingMoneySheMake) =>
      update(onboardingmoneyshemakes).replace(onBoardingMoneySheMake);
  Future deleteOnboardingmoneyshemake(
          Insertable<Onboardingmoneyshemake> onBoardingMoneySheMake) =>
      delete(onboardingmoneyshemakes).delete(onBoardingMoneySheMake);
  Future<int> countOnboardingmoneyshemake() async {
    return (await select(onboardingmoneyshemakes).get()).length;
  }

  Future<bool> isIncomeRangeInOnBoardingById(
      int incomeRangeId, int onboardingId) {
    return (select(onboardingmoneyshemakes)
          ..where((t) => t.onboarding.equals(onboardingId))
          ..where((t) => t.incomeRange.equals(incomeRangeId)))
        .get()
        .then((List<Onboardingmoneyshemake> onboardingmoneyshemakeList) {
      if (onboardingmoneyshemakeList.length > 0) {
        return true;
      } else {
        return false;
      }
    }, onError: (error) {
      return false;
    });
  }

  Future<Onboardingmoneyshemake> getIncomeRangeInOnBoardingById(
      int incomeRangeId, int onboardingId) {
    return (select(onboardingmoneyshemakes)
          ..where((t) => t.onboarding.equals(onboardingId))
          ..where((t) => t.incomeRange.equals(incomeRangeId)))
        .get()
        .then((List<Onboardingmoneyshemake> onboardingmoneyshemakeList) {
      if (onboardingmoneyshemakeList.length > 0) {
        return onboardingmoneyshemakeList[0];
      } else {
        return null;
      }
    }, onError: (error) {
      return null;
    });
  }

  Future<Onboardingmoneyshemake> getOnboardingmoneyshemakeById(
      int onboardingmoneyshemakeId) {
    return (select(onboardingmoneyshemakes)
          ..where((t) => t.id.equals(onboardingmoneyshemakeId)))
        .get()
        .then((List<Onboardingmoneyshemake> onboardingmoneyshemakeList) {
      if (onboardingmoneyshemakeList.length > 0) {
        return onboardingmoneyshemakeList[0];
      } else {
        return null;
      }
    }, onError: (error) {
      return null;
    });
  }

  deleteAllOnboardingmoneyshemake() {
    String TAG = 'deleteAllOnboardingmoneyshemake:';
    try {
      return delete(onboardingmoneyshemakes).go();
    } catch (e) {
      print(TAG + ' error==');
      print(e.toString());
    }
  }

  Future<List<OnboardingmoneyshemakesJoinClass>>
      getOnboardingmoneyshemakesJoinClassByOnboardingId(int onboardingId) {
    String TAG = 'getOnboardinginterestJoinClassByOnboardingId:';
    var query = (select(onboardingmoneyshemakes)).join([
      leftOuterJoin(incomeranges,
          incomeranges.id.equalsExp(onboardingmoneyshemakes.incomeRange)),
      leftOuterJoin(onboardings,
          onboardings.id.equalsExp(onboardingmoneyshemakes.onboarding)),
    ])
      ..where(onboardings.id.equals(onboardingId));
    return query.get().then((typedData) {
      List<OnboardingmoneyshemakesJoinClass> onboardinginterestJoinClassList =
          [];
      for (var onetypedData in typedData) {
        onboardinginterestJoinClassList
            .add(new OnboardingmoneyshemakesJoinClass(
          incomerange: onetypedData.readTable(incomeranges),
          onboarding: onetypedData.readTable(onboardings),
          onboardingmoneyshemake:
              onetypedData.readTable(onboardingmoneyshemakes),
        ));
      }
      return onboardinginterestJoinClassList;
    }, onError: (error) {
      print(TAG + error);
      return [];
    });
  }
}

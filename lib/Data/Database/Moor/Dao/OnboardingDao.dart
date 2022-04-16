import 'package:dating_app/Data/Database/Moor/Core/AppDatabase.dart';
import 'package:dating_app/Data/Database/Moor/Tables/Onboardings.dart';
import 'package:moor/moor.dart';
import 'package:moor_flutter/moor_flutter.dart';

part 'OnboardingDao.g.dart';

@UseDao(tables: [Onboardings])
class OnboardingDao extends DatabaseAccessor<AppDatabase>
    with _$OnboardingDaoMixin {
  final AppDatabase db;

  OnboardingDao(this.db) : super(db);

  Future<List<Onboarding>> getAllOnboardings() => select(onboardings).get();
  Stream<List<Onboarding>> watchAllOnboardings() => select(onboardings).watch();
  Future<int> insertOnboarding(Insertable<Onboarding> onBoarding) =>
      into(onboardings).insert(onBoarding);
  Future<bool> updateOnboarding(Insertable<Onboarding> onBoarding) =>
      update(onboardings).replace(onBoarding);
  Future deleteOnboarding(Insertable<Onboarding> onBoarding) =>
      delete(onboardings).delete(onBoarding);

  Future<Onboarding> getOnboardingById(int id) {
    return (select(onboardings)..where((t) => t.id.equals(id))).get().then(
        (List<Onboarding> onBoardingList) {
      if (onBoardingList.length > 0) {
        return onBoardingList[0];
      } else {
        return null;
      }
    }, onError: (error) {
      print('error=${error}');
      return null;
    });
  }

  Future<Onboarding> getRecentOnboarding() {
    return (select(onboardings)
          ..orderBy(
            ([
              (t) => OrderingTerm(expression: t.id, mode: OrderingMode.asc),
              //(t) => OrderingTerm(expression: t.name),
            ]),
          )
          ..limit(1))
        .get()
        .then((List<Onboarding> onBoardingList) {
      print('onBoardingList len==${onBoardingList.length}');
      if (onBoardingList.length > 0) {
        return onBoardingList[0];
      } else {
        return null;
      }
    }, onError: (error) {
      print('error=${error}');
      return null;
    });
    //..where((t) => t.completed.equals(true)))
    //.watch();
  }

  Future<List<Onboarding>> getRecentOnboardingLimit1() {
    return (select(onboardings)
          ..orderBy(
            ([
              (t) => OrderingTerm(expression: t.id, mode: OrderingMode.asc),
            ]),
          )
          ..limit(1))
        .get();
  }

  Future deleteAllOnboardingsFuture(List<Onboarding> OnboardingList) async {
    await batch((b) {
      for (Onboarding smc in OnboardingList) {
        deleteOnboardingFuture(smc);
      }
    });
  }

  Future deleteAllOnboardingsIndBFuture() async {
    List<Onboarding> OnboardingList = await getAllOnboardings();
    await batch((b) {
      for (Onboarding smc in OnboardingList) {
        deleteOnboardingFuture(smc);
      }
    });
  }

  Future<int> deleteOnboardingFuture(Onboarding onboarding) =>
      delete(onboardings).delete(onboarding);
}

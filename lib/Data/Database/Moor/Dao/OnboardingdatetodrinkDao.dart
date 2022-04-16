import 'package:dating_app/Data/Database/Moor/Core/AppDatabase.dart';
import 'package:dating_app/Data/Database/Moor/Tables/Onboardingdatetodrinks.dart';
import 'package:moor/moor.dart';
import 'package:moor_flutter/moor_flutter.dart';

part 'OnboardingdatetodrinkDao.g.dart';

@UseDao(tables: [Onboardingdatetodrinks])
class OnboardingdatetodrinkDao extends DatabaseAccessor<AppDatabase> with _$OnboardingdatetodrinkDaoMixin {
  final AppDatabase db;

  OnboardingdatetodrinkDao(this.db) : super(db);

  Future<List<Onboardingdatetodrink>> getAllOnboardingdatetodrinks() => select(onboardingdatetodrinks).get();
  Stream<List<Onboardingdatetodrink>> watchAllOnboardingdatetodrinks() => select(onboardingdatetodrinks).watch();
  Future insertOnboardingdatetodrink(Insertable<Onboardingdatetodrink> onBoardingDateToDrink) =>
      into(onboardingdatetodrinks).insert(onBoardingDateToDrink);
  Future updateOnboardingdatetodrink(Insertable<Onboardingdatetodrink> onBoardingDateToDrink) =>
      update(onboardingdatetodrinks).replace(onBoardingDateToDrink);
  Future deleteOnboardingdatetodrink(Insertable<Onboardingdatetodrink> onBoardingDateToDrink) =>
      delete(onboardingdatetodrinks).delete(onBoardingDateToDrink);
}

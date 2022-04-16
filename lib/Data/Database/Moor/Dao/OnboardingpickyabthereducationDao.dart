import 'package:dating_app/Data/Database/Moor/Core/AppDatabase.dart';
import 'package:dating_app/Data/Database/Moor/Tables/Onboardingpickyabthereducations.dart';
import 'package:moor/moor.dart';
import 'package:moor_flutter/moor_flutter.dart';

part 'OnboardingpickyabthereducationDao.g.dart';

@UseDao(tables: [Onboardingpickyabthereducations])
class OnboardingpickyabthereducationDao extends DatabaseAccessor<AppDatabase> with _$OnboardingpickyabthereducationDaoMixin {
  final AppDatabase db;

  OnboardingpickyabthereducationDao(this.db) : super(db);

  Future<List<Onboardingpickyabthereducation>> getAllOnboardingpickyabthereducations() => select(onboardingpickyabthereducations).get();
  Stream<List<Onboardingpickyabthereducation>> watchAllOnboardingpickyabthereducations() => select(onboardingpickyabthereducations).watch();
  Future insertOnboardingpickyabthereducation(Insertable<Onboardingpickyabthereducation> onBoardingPickyAbtHerEducation) =>
      into(onboardingpickyabthereducations).insert(onBoardingPickyAbtHerEducation);
  Future updateOnboardingpickyabthereducation(Insertable<Onboardingpickyabthereducation> onBoardingPickyAbtHerEducation) =>
      update(onboardingpickyabthereducations).replace(onBoardingPickyAbtHerEducation);
  Future deleteOnboardingpickyabthereducation(Insertable<Onboardingpickyabthereducation> onBoardingPickyAbtHerEducation) =>
      delete(onboardingpickyabthereducations).delete(onBoardingPickyAbtHerEducation);
}

import 'package:dating_app/Data/Database/Moor/Dao/EducationlevelDao.dart';
import 'package:dating_app/Data/Database/Moor/Dao/EthnicityDao.dart';
import 'package:dating_app/Data/Database/Moor/Dao/GenderDao.dart';
import 'package:dating_app/Data/Database/Moor/Dao/HobbyDao.dart';
import 'package:dating_app/Data/Database/Moor/Dao/IllnessDao.dart';
import 'package:dating_app/Data/Database/Moor/Dao/IncomerangeDao.dart';
import 'package:dating_app/Data/Database/Moor/Dao/InterestDao.dart';
import 'package:dating_app/Data/Database/Moor/Dao/DrinkstatusDao.dart';
import 'package:dating_app/Data/Database/Moor/Dao/OnboardingDao.dart';
import 'package:dating_app/Data/Database/Moor/Dao/OnboardingdatetodrinkDao.dart';
import 'package:dating_app/Data/Database/Moor/Dao/OnboardinginterestDao.dart';
import 'package:dating_app/Data/Database/Moor/Dao/OnboardingmoneyshemakeDao.dart';
import 'package:dating_app/Data/Database/Moor/Dao/OnboardingpickyabthereducationDao.dart';
import 'package:dating_app/Data/Database/Moor/Dao/OnboardingsomethingspecificDao.dart';
import 'package:dating_app/Data/Database/Moor/Dao/OnboardinguserillnessDao.dart';
import 'package:dating_app/Data/Database/Moor/Dao/RelationshipstatusDao.dart';
import 'package:dating_app/Data/Database/Moor/Dao/ReligionDao.dart';
import 'package:dating_app/Data/Database/Moor/Dao/ServicetrackerDao.dart';
import 'package:dating_app/Data/Database/Moor/Dao/SmokestatusDao.dart';
import 'package:dating_app/Data/Database/Moor/Dao/SomethingspecificDao.dart';
import 'package:dating_app/Data/Database/Moor/Dao/UserprofileDao.dart';
import 'package:dating_app/Data/Database/Moor/Dao/WantchildrenstatusDao.dart';
import 'package:dating_app/Data/Database/Moor/Tables/Educationlevels.dart';
import 'package:dating_app/Data/Database/Moor/Tables/Ethnicities.dart';
import 'package:dating_app/Data/Database/Moor/Tables/Genders.dart';
import 'package:dating_app/Data/Database/Moor/Tables/Hobbies.dart';
import 'package:dating_app/Data/Database/Moor/Tables/Illnesss.dart';
import 'package:dating_app/Data/Database/Moor/Tables/Incomeranges.dart';
import 'package:dating_app/Data/Database/Moor/Tables/Interests.dart';
import 'package:dating_app/Data/Database/Moor/Tables/Drinkstatuses.dart';
import 'package:dating_app/Data/Database/Moor/Tables/Onboardingdatetodrinks.dart';
import 'package:dating_app/Data/Database/Moor/Tables/Onboardinginterests.dart';
import 'package:dating_app/Data/Database/Moor/Tables/Onboardingmoneyshemakes.dart';
import 'package:dating_app/Data/Database/Moor/Tables/Onboardingpickyabthereducations.dart';
import 'package:dating_app/Data/Database/Moor/Tables/Onboardingsomethingspecifics.dart';
import 'package:dating_app/Data/Database/Moor/Tables/Onboardings.dart';
import 'package:dating_app/Data/Database/Moor/Tables/Onboardinguserillnesss.dart';
import 'package:dating_app/Data/Database/Moor/Tables/Relationshipstatuses.dart';
import 'package:dating_app/Data/Database/Moor/Tables/Religions.dart';
import 'package:dating_app/Data/Database/Moor/Tables/Services/Servicetrackers.dart';
import 'package:dating_app/Data/Database/Moor/Tables/Smokestatuses.dart';
import 'package:dating_app/Data/Database/Moor/Tables/Somethingspecifics.dart';
import 'package:dating_app/Data/Database/Moor/Tables/Userprofile.dart';
import 'package:dating_app/Data/Database/Moor/Tables/Wantchildrenstatuses.dart';
import 'package:moor/moor.dart';
import 'package:moor_flutter/moor_flutter.dart';
part 'AppDatabase.g.dart';

@UseMoor(tables: [
  Userprofile,
  Genders,
  Relationshipstatuses,
  Smokestatuses,
  Educationlevels,
  Wantchildrenstatuses,
  Drinkstatuses,
  Ethnicities,
  Religions,
  Hobbies,
  Interests,
  Incomeranges,
  Onboardings,
  Onboardingsomethingspecifics,
  Onboardinginterests,
  Onboardingmoneyshemakes,
  Onboardingdatetodrinks,
  Onboardingpickyabthereducations,
  Somethingspecifics,
  Servicetrackers,
  Illnesss,
  Onboardinguserillnesss,
], daos: [
  UserprofileDao,
  GenderDao,
  RelationshipstatusDao,
  SmokestatusDao,
  EducationLevelDao,
  WantchildrenstatusDao,
  DrinkstatusDao,
  EthnicityDao,
  ReligionDao,
  HobbyDao,
  InterestDao,
  IncomerangeDao,
  OnboardingDao,
  OnboardingsomethingspecificDao,
  OnboardinginterestDao,
  OnboardingmoneyshemakeDao,
  OnboardingdatetodrinkDao,
  OnboardingpickyabthereducationDao,
  SomethingspecificDao,
  ServicetrackerDao,
  IllnessDao,
  OnboardinguserillnessDao,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase()
      : super(FlutterQueryExecutor.inDatabaseFolder(
            path: 'dtndb.sqlite', logStatements: true));

  @override
  int get schemaVersion => 4;

  //MIGRATION STRATEGY
  @override
  MigrationStrategy get migration =>
      MigrationStrategy(onUpgrade: (migrator, from, to) async {
        if (from == 1 && to == 2) {
          await migrator.addColumn(onboardings, onboardings.firstname);
          await migrator.addColumn(onboardings, onboardings.lastname);
          await migrator.addColumn(onboardings, onboardings.phone_number);
          await migrator.addColumn(
              onboardings, onboardings.userprofile_onlineid);
        }
        if (from == 2 && to == 3) {
          await migrator.createTable(illnesss);
          await migrator.createTable(onboardinguserillnesss);
          await migrator.addColumn(
              onboardings, onboardings.have_chronic_illness);
        }
        if (from == 3 && to == 4) {
          await migrator.addColumn(
              onboardings, onboardings.fb_link);
          await migrator.addColumn(
              onboardings, onboardings.insta_link);
        }
      }, beforeOpen: (details) async {
        await customStatement('PRAGMA foreign_keys = ON');
      });

  Future<void> deleteAllDatabaseData() async {
    await customStatement('PRAGMA foreign_keys = OFF');
    return transaction(() async {
      for (var table in allTables) {
        await delete(table).go();
      }
    });
  }
}

//CHAIN FUTURES

import 'package:dating_app/Bloc/Streams/Fetch/OnFetchEvent.dart';
import 'package:dating_app/Bloc/Streams/Fetch/OnFetchFinishedBLoC.dart';
import 'package:dating_app/Chopper/data/post_api_service.dart';
import 'package:dating_app/Data/Database/Moor/Core/AppDatabase.dart';
import 'package:dating_app/Data/Database/Moor/Dao/DrinkstatusDao.dart';
import 'package:dating_app/Data/Database/Moor/Dao/EducationlevelDao.dart';
import 'package:dating_app/Data/Database/Moor/Dao/EthnicityDao.dart';
import 'package:dating_app/Data/Database/Moor/Dao/GenderDao.dart';
import 'package:dating_app/Data/Database/Moor/Dao/HobbyDao.dart';
import 'package:dating_app/Data/Database/Moor/Dao/IllnessDao.dart';
import 'package:dating_app/Data/Database/Moor/Dao/IncomerangeDao.dart';
import 'package:dating_app/Data/Database/Moor/Dao/RelationshipstatusDao.dart';
import 'package:dating_app/Data/Database/Moor/Dao/ReligionDao.dart';
import 'package:dating_app/Data/Database/Moor/Dao/ServicetrackerDao.dart';
import 'package:dating_app/Data/Database/Moor/Dao/SmokestatusDao.dart';
import 'package:dating_app/Data/Database/Moor/Dao/SomethingspecificDao.dart';
import 'package:dating_app/Data/Database/Moor/Dao/WantchildrenstatusDao.dart';
import 'package:dating_app/Models/JsonSerializable/Api/from/drinkstatus/DrinkStatusListRespModel.dart';
import 'package:dating_app/Models/JsonSerializable/Api/from/educationlevel/EducationlevelListRespModel.dart';
import 'package:dating_app/Models/JsonSerializable/Api/from/ethnicity/EthnicityListRespModel.dart';
import 'package:dating_app/Models/JsonSerializable/Api/from/gender/GenderListRespModel.dart';
import 'package:dating_app/Models/JsonSerializable/Api/from/hobby/HobbyListRespModel.dart';
import 'package:dating_app/Models/JsonSerializable/Api/from/illness/IllnessListRespJModel.dart';
import 'package:dating_app/Models/JsonSerializable/Api/from/illness/IllnessRespJModel.dart';
import 'package:dating_app/Models/JsonSerializable/Api/from/incomerange/IncomerangeListRespModel.dart';
import 'package:dating_app/Models/JsonSerializable/Api/from/relationshipstatus/RelStatusListRespModel.dart';
import 'package:dating_app/Models/JsonSerializable/Api/from/religion/ReligionListRespModel.dart';
import 'package:dating_app/Models/JsonSerializable/Api/from/smokestatus/SmokestatuseRespModel.dart';
import 'package:dating_app/Models/JsonSerializable/Api/from/drinkstatus/DrinkStatusRespModel.dart';
import 'package:dating_app/Models/JsonSerializable/Api/from/educationlevel/EducationlevelRespModel.dart';
import 'package:dating_app/Models/JsonSerializable/Api/from/ethnicity/EthnicityRespModel.dart';
import 'package:dating_app/Models/JsonSerializable/Api/from/gender/GenderRespModel.dart';
import 'package:dating_app/Models/JsonSerializable/Api/from/hobby/HobbyRespModel.dart';
import 'package:dating_app/Models/JsonSerializable/Api/from/incomerange/IncomerangeRespModel.dart';
import 'package:dating_app/Models/JsonSerializable/Api/from/relationshipstatus/RelStatusRespModel.dart';
import 'package:dating_app/Models/JsonSerializable/Api/from/religion/ReligionRespModel.dart';
import 'package:dating_app/Models/JsonSerializable/Api/from/smokestatus/SmokestatuseListRespModel.dart';
import 'package:dating_app/Models/JsonSerializable/Api/from/somethingspecific/SomethingspecificListRespModel.dart';
import 'package:dating_app/Models/JsonSerializable/Api/from/wantchildren/WantchildrenstatuseListRespModel.dart';

import 'package:dating_app/Models/JsonSerializable/Api/from/somethingspecific/SomethingspecificRespModel.dart';
import 'package:dating_app/Models/JsonSerializable/Api/from/wantchildren/WantchildrenstatuseRespModel.dart';
import 'package:dating_app/utils/dating_app_static_params.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:moor_flutter/moor_flutter.dart';

Future<int> runOnboardingDataFetch(
    BuildContext context, OnFetchFinishedBLoC onFetchFinishedBLoC) async {
  String TAG = 'runOnboardingDataFetch:';
  AppDatabase database = Provider.of<AppDatabase>(context);
  ServicetrackerDao servicetrackerDao = database.servicetrackerDao;
  Servicetracker servicetracker =
      await servicetrackerDao.getServicetrackerByName("onboardinginit");
  if (servicetracker != null) {
    print('servicetracker NOT NULL runnumber${servicetracker.runnumber}');
    //UPDATE THIS servicetracker
    if (servicetracker.runnumber > 0) {
      //SUBSEQUENT RUN --INIT SERVICE
      onFetchFinishedBLoC.onFetchFinished_visible_event_sink
          .add(OnFetchFinishedEvent(true));
      return 0;
    } else {
      //INITIAL RUN
      try {
        await syncOnBoardingSmokestatusData(database, context);
        await syncOnBoardingGenderData(database, context);
        await syncOnBoardingRelationshipstatusData(database, context);
        await syncOnBoardingDrinkstatusData(database, context);
        await syncOnBoardingEducationLevelData(database, context);
        await syncOnBoardingEthnicityData(database, context);
        await syncOnBoardingHobbieData(database, context);
        await syncOnBoardingIncomerangeData(database, context);
        await syncOnBoardingReligionData(database, context);
        await syncOnBoardingWantchildrenstatuseData(database, context);
        //await syncOnBoardingSomethingspecificData(database, context);
        await syncOnBoardingIllnessespecificData(database, context);

        ServicetrackersCompanion servicetrackersCompanion = servicetracker
            .toCompanion(false)
            .copyWith(
                name: Value('onboardinginit'),
                runnumber: Value(1 + servicetracker.runnumber));
        bool isUpdated = await servicetrackerDao
            .updateServicetracker(servicetrackersCompanion);
        print('INITIALRUN UPDATED isUpdated=${isUpdated}');
        if (isUpdated) {
          onFetchFinishedBLoC.onFetchFinished_visible_event_sink
              .add(OnFetchFinishedEvent(true));
          return servicetracker.id;
        } else {
          onFetchFinishedBLoC.onFetchFinished_visible_event_sink
              .add(OnFetchFinishedEvent(false));
          return 0;
        }
      } catch (error) {
        print('onboardingDataFetch error1=${error}');
        onFetchFinishedBLoC.onFetchFinished_visible_event_sink
            .add(OnFetchFinishedEvent(false));
        return 0;
      }
    }
  } else {
    //CREATE NEW servicetracker
    //INITIAL RUN
    try {
      await syncOnBoardingSmokestatusData(database, context);
      await syncOnBoardingGenderData(database, context);
      await syncOnBoardingRelationshipstatusData(database, context);
      await syncOnBoardingDrinkstatusData(database, context);
      await syncOnBoardingEducationLevelData(database, context);
      await syncOnBoardingEthnicityData(database, context);
      await syncOnBoardingHobbieData(database, context);
      await syncOnBoardingIncomerangeData(database, context);
      await syncOnBoardingReligionData(database, context);
      await syncOnBoardingWantchildrenstatuseData(database, context);
      //await syncOnBoardingSomethingspecificData(database, context);
      await syncOnBoardingIllnessespecificData(database, context);

      ServicetrackersCompanion servicetrackersCompanion =
          ServicetrackersCompanion(
              name: Value('onboardinginit'), runnumber: Value(1));
      int insertedId = await servicetrackerDao
          .insertServicetracker(servicetrackersCompanion);
      print('INITIALRUN INSERTED=${insertedId}');
      if (insertedId > 0) {
        onFetchFinishedBLoC.onFetchFinished_visible_event_sink
            .add(OnFetchFinishedEvent(true));
        return insertedId;
      } else {
        onFetchFinishedBLoC.onFetchFinished_visible_event_sink
            .add(OnFetchFinishedEvent(false));
        return 0;
      }
    } catch (error) {
      print('onboardingDataFetch error2=${error}');
      onFetchFinishedBLoC.onFetchFinished_visible_event_sink
          .add(OnFetchFinishedEvent(false));
      return 0;
    }
  }
}

syncOnBoardingSmokestatusData(var database, BuildContext context) async {
  SmokestatusDao smokestatusDao = database.smokestatusDao;
  var response = await Provider.of<PostApiService>(context).smokesStatus(
    DatingAppStaticParams.default_Max_int,
  );
  if (response != null) {
    var respBody = response.body;
    SmokestatuseListRespModel smokestatuseListRespModel =
        SmokestatuseListRespModel.fromJson(respBody);

    List<SmokestatuseRespModel> smokestatuseRespModelList =
        smokestatuseListRespModel.results;
    /*smokestatuseRespModelList = (respBody as List)
        .map((i) => SmokestatuseRespModel.fromJson(i))
        .toList();*/

    List<SmokestatusesCompanion> smokestatusesCompanionList = [];
    List<SmokestatusesCompanion> smokestatusesCompanionToUpdateList = [];
    for (SmokestatuseRespModel smokestatuseRespModel
        in smokestatuseRespModelList) {
      Smokestatuse smokestatuseInDb = await smokestatusDao
          .getSmokestatuseByOnlineId(smokestatuseRespModel.id);
      if (smokestatuseInDb == null) {
        SmokestatusesCompanion smokestatusesCompanion =
            new SmokestatusesCompanion(
                name: Value(smokestatuseRespModel.name),
                onlineid: Value(smokestatuseRespModel.id),
                active: Value(smokestatuseRespModel.active));
        smokestatusesCompanionList.add(smokestatusesCompanion);
      } else {
        SmokestatusesCompanion smokestatusesInDbCompanion =
            smokestatuseInDb.toCompanion(false);

        smokestatusesCompanionToUpdateList.add(
            smokestatusesInDbCompanion.copyWith(
                onlineid: Value(smokestatuseRespModel.id),
                name: Value(smokestatuseRespModel.name),
                active: Value(smokestatuseRespModel.active)));
      }
    }
    smokestatusDao.insertAllSmokeStatus(smokestatusesCompanionList);
    smokestatusDao.updateAllSmokeStatus(smokestatusesCompanionToUpdateList);
  }
}

syncOnBoardingGenderData(var database, BuildContext context) async {
  GenderDao genderDao = database.genderDao;
  var response = await Provider.of<PostApiService>(context).gender(
    DatingAppStaticParams.default_Max_int,
  );
  if (response != null) {
    var respBody = response.body;
    GenderListRespModel genderListRespModel =
        GenderListRespModel.fromJson(respBody);
    List<GenderRespModel> genderRespModelList = genderListRespModel.results;
    /*List<GenderRespModel> genderRespModelList = [];
    genderRespModelList =
        (respBody as List).map((i) => GenderRespModel.fromJson(i)).toList();*/

    List<GendersCompanion> gendersCompanionList = [];
    List<GendersCompanion> gendersCompanionToUpdateList = [];
    for (GenderRespModel genderRespModel in genderRespModelList) {
      Gender genderInDb =
          await genderDao.getGenderByOnlineId(genderRespModel.id);
      if (genderInDb == null) {
        GendersCompanion gendersCompanion = new GendersCompanion(
            name: Value(genderRespModel.name),
            onlineid: Value(genderRespModel.id),
            active: Value(genderRespModel.active));
        gendersCompanionList.add(gendersCompanion);
      } else {
        GendersCompanion gendersInDbCompanion = genderInDb.toCompanion(false);

        gendersCompanionToUpdateList.add(gendersInDbCompanion.copyWith(
            onlineid: Value(genderRespModel.id),
            name: Value(genderRespModel.name),
            active: Value(genderRespModel.active)));
      }
    }
    genderDao.insertAllGender(gendersCompanionList);
    genderDao.updateAllGender(gendersCompanionToUpdateList);
  }
}

syncOnBoardingRelationshipstatusData(var database, BuildContext context) async {
  RelationshipstatusDao relationshipstatusDao = database.relationshipstatusDao;
  var response = await Provider.of<PostApiService>(context).relationshipStatus(
    DatingAppStaticParams.default_Max_int,
  );
  if (response != null) {
    var respBody = response.body;
    RelStatusListRespModel relStatusListRespModel =
        RelStatusListRespModel.fromJson(respBody);

    List<RelStatusRespModel> relStatusRespModelList =
        relStatusListRespModel.results;
    /*List<RelStatusRespModel> relStatusRespModelList = [];
    relStatusRespModelList =
        (respBody as List).map((i) => RelStatusRespModel.fromJson(i)).toList();*/

    List<RelationshipstatusesCompanion> relationshipstatusesCompanionList = [];
    List<RelationshipstatusesCompanion>
        relationshipstatusesCompanionToUpdateList = [];
    for (RelStatusRespModel relStatusRespModel in relStatusRespModelList) {
      Relationshipstatuse relationshipstatuseInDb = await relationshipstatusDao
          .getRelationshipstatuseByOnlineId(relStatusRespModel.id);
      if (relationshipstatuseInDb == null) {
        RelationshipstatusesCompanion relationshipstatusesCompanion =
            new RelationshipstatusesCompanion(
                name: Value(relStatusRespModel.name),
                onlineid: Value(relStatusRespModel.id),
                active: Value(relStatusRespModel.active));
        relationshipstatusesCompanionList.add(relationshipstatusesCompanion);
      } else {
        RelationshipstatusesCompanion relationshipstatusesInDbCompanion =
            relationshipstatuseInDb.toCompanion(false);

        relationshipstatusesCompanionToUpdateList.add(
            relationshipstatusesInDbCompanion.copyWith(
                onlineid: Value(relStatusRespModel.id),
                name: Value(relStatusRespModel.name),
                active: Value(relStatusRespModel.active)));
      }
    }
    relationshipstatusDao
        .insertAllRelationshipstatuse(relationshipstatusesCompanionList);
    relationshipstatusDao.updateAllRelationshipstatuse(
        relationshipstatusesCompanionToUpdateList);
  }
}

syncOnBoardingDrinkstatusData(var database, BuildContext context) async {
  DrinkstatusDao drinkstatusDao = database.drinkstatusDao;
  var response = await Provider.of<PostApiService>(context).drinkStatus(
    DatingAppStaticParams.default_Max_int,
  );
  if (response != null) {
    var respBody = response.body;
    DrinkStatusListRespModel drinkStatusListRespModel =
        DrinkStatusListRespModel.fromJson(respBody);

    List<DrinkStatusRespModel> drinkStatusRespModelList =
        drinkStatusListRespModel.results;
    /*List<DrinkStatusRespModel> drinkStatusRespModelList = [];
    drinkStatusRespModelList = (respBody as List)
        .map((i) => DrinkStatusRespModel.fromJson(i))
        .toList();*/

    List<DrinkstatusesCompanion> drinkstatusesCompanionList = [];
    List<DrinkstatusesCompanion> drinkstatusesCompanionToUpdateList = [];
    for (DrinkStatusRespModel drinkStatusRespModel
        in drinkStatusRespModelList) {
      Drinkstatuse drinkstatuseInDb = await drinkstatusDao
          .getDrinkstatuseByOnlineId(drinkStatusRespModel.id);
      if (drinkstatuseInDb == null) {
        DrinkstatusesCompanion drinkstatusesCompanion =
            new DrinkstatusesCompanion(
                name: Value(drinkStatusRespModel.name),
                onlineid: Value(drinkStatusRespModel.id),
                active: Value(drinkStatusRespModel.active));
        drinkstatusesCompanionList.add(drinkstatusesCompanion);
      } else {
        DrinkstatusesCompanion drinkstatusesInDbCompanion =
            drinkstatuseInDb.toCompanion(false);

        drinkstatusesCompanionToUpdateList.add(
            drinkstatusesInDbCompanion.copyWith(
                onlineid: Value(drinkStatusRespModel.id),
                name: Value(drinkStatusRespModel.name),
                active: Value(drinkStatusRespModel.active)));
      }
    }
    drinkstatusDao.insertAllDrinkstatuse(drinkstatusesCompanionList);
    drinkstatusDao.updateAllDrinkstatuse(drinkstatusesCompanionToUpdateList);
  }
}

syncOnBoardingEducationLevelData(var database, BuildContext context) async {
  EducationLevelDao educationLevelDao = database.educationLevelDao;
  var response = await Provider.of<PostApiService>(context).educationLevel(
    DatingAppStaticParams.default_Max_int,
  );
  if (response != null) {
    var respBody = response.body;
    EducationlevelListRespModel educationlevelListRespModel =
        EducationlevelListRespModel.fromJson(respBody);

    List<EducationlevelRespModel> educationlevelRespModelList =
        educationlevelListRespModel.results;

/*    List<EducationlevelRespModel> educationlevelRespModelList = [];
    educationlevelRespModelList = (respBody as List)
        .map((i) => EducationlevelRespModel.fromJson(i))
        .toList();*/

    List<EducationlevelsCompanion> educationlevelsCompanionList = [];
    List<EducationlevelsCompanion> educationlevelsCompanionToUpdateList = [];
    for (EducationlevelRespModel educationlevelRespModel
        in educationlevelRespModelList) {
      Educationlevel educationlevelInDb = await educationLevelDao
          .getEducationlevelByOnlineId(educationlevelRespModel.id);
      if (educationlevelInDb == null) {
        EducationlevelsCompanion educationlevelsCompanion =
            new EducationlevelsCompanion(
                name: Value(educationlevelRespModel.name),
                onlineid: Value(educationlevelRespModel.id),
                active: Value(educationlevelRespModel.active));
        educationlevelsCompanionList.add(educationlevelsCompanion);
      } else {
        EducationlevelsCompanion educationlevelsInDbCompanion =
            educationlevelInDb.toCompanion(false);

        educationlevelsCompanionToUpdateList.add(
            educationlevelsInDbCompanion.copyWith(
                onlineid: Value(educationlevelRespModel.id),
                name: Value(educationlevelRespModel.name),
                active: Value(educationlevelRespModel.active)));
      }
    }
    educationLevelDao.insertAllEducationlevel(educationlevelsCompanionList);
    educationLevelDao
        .updateAllEducationlevel(educationlevelsCompanionToUpdateList);
  }
}

syncOnBoardingEthnicityData(var database, BuildContext context) async {
  EthnicityDao ethnicityDao = database.ethnicityDao;
  var response = await Provider.of<PostApiService>(context).ethnicity(
    DatingAppStaticParams.default_Max_int,
  );
  if (response != null) {
    var respBody = response.body;

    EthnicityListRespModel ethnicityListRespModel =
        EthnicityListRespModel.fromJson(respBody);
    List<EthnicityRespModel> ethnicitieRespModelList =
        ethnicityListRespModel.results;
    /*List<EthnicityRespModel> ethnicitieRespModelList = [];
    ethnicitieRespModelList =
        (respBody as List).map((i) => EthnicityRespModel.fromJson(i)).toList();*/

    List<EthnicitiesCompanion> ethnicitiesCompanionList = [];
    List<EthnicitiesCompanion> ethnicitiesCompanionToUpdateList = [];
    for (EthnicityRespModel ethnicitieRespModel in ethnicitieRespModelList) {
      Ethnicitie ethnicitieInDb =
          await ethnicityDao.getEthnicitieByOnlineId(ethnicitieRespModel.id);
      if (ethnicitieInDb == null) {
        EthnicitiesCompanion ethnicitiesCompanion = new EthnicitiesCompanion(
            name: Value(ethnicitieRespModel.name),
            onlineid: Value(ethnicitieRespModel.id),
            active: Value(ethnicitieRespModel.active));
        ethnicitiesCompanionList.add(ethnicitiesCompanion);
      } else {
        EthnicitiesCompanion ethnicitiesInDbCompanion =
            ethnicitieInDb.toCompanion(false);

        ethnicitiesCompanionToUpdateList.add(ethnicitiesInDbCompanion.copyWith(
            onlineid: Value(ethnicitieRespModel.id),
            name: Value(ethnicitieRespModel.name),
            active: Value(ethnicitieRespModel.active)));
      }
    }
    ethnicityDao.insertAllEthnicitie(ethnicitiesCompanionList);
    ethnicityDao.updateAllEthnicitie(ethnicitiesCompanionToUpdateList);
  }
}

syncOnBoardingHobbieData(var database, BuildContext context) async {
  HobbyDao hobbyDao = database.hobbyDao;
  var response = await Provider.of<PostApiService>(context).hobby(
    DatingAppStaticParams.default_Max_int,
  );
  if (response != null) {
    var respBody = response.body;
    HobbyListRespModel hobbyListRespModel =
        HobbyListRespModel.fromJson(respBody);
    List<HobbyRespModel> hobbieRespModelList = hobbyListRespModel.results;
    /*List<HobbyRespModel> hobbieRespModelList = [];
    hobbieRespModelList =
        (respBody as List).map((i) => HobbyRespModel.fromJson(i)).toList();*/

    List<HobbiesCompanion> hobbiesCompanionList = [];
    List<HobbiesCompanion> hobbiesCompanionToUpdateList = [];
    for (HobbyRespModel hobbieRespModel in hobbieRespModelList) {
      Hobbie hobbieInDb =
          await hobbyDao.getHobbieByOnlineId(hobbieRespModel.id);
      if (hobbieInDb == null) {
        HobbiesCompanion hobbiesCompanion = new HobbiesCompanion(
            name: Value(hobbieRespModel.name),
            onlineid: Value(hobbieRespModel.id),
            active: Value(hobbieRespModel.active));
        hobbiesCompanionList.add(hobbiesCompanion);
      } else {
        HobbiesCompanion hobbiesInDbCompanion = hobbieInDb.toCompanion(false);

        hobbiesCompanionToUpdateList.add(hobbiesInDbCompanion.copyWith(
            onlineid: Value(hobbieRespModel.id),
            name: Value(hobbieRespModel.name),
            active: Value(hobbieRespModel.active)));
      }
    }
    hobbyDao.insertAllHobbie(hobbiesCompanionList);
    hobbyDao.updateAllHobbie(hobbiesCompanionToUpdateList);
  }
}

syncOnBoardingIncomerangeData(var database, BuildContext context) async {
  IncomerangeDao incomerangeDao = database.incomerangeDao;
  var response = await Provider.of<PostApiService>(context).incomeRange(
    DatingAppStaticParams.default_Max_int,
  );
  if (response != null) {
    var respBody = response.body;
    IncomerangeListRespModel incomerangeListRespModel =
        IncomerangeListRespModel.fromJson(respBody);
    List<IncomerangeRespModel> incomerangeRespModelList =
        incomerangeListRespModel.results;
    /*List<IncomerangeRespModel> incomerangeRespModelList = [];
    incomerangeRespModelList = (respBody as List)
        .map((i) => IncomerangeRespModel.fromJson(i))
        .toList();*/

    List<IncomerangesCompanion> incomerangesCompanionList = [];
    List<IncomerangesCompanion> incomerangesCompanionToUpdateList = [];
    for (IncomerangeRespModel incomerangeRespModel
        in incomerangeRespModelList) {
      Incomerange incomerangeInDb = await incomerangeDao
          .getIncomerangeByOnlineId(incomerangeRespModel.id);
      if (incomerangeInDb == null) {
        IncomerangesCompanion incomerangesCompanion = new IncomerangesCompanion(
            onlineid: Value(incomerangeRespModel.id),
            active: Value(incomerangeRespModel.active),
            lowerlimit: Value(incomerangeRespModel.lowerlimit),
            upperlimit: Value(incomerangeRespModel.upperlimit),
            name: Value(incomerangeRespModel.name));
        incomerangesCompanionList.add(incomerangesCompanion);
      } else {
        IncomerangesCompanion incomerangesInDbCompanion =
            incomerangeInDb.toCompanion(false);

        incomerangesCompanionToUpdateList.add(
            incomerangesInDbCompanion.copyWith(
                onlineid: Value(incomerangeRespModel.id),
                active: Value(incomerangeRespModel.active),
                lowerlimit: Value(incomerangeRespModel.lowerlimit),
                upperlimit: Value(incomerangeRespModel.upperlimit)));
      }
    }
    incomerangeDao.insertAllIncomerange(incomerangesCompanionList);
    incomerangeDao.updateAllIncomerange(incomerangesCompanionToUpdateList);
  }
}

syncOnBoardingReligionData(var database, BuildContext context) async {
  ReligionDao religionDao = database.religionDao;
  var response = await Provider.of<PostApiService>(context).religion(
    DatingAppStaticParams.default_Max_int,
  );
  if (response != null) {
    var respBody = response.body;
    ReligionListRespModel religionListRespModel =
        ReligionListRespModel.fromJson(respBody);
    List<ReligionRespModel> religionRespModelList =
        religionListRespModel.results;
    /*List<ReligionRespModel> religionRespModelList = [];
    religionRespModelList =
        (respBody as List).map((i) => ReligionRespModel.fromJson(i)).toList();*/

    List<ReligionsCompanion> religionsCompanionList = [];
    List<ReligionsCompanion> religionsCompanionToUpdateList = [];
    for (ReligionRespModel religionRespModel in religionRespModelList) {
      Religion religionInDb =
          await religionDao.getReligionByOnlineId(religionRespModel.id);
      if (religionInDb == null) {
        ReligionsCompanion religionsCompanion = new ReligionsCompanion(
            name: Value(religionRespModel.name),
            onlineid: Value(religionRespModel.id),
            active: Value(religionRespModel.active));
        religionsCompanionList.add(religionsCompanion);
      } else {
        ReligionsCompanion religionsInDbCompanion =
            religionInDb.toCompanion(false);

        religionsCompanionToUpdateList.add(religionsInDbCompanion.copyWith(
            onlineid: Value(religionRespModel.id),
            name: Value(religionRespModel.name),
            active: Value(religionRespModel.active)));
      }
    }
    religionDao.insertAllReligion(religionsCompanionList);
    religionDao.updateAllReligion(religionsCompanionToUpdateList);
  }
}

syncOnBoardingWantchildrenstatuseData(
    var database, BuildContext context) async {
  WantchildrenstatusDao wantchildrenstatusDao = database.wantchildrenstatusDao;
  var response = await Provider.of<PostApiService>(context).wantChildrenStatus(
    DatingAppStaticParams.default_Max_int,
  );
  if (response != null) {
    var respBody = response.body;
    WantchildrenstatuseListRespModel wantchildrenstatuseListRespModel =
        WantchildrenstatuseListRespModel.fromJson(respBody);
    List<WantchildrenstatuseRespModel> wantchildrenstatuseRespModelList =
        wantchildrenstatuseListRespModel.results;
    /*List<WantchildrenstatuseRespModel> wantchildrenstatuseRespModelList = [];
    wantchildrenstatuseRespModelList = (respBody as List)
        .map((i) => WantchildrenstatuseRespModel.fromJson(i))
        .toList();*/

    List<WantchildrenstatusesCompanion> wantchildrenstatusesCompanionList = [];
    List<WantchildrenstatusesCompanion>
        wantchildrenstatusesCompanionToUpdateList = [];
    for (WantchildrenstatuseRespModel wantchildrenstatuseRespModel
        in wantchildrenstatuseRespModelList) {
      Wantchildrenstatuse wantchildrenstatuseInDb = await wantchildrenstatusDao
          .getWantchildrenstatuseByOnlineId(wantchildrenstatuseRespModel.id);
      if (wantchildrenstatuseInDb == null) {
        WantchildrenstatusesCompanion wantchildrenstatusesCompanion =
            new WantchildrenstatusesCompanion(
                name: Value(wantchildrenstatuseRespModel.name),
                onlineid: Value(wantchildrenstatuseRespModel.id),
                active: Value(wantchildrenstatuseRespModel.active));
        wantchildrenstatusesCompanionList.add(wantchildrenstatusesCompanion);
      } else {
        WantchildrenstatusesCompanion wantchildrenstatusesInDbCompanion =
            wantchildrenstatuseInDb.toCompanion(false);

        wantchildrenstatusesCompanionToUpdateList.add(
            wantchildrenstatusesInDbCompanion.copyWith(
                onlineid: Value(wantchildrenstatuseRespModel.id),
                name: Value(wantchildrenstatuseRespModel.name),
                active: Value(wantchildrenstatuseRespModel.active)));
      }
    }
    wantchildrenstatusDao
        .insertAllWantchildrenstatuse(wantchildrenstatusesCompanionList);
    wantchildrenstatusDao.updateAllWantchildrenstatuse(
        wantchildrenstatusesCompanionToUpdateList);
  }
}

syncOnBoardingSomethingspecificData(var database, BuildContext context) async {
  SomethingspecificDao somethingspecificDao = database.somethingspecificDao;
  var response = await Provider.of<PostApiService>(context).somethingSpecific(
    DatingAppStaticParams.default_Max_int,
  );
  if (response != null) {
    var respBody = response.body;
    SomethingspecificListRespModel somethingspecificListRespModel =
        SomethingspecificListRespModel.fromJson(respBody);
    List<SomethingspecificRespModel> somethingspecificRespModelList =
        somethingspecificListRespModel.results;
    /*List<SomethingspecificRespModel> somethingspecificRespModelList = [];
    somethingspecificRespModelList = (respBody as List)
        .map((i) => SomethingspecificRespModel.fromJson(i))
        .toList();*/

    List<SomethingspecificsCompanion> somethingspecificsCompanionList = [];
    List<SomethingspecificsCompanion> somethingspecificsCompanionToUpdateList =
        [];
    for (SomethingspecificRespModel somethingspecificRespModel
        in somethingspecificRespModelList) {
      Somethingspecific somethingspecificInDb = await somethingspecificDao
          .getSomethingspecificByOnlineId(somethingspecificRespModel.id);
      if (somethingspecificInDb == null) {
        SomethingspecificsCompanion somethingspecificsCompanion =
            new SomethingspecificsCompanion(
                name: Value(somethingspecificRespModel.name),
                onlineid: Value(somethingspecificRespModel.id),
                active: Value(somethingspecificRespModel.active));
        somethingspecificsCompanionList.add(somethingspecificsCompanion);
      } else {
        SomethingspecificsCompanion somethingspecificsInDbCompanion =
            somethingspecificInDb.toCompanion(false);

        somethingspecificsCompanionToUpdateList.add(
            somethingspecificsInDbCompanion.copyWith(
                onlineid: Value(somethingspecificRespModel.id),
                name: Value(somethingspecificRespModel.name),
                active: Value(somethingspecificRespModel.active)));
      }
    }
    somethingspecificDao
        .insertAllSomethingspecific(somethingspecificsCompanionList);
    somethingspecificDao
        .updateAllSomethingspecific(somethingspecificsCompanionToUpdateList);
  }
}

syncOnBoardingIllnessespecificData(
    AppDatabase database, BuildContext context) async {
  IllnessDao illnessDao = database.illnessDao;
  var response = await Provider.of<PostApiService>(context).illness(
    DatingAppStaticParams.default_Max_int,
  );
  if (response != null) {
    var respBody = response.body;
    IllnessListRespJModel illnessListRespJModel =
        IllnessListRespJModel.fromJson(respBody);
    List<IllnessRespJModel> somethingspecificRespModelList =
        illnessListRespJModel.results;

    List<IllnesssCompanion> illnesssCompanionList = [];
    List<IllnesssCompanion> illnesssCompanionToUpdateList = [];
    for (IllnessRespJModel illnessRespJModel
        in somethingspecificRespModelList) {
      Illness illnessInDb =
          await illnessDao.getIllnessByOnlineId(illnessRespJModel.id);
      if (illnessInDb == null) {
        IllnesssCompanion illnesssCompanion = new IllnesssCompanion(
            name: Value(illnessRespJModel.name),
            onlineid: Value(illnessRespJModel.id),
            active: Value(illnessRespJModel.active));
        illnesssCompanionList.add(illnesssCompanion);
      } else {
        IllnesssCompanion illnesssInDbCompanion =
            illnessInDb.toCompanion(false);

        illnesssCompanionToUpdateList.add(illnesssInDbCompanion.copyWith(
            onlineid: Value(illnessRespJModel.id),
            name: Value(illnessRespJModel.name),
            active: Value(illnessRespJModel.active)));
      }
    }
    illnessDao.insertAllIllness(illnesssCompanionList);
    illnessDao.updateAllIllness(illnesssCompanionToUpdateList);
  }
}

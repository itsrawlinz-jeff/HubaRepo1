import 'package:moor/moor.dart';
import 'package:moor_flutter/moor_flutter.dart';

class Onboardingdatetodrinks extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get onlineid => integer().nullable()();

  IntColumn get onboarding => integer()
      .nullable()
      .customConstraint('NULL REFERENCES onboardings(id) ON DELETE CASCADE')();

  IntColumn get drinkStatuse => integer()
      .nullable()
      .customConstraint('NULL REFERENCES drinkstatuses(id) ON DELETE CASCADE')();
}

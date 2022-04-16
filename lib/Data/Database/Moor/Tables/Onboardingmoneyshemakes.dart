import 'package:moor/moor.dart';
import 'package:moor_flutter/moor_flutter.dart';

class Onboardingmoneyshemakes extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get onlineid => integer().nullable()();

  IntColumn get onboarding => integer()
      .nullable()
      .customConstraint('NULL REFERENCES onboardings(id) ON DELETE CASCADE')();

  IntColumn get incomeRange => integer()
      .nullable()
      .customConstraint('NULL REFERENCES incomeranges(id) ON DELETE CASCADE')();
}

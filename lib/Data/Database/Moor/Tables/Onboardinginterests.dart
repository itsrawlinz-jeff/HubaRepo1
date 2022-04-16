import 'package:moor/moor.dart';
import 'package:moor_flutter/moor_flutter.dart';

class Onboardinginterests extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get onlineid => integer().nullable()();

  IntColumn get onboarding => integer()
      .nullable()
      .customConstraint('NULL REFERENCES onboardings(id) ON DELETE CASCADE')();

  IntColumn get hobbie =>
      integer().nullable().customConstraint('NULL REFERENCES hobbies(id) ON DELETE CASCADE')();
}

import 'package:moor/moor.dart';
import 'package:moor_flutter/moor_flutter.dart';


class Onboardingsomethingspecifics extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get onlineid => integer().nullable()();

  IntColumn get onboarding => integer()
      .nullable()
      .customConstraint('NULL REFERENCES onboardings(id) ON DELETE CASCADE')();

  IntColumn get somethingspecifics => integer()
      .nullable()
      .customConstraint('NULL REFERENCES somethingspecifics(id) ON DELETE CASCADE')();

}

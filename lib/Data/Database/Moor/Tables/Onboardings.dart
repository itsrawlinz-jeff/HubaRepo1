import 'package:moor/moor.dart';
import 'package:moor_flutter/moor_flutter.dart';

class Onboardings extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get onlineid => integer().nullable()();
  IntColumn get userprofile_onlineid => integer().nullable()();
  TextColumn get email => text().nullable()();
  TextColumn get username => text().nullable()();
  TextColumn get firstname => text().nullable()();
  TextColumn get lastname => text().nullable()();
  TextColumn get phone_number => text().nullable()();
  TextColumn get birthday => text().nullable()();
  TextColumn get password => text().nullable()();
  TextColumn get profpicpath => text().nullable()();
  TextColumn get insta_link => text().nullable()();
  TextColumn get fb_link => text().nullable()();

  IntColumn get iam => integer()
      .nullable()
      .customConstraint('NULL REFERENCES genders(id) ON DELETE CASCADE')();
  IntColumn get searchingfor => integer()
      .nullable()
      .customConstraint('NULL REFERENCES genders(id) ON DELETE CASCADE')();
  IntColumn get relationshipstatus => integer().nullable().customConstraint(
      'NULL REFERENCES relationshipstatuses(id) ON DELETE CASCADE')();
  IntColumn get do_you_smoke => integer().nullable().customConstraint(
      'NULL REFERENCES smokestatuses(id) ON DELETE CASCADE')();
  IntColumn get education_level => integer().nullable().customConstraint(
      'NULL REFERENCES educationlevels(id) ON DELETE CASCADE')();
  IntColumn get want_children => integer().nullable().customConstraint(
      'NULL REFERENCES wantchildrenstatuses(id) ON DELETE CASCADE')();
  IntColumn get often_you_drink => integer().nullable().customConstraint(
      'NULL REFERENCES drinkstatuses(id) ON DELETE CASCADE')();
  IntColumn get ethnicity => integer()
      .nullable()
      .customConstraint('NULL REFERENCES ethnicities(id) ON DELETE CASCADE')();
  IntColumn get religion => integer()
      .nullable()
      .customConstraint('NULL REFERENCES religions(id) ON DELETE CASCADE')();
  IntColumn get want_date_to_drink => integer().nullable().customConstraint(
      'NULL REFERENCES drinkstatuses(id) ON DELETE CASCADE')();
  IntColumn get picky_abt_her_education =>
      integer().nullable().customConstraint(
          'NULL REFERENCES educationlevels(id) ON DELETE CASCADE')();

  IntColumn get herage_low => integer().nullable()();
  IntColumn get herage_high => integer().nullable()();
  TextColumn get little_about_self => text().nullable()();

  BoolColumn get have_chronic_illness => boolean().withDefault(Constant(false))();

}

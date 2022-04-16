import 'package:moor/moor.dart';
import 'package:moor_flutter/moor_flutter.dart';

class Educationlevels extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get onlineid => integer().nullable()();
  TextColumn get name => text().nullable()();
  BoolColumn get issettobeupdated => boolean().withDefault(Constant(false))();
  BoolColumn get active => boolean().withDefault(Constant(false))();
}

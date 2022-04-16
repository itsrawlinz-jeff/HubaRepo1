import 'package:moor/moor.dart';
import 'package:moor_flutter/moor_flutter.dart';

class Incomeranges extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get onlineid => integer().nullable()();
  RealColumn get lowerlimit => real().nullable()();
  RealColumn get upperlimit => real().nullable()();
  BoolColumn get issettobeupdated => boolean().withDefault(Constant(false))();
  BoolColumn get active => boolean().withDefault(Constant(false))();
  TextColumn get name => text().nullable()();
}

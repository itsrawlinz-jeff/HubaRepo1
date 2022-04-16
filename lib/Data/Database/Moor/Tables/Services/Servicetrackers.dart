import 'package:moor/moor.dart';
import 'package:moor_flutter/moor_flutter.dart';

class Servicetrackers extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get onlineid => integer().nullable()();
  TextColumn get name => text().nullable()();
  IntColumn get runnumber => integer().nullable().withDefault(Constant(0))();
  BoolColumn get isBeingrunnow => boolean().withDefault(Constant(false))();
  BoolColumn get active => boolean().withDefault(Constant(false))();
}

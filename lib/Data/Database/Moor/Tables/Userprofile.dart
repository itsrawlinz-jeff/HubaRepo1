import 'package:moor/moor.dart';
import 'package:moor_flutter/moor_flutter.dart';



class Userprofile extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get onlineid => integer().nullable()();
  TextColumn get onlinepath => text().nullable()();
  TextColumn get localpath => text().nullable()();
  TextColumn get filename => text().nullable()();
}


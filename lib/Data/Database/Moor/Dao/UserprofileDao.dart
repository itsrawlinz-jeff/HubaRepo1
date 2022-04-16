
import 'package:dating_app/Data/Database/Moor/Core/AppDatabase.dart';
import 'package:dating_app/Data/Database/Moor/Tables/Userprofile.dart';
import 'package:moor/moor.dart';
import 'package:moor_flutter/moor_flutter.dart';

part 'UserprofileDao.g.dart';

@UseDao(tables: [Userprofile])
class UserprofileDao extends DatabaseAccessor<AppDatabase> with _$UserprofileDaoMixin {
  final AppDatabase db;

  UserprofileDao(this.db) : super(db);

  Future<List<UserprofileData>> getAllUserprofiles() => select(userprofile).get();
  Stream<List<UserprofileData>> watchAllUserprofiles() => select(userprofile).watch();
  Future insertUserprofile(Insertable<UserprofileData> userprofileData) => into(userprofile).insert(userprofileData);
  Future updateUserprofile(Insertable<UserprofileData> userprofileData) => update(userprofile).replace(userprofileData);
  Future deleteUserprofile(Insertable<UserprofileData> userprofileData) => delete(userprofile).delete(userprofileData);

}
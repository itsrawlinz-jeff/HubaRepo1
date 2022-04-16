import 'package:dating_app/Data/Database/Moor/Core/AppDatabase.dart';
import 'package:dating_app/Data/Database/Moor/Tables/Interests.dart';
import 'package:moor/moor.dart';
import 'package:moor_flutter/moor_flutter.dart';

part 'InterestDao.g.dart';

@UseDao(tables: [Interests])
class InterestDao extends DatabaseAccessor<AppDatabase> with _$InterestDaoMixin {
  final AppDatabase db;

  InterestDao(this.db) : super(db);

  Future<List<Interest>> getAllInterests() => select(interests).get();
  Stream<List<Interest>> watchAllInterests() => select(interests).watch();
  Future insertInterest(Insertable<Interest> interest) =>
      into(interests).insert(interest);
  Future updateInterest(Insertable<Interest> interest) =>
      update(interests).replace(interest);
  Future deleteInterest(Insertable<Interest> interest) =>
      delete(interests).delete(interest);
}

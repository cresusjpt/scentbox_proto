import 'package:floor/floor.dart';
import 'package:scentbox_proto/models/Calendrier.dart';


@dao
abstract class CalendrierDao{
  @Query("SELECT * from calendrier")
  Future<List<Calendrier>> getCalendriers();

  @Query("SELECT * from calendrier")
  Stream<List<Calendrier>> watchCalendriers();

  @Query("SELECT * from calendrier where id = :id")
  Future<Calendrier> getCalendrier(int id);

  @Query("SELECT * from calendrier where idDiffuser = :id ")
  Future<Calendrier> getCalendrierByDiffuser(int id);

  @Query("Select count(*) from calendrier")
  Future<void> taille();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<int> insertCalendrier(Calendrier calendrier);

  @update
  Future<int> updateCalendrier(Calendrier calendrier);

  @delete
  Future<void> deleteCalendrier(Calendrier calendrier);

  @Query("Delete from calendrier")
  Future<void> deleteAll();

  @Query("Delete from calendrier where idDiffuser = :idDiffuser")
  Future<void> deleteByDiffuser(int idDiffuser);
}
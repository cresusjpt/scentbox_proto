import 'package:floor/floor.dart';
import 'package:scentbox_proto/models/PlageHoraire.dart';

@dao
abstract class PlageHoraireDao{

  @Query("SELECT * from horaire")
  Future<List<PlageHoraire>> getHoraires();

  @Query("SELECT * from horaire")
  Stream<List<PlageHoraire>> watchHoraires();

  @Query("SELECT * from horaire where id = :id")
  Future<PlageHoraire> getHoraire(int id);

  @Query("SELECT * from horaire where idBoitier = :id ")
  Future<PlageHoraire> getHoraireByBoitier(int id);

  @Query("SELECT * from horaire where idBoitier = :id ")
  Stream<List<PlageHoraire>> watchHoraireByDiffuser(int id);

  @Query("Select count(*) from horaire")
  Future<void> taille();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<int> insertHoraire(PlageHoraire horaire);

  @update
  Future<int> updateHoraire(PlageHoraire horaire);

  @delete
  Future<void> deleteHoraire(PlageHoraire horaire);

  @Query("Delete from horaire")
  Future<void> deleteAll();

  @Query("Delete from horaire where idBoitier = :idBoitier")
  Future<void> deleteByDiffuser(int idBoitier);
}
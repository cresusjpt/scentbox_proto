import 'package:floor/floor.dart';
import 'package:scentbox_proto/models/Boitier.dart';

@dao
abstract class BoitierDao {
  @Query("SELECT * from boitier")
  Future<List<Boitier>> getDiffusers();

  @Query("SELECT * from boitier")
  Stream<List<Boitier>> watchDiffusers();

  @Query("SELECT * from boitier where id = :id")
  Future<Boitier> getDiffuser(int id);

  @Query("SELECT * from boitier where uniqueid = :uniqueId ")
  Future<Boitier> getDiffuserByUniqueid(String uniqueId);

  @Query("Select count(*) from boitier")
  Future<void> taille();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<int> insertDevice(Boitier diffuser);

  @update
  Future<int> updateDevice(Boitier diffuser);

  @delete
  Future<void> deleteDevice(Boitier diffuser);

  @Query("Delete from boitier")
  Future<void> deleteAll();

  @Query("Delete from boitier where id = :idBoitier")
  Future<void> deleteByBoitier(int idBoitier);
}

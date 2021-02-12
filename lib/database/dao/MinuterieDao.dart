import 'package:floor/floor.dart';
import 'package:scentbox_proto/models/Minuterie.dart';

@dao
abstract class MinuterieDao{
  @Query("SELECT * from minuterie")
  Future<List<Minuterie>> getMinuteurs();

  @Query("SELECT * from minuterie")
  Stream<List<Minuterie>> watchMinuteurs();

  @Query("SELECT * from minuterie where id = :id")
  Future<Minuterie> getMinuteur(int id);

  @Query("SELECT * from minuterie where idBoitier = :id ")
  Future<List<Minuterie>> getMinuteurByBoitier(int id);

  @Query("SELECT * from minuterie where idBoitier = :id ")
  Stream<List<Minuterie>> watchMinuteurByBoitier(int id);

  @Query("Select count(*) from minuterie")
  Future<void> length();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<int> insertMinuterie(Minuterie minuteur);

  @update
  Future<int> updateMinuterie(Minuterie minuteur);

  @delete
  Future<void> deleteMinuterie(Minuterie minuteur);

  @Query("Delete from minuterie")
  Future<void> deleteAll();

  @Query("Delete from minuterie where idBoitier = :idBoitier")
  Future<void> deleteByBoitier(int idBoitier);
}
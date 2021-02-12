import 'package:floor/floor.dart';
import 'package:scentbox_proto/models/Boitier.dart';

@Entity(tableName: "horaire", foreignKeys: [
  ForeignKey(
    childColumns: ['idBoitier'],
    parentColumns: ['id'],
    entity: Boitier,
  )
], indices: [
  Index(value: ['idBoitier'])
])
class PlageHoraire {
  @PrimaryKey(autoGenerate: true)
  int id;
  int idBoitier;
  bool on;

  String heureDebut;
  String heureFin;
  int jour;
  int millisSecondDebut;
  int millisecondFin;

  PlageHoraire(
      {this.id,
      this.idBoitier,
      this.on,
      this.heureDebut,
      this.heureFin,
      this.jour,
      this.millisSecondDebut,
      this.millisecondFin});
}

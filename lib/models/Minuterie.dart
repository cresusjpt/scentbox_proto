import 'package:floor/floor.dart';
import 'package:scentbox_proto/models/Boitier.dart';

@Entity(
    foreignKeys: [
      ForeignKey(
        childColumns: ['idBoitier'],
        parentColumns: ['id'],
        entity: Boitier,
      )
    ],
    indices: [Index(value: ['idBoitier'])]
)
class Minuterie{

  @PrimaryKey(autoGenerate: true)
  int id;
  int idBoitier;
  bool on;
  String heure;
  String jour;
  int millisecondsSinceEpoch;

  @ignore
  DateTime planned;

  Minuterie(
      {this.id,
      this.idBoitier,
      this.on,
      this.heure,
      this.jour,
      this.millisecondsSinceEpoch,
      this.planned});

  static bool activeOrNot(List<Minuterie> minuteurs) {
    bool returnable = false;
    minuteurs.forEach((element) {
      //MAGIC at this moment i don't know that exist (|=)
      returnable |= element.on;
    });

    return returnable;
  }
}
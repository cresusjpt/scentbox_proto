import 'package:floor/floor.dart';
import 'package:json_annotation/json_annotation.dart';

import 'Boitier.dart';

part 'Calendrier.g.dart';

@JsonSerializable()
@Entity(
    foreignKeys: [
      ForeignKey(
        childColumns: ['idDiffuser'],
        parentColumns: ['id'],
        entity: Boitier,
      )
    ],
    indices: [Index(value: ['idDiffuser'])]
)
class Calendrier{

  @PrimaryKey(autoGenerate: true)
  int id;

  int idDiffuser;
  bool monday;
  bool tuesday;
  bool wednesday;
  bool thursday;
  bool friday;
  bool saturday;
  bool sunday;

  Calendrier({this.id, this.idDiffuser, this.monday, this.tuesday, this.wednesday,
    this.thursday, this.friday, this.saturday, this.sunday});

  factory Calendrier.fromJSON(Map<String, dynamic> json) => _$CalendrierFromJson(json);
  Map<String, dynamic> toJson() => _$CalendrierToJson(this);

  List<int> timerDays(){
    List<int> ret = [];
    if(monday){
      ret.add(1);
    }
    if(tuesday){
      ret.add(2);
    }
    if(wednesday){
      ret.add(3);
    }
    if(thursday){
      ret.add(4);
    }
    if(friday){
      ret.add(5);
    }
    if(saturday){
      ret.add(6);
    }
    if(sunday){
      ret.add(0);
    }

    return ret;
  }
}
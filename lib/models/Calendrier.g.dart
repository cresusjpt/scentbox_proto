// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Calendrier.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Calendrier _$CalendrierFromJson(Map<String, dynamic> json) {
  return Calendrier(
    id: json['id'] as int,
    idDiffuser: json['idDiffuser'] as int,
    monday: json['monday'] as bool,
    tuesday: json['tuesday'] as bool,
    wednesday: json['wednesday'] as bool,
    thursday: json['thursday'] as bool,
    friday: json['friday'] as bool,
    saturday: json['saturday'] as bool,
    sunday: json['sunday'] as bool,
  );
}

Map<String, dynamic> _$CalendrierToJson(Calendrier instance) =>
    <String, dynamic>{
      'id': instance.id,
      'idDiffuser': instance.idDiffuser,
      'monday': instance.monday,
      'tuesday': instance.tuesday,
      'wednesday': instance.wednesday,
      'thursday': instance.thursday,
      'friday': instance.friday,
      'saturday': instance.saturday,
      'sunday': instance.sunday,
    };

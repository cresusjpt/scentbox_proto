import 'dart:async';

import 'package:floor/floor.dart';
import 'package:scentbox_proto/database/dao/BoitierDao.dart';
import 'package:scentbox_proto/database/dao/MinuterieDao.dart';
import 'package:scentbox_proto/database/dao/PlageHoraireDao.dart';
import 'package:scentbox_proto/database/dao/CalendrierDao.dart';

import 'package:sqflite/sqflite.dart' as sqflite;

import 'package:scentbox_proto/models/Boitier.dart';
import 'package:scentbox_proto/models/Minuterie.dart';
import 'package:scentbox_proto/models/Calendrier.dart';
import 'package:scentbox_proto/models/PlageHoraire.dart';

part 'AppDatabase.g.dart';

@Database(version: 1, entities: [Boitier,Minuterie,PlageHoraire,Calendrier])
abstract class AppDatabase extends FloorDatabase{
  BoitierDao get boitierDao;
  MinuterieDao get minuterieDao;
  PlageHoraireDao get plageHoraireDao;
  CalendrierDao get calendrierDao;
}
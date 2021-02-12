// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AppDatabase.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String name;

  final List<Migration> _migrations = [];

  Callback _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String> listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  BoitierDao _boitierDaoInstance;

  MinuterieDao _minuterieDaoInstance;

  PlageHoraireDao _plageHoraireDaoInstance;

  CalendrierDao _calendrierDaoInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback callback]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Boitier` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `uniqueid` TEXT, `label` TEXT, `password` TEXT, `parfum` TEXT, `state` INTEGER, `remoteSettings` INTEGER, `intensite` INTEGER, `manuel` INTEGER, `remoteid` INTEGER, `mode` INTEGER)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Minuterie` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `idBoitier` INTEGER, `on` INTEGER, `heure` TEXT, `jour` TEXT, `millisecondsSinceEpoch` INTEGER, FOREIGN KEY (`idBoitier`) REFERENCES `Boitier` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `horaire` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `idBoitier` INTEGER, `on` INTEGER, `heureDebut` TEXT, `heureFin` TEXT, `jour` INTEGER, `millisSecondDebut` INTEGER, `millisecondFin` INTEGER, FOREIGN KEY (`idBoitier`) REFERENCES `Boitier` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Calendrier` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `idDiffuser` INTEGER, `monday` INTEGER, `tuesday` INTEGER, `wednesday` INTEGER, `thursday` INTEGER, `friday` INTEGER, `saturday` INTEGER, `sunday` INTEGER, FOREIGN KEY (`idDiffuser`) REFERENCES `Boitier` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION)');
        await database.execute(
            'CREATE INDEX `index_Minuterie_idBoitier` ON `Minuterie` (`idBoitier`)');
        await database.execute(
            'CREATE INDEX `index_horaire_idBoitier` ON `horaire` (`idBoitier`)');
        await database.execute(
            'CREATE INDEX `index_Calendrier_idDiffuser` ON `Calendrier` (`idDiffuser`)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  BoitierDao get boitierDao {
    return _boitierDaoInstance ??= _$BoitierDao(database, changeListener);
  }

  @override
  MinuterieDao get minuterieDao {
    return _minuterieDaoInstance ??= _$MinuterieDao(database, changeListener);
  }

  @override
  PlageHoraireDao get plageHoraireDao {
    return _plageHoraireDaoInstance ??=
        _$PlageHoraireDao(database, changeListener);
  }

  @override
  CalendrierDao get calendrierDao {
    return _calendrierDaoInstance ??= _$CalendrierDao(database, changeListener);
  }
}

class _$BoitierDao extends BoitierDao {
  _$BoitierDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _boitierInsertionAdapter = InsertionAdapter(
            database,
            'Boitier',
            (Boitier item) => <String, dynamic>{
                  'id': item.id,
                  'uniqueid': item.uniqueid,
                  'label': item.label,
                  'password': item.password,
                  'parfum': item.parfum,
                  'state': item.state == null ? null : (item.state ? 1 : 0),
                  'remoteSettings': item.remoteSettings,
                  'intensite': item.intensite,
                  'manuel': item.manuel == null ? null : (item.manuel ? 1 : 0),
                  'remoteid': item.remoteid,
                  'mode': item.mode
                },
            changeListener),
        _boitierUpdateAdapter = UpdateAdapter(
            database,
            'Boitier',
            ['id'],
            (Boitier item) => <String, dynamic>{
                  'id': item.id,
                  'uniqueid': item.uniqueid,
                  'label': item.label,
                  'password': item.password,
                  'parfum': item.parfum,
                  'state': item.state == null ? null : (item.state ? 1 : 0),
                  'remoteSettings': item.remoteSettings,
                  'intensite': item.intensite,
                  'manuel': item.manuel == null ? null : (item.manuel ? 1 : 0),
                  'remoteid': item.remoteid,
                  'mode': item.mode
                },
            changeListener),
        _boitierDeletionAdapter = DeletionAdapter(
            database,
            'Boitier',
            ['id'],
            (Boitier item) => <String, dynamic>{
                  'id': item.id,
                  'uniqueid': item.uniqueid,
                  'label': item.label,
                  'password': item.password,
                  'parfum': item.parfum,
                  'state': item.state == null ? null : (item.state ? 1 : 0),
                  'remoteSettings': item.remoteSettings,
                  'intensite': item.intensite,
                  'manuel': item.manuel == null ? null : (item.manuel ? 1 : 0),
                  'remoteid': item.remoteid,
                  'mode': item.mode
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Boitier> _boitierInsertionAdapter;

  final UpdateAdapter<Boitier> _boitierUpdateAdapter;

  final DeletionAdapter<Boitier> _boitierDeletionAdapter;

  @override
  Future<List<Boitier>> getDiffusers() async {
    return _queryAdapter.queryList('SELECT * from boitier',
        mapper: (Map<String, dynamic> row) => Boitier(
            id: row['id'] as int,
            uniqueid: row['uniqueid'] as String,
            label: row['label'] as String,
            password: row['password'] as String,
            parfum: row['parfum'] as String,
            state: row['state'] == null ? null : (row['state'] as int) != 0,
            remoteSettings: row['remoteSettings'] as int,
            intensite: row['intensite'] as int,
            manuel: row['manuel'] == null ? null : (row['manuel'] as int) != 0,
            remoteid: row['remoteid'] as int,
            mode: row['mode'] as int));
  }

  @override
  Stream<List<Boitier>> watchDiffusers() {
    return _queryAdapter.queryListStream('SELECT * from boitier',
        queryableName: 'Boitier',
        isView: false,
        mapper: (Map<String, dynamic> row) => Boitier(
            id: row['id'] as int,
            uniqueid: row['uniqueid'] as String,
            label: row['label'] as String,
            password: row['password'] as String,
            parfum: row['parfum'] as String,
            state: row['state'] == null ? null : (row['state'] as int) != 0,
            remoteSettings: row['remoteSettings'] as int,
            intensite: row['intensite'] as int,
            manuel: row['manuel'] == null ? null : (row['manuel'] as int) != 0,
            remoteid: row['remoteid'] as int,
            mode: row['mode'] as int));
  }

  @override
  Future<Boitier> getDiffuser(int id) async {
    return _queryAdapter.query('SELECT * from boitier where id = ?',
        arguments: <dynamic>[id],
        mapper: (Map<String, dynamic> row) => Boitier(
            id: row['id'] as int,
            uniqueid: row['uniqueid'] as String,
            label: row['label'] as String,
            password: row['password'] as String,
            parfum: row['parfum'] as String,
            state: row['state'] == null ? null : (row['state'] as int) != 0,
            remoteSettings: row['remoteSettings'] as int,
            intensite: row['intensite'] as int,
            manuel: row['manuel'] == null ? null : (row['manuel'] as int) != 0,
            remoteid: row['remoteid'] as int,
            mode: row['mode'] as int));
  }

  @override
  Future<Boitier> getDiffuserByUniqueid(String uniqueId) async {
    return _queryAdapter.query('SELECT * from boitier where uniqueid = ?',
        arguments: <dynamic>[uniqueId],
        mapper: (Map<String, dynamic> row) => Boitier(
            id: row['id'] as int,
            uniqueid: row['uniqueid'] as String,
            label: row['label'] as String,
            password: row['password'] as String,
            parfum: row['parfum'] as String,
            state: row['state'] == null ? null : (row['state'] as int) != 0,
            remoteSettings: row['remoteSettings'] as int,
            intensite: row['intensite'] as int,
            manuel: row['manuel'] == null ? null : (row['manuel'] as int) != 0,
            remoteid: row['remoteid'] as int,
            mode: row['mode'] as int));
  }

  @override
  Future<void> taille() async {
    await _queryAdapter.queryNoReturn('Select count(*) from boitier');
  }

  @override
  Future<void> deleteAll() async {
    await _queryAdapter.queryNoReturn('Delete from boitier');
  }

  @override
  Future<void> deleteByBoitier(int idBoitier) async {
    await _queryAdapter.queryNoReturn('Delete from boitier where id = ?',
        arguments: <dynamic>[idBoitier]);
  }

  @override
  Future<int> insertDevice(Boitier diffuser) {
    return _boitierInsertionAdapter.insertAndReturnId(
        diffuser, OnConflictStrategy.replace);
  }

  @override
  Future<int> updateDevice(Boitier diffuser) {
    return _boitierUpdateAdapter.updateAndReturnChangedRows(
        diffuser, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteDevice(Boitier diffuser) async {
    await _boitierDeletionAdapter.delete(diffuser);
  }
}

class _$MinuterieDao extends MinuterieDao {
  _$MinuterieDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _minuterieInsertionAdapter = InsertionAdapter(
            database,
            'Minuterie',
            (Minuterie item) => <String, dynamic>{
                  'id': item.id,
                  'idBoitier': item.idBoitier,
                  'on': item.on == null ? null : (item.on ? 1 : 0),
                  'heure': item.heure,
                  'jour': item.jour,
                  'millisecondsSinceEpoch': item.millisecondsSinceEpoch
                },
            changeListener),
        _minuterieUpdateAdapter = UpdateAdapter(
            database,
            'Minuterie',
            ['id'],
            (Minuterie item) => <String, dynamic>{
                  'id': item.id,
                  'idBoitier': item.idBoitier,
                  'on': item.on == null ? null : (item.on ? 1 : 0),
                  'heure': item.heure,
                  'jour': item.jour,
                  'millisecondsSinceEpoch': item.millisecondsSinceEpoch
                },
            changeListener),
        _minuterieDeletionAdapter = DeletionAdapter(
            database,
            'Minuterie',
            ['id'],
            (Minuterie item) => <String, dynamic>{
                  'id': item.id,
                  'idBoitier': item.idBoitier,
                  'on': item.on == null ? null : (item.on ? 1 : 0),
                  'heure': item.heure,
                  'jour': item.jour,
                  'millisecondsSinceEpoch': item.millisecondsSinceEpoch
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Minuterie> _minuterieInsertionAdapter;

  final UpdateAdapter<Minuterie> _minuterieUpdateAdapter;

  final DeletionAdapter<Minuterie> _minuterieDeletionAdapter;

  @override
  Future<List<Minuterie>> getMinuteurs() async {
    return _queryAdapter.queryList('SELECT * from minuterie',
        mapper: (Map<String, dynamic> row) => Minuterie(
            id: row['id'] as int,
            idBoitier: row['idBoitier'] as int,
            on: row['on'] == null ? null : (row['on'] as int) != 0,
            heure: row['heure'] as String,
            jour: row['jour'] as String,
            millisecondsSinceEpoch: row['millisecondsSinceEpoch'] as int));
  }

  @override
  Stream<List<Minuterie>> watchMinuteurs() {
    return _queryAdapter.queryListStream('SELECT * from minuterie',
        queryableName: 'Minuterie',
        isView: false,
        mapper: (Map<String, dynamic> row) => Minuterie(
            id: row['id'] as int,
            idBoitier: row['idBoitier'] as int,
            on: row['on'] == null ? null : (row['on'] as int) != 0,
            heure: row['heure'] as String,
            jour: row['jour'] as String,
            millisecondsSinceEpoch: row['millisecondsSinceEpoch'] as int));
  }

  @override
  Future<Minuterie> getMinuteur(int id) async {
    return _queryAdapter.query('SELECT * from minuterie where id = ?',
        arguments: <dynamic>[id],
        mapper: (Map<String, dynamic> row) => Minuterie(
            id: row['id'] as int,
            idBoitier: row['idBoitier'] as int,
            on: row['on'] == null ? null : (row['on'] as int) != 0,
            heure: row['heure'] as String,
            jour: row['jour'] as String,
            millisecondsSinceEpoch: row['millisecondsSinceEpoch'] as int));
  }

  @override
  Future<List<Minuterie>> getMinuteurByBoitier(int id) async {
    return _queryAdapter.queryList(
        'SELECT * from minuterie where idBoitier = ?',
        arguments: <dynamic>[id],
        mapper: (Map<String, dynamic> row) => Minuterie(
            id: row['id'] as int,
            idBoitier: row['idBoitier'] as int,
            on: row['on'] == null ? null : (row['on'] as int) != 0,
            heure: row['heure'] as String,
            jour: row['jour'] as String,
            millisecondsSinceEpoch: row['millisecondsSinceEpoch'] as int));
  }

  @override
  Stream<List<Minuterie>> watchMinuteurByBoitier(int id) {
    return _queryAdapter.queryListStream(
        'SELECT * from minuterie where idBoitier = ?',
        arguments: <dynamic>[id],
        queryableName: 'Minuterie',
        isView: false,
        mapper: (Map<String, dynamic> row) => Minuterie(
            id: row['id'] as int,
            idBoitier: row['idBoitier'] as int,
            on: row['on'] == null ? null : (row['on'] as int) != 0,
            heure: row['heure'] as String,
            jour: row['jour'] as String,
            millisecondsSinceEpoch: row['millisecondsSinceEpoch'] as int));
  }

  @override
  Future<void> length() async {
    await _queryAdapter.queryNoReturn('Select count(*) from minuterie');
  }

  @override
  Future<void> deleteAll() async {
    await _queryAdapter.queryNoReturn('Delete from minuterie');
  }

  @override
  Future<void> deleteByBoitier(int idBoitier) async {
    await _queryAdapter.queryNoReturn(
        'Delete from minuterie where idBoitier = ?',
        arguments: <dynamic>[idBoitier]);
  }

  @override
  Future<int> insertMinuterie(Minuterie minuteur) {
    return _minuterieInsertionAdapter.insertAndReturnId(
        minuteur, OnConflictStrategy.replace);
  }

  @override
  Future<int> updateMinuterie(Minuterie minuteur) {
    return _minuterieUpdateAdapter.updateAndReturnChangedRows(
        minuteur, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteMinuterie(Minuterie minuteur) async {
    await _minuterieDeletionAdapter.delete(minuteur);
  }
}

class _$PlageHoraireDao extends PlageHoraireDao {
  _$PlageHoraireDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _plageHoraireInsertionAdapter = InsertionAdapter(
            database,
            'horaire',
            (PlageHoraire item) => <String, dynamic>{
                  'id': item.id,
                  'idBoitier': item.idBoitier,
                  'on': item.on == null ? null : (item.on ? 1 : 0),
                  'heureDebut': item.heureDebut,
                  'heureFin': item.heureFin,
                  'jour': item.jour,
                  'millisSecondDebut': item.millisSecondDebut,
                  'millisecondFin': item.millisecondFin
                },
            changeListener),
        _plageHoraireUpdateAdapter = UpdateAdapter(
            database,
            'horaire',
            ['id'],
            (PlageHoraire item) => <String, dynamic>{
                  'id': item.id,
                  'idBoitier': item.idBoitier,
                  'on': item.on == null ? null : (item.on ? 1 : 0),
                  'heureDebut': item.heureDebut,
                  'heureFin': item.heureFin,
                  'jour': item.jour,
                  'millisSecondDebut': item.millisSecondDebut,
                  'millisecondFin': item.millisecondFin
                },
            changeListener),
        _plageHoraireDeletionAdapter = DeletionAdapter(
            database,
            'horaire',
            ['id'],
            (PlageHoraire item) => <String, dynamic>{
                  'id': item.id,
                  'idBoitier': item.idBoitier,
                  'on': item.on == null ? null : (item.on ? 1 : 0),
                  'heureDebut': item.heureDebut,
                  'heureFin': item.heureFin,
                  'jour': item.jour,
                  'millisSecondDebut': item.millisSecondDebut,
                  'millisecondFin': item.millisecondFin
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<PlageHoraire> _plageHoraireInsertionAdapter;

  final UpdateAdapter<PlageHoraire> _plageHoraireUpdateAdapter;

  final DeletionAdapter<PlageHoraire> _plageHoraireDeletionAdapter;

  @override
  Future<List<PlageHoraire>> getHoraires() async {
    return _queryAdapter.queryList('SELECT * from horaire',
        mapper: (Map<String, dynamic> row) => PlageHoraire(
            id: row['id'] as int,
            idBoitier: row['idBoitier'] as int,
            on: row['on'] == null ? null : (row['on'] as int) != 0,
            heureDebut: row['heureDebut'] as String,
            heureFin: row['heureFin'] as String,
            jour: row['jour'] as int,
            millisSecondDebut: row['millisSecondDebut'] as int,
            millisecondFin: row['millisecondFin'] as int));
  }

  @override
  Stream<List<PlageHoraire>> watchHoraires() {
    return _queryAdapter.queryListStream('SELECT * from horaire',
        queryableName: 'horaire',
        isView: false,
        mapper: (Map<String, dynamic> row) => PlageHoraire(
            id: row['id'] as int,
            idBoitier: row['idBoitier'] as int,
            on: row['on'] == null ? null : (row['on'] as int) != 0,
            heureDebut: row['heureDebut'] as String,
            heureFin: row['heureFin'] as String,
            jour: row['jour'] as int,
            millisSecondDebut: row['millisSecondDebut'] as int,
            millisecondFin: row['millisecondFin'] as int));
  }

  @override
  Future<PlageHoraire> getHoraire(int id) async {
    return _queryAdapter.query('SELECT * from horaire where id = ?',
        arguments: <dynamic>[id],
        mapper: (Map<String, dynamic> row) => PlageHoraire(
            id: row['id'] as int,
            idBoitier: row['idBoitier'] as int,
            on: row['on'] == null ? null : (row['on'] as int) != 0,
            heureDebut: row['heureDebut'] as String,
            heureFin: row['heureFin'] as String,
            jour: row['jour'] as int,
            millisSecondDebut: row['millisSecondDebut'] as int,
            millisecondFin: row['millisecondFin'] as int));
  }

  @override
  Future<PlageHoraire> getHoraireByBoitier(int id) async {
    return _queryAdapter.query('SELECT * from horaire where idBoitier = ?',
        arguments: <dynamic>[id],
        mapper: (Map<String, dynamic> row) => PlageHoraire(
            id: row['id'] as int,
            idBoitier: row['idBoitier'] as int,
            on: row['on'] == null ? null : (row['on'] as int) != 0,
            heureDebut: row['heureDebut'] as String,
            heureFin: row['heureFin'] as String,
            jour: row['jour'] as int,
            millisSecondDebut: row['millisSecondDebut'] as int,
            millisecondFin: row['millisecondFin'] as int));
  }

  @override
  Stream<List<PlageHoraire>> watchHoraireByDiffuser(int id) {
    return _queryAdapter.queryListStream(
        'SELECT * from horaire where idBoitier = ?',
        arguments: <dynamic>[id],
        queryableName: 'horaire',
        isView: false,
        mapper: (Map<String, dynamic> row) => PlageHoraire(
            id: row['id'] as int,
            idBoitier: row['idBoitier'] as int,
            on: row['on'] == null ? null : (row['on'] as int) != 0,
            heureDebut: row['heureDebut'] as String,
            heureFin: row['heureFin'] as String,
            jour: row['jour'] as int,
            millisSecondDebut: row['millisSecondDebut'] as int,
            millisecondFin: row['millisecondFin'] as int));
  }

  @override
  Future<void> taille() async {
    await _queryAdapter.queryNoReturn('Select count(*) from horaire');
  }

  @override
  Future<void> deleteAll() async {
    await _queryAdapter.queryNoReturn('Delete from horaire');
  }

  @override
  Future<void> deleteByDiffuser(int idBoitier) async {
    await _queryAdapter.queryNoReturn('Delete from horaire where idBoitier = ?',
        arguments: <dynamic>[idBoitier]);
  }

  @override
  Future<int> insertHoraire(PlageHoraire horaire) {
    return _plageHoraireInsertionAdapter.insertAndReturnId(
        horaire, OnConflictStrategy.replace);
  }

  @override
  Future<int> updateHoraire(PlageHoraire horaire) {
    return _plageHoraireUpdateAdapter.updateAndReturnChangedRows(
        horaire, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteHoraire(PlageHoraire horaire) async {
    await _plageHoraireDeletionAdapter.delete(horaire);
  }
}

class _$CalendrierDao extends CalendrierDao {
  _$CalendrierDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _calendrierInsertionAdapter = InsertionAdapter(
            database,
            'Calendrier',
            (Calendrier item) => <String, dynamic>{
                  'id': item.id,
                  'idDiffuser': item.idDiffuser,
                  'monday': item.monday == null ? null : (item.monday ? 1 : 0),
                  'tuesday':
                      item.tuesday == null ? null : (item.tuesday ? 1 : 0),
                  'wednesday':
                      item.wednesday == null ? null : (item.wednesday ? 1 : 0),
                  'thursday':
                      item.thursday == null ? null : (item.thursday ? 1 : 0),
                  'friday': item.friday == null ? null : (item.friday ? 1 : 0),
                  'saturday':
                      item.saturday == null ? null : (item.saturday ? 1 : 0),
                  'sunday': item.sunday == null ? null : (item.sunday ? 1 : 0)
                },
            changeListener),
        _calendrierUpdateAdapter = UpdateAdapter(
            database,
            'Calendrier',
            ['id'],
            (Calendrier item) => <String, dynamic>{
                  'id': item.id,
                  'idDiffuser': item.idDiffuser,
                  'monday': item.monday == null ? null : (item.monday ? 1 : 0),
                  'tuesday':
                      item.tuesday == null ? null : (item.tuesday ? 1 : 0),
                  'wednesday':
                      item.wednesday == null ? null : (item.wednesday ? 1 : 0),
                  'thursday':
                      item.thursday == null ? null : (item.thursday ? 1 : 0),
                  'friday': item.friday == null ? null : (item.friday ? 1 : 0),
                  'saturday':
                      item.saturday == null ? null : (item.saturday ? 1 : 0),
                  'sunday': item.sunday == null ? null : (item.sunday ? 1 : 0)
                },
            changeListener),
        _calendrierDeletionAdapter = DeletionAdapter(
            database,
            'Calendrier',
            ['id'],
            (Calendrier item) => <String, dynamic>{
                  'id': item.id,
                  'idDiffuser': item.idDiffuser,
                  'monday': item.monday == null ? null : (item.monday ? 1 : 0),
                  'tuesday':
                      item.tuesday == null ? null : (item.tuesday ? 1 : 0),
                  'wednesday':
                      item.wednesday == null ? null : (item.wednesday ? 1 : 0),
                  'thursday':
                      item.thursday == null ? null : (item.thursday ? 1 : 0),
                  'friday': item.friday == null ? null : (item.friday ? 1 : 0),
                  'saturday':
                      item.saturday == null ? null : (item.saturday ? 1 : 0),
                  'sunday': item.sunday == null ? null : (item.sunday ? 1 : 0)
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Calendrier> _calendrierInsertionAdapter;

  final UpdateAdapter<Calendrier> _calendrierUpdateAdapter;

  final DeletionAdapter<Calendrier> _calendrierDeletionAdapter;

  @override
  Future<List<Calendrier>> getCalendriers() async {
    return _queryAdapter.queryList('SELECT * from calendrier',
        mapper: (Map<String, dynamic> row) => Calendrier(
            id: row['id'] as int,
            idDiffuser: row['idDiffuser'] as int,
            monday: row['monday'] == null ? null : (row['monday'] as int) != 0,
            tuesday:
                row['tuesday'] == null ? null : (row['tuesday'] as int) != 0,
            wednesday: row['wednesday'] == null
                ? null
                : (row['wednesday'] as int) != 0,
            thursday:
                row['thursday'] == null ? null : (row['thursday'] as int) != 0,
            friday: row['friday'] == null ? null : (row['friday'] as int) != 0,
            saturday:
                row['saturday'] == null ? null : (row['saturday'] as int) != 0,
            sunday:
                row['sunday'] == null ? null : (row['sunday'] as int) != 0));
  }

  @override
  Stream<List<Calendrier>> watchCalendriers() {
    return _queryAdapter.queryListStream('SELECT * from calendrier',
        queryableName: 'Calendrier',
        isView: false,
        mapper: (Map<String, dynamic> row) => Calendrier(
            id: row['id'] as int,
            idDiffuser: row['idDiffuser'] as int,
            monday: row['monday'] == null ? null : (row['monday'] as int) != 0,
            tuesday:
                row['tuesday'] == null ? null : (row['tuesday'] as int) != 0,
            wednesday: row['wednesday'] == null
                ? null
                : (row['wednesday'] as int) != 0,
            thursday:
                row['thursday'] == null ? null : (row['thursday'] as int) != 0,
            friday: row['friday'] == null ? null : (row['friday'] as int) != 0,
            saturday:
                row['saturday'] == null ? null : (row['saturday'] as int) != 0,
            sunday:
                row['sunday'] == null ? null : (row['sunday'] as int) != 0));
  }

  @override
  Future<Calendrier> getCalendrier(int id) async {
    return _queryAdapter.query('SELECT * from calendrier where id = ?',
        arguments: <dynamic>[id],
        mapper: (Map<String, dynamic> row) => Calendrier(
            id: row['id'] as int,
            idDiffuser: row['idDiffuser'] as int,
            monday: row['monday'] == null ? null : (row['monday'] as int) != 0,
            tuesday:
                row['tuesday'] == null ? null : (row['tuesday'] as int) != 0,
            wednesday: row['wednesday'] == null
                ? null
                : (row['wednesday'] as int) != 0,
            thursday:
                row['thursday'] == null ? null : (row['thursday'] as int) != 0,
            friday: row['friday'] == null ? null : (row['friday'] as int) != 0,
            saturday:
                row['saturday'] == null ? null : (row['saturday'] as int) != 0,
            sunday:
                row['sunday'] == null ? null : (row['sunday'] as int) != 0));
  }

  @override
  Future<Calendrier> getCalendrierByDiffuser(int id) async {
    return _queryAdapter.query('SELECT * from calendrier where idDiffuser = ?',
        arguments: <dynamic>[id],
        mapper: (Map<String, dynamic> row) => Calendrier(
            id: row['id'] as int,
            idDiffuser: row['idDiffuser'] as int,
            monday: row['monday'] == null ? null : (row['monday'] as int) != 0,
            tuesday:
                row['tuesday'] == null ? null : (row['tuesday'] as int) != 0,
            wednesday: row['wednesday'] == null
                ? null
                : (row['wednesday'] as int) != 0,
            thursday:
                row['thursday'] == null ? null : (row['thursday'] as int) != 0,
            friday: row['friday'] == null ? null : (row['friday'] as int) != 0,
            saturday:
                row['saturday'] == null ? null : (row['saturday'] as int) != 0,
            sunday:
                row['sunday'] == null ? null : (row['sunday'] as int) != 0));
  }

  @override
  Future<void> taille() async {
    await _queryAdapter.queryNoReturn('Select count(*) from calendrier');
  }

  @override
  Future<void> deleteAll() async {
    await _queryAdapter.queryNoReturn('Delete from calendrier');
  }

  @override
  Future<void> deleteByDiffuser(int idDiffuser) async {
    await _queryAdapter.queryNoReturn(
        'Delete from calendrier where idDiffuser = ?',
        arguments: <dynamic>[idDiffuser]);
  }

  @override
  Future<int> insertCalendrier(Calendrier calendrier) {
    return _calendrierInsertionAdapter.insertAndReturnId(
        calendrier, OnConflictStrategy.replace);
  }

  @override
  Future<int> updateCalendrier(Calendrier calendrier) {
    return _calendrierUpdateAdapter.updateAndReturnChangedRows(
        calendrier, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteCalendrier(Calendrier calendrier) async {
    await _calendrierDeletionAdapter.delete(calendrier);
  }
}

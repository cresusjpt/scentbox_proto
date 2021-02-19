import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get_ip/get_ip.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:scentbox_proto/Others/IntervalledDatePicker.dart';
import 'package:scentbox_proto/database/dao/CalendrierDao.dart';
import 'package:scentbox_proto/database/dao/PlageHoraireDao.dart';
import 'package:scentbox_proto/inheritedwidgets/IOWebSocketChannelWidget.dart';
import 'package:scentbox_proto/inheritedwidgets/IOWebSocketChannelWidgetData.dart';
import 'package:scentbox_proto/models/Boitier.dart';
import 'package:scentbox_proto/models/Calendrier.dart';
import 'package:scentbox_proto/models/PlageHoraire.dart';
import 'package:scentbox_proto/network/RestApi.dart';
import 'package:web_socket_channel/io.dart';

class Horaire extends StatefulWidget {
  @override
  _HoraireState createState() => _HoraireState();
}

class _HoraireState extends State<Horaire> {
  String _title = " | Plage Horaire";
  Map data = {};
  Boitier device;
  Calendrier _calendrier;
  CalendrierDao _calendrierDao;
  int counter = 0;
  bool _saving = false;
  final key = GlobalKey<ScaffoldState>();
  IOWebSocketChannelWidgetData inheritedData;

  bool isMonday = false;
  bool isTuesday = false;
  bool isWednesday = false;
  bool isThursday = false;
  bool isFriday = false;
  bool isSaturday = false;
  bool isSunday = false;

  bool switcher = false;

  IOWebSocketChannel channel;
  String endpoint;

  void bindCalendrier(Calendrier calendrier) {
    setState(() {
      isMonday = calendrier.monday;
      isTuesday = calendrier.tuesday;
      isWednesday = calendrier.wednesday;
      isThursday = calendrier.thursday;
      isFriday = calendrier.friday;
      isSaturday = calendrier.saturday;
      isSunday = calendrier.sunday;
    });
  }

  void connectAndListenWebSocket() {
    endpoint = "${RestApi.WEBSOCKET_URL_PART}app_${device.uniqueid}";
    channel = IOWebSocketChannel.connect(Uri.parse(endpoint));
    channel.stream.listen((event) {
      print("JEANPAUL message recu ${event.toString()}");
    });
  }

  void listenWebSocket(){
    inheritedData = IOWebSocketChannelWidget.of(context).data;
    inheritedData.stream.listen((event) {
      key.currentState.showSnackBar(SnackBar(
        content: Text(event.toString()),
      ));
    });
  }

  void checkBoxChangedState(String day, bool newValue) {
    setState(() {
      switch (day) {
        case "monday":
          isMonday = newValue;
          _calendrier.monday = newValue;
          break;
        case "tuesday":
          isTuesday = newValue;
          _calendrier.tuesday = newValue;
          break;
        case "wednesday":
          isWednesday = newValue;
          _calendrier.wednesday = newValue;
          break;
        case "thursday":
          isThursday = newValue;
          _calendrier.thursday = newValue;
          break;
        case "friday":
          isFriday = newValue;
          _calendrier.friday = newValue;
          break;
        case "saturday":
          isSaturday = newValue;
          _calendrier.saturday = newValue;
          break;
        case "sunday":
          isSunday = newValue;
          _calendrier.sunday = newValue;
          break;
      }
      _calendrierDao.updateCalendrier(_calendrier);
    });
  }

  Future<String> getIpAdress() async {
    final String ip = await GetIp.ipAddress;
    return ip;
  }

  void deleteAll() async {
    setState(() {
      _saving = true;
    });
    String ip = await getIpAdress();
    if (!ip.startsWith(RestApi.BASE_URL_PART)) {
      String commande = "Plage*";
      //Provider.of<PlageHoraireDao>(context).deleteAll();
      channel.sink.add(commande);
    }else{
      key.currentState.showSnackBar(SnackBar(
        content: Text("Vous êtes en connexion directe, cette fonctionnalité n'est pas encore implémentée"),
      ));
    }
    Future.delayed(Duration(seconds: 2));
    setState(() {
      _saving = false;
    });
  }

  void switchChangedState(
      BuildContext context, bool value, PlageHoraire object) async {
    object.on = !object.on;
    String ip = await getIpAdress();
    if (ip.startsWith(RestApi.BASE_URL_PART)) {
      key.currentState.showSnackBar(SnackBar(
        content: Text("Vous êtes en connexion directe, cette fonctionnalité n'est pas encore implémentée"),
      ));
    } else {
      _calendrier.timerDays().forEach((element) {
        String commande = object.on ? "PlageAdd" : "PlageDelete";
        String message =
            "$commande/${object.heureDebut}:00;${object.heureFin}:00;$element";
        print("Message envoyé minuteur : $message");
        channel.sink.add(message);
      });
    }
    setState(() {
      Provider.of<PlageHoraireDao>(context).updateHoraire(object);
    });
  }

  @override
  Widget build(BuildContext context) {
    _title = " | Horaires ";
    final horaireDao = Provider.of<PlageHoraireDao>(context);
    if (data.isEmpty) {
      device = ModalRoute.of(context).settings.arguments;
      _calendrierDao = Provider.of<CalendrierDao>(context);

      _calendrierDao.getCalendrierByDiffuser(device.id).then((value) {
        _calendrier = value;
        if (counter == 0) {
          bindCalendrier(_calendrier);
          counter += 1;
        }
      });
    }

    connectAndListenWebSocket();
    listenWebSocket();

    return Scaffold(
      key: key,
      appBar: AppBar(
        elevation: 0,
        title: Text("${device.label}$_title"),
        actions: [
          IconButton(
              icon: Icon(Icons.delete_outline_outlined), onPressed: deleteAll)
        ],
      ),
      body: ModalProgressHUD(
        inAsyncCall: _saving,
        progressIndicator: CircularProgressIndicator(),
        child: Container(
          child: Column(
            children: [
              Expanded(
                flex: 1,
                //fit: FlexFit.tight,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: <Widget>[
                            Checkbox(
                              onChanged: (value) {
                                checkBoxChangedState('monday', value);
                              },
                              value: isMonday,
                            ),
                            Text(
                              "Lun",
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: <Widget>[
                            Checkbox(
                              onChanged: (value) {
                                checkBoxChangedState('tuesday', value);
                              },
                              value: isTuesday,
                            ),
                            Text(
                              "Mar",
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: <Widget>[
                            Checkbox(
                              onChanged: (value) {
                                checkBoxChangedState('wednesday', value);
                              },
                              value: isWednesday,
                            ),
                            Text(
                              "Mer",
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: <Widget>[
                            Checkbox(
                              onChanged: (value) {
                                checkBoxChangedState('thursday', value);
                              },
                              value: isThursday,
                            ),
                            Text(
                              "Jeu",
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: <Widget>[
                            Checkbox(
                              onChanged: (value) {
                                checkBoxChangedState('friday', value);
                              },
                              value: isFriday,
                            ),
                            Text(
                              "Ven",
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: <Widget>[
                            Checkbox(
                              onChanged: (value) {
                                checkBoxChangedState('saturday', value);
                              },
                              value: isSaturday,
                            ),
                            Text(
                              "Sam",
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: <Widget>[
                            Checkbox(
                              onChanged: (value) {
                                checkBoxChangedState('sunday', value);
                              },
                              value: isSunday,
                            ),
                            Text(
                              "Dim",
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Divider(
                color: Colors.black,
                height: 1,
              ),
              Expanded(
                  flex: 5,
                  child: StreamBuilder<List<PlageHoraire>>(
                    stream: horaireDao.watchHoraireByDiffuser(device.id),
                    builder: (context, snapshot) {
                      final horaires = snapshot.hasData ? snapshot.data : List();
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: horaires.length,
                        itemBuilder: (context, index) {
                          PlageHoraire object = horaires.elementAt(index);
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 1.0,
                              horizontal: 4.0,
                            ),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                /*side: BorderSide(color: Colors.red)*/
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 10, bottom: 10),
                                child: ListTile(
                                  onTap: () {},
                                  title: object != null
                                      ? GestureDetector(
                                          onTap: () {
                                            DatePicker.showPicker(context,
                                                locale: LocaleType.fr,
                                                showTitleActions: true,
                                                onChanged: (date) {},
                                                onConfirm: (date) {
                                              setState(() {
                                                object.on = false;
                                                object.heureFin =
                                                    "${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
                                                Provider.of<PlageHoraireDao>(
                                                        context)
                                                    .updateHoraire(object);
                                              });
                                            },
                                                pickerModel:
                                                    IntervalledDatePicker(
                                                        currentTime:
                                                            DateTime.now(),
                                                        interval: 1));
                                          },
                                          child: Text(
                                            '${object.heureFin}',
                                            style: TextStyle(
                                              letterSpacing: 2.0,
                                              fontSize: 25.0,
                                              backgroundColor:
                                                  Color.fromRGBO(67, 64, 67, 0.6),
                                            ),
                                          ),
                                        )
                                      : Text('--'),
                                  leading: object != null
                                      ? Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                            //side: BorderSide(color: Colors.white)
                                          ),
                                          child: GestureDetector(
                                            onTap: () {
                                              DatePicker.showPicker(context,
                                                  locale: LocaleType.fr,
                                                  showTitleActions: true,
                                                  onChanged: (date) {},
                                                  onConfirm: (date) {
                                                setState(() {
                                                  object.on = false;
                                                  object.heureDebut =
                                                      "${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
                                                  Provider.of<PlageHoraireDao>(
                                                          context)
                                                      .updateHoraire(object);
                                                });
                                              },
                                                  pickerModel:
                                                      IntervalledDatePicker(
                                                          currentTime:
                                                              DateTime.now(),
                                                          interval: 1));
                                            },
                                            child: Text(
                                              '${object.heureDebut}',
                                              style: TextStyle(
                                                letterSpacing: 2.0,
                                                fontSize: 25.0,
                                                //Couleur de fond checkbox
                                                wordSpacing: 1,
                                              ),
                                            ),
                                          ),
                                        )
                                      : Text('--'),
                                  trailing: Switch(
                                    onChanged: (value) {
                                      switchChangedState(context, value, object);
                                    },
                                    value: object.on,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

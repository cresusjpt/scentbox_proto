import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get_ip/get_ip.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:scentbox_proto/database/dao/MinuterieDao.dart';
import 'package:scentbox_proto/inheritedwidgets/IOWebSocketChannelWidget.dart';
import 'package:scentbox_proto/inheritedwidgets/IOWebSocketChannelWidgetData.dart';
import 'package:scentbox_proto/models/Boitier.dart';
import 'package:scentbox_proto/models/Minuterie.dart';
import 'package:scentbox_proto/network/RestApi.dart';
import 'package:web_socket_channel/io.dart';

class Minuteur extends StatefulWidget {
  @override
  _MinuteurState createState() => _MinuteurState();
}

class _MinuteurState extends State<Minuteur> {
  String _title = " | Minuteur";
  Map data = {};
  final key = GlobalKey<ScaffoldState>();
  Boitier device;
  bool swithValue = false;
  IOWebSocketChannelWidgetData inheritedData;

  bool _saving = false;

  //websocket channel
  IOWebSocketChannel channel;
  String endpoint;

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
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
      String commande = "Minuteur*";
      Provider.of<MinuterieDao>(context, listen: false).deleteAll();
      channel.sink.add(commande);
    } else {
      if (key != null && key.currentState != null)
        ScaffoldMessenger.of(key.currentState.context).showSnackBar(SnackBar(
          content: Text(
              "Vous êtes en connexion directe, cette fonctionnalité n'est pas encore implémentée"),
        ));
    }
    Future.delayed(Duration(seconds: 2));
    setState(() {
      _saving = false;
    });
  }

  void minuteurChecked(Minuterie minuteur, bool value) async {
    minuteur.on = !minuteur.on;
    String ip = await getIpAdress();
    if (ip.startsWith(RestApi.BASE_URL_PART)) {
      if (key != null && key.currentState != null)
        ScaffoldMessenger.of(key.currentState.context).showSnackBar(SnackBar(
          content: Text(
              "Vous êtes en connexion directe, cette fonctionnalité n'est pas encore implémentée"),
        ));
    } else {
      String commande = minuteur.on ? "MinuteurAdd" : "MinuteurDelete";
      String message = "$commande/${minuteur.jour};${minuteur.heure}:00";
      print("Message envoyé minuteur : $message");
      channel.sink.add(message);
    }
    setState(() {
      Provider.of<MinuterieDao>(context, listen: false).updateMinuterie(minuteur);
    });
  }

  void connectAndListenWebSocket() {
    endpoint = "${RestApi.WEBSOCKET_URL_PART}app_${device.uniqueid}";
    channel = IOWebSocketChannel.connect(Uri.parse(endpoint));
  }

  void listenWebSocket() {
    inheritedData = IOWebSocketChannelWidget.of(context).data;

    inheritedData.stream.listen((event) {
      if (key != null && key.currentState != null)
        ScaffoldMessenger.of(key.currentState.context).showSnackBar(SnackBar(content: Text(event.toString())));
    });
  }

  void _addMinuteur(context) {
    DatePicker.showDateTimePicker(context,
        showTitleActions: true,
        minTime: DateTime.now().add(Duration(minutes: 5)),
        maxTime: DateTime.now().add(Duration(days: 30)), onChanged: (date) {
      print('change $date in time zone ' +
          date.timeZoneOffset.inHours.toString());
    }, onConfirm: (date) {
      final minuteurDao = Provider.of<MinuterieDao>(context, listen: false);
      Minuterie minuteur = Minuterie(
          idBoitier: device.id,
          on: false,
          jour:
              "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
          heure:
              "${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}",
          millisecondsSinceEpoch: date.millisecondsSinceEpoch);
      minuteurDao.insertMinuterie(minuteur);
    }, locale: LocaleType.fr);
  }

  @override
  Widget build(BuildContext context) {
    _title = " | Minuteurs ";
    final minuteurDao = Provider.of<MinuterieDao>(context, listen: false);
    device = ModalRoute.of(context).settings.arguments;

    connectAndListenWebSocket();
    listenWebSocket();

    return Scaffold(
      key: key,
      appBar: AppBar(
        elevation: 0,
        title: Text("${device.label}$_title"),
        actions: [
          IconButton(
              icon: Icon(Icons.delete_outline_outlined), onPressed: deleteAll),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addMinuteur(context);
        },
        child: Icon(Icons.add),
      ),
      body: ModalProgressHUD(
        inAsyncCall: _saving,
        progressIndicator: CircularProgressIndicator(),
        child: Container(
          child: StreamBuilder<List<Minuterie>>(
            stream: minuteurDao.watchMinuteurByBoitier(device.id),
            builder: (context, AsyncSnapshot<List<Minuterie>> snapshot) {
              final List<Minuterie> minuteurs = snapshot.data ?? [];
              return ListView.builder(
                  itemCount: minuteurs.length,
                  itemBuilder: (context, index) {
                    Minuterie minuteur = minuteurs.elementAt(index);
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 1.0, horizontal: 4.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          /*side: BorderSide(color: Colors.red)*/
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          child: ListTile(
                            onTap: () {},
                            title: minuteur != null
                                ? Text(
                                    '${minuteur.heure}',
                                    style: TextStyle(
                                      letterSpacing: 5,
                                      fontSize: 25.0,
                                    ),
                                  )
                                : Text('--'),
                            leading: Text(
                              '${minuteur.jour}',
                              style: TextStyle(
                                letterSpacing: 3,
                              ),
                            ),
                            trailing: Switch(
                              onChanged: (value) {
                                minuteurChecked(minuteur, value);
                              },
                              value: minuteur.on,
                            ),
                          ),
                        ),
                      ),
                    );
                  });
            },
          ),
        ),
      ),
    );
  }
}

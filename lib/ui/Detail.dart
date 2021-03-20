import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:get_ip/get_ip.dart';
import 'package:intl/intl.dart';

//import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:scentbox_proto/database/dao/BoitierDao.dart';
import 'package:scentbox_proto/database/dao/MinuterieDao.dart';
import 'package:scentbox_proto/database/dao/PlageHoraireDao.dart';
import 'package:scentbox_proto/inheritedwidgets/IOWebSocketChannelWidget.dart';
import 'package:scentbox_proto/inheritedwidgets/IOWebSocketChannelWidgetData.dart';
import 'package:scentbox_proto/models/Boitier.dart';
import 'package:scentbox_proto/network/RestApi.dart';
import 'package:web_socket_channel/io.dart';

import '../database/dao/CalendrierDao.dart';

class Detail extends StatefulWidget {
  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  Map data = {};
  final key = GlobalKey<ScaffoldState>();
  Boitier device;
  int firstTime = 0;

  BuildContext myContext;
  double value = 0;

  //bool _saving = true;
  bool isTogglePressed = false;
  String togglemessage = "OFF";
  IOWebSocketChannelWidgetData inheritedData;

  bool advanceValue = true;
  double seekbar = 0;
  String labelSeekbar = "0%";

  //websocket channel
  IOWebSocketChannel channel;
  String endpoint;

  Future<String> getIpAdress() async {
    final String ip = await GetIp.ipAddress;
    return ip;
  }

  ///just a dialog to confirm diffuser delete feature
  void _showDialog(BuildContext context, String title, String content) async {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(title),
          content: new Text(content),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            TextButton(
              child: Text("Annuler"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("OK"),
              onPressed: () async {
                ///in only this order because of relation on the database tables
                await Provider.of<PlageHoraireDao>(context, listen: false)
                    .deleteByDiffuser(device.id);
                await Provider.of<MinuterieDao>(context, listen: false)
                    .deleteByBoitier(device.id);
                await Provider.of<CalendrierDao>(context,listen: false).deleteByDiffuser(device.id);
                await Provider.of<BoitierDao>(context, listen: false)
                    .deleteByBoitier(device.id);

                Navigator.pop(context, true);
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/');
              },
            ),
          ],
        );
      },
    );
  }

  void remoteAction() async {
    String ip = await getIpAdress();
    if (ip.startsWith(RestApi.BASE_URL_PART)) {
      Navigator.pushReplacementNamed(context, '/remote',
          arguments: {'device': device});
    } else {
      if (key.currentState != null) {
        ScaffoldMessenger.of(key.currentState.context).showSnackBar(SnackBar(
            content: Text("Vous devez être connecté au wifi du diffuseur")));
      }
    }
  }

  void deleteAction() {
    _showDialog(context, "Suppression", "Supprimer diffuseur");
  }

  void _checkSliderPressed(double newValue) {
    setState(() {
      seekbar = newValue;
      device.intensite = newValue.toInt();
      labelSeekbar = "${seekbar.toInt()} %";
    });
  }

  void _checkSliderStopped(BuildContext context, double newValue) {
    setState(() {
      seekbar = newValue;
      labelSeekbar = "${seekbar.toInt()} %";

      BoitierDao boitierDao = Provider.of<BoitierDao>(context, listen: false);
      device.intensite = newValue.toInt();
      boitierDao.updateDevice(device);
    });
    manualAction(isTogglePressed);
  }

  void scanBarCodeAction() async {
    var result = await BarcodeScanner.scan();
    if (result.type == ResultType.Barcode) {
      String uniqueId = result.rawContent;
      if (uniqueId != null) {
        device.uniqueid = uniqueId;
        Provider.of<BoitierDao>(context, listen: false).updateDevice(device);
      }
    } else {
      if (key.currentState != null) {
        ScaffoldMessenger.of(key.currentState.context).showSnackBar(SnackBar(
            content: Text("Une erreur s'est produite pendant le scan")));
      }
    }
  }

  @override
  void initState() {
    Future.delayed(Duration(seconds: 3)).then((value) {
      Future.delayed(Duration(milliseconds: 1500));

      ///assert if uniqueid exist (it's allow us to send request to web service), if not and we are not connected to diffuser wifi show snack to scan
      getIpAdress().then((ip) {
        if ((device == null ||
                device.uniqueid == null ||
                device.uniqueid.isEmpty) &&
            !ip.startsWith(RestApi.BASE_URL_PART)) {
          if (key.currentState != null) {
            ScaffoldMessenger.of(key.currentState.context)
                .showSnackBar(SnackBar(
              content: Text("Scanner le code du diffuseur"),
              action: SnackBarAction(
                label:
                    "Veuillez scanner le code qr du boitier ou vous connecter à son wifi",
                onPressed: scanBarCodeAction,
              ),
            ));
          }
        }
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

  void checkDiffuserState() {
    String message = "Etat";
    channel.sink.add(message);
  }

  void manualAction(bool manual) async {
    isTogglePressed = manual;
    value = isTogglePressed ? 0 : 1;
    togglemessage = isTogglePressed ? "ON" : "OFF";
    device.state = isTogglePressed;
    String ip = await getIpAdress();
    if (ip.startsWith(RestApi.BASE_URL_PART)) {
      int mode = isTogglePressed ? 2 : 0;
      DateTime now = DateTime.now();
      String formattedHour = DateFormat('HH:mm:ss').format(now);
      RestApi.createClient()
          .manualSwitch(mode, formattedHour, device.getCommandeIntensite())
          .then((it) {
        print(it);
        if (key.currentState != null) {
          ScaffoldMessenger.of(key.currentState.context)
              .showSnackBar(SnackBar(content: Text("Action bien effectuée")));
        }
      }).catchError((Object obj) {
        isTogglePressed = !isTogglePressed;
        togglemessage = isTogglePressed ? "ON" : "OFF";
        device.state = isTogglePressed;
        if (key.currentState != null) {
          ScaffoldMessenger.of(key.currentState.context).showSnackBar(
              SnackBar(content: Text("Une erreur s'est produite")));
        }
      });
    } else {
      int mode = isTogglePressed ? 1 : 0;
      String message = "Manuel/$mode;${device.getCommandeIntensite()}";
      channel.sink.add(message);
    }
    setState(() {
      Provider.of<BoitierDao>(context, listen: false).updateDevice(device);
    });
  }

  void togglePressed() async {
    isTogglePressed = !isTogglePressed;
    manualAction(isTogglePressed);
  }

  void connectAndListenWebSocket() {
    inheritedData = IOWebSocketChannelWidget.of(context).data;
    endpoint = "${RestApi.WEBSOCKET_URL_PART}app_${device.uniqueid}";
    print("endpoint $endpoint");

    channel = IOWebSocketChannel.connect(Uri.parse(endpoint));

    channel.stream.listen((event) {
      /*bool deviceState = false;
      if (event.toString() == "on") {
        deviceState = true;
      } else if (event.toString() == "off") {
        deviceState = false;
      }

      if (device.state != deviceState) {
        device.state = deviceState;
        Provider.of<BoitierDao>(context).updateDevice(device);
        Future.delayed(Duration(milliseconds: 1500)).then((value) {
          setState(() {});
        });
      }*/
      //inheritedData.sink.add(event.toString());
      print("JEANPAUL message recu de detail ${event.toString()}");
      if (key != null && key.currentState != null && key.currentState.context != null) {
        ScaffoldMessenger.of(key.currentState.context)
            .showSnackBar(SnackBar(content: Text(event.toString())));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      device = ModalRoute.of(context).settings.arguments;
      seekbar = device.intensite.toDouble();
      labelSeekbar = "${device.intensite}%";
      isTogglePressed = device.state;
      togglemessage = isTogglePressed ? "ON" : "OFF";
      value = device.state ? 0 : 1;
    }

    if(firstTime == 0){
      connectAndListenWebSocket();
      firstTime = 1;
    }

    return Scaffold(
      key: key,
      appBar: AppBar(
        title: Text(device.label),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () async {
              scanBarCodeAction();
            },
            icon: Icon(Icons.info),
            tooltip: "Scanner code qr boitier",
          ),
          IconButton(
            onPressed: () {
              deleteAction();
            },
            icon: Icon(Icons.delete),
            tooltip: "Suppression",
          ),
          /*IconButton(
                onPressed: () {
                  //EditDiffuserDialog.dialog(context, device);
                },
                icon: Icon(Icons.edit),
                tooltip: "Modifier etiquette",
              ),*/
          IconButton(
            onPressed: () {
              remoteAction();
            },
            icon: Icon(Icons.settings_remote),
            tooltip: "Configurer wifi boitier",
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width / 3,
                      height: MediaQuery.of(context).size.width / 3,
                      child: RawMaterialButton(
                        shape: CircleBorder(),
                        elevation: 0.0,
                        onPressed: togglePressed,
                        child: Stack(
                          clipBehavior: Clip.hardEdge,
                          children: <Widget>[
                            Container(
                              height: 250,
                              width: 250,
                              child: CircularProgressIndicator(
                                strokeWidth: 6,
                                backgroundColor: Color(0xFFE77834),
                                value: value,
                                valueColor: value == 0
                                    ? AlwaysStoppedAnimation<Color>(
                                        Color(0xFFE77834))
                                    : AlwaysStoppedAnimation<Color>(
                                        Color(0xFFB0CEE8)),
                              ),
                            ),
                            Container(
                              height: 250,
                              width: 250,
                              alignment: Alignment.center,
                              child: Text(
                                togglemessage,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 20.0,
                                    color: Color(0xFFB0CEE8),
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: Text("Intensite"),
                    ),
                    Expanded(
                      flex: 4,
                      child: Slider(
                        value: seekbar,
                        divisions: 5,
                        min: 0,
                        max: 100,
                        onChanged: _checkSliderPressed,
                        onChangeEnd: (value) {
                          _checkSliderStopped(context, value);
                        },
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(labelSeekbar),
                    ),
                  ],
                ),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    /*side: BorderSide(color: Colors.red)*/
                  ),
                  elevation: 2.3,
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, "/horaire",
                          arguments: device);
                    },
                    child: ListTile(
                      title: Text("Plage Horaire"),
                      trailing: Icon(Icons.chevron_right_outlined),
                      subtitle: Text("Parametrage des plages horaires"),
                    ),
                  ),
                ),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    /*side: BorderSide(color: Colors.red)*/
                  ),
                  elevation: 2.3,
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, "/minuteur",
                          arguments: device);
                    },
                    child: ListTile(
                      title: Text("Minuteur"),
                      trailing: Icon(Icons.chevron_right_outlined),
                      subtitle: Text("Parametrage des minuteurs"),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

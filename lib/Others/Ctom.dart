import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scentbox_proto/database/dao/BoitierDao.dart';
import 'package:scentbox_proto/database/dao/CalendrierDao.dart';
import 'package:scentbox_proto/database/dao/PlageHoraireDao.dart';

//import 'package:klip_ios_connect/custom/Format.dart';
import 'package:scentbox_proto/models/Boitier.dart';
import 'package:scentbox_proto/models/Calendrier.dart';
import 'package:scentbox_proto/models/PlageHoraire.dart';

class Ctom {
  static Future<Boitier> resetDialogBox(BuildContext context) {
    return showDialog<Boitier>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return CustomAlertDialog(
          title: "Ajouter Boitier",
        );
      },
    );
  }
}

class CustomAlertDialog extends StatefulWidget {
  final String title;

  const CustomAlertDialog({Key key, this.title}) : super(key: key);

  @override
  CustomAlertDialogState createState() => CustomAlertDialogState();
}

class CustomAlertDialogState extends State<CustomAlertDialog> {
  final _resetKey = GlobalKey<FormState>();
  Boitier _device;

  final _resetSSIDController = TextEditingController(text: "MikroAir");
  String _resetSSID;

  final _resetLabelController = TextEditingController();
  String _resetLabel;

  final _resetPasswordController = TextEditingController();
  String _resetPassword;

  final _resetFragranceController = TextEditingController();
  String _resetFragrance = " -- ";

  bool _resetValidate = false;

  StreamController<bool> rebuild = StreamController<bool>();

  ///perform action when push dialog ok button
  bool _send() {
    _resetLabel = _resetLabelController.text;
    _resetSSID = _resetSSIDController.text;
    _resetPassword = _resetPasswordController.text;
    _resetFragranceController.text.isEmpty
        ? _resetFragrance = "--"
        : _resetFragrance = _resetFragranceController.text;

    if (_resetKey.currentState.validate()) {
      _resetKey.currentState.save();
      try {
        BoitierDao dao = Provider.of<BoitierDao>(context);
        CalendrierDao calendrierDao = Provider.of<CalendrierDao>(context);
        PlageHoraireDao horaireDao = Provider.of<PlageHoraireDao>(context);

        //add diffuser
        Boitier device = Boitier(
            label: _resetLabel,
            password: _resetPassword,
            parfum: _resetFragrance,
            intensite: 20,
            uniqueid: "default",
            state: false);

        dao.insertDevice(device).then((idDiffuser) {
          device.id = idDiffuser;
          for(int i=0;i<6;i++){
            PlageHoraire horaire = PlageHoraire(
              idBoitier: device.id,
              on: false,
              heureDebut: "00:00",
              heureFin: "00:00",
              millisSecondDebut: 0,
              millisecondFin: 0,
            );
            horaireDao.insertHoraire(horaire);
          }

          Calendrier calendrier = Calendrier(
              idDiffuser: idDiffuser,
              monday: true,
              tuesday: true,
              wednesday: true,
              thursday: true,
              friday: true,
              saturday: false,
              sunday: false);
          calendrierDao.insertCalendrier(calendrier);
        });
        _device = device;
        return true;
      } catch (exception) {
        return false;
      }
    } else {
      setState(() {
        _resetValidate = true;
      });
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: AlertDialog(
        title: Text(widget.title),
        content: SingleChildScrollView(
          child: Form(
            key: _resetKey,
            autovalidate: _resetValidate,
            child: ListBody(
              children: <Widget>[
                Text("Ajout de diffuser"),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 9),
                ),
                Visibility(
                  visible: false,
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: Icon(
                          Icons.wifi,
                          size: 20.0,
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          validator: validateSSID,
                          onSaved: (String val) {
                            _resetSSID = val;
                          },
                          controller: _resetSSIDController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "nom du wifi",
                              contentPadding:
                              EdgeInsets.only(left: 25.0, top: 15.0),
                              hintStyle: TextStyle(fontSize: 14.0)),
                        ),
                      )
                    ],
                  ),
                ),
                Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Icon(
                        Icons.label,
                        size: 20.0,
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        validator: validateEmail,
                        onSaved: (String val) {
                          _resetLabel = val;
                        },
                        controller: _resetLabelController,
                        keyboardType: TextInputType.emailAddress,
                        autofocus: true,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Etiquette",
                            contentPadding:
                            EdgeInsets.only(left: 25.0, top: 15.0),
                            hintStyle: TextStyle(fontSize: 14.0)),
                      ),
                    )
                  ],
                ),
                Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Icon(
                        Icons.flag,
                        size: 20.0,
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        validator: null,
                        onSaved: (String val) {
                          if (val == "") {
                            _resetFragrance = "--";
                          } else {
                            _resetFragrance = val;
                          }
                        },
                        controller: _resetFragranceController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Nom parfum / essence",
                            contentPadding:
                            EdgeInsets.only(left: 25.0, top: 15.0),
                            hintStyle: TextStyle(fontSize: 14.0)),
                      ),
                    )
                  ],
                ),
                Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Icon(
                        Icons.lock,
                        size: 20.0,
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        obscureText: true,
                        validator: validatePassword,
                        onSaved: (String val) {
                          _resetPassword = val;
                        },
                        controller: _resetPasswordController,
                        keyboardType: TextInputType.visiblePassword,
                        autofocus: true,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Mot de passe",
                            contentPadding:
                            EdgeInsets.only(left: 25.0, top: 15.0),
                            hintStyle: TextStyle(fontSize: 14.0)),
                      ),
                    )
                  ],
                ),
                Column(children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                        border: Border(
                            bottom:
                            BorderSide(width: 0.5, color: Colors.black))),
                  )
                ]),
              ],
            ),
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text("Annuler"),
            onPressed: () {
              Navigator.of(context).pop(_resetLabel);
            },
          ),
          FlatButton(
            child: Text("Valider"),
            onPressed: () {
              if (_send()) {
                Navigator.of(context).pop(_device);
              }
            },
          ),
        ],
      ),
    );
  }
}

String validatePassword(String value) {
  if (value
      .trim()
      .isEmpty) {
    return 'Mot de passe requis';
  } else if (value.length < 8) {
    return "Mot de passe inférieur à 8";
  } else {
    return null;
  }
}

String validateSSID(String value) {
  if (value.trim().isEmpty) {
    return 'Nom du wifi requis';
  } else {
    return null;
  }
}

String validateEmail(String value) {
  /*String pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regExp = RegExp(pattern);*/

  if (value
      .trim()
      .isEmpty) {
    return 'Email vide';
  }
  /*else if (!regExp.hasMatch(value.toLowerCase())){
    return "Email non conforme";
  }*/
  else {
    return null;
  }
}

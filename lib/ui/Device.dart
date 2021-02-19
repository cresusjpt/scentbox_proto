import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:get_ip/get_ip.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:scentbox_proto/Others/Ctom.dart';
import 'package:scentbox_proto/database/dao/BoitierDao.dart';
import 'package:scentbox_proto/models/Boitier.dart';
import 'dart:io' show Platform;

import 'package:retrofit/dio.dart';
import 'package:scentbox_proto/network/RestApi.dart';
//import 'package:html/parser.dart';

class Device extends StatefulWidget {
  @override
  _DeviceState createState() => _DeviceState();
}

class _DeviceState extends State<Device> {

  bool _saving = false;
  final key = GlobalKey<ScaffoldState>();

  Future<String> getIp() async {
    return await GetIp.ipAddress;
  }

  Future<bool> fetchSerialInfo(Boitier device) async {
    bool serialInfoFind = false;
    /*
    try {
      HttpResponse<dynamic> it = await RestApi.createClient().serialInfo();
      if (it.response.statusCode == 200) {
        String data = it.response.data;
        var document = parse(data);
        var body = document.body;
        var elements = body.getElementsByTagName("div");
        var ulElements = elements.elementAt(0).getElementsByTagName("ul");
        var liElements = ulElements.elementAt(0).getElementsByTagName("li");
        String serialInfo = liElements.elementAt(0).text;
        //serialInfo format example: uniqueid=003400545934571120363133&version=0.18&flacid=175&flaconTps=14166&cm=2&wv=0.21serie
        List<String> info = serialInfo.split("&");
        device.uniqueid = info.elementAt(0).split("=").elementAt(1);
        device.flacid = int.parse(info.elementAt(2).split("=").elementAt(1));
        device.flaconTmps =
            int.parse(info.elementAt(3).split("=").elementAt(1));
        serialInfoFind = true;
      } else {
        serialInfoFind = false;
      }
    } catch (exception) {
      serialInfoFind = false;
    }
*/
    return serialInfoFind;
  }

  Future<String> scanQRCode(Boitier diffuser) async {
    var result = await BarcodeScanner.scan();
    if (result.type == ResultType.Barcode) {
      String uniqueid = result.rawContent;
      if (uniqueid != null) {
        diffuser.uniqueid = uniqueid;
        BoitierDao dao =
        Provider.of<BoitierDao>(key.currentState.context);
        if (dao != null) {
          dao.updateDevice(diffuser);
        }
      } else {
        //Erreur lors du scan du qrcode
        key.currentState.showSnackBar(
          SnackBar(
              content: Text("Erreur lors du scan du qrcode"),
          )
        );
      }
    } else {
      key.currentState.showSnackBar(
          SnackBar(
            content: Text("Erreur lors du scan du qrcode"),
          )
      );
    }

    return result.rawContent;
  }

  void addDevice() {
    Ctom.resetDialogBox(context).then((diffuser) async {
      if (diffuser != null) {
        String ip = await getIp();
        if (ip.startsWith(RestApi.BASE_URL_PART)) {
          /*ProgressDialog pr = ProgressDialogCustom.buildProgress(context);
          await pr.show();*/
          bool fetchSerial = await fetchSerialInfo(diffuser);
          //if get serial info update on card is made get it, else show barcode scanner to scan the device for unique id
          if (fetchSerial) {
            BoitierDao dao =
            Provider.of<BoitierDao>(key.currentState.context);
            if (dao != null) {
              dao.updateDevice(diffuser);
            }
          } else {
            await scanQRCode(diffuser);
          }
          //await pr.hide();
        } else {
          await scanQRCode(diffuser);
        }
        Navigator.pop(context);
      } else {
        key.currentState.showSnackBar(
            SnackBar(
              content: Text("Une erreur s'est produite."),
            )
        );
      }
    });
  }


  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => addDevice());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ajouter Diffuseur"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              addDevice();
            },
          )
        ],
      ),
      key: key,
      body: ModalProgressHUD(
        inAsyncCall: _saving,
        dismissible: false,
        progressIndicator: CircularProgressIndicator(),
        child: Container(

        ),
      ),

    );
  }
}

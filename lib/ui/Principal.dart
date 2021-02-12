import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scentbox_proto/database/dao/BoitierDao.dart';
import 'package:scentbox_proto/models/Boitier.dart';

class Principal extends StatefulWidget {
  @override
  _PrincipalState createState() => _PrincipalState();
}

class _PrincipalState extends State<Principal> {
  Boitier device;
  final key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final boitierDao = Provider.of<BoitierDao>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Scentbox"),
        elevation: 0,
      ),
      key: key,
      body: Container(
        child: StreamBuilder<List<Boitier>>(
          stream: boitierDao.watchDiffusers(),
          builder: (context, AsyncSnapshot<List<Boitier>> snapshot) {
            final List<Boitier> devices = snapshot.data ?? List();
            return ListView.builder(
                itemExtent: 70,
                itemCount: devices.length,
                itemBuilder: (context, index) {
                  Boitier device = devices.elementAt(index);
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 1.0, horizontal: 4.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3.0),
                        /*side: BorderSide(color: Colors.red)*/
                      ),
                      elevation: 2.3,
                      child: ListTile(
                        onTap: () async {
                          Navigator.pushNamed(context, "/detail",
                              arguments: device);
                        },
                        title: Text(device.label),
                        subtitle: Text(device.uniqueid),
                      ),
                    ),
                  );
                });
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, "/device");
        },
      ),
    );
  }
}

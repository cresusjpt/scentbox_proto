import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:scentbox_proto/database/AppDatabase.dart';
import 'package:scentbox_proto/inheritedwidgets/IOWebSocketChannelWidget.dart';
import 'package:scentbox_proto/inheritedwidgets/IOWebSocketChannelWidgetData.dart';
import 'package:scentbox_proto/network/RestApi.dart';
import 'package:scentbox_proto/ui/Detail.dart';
import 'package:scentbox_proto/ui/Device.dart';
import 'package:scentbox_proto/ui/Horaire.dart';
import 'package:scentbox_proto/ui/Minuteur.dart';
import 'package:scentbox_proto/ui/Principal.dart';
import 'package:web_socket_channel/io.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const String _appTitle = "ScentBox Proto";

  final db = await $FloorAppDatabase.databaseBuilder('app_database.db').build();

  runApp(MultiProvider(
    providers: [
      Provider(create: (_) => db.boitierDao),
      Provider(create: (_) => db.minuterieDao),
      Provider(create: (_) => db.plageHoraireDao),
      Provider(create: (_) => db.calendrierDao),
    ],
    child: App(_appTitle),
  ));
}

class App extends StatefulWidget {
  final String title;

  App(this.title);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  Route<dynamic> onGeneratedRoute(RouteSettings settings) {
    switch (settings.name) {
      case "/":
        return PageTransition(
            settings: settings,
            child: Principal(),
            type: PageTransitionType.fade);
        break;
      case "/detail":
        return PageTransition(
            settings: settings, child: Detail(), type: PageTransitionType.fade);
        break;
      case "/horaire":
        return PageTransition(
            settings: settings,
            child: Horaire(),
            type: PageTransitionType.fade);
        break;
      case "/minuteur":
        return PageTransition(
            settings: settings,
            child: Minuteur(),
            type: PageTransitionType.fade);
        break;
      case "/device":
        return PageTransition(
            settings: settings, child: Device(), type: PageTransitionType.fade);
        break;

      default:
        return null;
    }
  }

  IOWebSocketChannelWidgetData channelWidgetData;
  IOWebSocketChannel channel = IOWebSocketChannel.connect(RestApi.WEBSOCKET_URL_PART);

  @override
  Widget build(BuildContext context) {
    channelWidgetData = IOWebSocketChannelWidgetData(webSocketChannel: channel);
    return IOWebSocketChannelWidget(
      data: channelWidgetData,
      child: MaterialApp(
        title: widget.title,
        debugShowCheckedModeBanner: false,
        initialRoute: "/",
        routes: {},
        onGenerateRoute: onGeneratedRoute,
      ),
    );
  }
}

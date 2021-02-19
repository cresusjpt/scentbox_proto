import 'package:flutter/cupertino.dart';
import 'package:scentbox_proto/inheritedwidgets/IOWebSocketChannelWidgetData.dart';

class IOWebSocketChannelWidget extends InheritedWidget {
  final IOWebSocketChannelWidgetData data;

  IOWebSocketChannelWidget({Key key, this.data, @required Widget child})
      : assert(child != null),
        super(key: key, child: child);

  static IOWebSocketChannelWidget of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<IOWebSocketChannelWidget>();
  }

  @override
  bool updateShouldNotify(covariant IOWebSocketChannelWidget oldWidget) => true;
}

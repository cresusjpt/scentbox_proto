import 'dart:async';

import 'package:web_socket_channel/io.dart';

class IOWebSocketChannelWidgetData {
  IOWebSocketChannel webSocketChannel;

  // ignore: close_sinks
  final StreamController<String> _streamController = StreamController.broadcast();

  Stream<String>  get stream => _streamController.stream;

  Sink<String> get sink => _streamController.sink;

  IOWebSocketChannelWidgetData({this.webSocketChannel});


}

import 'dart:async';

class BlurbStream {
  final blurbController = StreamController<List<dynamic>>.broadcast();
  StreamSink<List<dynamic>> get indexSink => blurbController.sink;
  Stream<List<dynamic>> get indexStream => blurbController.stream.asBroadcastStream();

  static final BlurbStream blurbStream = BlurbStream._();
  factory BlurbStream() => blurbStream;
  BlurbStream._();

  void disposeStreams() {
    blurbController.close();
  }
}

import 'package:stomp_dart_client/stomp.dart';

extension StompClientExtension on StompClient {
  void unsubscribe({
    required String destination,
  }) {
    subscribe(
      destination: destination,
      callback: (p0) {},
    );
  }
}

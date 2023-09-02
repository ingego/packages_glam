import 'dart:async';

import 'package:alfred/alfred.dart';

mixin ProfileEndpoint {
  FutureOr<dynamic> profile(HttpRequest req, HttpResponse res) {
    throw UnimplementedError();
  }
}

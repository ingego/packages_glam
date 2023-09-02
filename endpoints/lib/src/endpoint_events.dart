import 'dart:async';

import 'package:alfred/alfred.dart';
import 'package:endpoints/endpoints.dart';
import 'package:endpoints/src/errors.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';
import 'package:models/models.dart';
import 'package:mongo_dart/mongo_dart.dart';

mixin EventEndpoint {
  FutureOr<dynamic> getEvents(
      HttpRequest req, HttpResponse res, String jwtToken) async {
    var token = verifyJwtHS256Signature(req.headers.value(AUTH)!, jwtToken);
    var uuid = token.payload["uuid"];
    var service = MongoService.getInstance();
    service.pool.databaseName = "events";
    var col = service.pool.collection(uuid);
    var res = await col.find().toList();
    return {"events": res};
  }

  //required params
  FutureOr<dynamic> getEvent(
      HttpRequest req, HttpResponse res, String jwtToken) async {
    var eventUuid = req.params['uuid']!;
    var token = verifyJwtHS256Signature(req.headers.value(AUTH)!, jwtToken);
    var uuid = token.payload["uuid"];
    var service = MongoService.getInstance();
    service.pool.databaseName = "events";
    print(eventUuid);
    print(uuid);
    var col = service.pool.collection(uuid);
    var tests = await col.find().toList();
    print(tests);
    var res = await col.find(where.eq("events_uuid", eventUuid)).toList();
    return {"events": res};
  }

  FutureOr<dynamic> removeEvent(
      HttpRequest req, HttpResponse res, String jwtToken) async {
    var eventUuid = req.params['uuid']!;
    var token = verifyJwtHS256Signature(req.headers.value(AUTH)!, jwtToken);
    var uuid = token.payload["uuid"];
    var service = MongoService.getInstance();
    service.pool.databaseName = "events";
    print(eventUuid);
    print(uuid);
    var col = service.pool.collection(uuid);
    var res = await col.remove(where.eq("events_uuid", eventUuid));
    var tests = await col.find().toList();
    print(tests);

    return {"events": tests};
  }

  FutureOr<dynamic> addEvent(
      HttpRequest req, HttpResponse res, String jwtToken) async {
    var token = verifyJwtHS256Signature(req.headers.value(AUTH)!, jwtToken);
    var uuid = token.payload["uuid"];
    var service = MongoService.getInstance();
    var body = await req.bodyAsJsonMap.catchError((e) {
      throw AlfredException(403, jsonIsDumped);
    });
    service.pool.databaseName = "events";
    print(uuid);
    var col = service.pool.collection(uuid);
    // print(tests);
    if ([
      body["area"],
      body["procedura"],
      body["drugs"],
      // body["ammounts"],
      // body["events_uuid"]
    ].contains(null)) {
      throw AlfredException(403, jsonIsDumped);
    }
    var res = await col.insertOne({
      "date": body["date"] ?? DateTime.now().toIso8601String(),
      "area": body["area"],
      "procedura": body["procedura"],
      "drugs": body["drugs"],
      "ammounts": body["ammounts"] ?? "1",
      "events_uuid": Uuid().v4()
    });
    var tests = await col.find().toList();

    return {"events": tests};
  }
}

import 'dart:async';

import 'package:alfred/alfred.dart';
import 'package:endpoints/endpoints.dart';
import 'package:endpoints/src/errors.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';
import 'package:models/models.dart';
import 'package:mongo_dart/mongo_dart.dart';

mixin NotesEndpoint {
  FutureOr<dynamic> getnotes(
      HttpRequest req, HttpResponse res, String jwtToken) async {
    var token = verifyJwtHS256Signature(req.headers.value(AUTH)!, jwtToken);
    var uuid = token.payload["uuid"];
    var service = MongoService.getInstance();
    service.pool.databaseName = "notes";
    var col = service.pool.collection(uuid);
    var res = await col.find().toList();
    return {"notes": res};
  }

  //required params
  FutureOr<dynamic> getNote(
      HttpRequest req, HttpResponse res, String jwtToken) async {
    var eventUuid = req.params['uuid']!;
    var token = verifyJwtHS256Signature(req.headers.value(AUTH)!, jwtToken);
    var uuid = token.payload["uuid"];
    var service = MongoService.getInstance();
    service.pool.databaseName = "notes";
    print(eventUuid);
    print(uuid);
    var col = service.pool.collection(uuid);
    var tests = await col.find().toList();
    print(tests);
    var res = await col.find(where.eq("notes_uuid", eventUuid)).toList();
    return {"notes": res};
  }

  FutureOr<dynamic> removeNote(
      HttpRequest req, HttpResponse res, String jwtToken) async {
    var eventUuid = req.params['uuid']!;
    var token = verifyJwtHS256Signature(req.headers.value(AUTH)!, jwtToken);
    var uuid = token.payload["uuid"];
    var service = MongoService.getInstance();
    service.pool.databaseName = "notes";
    print(eventUuid);
    print(uuid);
    var col = service.pool.collection(uuid);
    var res = await col.remove(where.eq("notes_uuid", eventUuid));
    var tests = await col.find().toList();
    print(tests);

    return {"notes": tests};
  }

  FutureOr<dynamic> addNote(
      HttpRequest req, HttpResponse res, String jwtToken) async {
    var token = verifyJwtHS256Signature(req.headers.value(AUTH)!, jwtToken);
    var uuid = token.payload["uuid"];
    var service = MongoService.getInstance();
    var body = await req.bodyAsJsonMap.catchError((e) {
      throw AlfredException(403, jsonIsDumped);
    });
    service.pool.databaseName = "notes";
    print(uuid);
    var col = service.pool.collection(uuid);
    // print(tests);
    if ([
      body["text"],
      body["symptoms"],
      // body["ammounts"],
      // body["notes_uuid"]
    ].contains(null)) {
      throw AlfredException(403, jsonIsDumped);
    }
    var res = await col.insertOne({
      "date": body["date"] ?? DateTime.now().toIso8601String(),
      "text": body["text"],
      "symptoms": body["symptoms"],
      "notes_uuid": Uuid().v4()
    });
    var tests = await col.find().toList();

    return {"notes": tests};
  }
}

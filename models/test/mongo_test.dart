import 'package:models/models.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:test/scaffolding.dart';

void main() {
  group("test mongo", () {
    late final MongoService mongo;

    setUp(() async => mongo = await MongoService.init());
    test("get all databases", () async {
      mongo.pool.databaseName = "locale";
      var lists = await mongo.pool.getCollectionNames();
      print(lists);
    });
    test("test", () async {
      mongo.pool.databaseName = "events";

      var res = await mongo.pool
          .collection("eb93d4bb-671f-40a5-b0ae-60573ddefc75")
          .find()
          .toList();
      print(res);
      // var lists = await mongo.pool.getCollectionNames();
      // print(lists);
    });
    test("test1", () async {
      mongo.pool.databaseName = "events";

      var res = await mongo.pool
          .collection("eb93d4bb-671f-40a5-b0ae-60573ddefc75")
          .find(where.eq("events_uuid", "313d7a8d-3d3b-4c3c-a08c-cc4c6d8ed3fa"))
          .toList();
      print(res);
      // var lists = await mongo.pool.getCollectionNames();
      // print(lists);
    });
    test("test2", () async {
      mongo.pool.databaseName = "events";
      await mongo.pool.createCollection(Uuid().v4());

      // var lists = wait mongo.pool.getCollectionNames();
      // print(lists);
    });
  });
}

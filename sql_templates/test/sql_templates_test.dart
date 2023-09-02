import 'package:mysql_client/mysql_client.dart';
import 'package:sql_templates/sql_templates.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    late MySQLConnectionPool pool;
    setUp(() async {
      pool = MySQLConnectionPool(
          host: "localhost",
          port: 3307,
          userName: "root",
          password: "89048202409",
          maxConnections: 5);
    });
    test("add", () async {
      // print("sdfsdf".sqlLike);
      var str = SqlTemplates().addUserInService(
          schema: "glam",
          db: "user",
          userName: "userName",
          userLogin: "userLogin",
          userPassword: "userPassword",
          userUuid: "userUuid1",
          email: 'ыва');
      print(str);
      await pool.execute(str);
    });
    test("getall", () async {
      // print("sdfsdf".sqlLike);
      var str = SqlTemplates().getUsersInService(
        schema: "glam",
        db: "user",
      );
      print(str);
      await pool.execute(str);
    });
    test("get", () async {
      // print("sdfsdf".sqlLike);
      var str = SqlTemplates()
          .getUserInService(schema: "glam", db: "user", uuid: "userUuid1");
      print(str);
      var res = await pool.execute(str);
      var first = res.rows.map((e) => e.assoc()).first;
      print(first);
    });
    test("update", () async {
      // print("sdfsdf".sqlLike);
      var str = SqlTemplates().updateUserInService(
          schema: "glam", db: "user", uuid: "userUuid1", name: "sdef");
      print(str);
      await pool.execute(str);
    });
    test("remove", () async {
      // print("sdfsdf".sqlLike);
      var str = SqlTemplates()
          .deleteUserInService(schema: "glam", db: "user", uuid: "userUuid");
      print(str);
      await pool.execute(str);
    });
  });
}

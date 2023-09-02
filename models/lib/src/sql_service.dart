import 'package:mysql_client/mysql_client.dart';
import 'package:mongo_dart/mongo_dart.dart';

class SqlService {
  static late final MySQLConnectionPool _pool;
  late final MySQLConnectionPool pool;
  SqlService._(this.pool);
  static SqlService init(
      String host, int port, String userName, String password) {
    _pool = MySQLConnectionPool(
        host: host,
        port: port,
        userName: userName,
        password: password,
        maxConnections: 10);
    return SqlService._(_pool);
  }

  static SqlService getInstance() => SqlService._(_pool);
}

class MongoService {
  static late final Db _pool;
  late final Db pool;
  MongoService._(this.pool);
  static Future<MongoService> init() async {
    _pool = await Db.create("mongodb://localhost:27017/");
    await _pool.open();
    return MongoService._(_pool);
  }

  static MongoService getInstance() => MongoService._(_pool);
}

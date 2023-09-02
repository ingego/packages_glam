import 'dart:async';

import 'package:alfred/alfred.dart';
import 'package:endpoints/src/errors.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';
import 'package:models/models.dart';
import 'package:sql_templates/sql_templates.dart';
import 'package:uuid/uuid.dart';

const AUTH = "Authorization";
mixin Endpoint {}
//FutureOr<dynamic> Function(HttpRequest, HttpResponse)

List<dynamic> iResultSetToMap(dynamic sets) {
  return (sets.rows.map((e) => e.assoc())).toList();
}

mixin GetTokenEndpoint {
  FutureOr<dynamic> getToken(
      HttpRequest req, HttpResponse res, String jwtPhrase) {
    if (req.headers.value(AUTH) != null) {
      var token = req.headers.value(AUTH);
      return {"current_token": token};
    }

    print(res);
    var claim = JwtClaim(payload: {
      "role": 0,
      "uuid": Uuid().v4(),
    });
    var token = issueJwtHS256(claim, jwtPhrase);

    return {
      "token": token,
    };
  }
}

mixin VerificationEndpoint {
  FutureOr<dynamic> verification(
      HttpRequest req, HttpResponse res, String jwtPhrase) {
    try {
      if (req.headers.value(AUTH) == null) {
        throw AlfredException(403, tokenNullError);
      }

      var token = req.headers.value(AUTH)!;
      var claim = verifyJwtHS256Signature(token, jwtPhrase);
      if (claim.payload["role"] < 0) {
        throw AlfredException(403, accountBannedError);
      }
    } on Error {
      throw AlfredException(403, tokenDecodeError);
    }
  }

  FutureOr<dynamic> test(
    HttpRequest req,
    HttpResponse res,
    String jwtPhrase,
  ) {
    return {"message": "text"};
  }
}
mixin AuthEndpoint {
  FutureOr<dynamic> authMe(
    HttpRequest req,
    HttpResponse res,
    String jwtPhrase,
  ) async {
    var token = req.headers.value(AUTH)!;
    var claimed = verifyJwtHS256Signature(token, jwtPhrase);
    var uuid = claimed.payload["uuid"];
    var sql = SqlService.getInstance();
    var temp = SqlTemplates();
    var res = await sql.pool
        .execute(temp.getUserInService(schema: "glam", db: "user", uuid: uuid));
    return {"users": iResultSetToMap(res)};
  }

  FutureOr<dynamic> login(
    HttpRequest req,
    HttpResponse res,
    String jwtPhrase,
  ) async {
    var token = req.headers.value(AUTH)!;
    var claimed = verifyJwtHS256Signature(token, jwtPhrase);
    var uuid = claimed.payload["uuid"];
    var body = await req.bodyAsJsonMap;
    var logAndPass = [body["login"], body["password"]];
    if (logAndPass.contains(null)) {
      throw AlfredException(403, nobodyElementError);
    }

    var sql = SqlService.getInstance();
    var temp = SqlTemplates();
    var res = await sql.pool.execute(temp.getUserInServiceByLogin(
        schema: "glam", db: "user", login: logAndPass.first));
    var user = iResultSetToMap(res);
    var confirmed = user.first["password"] == logAndPass.last;
    if (confirmed) {
      claimed.payload["role"] = 1;
      claimed.payload["uuid"] = user.first["uuid"];
      return {"users": user, "token": issueJwtHS256(claimed, jwtPhrase)};
    } else {
      throw AlfredException(403, loginError);
    }
  }

  FutureOr<dynamic> register(
    HttpRequest req,
    HttpResponse res,
    String jwtPhrase,
  ) async {
    var token = req.headers.value(AUTH)!;
    var claimed = verifyJwtHS256Signature(token, jwtPhrase);
    var body = await req.bodyAsJsonMap;
    _UserRegister data = (
      login: body["login"],
      email: body["email"],
      password: body["password"],
      name: body["name"]
    );
    if ([data.email, data.login, data.password, data.name].contains(null)) {
      throw AlfredException(403, nobodyElementError);
    }
    var uuid = claimed.payload["uuid"];
    var sql = SqlService.getInstance();
    var temp = SqlTemplates();
    var res = await sql.pool.execute(temp.addUserInService(
        schema: "glam",
        db: "user",
        userLogin: data.login.toString(),
        userName: data.name.toString(),
        userPassword: data.password.toString(),
        userUuid: uuid.toString(),
        email: data.email.toString()));
    claimed.payload["role"] = 1;
    return {
      // "users": iResultSetToMap(res),
      "new_token": issueJwtHS256(claimed, jwtPhrase)
    };
  }
}

typedef _UserRegister = ({
  String? login,
  String? email,
  String? password,
  String? name,
});

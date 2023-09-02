// TODO: Put public facing types in this file.

// ignore_for_file: unused_element, unnecessary_string_interpolations

extension on String {
  String get sqlLike => "'$this'";
}

class SqlTemplates {
  String addUserInService({
    required String schema,
    required String db,
    required String userName,
    required String userLogin,
    required String userPassword,
    required String userUuid,
    required String email,
  }) {
    StringBuffer buffer = StringBuffer();
    buffer.write(
        "insert into $schema.$db(login, password, uuid, name, email) values (${userLogin.sqlLike}, ${userPassword.sqlLike}, ${userUuid.sqlLike}, ${userName.sqlLike}, ${email.sqlLike}) ;");
    return buffer.toString();
  }

  String getUsersInService({
    required String schema,
    required String db,
  }) {
    StringBuffer buffer = StringBuffer();
    buffer.write("select * from $schema.$db");
    return buffer.toString();
  }

  String getUserInService({
    required String schema,
    required String db,
    required String uuid,
  }) {
    StringBuffer buffer = StringBuffer();
    buffer.write("select * from $schema.$db where uuid = ${uuid.sqlLike}");
    return buffer.toString();
  }

  String getUserInServiceByLogin({
    required String schema,
    required String db,
    required String login,
  }) {
    StringBuffer buffer = StringBuffer();
    buffer.write("select * from $schema.$db where login = ${login.sqlLike}");
    return buffer.toString();
  }

  String deleteUserInService({
    required String schema,
    required String db,
    required String uuid,
  }) {
    StringBuffer buffer = StringBuffer();
    buffer.write("delete  from $schema.$db WHERE uuid=${uuid.sqlLike}");
    return buffer.toString();
  }

  String updateUserInService({
    required String schema,
    required String db,
    required String uuid,
    String? name,
    String? password,
  }) {
    StringBuffer buffer = StringBuffer();

    buffer.write("UPDATE $schema.$db SET");

    if (name != null) {
      buffer.write(" name = ${name.sqlLike}");
    }

    if (password != null) {
      buffer.write(" password = ${password.sqlLike}");
    }
    buffer.write(" WHERE uuid=${uuid.sqlLike}");
    return buffer.toString();
  }
}

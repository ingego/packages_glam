// typedef _ServerError = ({int id, String title});

typedef _ServerError = Map<String, dynamic>;
_ServerError get tokenNullError => {"code": "00", "message": "токен не указан"};
_ServerError get accountBannedError =>
    {"code": "00", "message": "токен не указан"};
_ServerError get noParamsError =>
    {"code": "01", "message": "параметры не указаны"};
_ServerError get nobodyElementError =>
    {"code": "02", "message": "не все поля указаны"};
_ServerError get loginError =>
    {"code": "02", "message": "логин или пароль неверные"};
_ServerError get tokenDecodeError =>
    {"code": "00", "message": "токен не расшифрован"};
_ServerError get jsonIsDumped => {"code": "03", "message": "json не полный"};

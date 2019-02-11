class AppResponse {
  int code;
  String msg;
  dynamic result;

  AppResponse(this.code, this.msg, this.result);

  AppResponse.fromJson(Map<String, dynamic> json)
      : code = json['code'],
        msg = json['msg'],
        result = json['result'];

  @override
  String toString() {
    return 'AppResponse{code: $code, msg: $msg, result: $result}';
  }
}

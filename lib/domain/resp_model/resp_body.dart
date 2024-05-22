class RespBody {
  int code;
  String message;
  dynamic data;

  RespBody({required this.code, required this.message, required this.data});

  factory RespBody.fromJson(Map<String, dynamic> json) {
    return RespBody(
      code: json['code'],
      message: json['message'],
      data: json['data'],
    );
  }
}
import 'dart:convert';

class Result<T> {
  bool error;
  T results;

  factory Result(jsonStr, Function buildFun) => jsonStr is String
      ? Result.fromJson(json.decode(jsonStr), buildFun)
      : Result.fromJson(jsonStr, buildFun);

  Result.fromJson(jsonRes, Function buildFun) {
    error = jsonRes['error'];
    _check(error);

    results = buildFun(jsonRes['results']);
  }
}

class ResultList<T> {
  bool error;
  List<T> data;

  factory ResultList(jsonStr, Function buildFun) => jsonStr is String
      ? ResultList.fromJson(json.decode(jsonStr), buildFun)
      : ResultList.fromJson(jsonStr, buildFun);

  ResultList.fromJson(jsonRes, Function buildFun) {
    error = jsonRes['error'];

    _check(error);

    data = (jsonRes['results'] as List).map<T>((ele) => buildFun(ele)).toList();
  }
}

/// 这里可以做code和msg的处理逻辑
void _check(bool code) {}

import 'dart:convert';

import 'package:equatable/equatable.dart';

export 'package:flutter_color/flutter_color.dart';
export 'package:munchkin/models/constants.dart';
export 'package:munchkin/models/extensions.dart';
export 'package:munchkin/models/munchkin.dart';

class StringAndInt extends Equatable {
  final String string;
  final int value;
  const StringAndInt({
    this.string = '',
    this.value = 0,
  });

  @override
  List<Object> get props => [string, value];

  @override
  bool get stringify => true;

  Map<String, dynamic> toMap() {
    return {
      'string': string,
      'value': value,
    };
  }

  factory StringAndInt.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return StringAndInt(
      string: map['string'],
      value: map['value'],
    );
  }

  String toJson() => json.encode(toMap());

  factory StringAndInt.fromJson(String source) =>
      StringAndInt.fromMap(json.decode(source));
}

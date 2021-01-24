import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'constants.dart';

class Player extends Equatable {
  final String id;
  final String name;
  final Gender gender;
  final int level;
  final int gear;
  Player(
      {this.id,
      this.name,
      this.gender = Gender.MALE,
      this.level = 1,
      this.gear = 0});

  Player copyWith({
    String id,
    String name,
    Gender gender,
    int level,
    int gear,
  }) {
    return Player(
      id: id ?? this.id,
      name: name ?? this.name,
      gender: gender ?? this.gender,
      level: level ?? this.level,
      gear: gear ?? this.gear,
    );
  }

  int get strength => level + gear;

  @override
  List<Object> get props => [id, name, gender, level, gear];

  @override
  bool get stringify => true;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'gender': gender == Gender.MALE ? 'male' : 'female',
      'level': level,
      'gear': gear,
    };
  }

  factory Player.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Player(
      id: map['id'],
      name: map['name'],
      gender: map['gender'] == 'male' ? Gender.MALE : Gender.FEMALE,
      level: map['level'],
      gear: map['gear'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Player.fromJson(String source) => Player.fromMap(json.decode(source));
}

class Monster extends Equatable {
  final String id;
  final int level;
  final int modifiers;
  final int treasures;
  Monster({this.id, this.level = 1, this.modifiers = 0, this.treasures = 0});
  int get strength => level + modifiers;

  @override
  List<Object> get props => [id, level, modifiers, treasures];

  @override
  bool get stringify => true;

  Monster copyWith({
    String id,
    int level,
    int modifiers,
    int treasures,
  }) {
    return Monster(
      id: id ?? this.id,
      level: level ?? this.level,
      modifiers: modifiers ?? this.modifiers,
      treasures: treasures ?? this.treasures,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'level': level,
      'modifiers': modifiers,
      'treasures': treasures,
    };
  }

  factory Monster.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Monster(
      id: map['id'],
      level: map['level'],
      modifiers: map['modifiers'],
      treasures: map['treasures'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Monster.fromJson(String source) =>
      Monster.fromMap(json.decode(source));
}

import 'package:equatable/equatable.dart';

import 'constants.dart';

class Player extends Equatable {
  final String id;
  final String name;
  final Gender gender;
  final int level;
  final int gear;
  int get strength => level + gear;
  Player({
    this.id,
    this.name,
    this.gear = 0,
    this.level = 1,
    this.gender = Gender.MALE,
  });

  @override
  List<Object> get props => [id, name, gender, level, gear];

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

  @override
  bool get stringify => true;
}

abstract class PlayerDecorator implements Player {
  final Player player;
  PlayerDecorator({this.player});
}

class PlayerInBattle extends PlayerDecorator {
  @override
  int gear;

  @override
  int level;

  @override
  Gender gender;

  @override
  String name;

  int modifier;

  Player ally;

  @override
  int get strength => player.strength + modifier + ally?.strength ?? 0;

  @override
  String id;

  PlayerInBattle({
    this.gear,
    this.level,
    this.gender,
    this.name,
    this.modifier,
    this.ally,
    this.id,
  });

  @override
  List<Object> get props => [player, gear, level, name, modifier, ally];

  @override
  bool get stringify => throw UnimplementedError();

  PlayerInBattle copyWith({
    int gear,
    int level,
    Gender gender,
    String name,
    int modifier,
    Player ally,
    String id,
  }) {
    return PlayerInBattle(
      gear: gear ?? this.gear,
      level: level ?? this.level,
      gender: gender ?? this.gender,
      name: name ?? this.name,
      modifier: modifier ?? this.modifier,
      ally: ally ?? this.ally,
      id: id ?? this.id,
    );
  }
}

class Monster {
  int level;
  int modifiers;
  int treasures;
  int get strength => level + modifiers;
}

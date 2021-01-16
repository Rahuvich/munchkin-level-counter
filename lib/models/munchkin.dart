import 'package:equatable/equatable.dart';

import 'constants.dart';

abstract class PlayerBase extends Equatable {
  final String id;
  final String name;
  final Gender gender;
  final int level;
  final int gear;
  PlayerBase({this.id, this.name, this.gender, this.level, this.gear});

  int get strength;

  @override
  List<Object> get props;

  @override
  bool get stringify;
}

class Player extends PlayerBase {
  Player({
    String id,
    String name,
    Gender gender = Gender.MALE,
    int level = 1,
    int gear = 0,
  }) : super(gear: gear, level: level, gender: gender, id: id, name: name);

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
  int get strength => level + gear;

  @override
  List<Object> get props => [id, name, gender, level, gear];

  @override
  bool get stringify => true;
}

/* 
abstract class PlayerDecorator extends PlayerBase {
  final Player player;
  PlayerDecorator({this.player});

  @override
  int get strength => player.strength;

  @override
  List<Object> get props => player.props;

  @override
  bool get stringify => player.stringify;
}

class PlayerInBattle extends PlayerDecorator {
  PlayerInBattle({Player player, this.modifier = 0, this.ally})
      : super(player: player);

  final int modifier;

  final Player ally;

  @override
  int get strength => player.strength + modifier + ally?.strength ?? 0;

  @override
  List<Object> get props => List.from([
        [modifier, ally]
      ]..addAll(player.props));

  @override
  bool get stringify => player.stringify;

  PlayerInBattle copyWith({
    Player player,
    int modifier,
    Player ally,
  }) {
    return PlayerInBattle(
      player: player,
      modifier: modifier ?? this.modifier,
      ally: ally ?? this.ally,
    );
  }
}
 */
class Monster extends Equatable {
  final String id;
  final int level;
  final int modifiers;
  final int treasures;
  Monster({this.id, this.level, this.modifiers, this.treasures});
  int get strength => level + modifiers;

  @override
  List<Object> get props => [id, level, modifiers, treasures];

  @override
  bool get stringify => true;

  Monster copyWith({
    String id,
    int level = 1,
    int modifiers = 0,
    int treasures = 0,
  }) {
    return Monster(
      id: id ?? this.id,
      level: level ?? this.level,
      modifiers: modifiers ?? this.modifiers,
      treasures: treasures ?? this.treasures,
    );
  }
}

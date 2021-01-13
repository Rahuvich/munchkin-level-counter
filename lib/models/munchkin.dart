import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

enum Gender { MALE, FEMALE }

class Player extends Equatable {
  String id;
  String name;
  Gender male;
  int level;
  int gear;
  int get strength => level + gear;
  Player({
    @required this.name,
    this.gear = 0,
    this.level = 0,
    this.male = Gender.MALE,
  }) {
    this.id = Uuid().v1();
  }

  /* https://www.youtube.com/watch?v=wCYNFCKeLIY */

  @override
  List<Object> get props => [id, name, male, level, gear];
}

abstract class PlayerDecorator implements Player {
  Player player;
  PlayerDecorator({this.player});
}

class PlayerInBattle extends PlayerDecorator {
  @override
  int gear;

  @override
  int level;

  @override
  Gender male;

  @override
  String name;

  int modifier;

  Player ally;

  @override
  int get strength => player.strength + modifier + ally?.strength ?? 0;

  @override
  String id;

  @override
  List<Object> get props => [player, gear, level, name, modifier, ally];

  @override
  bool get stringify => throw UnimplementedError();
}

class Monster {
  int level;
  int modifiers;
  int treasures;
  int get strength => level + modifiers;
}

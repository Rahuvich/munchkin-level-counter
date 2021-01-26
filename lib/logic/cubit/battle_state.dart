part of 'battle_cubit.dart';

class BattleState extends Equatable {
  final Player player;
  final int modifiers;
  final Player ally;

  final List<Monster> monsters;

  final bool battleFinished;

  const BattleState(
      {this.player,
      this.modifiers = 0,
      this.ally,
      this.monsters,
      this.battleFinished = false});

  @override
  List<Object> get props => [player, modifiers, ally, monsters, battleFinished];

  @override
  bool get stringify => true;

  BattleState copyWith({
    Player player,
    int modifiers,
    Player ally,
    List<Monster> monsters,
    bool battleFinished,
  }) {
    return BattleState(
        player: player ?? this.player,
        modifiers: modifiers ?? this.modifiers,
        ally: ally ?? this.ally,
        monsters: monsters ?? this.monsters,
        battleFinished: battleFinished ?? this.battleFinished);
  }

  int get playerStrength =>
      (player?.strength ?? 0) + modifiers + (ally?.strength ?? 0);
  int get monstersStrength =>
      monsters.fold(0, (sum, monster) => sum + monster.strength);

  Map<String, dynamic> toMap() {
    return {
      'player': player?.toMap(),
      'modifiers': modifiers,
      'ally': ally?.toMap(),
      'monsters': monsters?.map((x) => x?.toMap())?.toList(),
      'battleFinished': battleFinished,
    };
  }

  factory BattleState.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return BattleState(
      player: Player.fromMap(map['player']),
      modifiers: map['modifiers'],
      ally: Player.fromMap(map['ally']),
      monsters: List<Monster>.from(
          map['monsters']?.map((x) => Monster.fromMap(x)) ?? <Monster>[]),
      battleFinished: map['battleFinished'],
    );
  }

  String toJson() => json.encode(toMap());

  factory BattleState.fromJson(String source) =>
      BattleState.fromMap(json.decode(source));
}

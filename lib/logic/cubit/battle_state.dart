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
}

part of 'battle_cubit.dart';

class BattleState extends Equatable {
  final Player player;
  final int modifiers;
  final Player ally;

  final List<Monster> monsters;

  const BattleState(
      {this.player, this.modifiers = 0, this.ally, this.monsters});

  @override
  List<Object> get props => [player, modifiers, ally, monsters];

  @override
  bool get stringify => true;

  BattleState copyWith({
    Player player,
    int modifiers,
    Player ally,
    List<Monster> monsters,
  }) {
    return BattleState(
      player: player ?? this.player,
      modifiers: modifiers ?? this.modifiers,
      ally: ally ?? this.ally,
      monsters: monsters ?? this.monsters,
    );
  }

  int get playerStrength =>
      (player?.strength ?? 0) + modifiers + (ally?.strength ?? 0);
  int get monstersStrength =>
      monsters.fold(0, (sum, monster) => sum + monster.strength);
}

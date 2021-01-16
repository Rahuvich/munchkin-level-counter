part of 'battle_cubit.dart';

class BattleState extends Equatable {
  final Player player;
  final int modifiers;
  final Player ally;

  int get playerStrength => player.strength + modifiers + (ally?.strength ?? 0);

  final List<Monster> monsters;
  int get monstersStrength =>
      monsters.fold(0, (sum, monster) => sum + monster.strength);

  const BattleState(
      {this.player, this.modifiers = 0, this.ally, this.monsters});

  @override
  List<Object> get props => [player, monsters];

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
}

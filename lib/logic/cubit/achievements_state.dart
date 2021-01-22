part of 'achievements_cubit.dart';

class AchievementsState extends Equatable {
  final Map<String, int> mostTreasures;
  final Map<String, int> mostMonstersKilled;
  final Map<String, int> mostStrength;
  final Map<String, int> mostLonelyBoy;
  final Map<String, int> mostLostBattles;

  const AchievementsState(
      {this.mostTreasures = const {},
      this.mostLonelyBoy = const {},
      this.mostLostBattles = const {},
      this.mostMonstersKilled = const {},
      this.mostStrength = const {}});

  @override
  List<Object> get props => [
        mostTreasures,
        mostLonelyBoy,
        mostLostBattles,
        mostMonstersKilled,
        mostStrength
      ];

  AchievementsState copyWith({
    Map<String, int> mostTreasures,
    Map<String, int> mostMonstersKilled,
    Map<String, int> mostStrength,
    Map<String, int> mostLonelyBoy,
    Map<String, int> mostLostBattles,
  }) {
    return AchievementsState(
      mostTreasures: mostTreasures ?? this.mostTreasures,
      mostMonstersKilled: mostMonstersKilled ?? this.mostMonstersKilled,
      mostStrength: mostStrength ?? this.mostStrength,
      mostLonelyBoy: mostLonelyBoy ?? this.mostLonelyBoy,
      mostLostBattles: mostLostBattles ?? this.mostLostBattles,
    );
  }

  @override
  bool get stringify => true;
}

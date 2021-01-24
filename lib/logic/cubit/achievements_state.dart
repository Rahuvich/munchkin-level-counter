part of 'achievements_cubit.dart';

class AchievementsState extends Equatable {
  final Map<String, int> mostTreasures;
  final Map<String, int> mostMonstersKilled;
  final Map<String, int> mostLonelyBoy;
  final Map<String, int> mostLostBattles;

  final StringAndInt strongest;

  const AchievementsState(
      {this.mostTreasures = const {},
      this.mostLonelyBoy = const {},
      this.mostLostBattles = const {},
      this.mostMonstersKilled = const {},
      this.strongest = const StringAndInt()});

  @override
  List<Object> get props => [
        mostTreasures,
        mostLonelyBoy,
        mostLostBattles,
        mostMonstersKilled,
        strongest
      ];

  AchievementsState copyWith({
    Map<String, int> mostTreasures,
    Map<String, int> mostMonstersKilled,
    StringAndInt strongest,
    Map<String, int> mostLonelyBoy,
    Map<String, int> mostLostBattles,
  }) {
    return AchievementsState(
      mostTreasures:
          AchievementsState.sortMap(mostTreasures) ?? this.mostTreasures,
      mostMonstersKilled: AchievementsState.sortMap(mostMonstersKilled) ??
          this.mostMonstersKilled,
      strongest: strongest ?? this.strongest,
      mostLonelyBoy:
          AchievementsState.sortMap(mostLonelyBoy) ?? this.mostLonelyBoy,
      mostLostBattles:
          AchievementsState.sortMap(mostLostBattles) ?? this.mostLostBattles,
    );
  }

  @override
  bool get stringify => true;

  static Map<String, int> sortMap(Map<String, int> map) {
    return map == null
        ? map
        : LinkedHashMap.from(
            SplayTreeMap.from(
                map, (key1, key2) => map[key2].compareTo(map[key1])),
          );
  }
}

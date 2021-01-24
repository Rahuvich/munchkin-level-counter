part of 'game_cubit.dart';

class GameState extends Equatable {
  final List<Player> players;
  final bool gameFinished;
  final bool hasJustStarted;

  final int maxLevelTrigger;

  const GameState(
      {this.players = const [],
      this.gameFinished = false,
      this.hasJustStarted = true,
      this.maxLevelTrigger = 10});

  @override
  List<Object> get props =>
      [players, gameFinished, hasJustStarted, maxLevelTrigger];

  @override
  bool get stringify => true;

  GameState copyWith({
    List<Player> players,
    bool gameFinished,
    int maxLevelTrigger,
  }) {
    return GameState(
        players: players ?? this.players,
        gameFinished: gameFinished ?? this.gameFinished,
        maxLevelTrigger: maxLevelTrigger ?? this.maxLevelTrigger,
        hasJustStarted: false);
  }

  Map<String, dynamic> toMap() {
    return {
      'players': players?.map((x) => x?.toMap())?.toList() ?? [],
      'gameFinished': gameFinished,
      'hasJustStarted': hasJustStarted,
      'maxLevelTrigger': maxLevelTrigger
    };
  }

  factory GameState.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return GameState(
        players: List<Player>.from(
            map['players']?.map((x) => Player.fromMap(x)) ?? []),
        gameFinished: map['gameFinished'],
        hasJustStarted: map['hasJustStarted'],
        maxLevelTrigger: map['maxLevelTrigger']);
  }

  String toJson() => json.encode(toMap());

  factory GameState.fromJson(String source) =>
      GameState.fromMap(json.decode(source));
}

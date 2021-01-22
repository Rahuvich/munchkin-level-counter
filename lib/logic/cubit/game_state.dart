part of 'game_cubit.dart';

class GameState extends Equatable {
  final List<Player> players;
  final bool gameFinished;
  final bool hasJustStarted;
  const GameState(
      {this.players = const [],
      this.gameFinished = false,
      this.hasJustStarted = true});

  @override
  List<Object> get props => [players, gameFinished, hasJustStarted];

  @override
  bool get stringify => true;

  GameState copyWith({
    List<Player> players,
    bool gameFinished,
  }) {
    return GameState(
        players: players ?? this.players,
        gameFinished: gameFinished ?? this.gameFinished,
        hasJustStarted: false);
  }

  Map<String, dynamic> toMap() {
    return {
      'players': players?.map((x) => x?.toMap())?.toList() ?? [],
      'gameFinished': gameFinished,
      'hasJustStarted': hasJustStarted
    };
  }

  factory GameState.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return GameState(
        players: List<Player>.from(
            map['players']?.map((x) => Player.fromMap(x)) ?? []),
        gameFinished: map['gameFinished'],
        hasJustStarted: map['hasJustStarted']);
  }

  String toJson() => json.encode(toMap());

  factory GameState.fromJson(String source) =>
      GameState.fromMap(json.decode(source));
}

part of 'game_cubit.dart';

class GameState extends Equatable {
  final List<Player> players;
  const GameState({this.players});

  @override
  List<Object> get props => [players];

  @override
  bool get stringify => true;

  GameState copyWith({
    List<Player> players,
    bool expandedMode,
  }) {
    return GameState(
      players: players ?? this.players,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'players': players?.map((x) => x?.toMap())?.toList() ?? [],
    };
  }

  factory GameState.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return GameState(
      players: List<Player>.from(
          map['players']?.map((x) => Player.fromMap(x)) ?? []),
    );
  }

  String toJson() => json.encode(toMap());

  factory GameState.fromJson(String source) =>
      GameState.fromMap(json.decode(source));
}

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
}

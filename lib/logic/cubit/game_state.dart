part of 'game_cubit.dart';

class GameState extends Equatable {
  final List<Player> players;
  const GameState({this.players});

  @override
  List<Object> get props => [players];

  GameState copyWith({
    List<Player> players,
  }) {
    return GameState(
      players: players ?? this.players,
    );
  }

  @override
  bool get stringify => true;
}

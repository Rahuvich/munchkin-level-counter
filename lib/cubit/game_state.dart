part of 'game_cubit.dart';

class GameplayState extends Equatable {
  final List<Player> players;
  const GameplayState({this.players});

  @override
  List<Object> get props => [players];
}

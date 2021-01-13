import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:munchkin/models/munchkin.dart';

part 'game_state.dart';

class GameCubit extends Cubit<GameplayState> {
  GameCubit()
      : super(GameplayState(players: [
          Player(name: 'Mabe'),
          Player(name: 'Planas'),
          Player(name: 'Cade'),
        ]));

  void addPlayer(String name) => emit(GameplayState(
      players: List.unmodifiable([]
        ..addAll(this.state.players)
        ..add(Player(name: name)))));

  void removePlayer(String id) => emit(GameplayState(
      players: List.unmodifiable(
          []..addAll(this.state.players.where((player) => player.id != id)))));

  void levelUpPlayer(String id) {
    List<Player> list = this.state.players;
    list.forEach((player) {
      if (player.id == id) {
        player.level++;
      }
    });

    emit(GameplayState(players: List.unmodifiable(list)));
  }
}

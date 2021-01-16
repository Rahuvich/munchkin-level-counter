import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:munchkin/models/models.dart';
import 'package:uuid/uuid.dart';
import 'dart:math' as math;

part 'game_state.dart';

class GameCubit extends Cubit<GameState> {
  GameCubit() : super(GameState(players: []));

  void addPlayer(String name, {String id}) => emit(this.state.copyWith(
      players: List.unmodifiable([]
        ..addAll(this.state.players)
        ..add(Player(id: id ?? Uuid().v1(), name: name)))));

  void removePlayer(String id) => emit(this.state.copyWith(
      players: List.unmodifiable(
          []..addAll(this.state.players.where((player) => player.id != id)))));

  void addLevelToPlayer(String id, int count) {
    List<Player> list = this.state.players.map((player) {
      if (player.id == id) {
        return player.copyWith(level: math.max(player.level + count, 1));
      }
      return player;
    }).toList();

    emit(this.state.copyWith(players: List.unmodifiable(list)));
  }

  void addGearToPlayer(String id, int count) {
    List<Player> list = this.state.players.map((player) {
      if (player.id == id) {
        return player.copyWith(gear: math.max(player.gear + count, 0));
      }
      return player;
    }).toList();

    emit(this.state.copyWith(players: List.unmodifiable(list)));
  }

  void toggleGenderOfPlayer(String id) {
    List<Player> list = this.state.players.map((player) {
      if (player.id == id) {
        return player.copyWith(
            gender: player.gender == Gender.MALE ? Gender.FEMALE : Gender.MALE);
      }
      return player;
    }).toList();

    emit(this.state.copyWith(players: List.unmodifiable(list)));
  }

  void killPlayer(String id) {
    List<Player> list = this.state.players.map((player) {
      if (player.id == id) {
        return player.copyWith(gear: 0);
      }
      return player;
    }).toList();

    emit(this.state.copyWith(players: List.unmodifiable(list)));
  }

  void resetPlayer(String id) {
    List<Player> list = this.state.players.map((player) {
      if (player.id == id) {
        return player.copyWith(gear: 0, level: 1);
      }
      return player;
    }).toList();

    emit(this.state.copyWith(players: List.unmodifiable(list)));
  }

  void resetPlayers() {
    List<Player> list = this.state.players.map((player) {
      return player.copyWith(gear: 0, level: 1);
    }).toList();

    emit(this.state.copyWith(players: List.unmodifiable(list)));
  }

  void shufflePlayers() {
    List<Player> list = List.from(this.state.players);
    list.shuffle();

    emit(this.state.copyWith(players: List.unmodifiable(list)));
  }

  void restartGame() => emit(this.state.copyWith(players: []));
}

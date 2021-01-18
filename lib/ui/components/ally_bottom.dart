import 'package:flutter/material.dart';
import 'package:munchkin/logic/cubit/battle_cubit.dart';
import 'package:munchkin/models/models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlayersBottomSheet extends StatelessWidget {
  final List<Player> players;
  PlayersBottomSheet({this.players});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Material(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          color: context.theme().scaffoldBackgroundColor,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: players
                  .map((player) => ListTile(
                        onTap: () {
                          context.read<BattleCubit>()?.addAlly(player);
                          Navigator.of(context).pop();
                        },
                        leading: CircleAvatar(
                          backgroundColor: Colors.white.withOpacity(.1),
                          radius: 30,
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: FittedBox(
                                child: Text(
                                  player.strength.toString(),
                                  style: context.theme().textTheme.headline5,
                                ),
                              ),
                            ),
                          ),
                        ),
                        title: Text(player.name,
                            style: context.theme().textTheme.bodyText1),
                        subtitle: Text('Level ${player.level}'),
                      ))
                  .toList()
                    ..add(ListTile(
                      onTap: () {
                        context.read<BattleCubit>().removeAlly();
                        Navigator.of(context).pop();
                      },
                      leading: CircleAvatar(
                        backgroundColor: Colors.white.withOpacity(.1),
                        radius: 30,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: FittedBox(
                              child: Text(
                                0.toString(),
                                style: context.theme().textTheme.headline5,
                              ),
                            ),
                          ),
                        ),
                      ),
                      title: Text('No ally',
                          style: context.theme().textTheme.bodyText1),
                    )),
            ),
          ),
        ),
      ),
    );
  }
}

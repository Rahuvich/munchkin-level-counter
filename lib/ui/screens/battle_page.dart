import 'package:flutter/material.dart';
import 'package:munchkin/models/models.dart';

class BattlePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          backgroundColor: context.theme().scaffoldBackgroundColor,
          title: Text(
            'Battle',
            style: context.theme().textTheme.headline3,
          ),
        ),
        SliverFillRemaining(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20.0),
            child: Container(
              color: Colors.purpleAccent,
            ),
          ),
        ),
      ],
    );
  }
}

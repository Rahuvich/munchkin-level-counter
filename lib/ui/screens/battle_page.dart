import 'package:flutter/material.dart';
import 'package:munchkin/models/models.dart';

class BattlePage extends StatelessWidget {
  final VoidCallback onBack;
  BattlePage({@required this.onBack});
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          backgroundColor: context.theme().scaffoldBackgroundColor,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => onBack.call(),
          ),
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
              child: Center(
                  child: Text(
                'Mabe',
                style: context.theme().textTheme.bodyText1,
              )),
            ),
          ),
        ),
      ],
    );
  }
}

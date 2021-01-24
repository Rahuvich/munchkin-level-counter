import 'package:flutter/material.dart';
import 'package:munchkin/models/models.dart';

class RedoSnackbar extends StatelessWidget {
  final String title, subtitle;
  final VoidCallback onAction;
  final Color color;
  const RedoSnackbar({
    Key key,
    this.color,
    this.subtitle,
    this.title,
    this.onAction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: context.theme().textTheme.subtitle1.copyWith(color: color),
            ),
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            icon: Icon(
              Icons.undo_rounded,
              color: color,
            ),
            onPressed: () {
              Scaffold.of(context)
                  .hideCurrentSnackBar(reason: SnackBarClosedReason.action);
              onAction.call();
            },
          ),
        ],
      ),
    );
    return ListTile(
      dense: true,
      title: Text(
        title,
        style: context.theme().textTheme.subtitle1.copyWith(color: color),
      ),
      subtitle: subtitle != null
          ? Text(subtitle, style: TextStyle(color: color))
          : null,
      trailing: IconButton(
        visualDensity: VisualDensity.compact,
        icon: Icon(
          Icons.undo_rounded,
          color: color,
        ),
        onPressed: () {
          Scaffold.of(context)
              .hideCurrentSnackBar(reason: SnackBarClosedReason.action);
          onAction.call();
        },
      ),
    );
  }
}

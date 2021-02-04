import 'package:flutter/material.dart';
import 'package:munchkin/ui/components/bottom_sheets/social_media_bottom.dart';
import 'package:munchkin/ui/components/button.dart';
import 'package:munchkin/models/models.dart';

class Helper {
  static void showSocialMediaBottomSheet(BuildContext context) {
    showModalBottomSheet(
        barrierColor: Colors.black26,
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32.0),
          topRight: Radius.circular(32.0),
        )),
        context: context,
        builder: (_) => BottomSheet(
            backgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
              topLeft: Radius.circular(32),
              topRight: Radius.circular(32),
            )),
            onClosing: () => true,
            builder: (context) => SocialMediaSheet()));
  }

  static Future<bool> showConfirmDialog(
      {BuildContext context,
      String title,
      VoidCallback onConfirm,
      VoidCallback onDismissed,
      bool destructive}) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              title,
              style: context.theme().textTheme.headline3,
              textAlign: TextAlign.center,
            ),
            actionsPadding:
                EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            actions: [
              FancyButton(
                color: !destructive
                    ? context.theme().errorColor
                    : context.theme().accentColor,
                size: 30,
                child: Center(
                  child: Text(
                    'Cancel',
                    style: context.theme().textTheme.bodyText1,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop(false);
                  onDismissed?.call();
                },
              ),
              SizedBox(
                width: 15.0,
              ),
              FancyButton(
                color: destructive
                    ? context.theme().errorColor
                    : context.theme().accentColor,
                size: 30,
                child: Center(
                  child: Text(
                    'Confirm',
                    style: context.theme().textTheme.bodyText1,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop(true);
                  onConfirm?.call();
                },
              )
            ],
          );
        });
  }
}

import 'package:flutter/material.dart';
import 'package:munchkin/ui/components/bottom_sheets/social_media_bottom.dart';

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
}

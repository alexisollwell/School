import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<void> showLoadingAlert({required BuildContext context}) async {
  return showCupertinoDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return CupertinoAlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset("assets/images/loadingLogo.png",fit: BoxFit.fitWidth,width: 100,),
            const SizedBox(height: 16),
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            const Text('Espere por favor...'),
          ],
        )
      );
    },
  );
}

void  closeLoadingAlert({required BuildContext context}){
  Navigator.of(context).pop();
}

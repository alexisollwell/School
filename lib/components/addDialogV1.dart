import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'CloseDialogButton.dart';
import 'OkDialogAlert.dart';
import 'accept_button_design.dart';
import 'cancel_button_design.dart';

Future<void> addDialogV1(
    {required String title,
    required String field1,
    required String field2,
    String? fieldValue1,
    String? fieldValue2,
    required BuildContext context,
    void Function(String, bool)? action,
    void Function()? actionCancel}) async {
  double height = 400;
  double width = 450;
  double borderBox = 20;

  TextEditingController _textFieldController2 = TextEditingController();
  _textFieldController2.text = fieldValue1 ?? "";
  bool status = fieldValue2 == "1";

  final MaterialStateProperty<Color?> trackColor =
      MaterialStateProperty.resolveWith<Color?>(
    (Set<MaterialState> states) {
      if (states.contains(MaterialState.selected)) {
        return Colors.blueAccent;
      }
      return null;
    },
  );
  final MaterialStateProperty<Color?> overlayColor =
      MaterialStateProperty.resolveWith<Color?>(
    (Set<MaterialState> states) {
      if (states.contains(MaterialState.selected)) {
        return Colors.blueAccent.withOpacity(0.54);
      }
      if (states.contains(MaterialState.disabled)) {
        return Colors.grey.shade400;
      }
      return null;
    },
  );

  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext dialogContext) {
      return StatefulBuilder(builder: (ctx, stst) {
        return Material(
          color: Colors.transparent,
          child: SizedBox(
            height: height,
            width: width,
            child: Stack(
              children: [
                Container(
                  color: Colors.grey.withOpacity(0.05),
                ),
                Center(
                  child: Container(
                    height: height,
                    width: width,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.grey[200]!,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey[500]!,
                            blurRadius: 4,
                            offset: const Offset(2, 2), // Shadow position
                          ),
                        ],
                        borderRadius: BorderRadius.circular(borderBox)),
                    child: Column(
                      children: [
                        CloseDialogButton(width: width),
                        const Spacer(),
                        Text(
                          title,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                              color: Colors.black),
                        ),
                        const Spacer(
                          flex: 2,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          child: CupertinoTextField(
                            controller: _textFieldController2,
                            //enabled: false,
                            placeholderStyle: const TextStyle(
                              color: Colors.black,
                            ),
                            textAlignVertical: TextAlignVertical.top,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          child: Row(
                            children: [
                              Text(
                                field2,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 15),
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              Switch(
                                value: status,
                                overlayColor: overlayColor,
                                trackColor: trackColor,
                                thumbColor:
                                    const MaterialStatePropertyAll<Color>(
                                        Colors.black),
                                onChanged: (bool value) {
                                  stst(() {
                                    status = value;
                                  });
                                },
                              )
                            ],
                          ),
                        ),
                        const Spacer(
                          flex: 2,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            CancelButtonDesign(
                              onTap: () {
                                Navigator.of(context).pop();
                                if (actionCancel != null) {
                                  actionCancel();
                                }
                              },
                            ),
                            AcceptButtonDesign(
                              onTap: () {
                                if (_textFieldController2.text.isEmpty) {
                                  showOkAlert(
                                      title: "Atención",
                                      message: "Es necesario ingresar un valor",
                                      context: ctx);
                                  return;
                                }
                                if (_textFieldController2.text.length > 50) {
                                  showOkAlert(
                                      title: "Atención",
                                      message:
                                          "El texto ingresado debe ser menor a 50 caracteres",
                                      context: ctx);
                                  return;
                                }
                                action!(_textFieldController2.text, status);
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      });
    },
  );
}

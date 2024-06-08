import 'package:flutter/material.dart';
import '../models/PruebasModel.dart';
import 'CloseDialogButton.dart';
import 'accept_button_design.dart';
import 'cancel_button_design.dart';

Future<void> addDialogV9({
  required String title,
  required List<PruebasModel> tests,
  required BuildContext context,
  void Function(PruebasModel)? action,
}) async {
  double height = 420;
  double width = 450;
  double borderBox = 20;

  PruebasModel selectedTest = tests[0];

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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            DropdownButton<String>(
                              value: selectedTest.nombre,
                              icon: const Icon(Icons.arrow_downward),
                              elevation: 16,
                              style: const TextStyle(color: Colors.orange),
                              underline: Container(
                                height: 2,
                                color: Colors.orange,
                              ),
                              onChanged: (String? value) {
                                // This is called when the user selects an item.
                                stst(() {
                                  selectedTest = tests.firstWhere(
                                      (element) => element.nombre == value!);
                                });
                              },
                              items: tests.map<DropdownMenuItem<String>>(
                                  (PruebasModel value) {
                                return DropdownMenuItem<String>(
                                  value: value.nombre,
                                  child: Text(value.nombre!),
                                );
                              }).toList(),
                            )
                          ],
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
                              },
                            ),
                            AcceptButtonDesign(
                              onTap: () {
                                action!(selectedTest);
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

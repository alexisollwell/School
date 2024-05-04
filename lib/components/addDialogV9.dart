import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../constants.dart';
import '../models/CampusModel.dart';
import '../models/PruebasModel.dart';
import '../models/PruebasPerfil.dart';
import '../models/user/PersonaModel.dart';

Future<void> addDialogV9(
    {required String title,
    required List<PruebasModel> tests,
    required BuildContext context,
    void Function(PruebasModel)? action,
    }) async {
  double height = 400;
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
                        Container(
                          height: 70,
                          width: width,
                          decoration: BoxDecoration(
                              color: Colors.grey.shade700,
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20))),
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 15,
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).pop(false);
                                },
                                child: const SizedBox(
                                  height: 60,
                                  width: 100,
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.arrow_back,
                                        color: Colors.white,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "Regresar",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Image.asset(
                                "assets/images/xochicalco.png",
                                fit: BoxFit.fitHeight,
                                height: 30,
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        Text(
                          title,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.blue[800]),
                        ),
                        const Spacer(),

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
                                  selectedTest = tests.firstWhere((element) =>
                                  element.nombre == value!);
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
                            InkWell(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 3),
                                decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(10)),
                                child: const Text(
                                  "Cancelar",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                action!(
                                  selectedTest
                                );
                                Navigator.of(context).pop();
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 3),
                                decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(10)),
                                child: const Text(
                                  "Aceptar",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: Colors.white),
                                ),
                              ),
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

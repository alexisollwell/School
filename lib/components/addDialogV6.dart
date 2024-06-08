import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/PruebasModel.dart';
import 'CloseDialogButton.dart';
import 'OkDialogAlert.dart';
import 'accept_button_design.dart';
import 'cancel_button_design.dart';

Future<void> addDialogV6(
    {required String title,
    required PruebasModel data,
    required BuildContext context,
    void Function(PruebasModel)? action,
    void Function()? actionCancel}) async {
  double height = 450;
  double width = 450;
  double borderBox = 20;

  TextEditingController _textFieldController2 = TextEditingController();
  TextEditingController _textFieldController3 = TextEditingController();
  TextEditingController _textFieldController4 = TextEditingController();
  TextEditingController _textFieldController5 = TextEditingController();

  _textFieldController2.text = data.nombre ?? "";
  _textFieldController3.text = data.descripcion ?? "";
  _textFieldController5.text = data.Instruccion ?? "";
  _textFieldController4.text = data.minutos.toString();
  bool status = data.estatus == "1";

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
                            placeholder: "Nombre",
                            placeholderStyle: const TextStyle(
                              color: Colors.black,
                            ),
                            textAlignVertical: TextAlignVertical.top,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          child: CupertinoTextField(
                            controller: _textFieldController3,
                            placeholder: "Descripción",
                            keyboardType: TextInputType.multiline,
                            maxLines: 3,
                            placeholderStyle: const TextStyle(
                              color: Colors.black,
                            ),
                            textAlignVertical: TextAlignVertical.top,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          child: CupertinoTextField(
                            controller: _textFieldController5,
                            placeholder: "Instrucción",
                            keyboardType: TextInputType.multiline,
                            maxLines: 3,
                            placeholderStyle: const TextStyle(
                              color: Colors.black,
                            ),
                            textAlignVertical: TextAlignVertical.top,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          child: CupertinoTextField(
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            controller: _textFieldController4,
                            placeholder: "Tiempo(Minutos)",
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
                                "Estatus",
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
                                      message:
                                          "Es necesario ingresar un nombre",
                                      context: ctx);
                                  return;
                                }
                                if (_textFieldController3.text.isEmpty) {
                                  showOkAlert(
                                      title: "Atención",
                                      message:
                                          "Es necesario ingresar una descripción",
                                      context: ctx);
                                  return;
                                }
                                if (_textFieldController5.text.isEmpty) {
                                  showOkAlert(
                                      title: "Atención",
                                      message:
                                          "Es necesario ingresar una instrucción",
                                      context: ctx);
                                  return;
                                }
                                if (_textFieldController2.text.length > 50) {
                                  showOkAlert(
                                      title: "Atención",
                                      message:
                                          "El nombre ingresado debe ser menor a 50 caracteres",
                                      context: ctx);
                                  return;
                                }
                                if (_textFieldController5.text.length > 1000) {
                                  showOkAlert(
                                      title: "Atención",
                                      message:
                                          "La instrucción ingresada debe ser menor a 1000 caracteres",
                                      context: ctx);
                                  return;
                                }
                                if (_textFieldController3.text.length > 1000) {
                                  showOkAlert(
                                      title: "Atención",
                                      message:
                                          "La descripción ingresada debe ser menor a 1000 caracteres",
                                      context: ctx);
                                  return;
                                }

                                int horas =
                                    int.parse(_textFieldController4.text) ~/ 60;
                                int minutos =
                                    int.parse(_textFieldController4.text) % 60;
                                String horasStr =
                                    horas.toString().padLeft(2, '0');
                                String minutosStr =
                                    minutos.toString().padLeft(2, '0');
                                String segundosStr = "00";

                                action!(PruebasModel(
                                  id: data.id > 0 ? data.id : 0,
                                  nombre: _textFieldController2.text,
                                  descripcion: _textFieldController3.text,
                                  minutos:
                                      int.parse(_textFieldController4.text),
                                  tiempo: "$horasStr:$minutosStr:$segundosStr",
                                  estatus: status ? "1" : "0",
                                ));
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

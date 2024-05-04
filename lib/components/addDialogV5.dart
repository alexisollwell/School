import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:school/models/DivisionesModel.dart';
import '../models/CarreraModel.dart';
import '../models/PerfilModel.dart';
import '../models/PeriodoModel.dart';
import 'OkDialogAlert.dart';

Future<void> addDialogV5(
    {required String title,
    required PerfilModel data,
    required BuildContext context,
    void Function(PerfilModel)? action,
    void Function()? actionCancel}) async {
  double height = 400;
  double width = 450;
  double borderBox = 20;

  TextEditingController _textFieldController2 = TextEditingController();
  TextEditingController _textFieldController3 = TextEditingController();

  _textFieldController2.text = data.nombre ?? "";
  _textFieldController3.text = data.descripcion ?? "";
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
                            maxLines: 6,
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
                            InkWell(
                              onTap: () {
                                Navigator.of(context).pop();
                                if (actionCancel != null) {
                                  actionCancel();
                                }
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
                                if(_textFieldController2.text.isEmpty){
                                  showOkAlert(title: "Atención", message: "Es necesario ingresar un nombre", context: ctx);
                                  return;
                                }
                                if(_textFieldController3.text.isEmpty){
                                  showOkAlert(title: "Atención", message: "Es necesario ingresar una descripción", context: ctx);
                                  return;
                                }
                                if(_textFieldController2.text.length>50){
                                  showOkAlert(title: "Atención", message: "El nombre ingresado debe ser menor a 50 caracteres", context: ctx);
                                  return;
                                }
                                if( _textFieldController3.text.length>250){
                                  showOkAlert(title: "Atención", message: "La descripción ingresada debe ser menor a 250 caracteres", context: ctx);
                                  return;
                                }
                                action!(PerfilModel(
                                  id: data.id > 0 ? data.id : 0,
                                  nombre: _textFieldController2.text,
                                  descripcion: _textFieldController3.text,
                                  estatus: status ? "1" : "0",
                                ));
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

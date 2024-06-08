import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:school/models/user/updatePassword.dart';
import '../constants.dart';
import '../models/CampusModel.dart';
import '../models/user/PersonaModel.dart';
import 'CloseDialogButton.dart';
import 'OkDialogAlert.dart';
import 'accept_button_design.dart';
import 'cancel_button_design.dart';

Future<void> addDialogV8({
  required String title,
  required PersonaModel data,
  required List<CampusModel> campus,
  required BuildContext context,
  void Function(PersonaModel, UpdatePassword)? action,
}) async {
  double height = 500;
  double width = 450;
  double borderBox = 20;

  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerApellido = TextEditingController();
  TextEditingController controllerDomicilio = TextEditingController();
  TextEditingController controllerTelefono = TextEditingController();
  TextEditingController controllerCorreo = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();
  TextEditingController controllerPassword2 = TextEditingController();

  controllerName.text = data.nombre ?? "";
  controllerApellido.text = data.apellido ?? "";
  controllerDomicilio.text = data.domicilio ?? "";
  controllerTelefono.text = data.telefono ?? "";
  controllerCorreo.text = data.correo ?? "";

  DateTime saveFecNac =
      data.fechaNaC == null ? DateTime.now() : DateTime.parse(data.fechaNaC!);
  String fechaNac =
      "Fecha Nacimiento: ${DateFormat('yyyy-MM-dd').format(saveFecNac)}";

  String edoCi = "";
  for (String item in edoCivil) {
    if (item.toLowerCase() == data.edoCivil!.toLowerCase()) {
      edoCi = item;
    }
  }
  if (edoCi.isEmpty) {
    edoCi = edoCivil[0];
  }

  String nacionalidad = "";
  for (String item in nationality) {
    if (item.toLowerCase() == data.nacionalidad!.toLowerCase()) {
      nacionalidad = item;
    }
  }
  if (nacionalidad.isEmpty) {
    nacionalidad = nationality.first;
  }

  CampusModel selectedCampus =
      campus.firstWhere((element) => element.id == data.campusId);

  bool status = true;
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
                          child: Row(
                            children: [
                              SizedBox(
                                width: 200,
                                child: CupertinoTextField(
                                  controller: controllerName,
                                  placeholder: "Nombre",
                                  placeholderStyle: const TextStyle(
                                    color: Colors.black,
                                  ),
                                  textAlignVertical: TextAlignVertical.top,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              SizedBox(
                                width: 200,
                                child: CupertinoTextField(
                                  controller: controllerApellido,
                                  placeholder: "Apellido",
                                  placeholderStyle: const TextStyle(
                                    color: Colors.black,
                                  ),
                                  textAlignVertical: TextAlignVertical.top,
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 200,
                                child: CupertinoTextField(
                                  controller: controllerCorreo,
                                  placeholder: "Correo",
                                  placeholderStyle: const TextStyle(
                                    color: Colors.black,
                                  ),
                                  textAlignVertical: TextAlignVertical.top,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              SizedBox(
                                width: 200,
                                child: CupertinoTextField(
                                  controller: controllerTelefono,
                                  placeholder: "Telefono",
                                  placeholderStyle: const TextStyle(
                                    color: Colors.black,
                                  ),
                                  textAlignVertical: TextAlignVertical.top,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          child: CupertinoTextField(
                            controller: controllerDomicilio,
                            placeholder: "Domicilio",
                            placeholderStyle: const TextStyle(
                              color: Colors.black,
                            ),
                            textAlignVertical: TextAlignVertical.top,
                          ),
                        ),
                        Row(
                          children: [
                            const SizedBox(
                              width: 15,
                            ),
                            DropdownButton<String>(
                              value: edoCi,
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
                                  edoCi = value!;
                                });
                              },
                              items: edoCivil.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            DropdownButton<String>(
                              value: nacionalidad,
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
                                  nacionalidad = value!;
                                });
                              },
                              items: nationality.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const SizedBox(
                              width: 15,
                            ),
                            DropdownButton<String>(
                              value: selectedCampus.nombre,
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
                                  selectedCampus = campus.firstWhere(
                                      (element) => element.nombre == value!);
                                });
                              },
                              items: campus.map<DropdownMenuItem<String>>(
                                  (CampusModel value) {
                                return DropdownMenuItem<String>(
                                  value: value.nombre,
                                  child: Text(value.nombre!),
                                );
                              }).toList(),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            const Text(
                              "Estatus",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 15),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Switch(
                              value: status,
                              overlayColor: overlayColor,
                              trackColor: trackColor,
                              thumbColor: const MaterialStatePropertyAll<Color>(
                                  Colors.black),
                              onChanged: (bool value) {
                                stst(() {
                                  status = value;
                                });
                              },
                            )
                          ],
                        ),
                        Row(
                          children: [
                            const SizedBox(
                              width: 15,
                            ),
                            InkWell(
                              onTap: () {
                                showDatePicker(
                                        context: ctx,
                                        initialDate: saveFecNac,
                                        firstDate: DateTime.now().add(
                                            const Duration(
                                                days: -1 * (350 * 100))),
                                        lastDate: DateTime.now().add(const Duration(
                                            days:
                                                365))) //what will be the up to supported date in picker
                                    .then((pickedDate) {
                                  //then usually do the future job
                                  if (pickedDate == null) {
                                    //if user tap cancel then this function will stop
                                    return;
                                  }
                                  stst(() {
                                    saveFecNac = pickedDate;
                                    fechaNac =
                                        "Fecha Nacimiento: ${DateFormat('yyyy-MM-dd').format(pickedDate)}";
                                  });
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: Colors.blueAccent,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Text(
                                  fechaNac,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 200,
                                child: CupertinoTextField(
                                  controller: controllerPassword,
                                  placeholder: "Contraseña",
                                  placeholderStyle: const TextStyle(
                                    color: Colors.black,
                                  ),
                                  obscureText: true,
                                  textAlignVertical: TextAlignVertical.top,
                                ),
                              ),
                              const Spacer(),
                              SizedBox(
                                width: 200,
                                child: CupertinoTextField(
                                  controller: controllerPassword2,
                                  placeholder: "Confirmación Contraseña",
                                  placeholderStyle: const TextStyle(
                                    color: Colors.black,
                                  ),
                                  obscureText: true,
                                  textAlignVertical: TextAlignVertical.top,
                                ),
                              ),
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
                              },
                            ),
                            AcceptButtonDesign(
                              onTap: () {
                                if (controllerName.text.isEmpty) {
                                  showOkAlert(
                                      title: "Atención",
                                      message:
                                          "Es necesario ingresar un nombre",
                                      context: ctx);
                                  return;
                                }
                                if (controllerName.text.length > 50) {
                                  showOkAlert(
                                      title: "Atención",
                                      message:
                                          "El nombre ingresado debe ser menor a 50 caracteres",
                                      context: ctx);
                                  return;
                                }
                                if (controllerApellido.text.isEmpty) {
                                  showOkAlert(
                                      title: "Atención",
                                      message:
                                          "Es necesario ingresar un apellido",
                                      context: ctx);
                                  return;
                                }
                                if (controllerName.text.length > 50) {
                                  showOkAlert(
                                      title: "Atención",
                                      message:
                                          "El apellido ingresado debe ser menor a 50 caracteres",
                                      context: ctx);
                                  return;
                                }
                                if (controllerPassword.text.isNotEmpty ||
                                    controllerPassword2.text.isNotEmpty) {
                                  if (controllerPassword.text.length < 6) {
                                    showOkAlert(
                                        title: "Atención",
                                        message:
                                            "Es necesario ingresar una contraseña contraseña mayor a 6 caracteres",
                                        context: ctx);
                                    return;
                                  }
                                  if (controllerPassword.text !=
                                      controllerPassword2.text) {
                                    showOkAlert(
                                        title: "Atención",
                                        message:
                                            "Es necesario que la contraseña y su confirmación coincidan",
                                        context: ctx);
                                    return;
                                  }
                                }
                                if (controllerCorreo.text.isEmpty) {
                                  showOkAlert(
                                      title: "Atención",
                                      message:
                                          "Es necesario ingresar un correo",
                                      context: ctx);
                                  return;
                                }
                                RegExp emailRegex = RegExp(
                                  r'^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$',
                                  caseSensitive: false,
                                  multiLine: false,
                                );
                                if (!emailRegex
                                    .hasMatch(controllerCorreo.text)) {
                                  showOkAlert(
                                      title: "Atención",
                                      message:
                                          "Es necesario ingresar un correo válido",
                                      context: ctx);
                                  return;
                                }
                                action!(
                                    PersonaModel(
                                      id: data.id,
                                      nombre: controllerName.text,
                                      correo: controllerCorreo.text,
                                      apellido: controllerApellido.text,
                                      fechaNaC: DateFormat('yyyy-MM-dd')
                                          .format(saveFecNac),
                                      domicilio: controllerDomicilio.text,
                                      telefono: controllerTelefono.text,
                                      edoCivil: edoCi,
                                      nacionalidad: nacionalidad,
                                      estatus: status ? "1" : "0",
                                      campusId: selectedCampus.id,
                                      usuarioId: data.usuarioId,
                                    ),
                                    UpdatePassword(
                                        password: controllerPassword.text));
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

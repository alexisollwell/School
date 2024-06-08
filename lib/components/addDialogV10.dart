import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/SolicitudesModel.dart';
import 'CloseDialogButton.dart';
import 'accept_button_design.dart';
import 'cancel_button_design.dart';

Future<void> addDialogV10({
  required String title,
  required SolicitudesModel data,
  required BuildContext context,
  void Function(SolicitudesModel)? action,
}) async {
  double height = 400;
  double width = 450;
  double borderBox = 20;

  TextEditingController controllerComentarios = TextEditingController();
  TextEditingController controllerResultados = TextEditingController();
  controllerComentarios.text = data.comentarios ?? "";
  controllerResultados.text = data.Resultados ?? "";
  DateTime fechApli = data.fechaAplicacion == null
      ? DateTime.now()
      : DateTime.parse(data.fechaAplicacion!);
  String fechApliSt =
      "Fecha Aplicación: ${DateFormat('yyyy-MM-dd').format(fechApli)}";
  DateTime fechAna = data.Fecha_analisis == null
      ? DateTime.now()
      : DateTime.parse(data.Fecha_analisis!);
  String fechAnaSt =
      "Fecha Analisis: ${DateFormat('yyyy-MM-dd').format(fechAna)}";
  List<String> statusTestTemp = ["Completado", "Cancelado"];
  String selectedStatus = statusTestTemp[0];

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
                            controller: controllerComentarios,
                            placeholder: "Comentarios",
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
                            controller: controllerResultados,
                            placeholder: "Resultados",
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
                            InkWell(
                              onTap: () {
                                showDatePicker(
                                        context: ctx,
                                        initialDate: fechAna,
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
                                    fechAna = pickedDate;
                                    fechAnaSt =
                                        "Fecha Analisis: ${DateFormat('yyyy-MM-dd').format(pickedDate)}";
                                  });
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: Colors.blueAccent,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Text(
                                  fechAnaSt,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            const Spacer(),
                            DropdownMenu<String>(
                              initialSelection: selectedStatus,
                              onSelected: (value) {
                                stst(() {
                                  selectedStatus = value!;
                                });
                              },
                              dropdownMenuEntries: statusTestTemp
                                  .map<DropdownMenuEntry<String>>(
                                      (String value) {
                                return DropdownMenuEntry<String>(
                                    value: value, label: value);
                              }).toList(),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
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
                                        initialDate: fechApli,
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
                                    fechApli = pickedDate;
                                    fechApliSt =
                                        "Fecha Aplicación: ${DateFormat('yyyy-MM-dd').format(pickedDate)}";
                                  });
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: Colors.blueAccent,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Text(
                                  fechApliSt,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
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
                                data.Fecha_analisis =
                                    DateFormat('yyyy-MM-dd').format(fechAna);
                                data.fechaAplicacion =
                                    DateFormat('yyyy-MM-dd').format(fechApli);
                                data.comentarios = controllerComentarios.text;
                                data.Resultados = controllerResultados.text;
                                data.estatus =
                                    selectedStatus == statusTestTemp[0]
                                        ? "3"
                                        : "4";
                                action!(data);
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

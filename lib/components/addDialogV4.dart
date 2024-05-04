import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:school/models/DivisionesModel.dart';
import '../models/CarreraModel.dart';
import '../models/PeriodoModel.dart';

Future<void> addDialogV4(
    {required String title,
    required PeriodoModel data,
    required BuildContext context,
    void Function(PeriodoModel)? action,
    void Function()? actionCancel}) async {
  double height = 400;
  double width = 450;
  double borderBox = 20;

  TextEditingController _textFieldController2 = TextEditingController();
  TextEditingController _textFieldController3 = TextEditingController();

  _textFieldController2.text = data.nombre ?? "";
  _textFieldController3.text = data.clave ?? "";
  bool status = data.estatus == "1";

  final f = DateFormat('yyyy-MM-dd');

  DateTime saveInicial =
      data.startDate == null ? DateTime.now() : DateTime.parse(data.startDate!);
  DateTime savefinal =
      data.endDate == null ? DateTime.now() : DateTime.parse(data.endDate!);
  String fechaInicial = data.startDate == null
      ? "Selecciona Fecha Inicial"
      : "Fecha Inicial:${data.startDate}";
  String fechaFinal = data.startDate == null
      ? "Selecciona Fecha Final"
      : "Fecha Final:${data.endDate}";

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
                            placeholder: "Clave",
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
                        Row(
                          children: [
                            const SizedBox(
                              width: 15,
                            ),
                            InkWell(
                              onTap: () {
                                showDatePicker(
                                        context: ctx,
                                        initialDate: saveInicial,
                                        firstDate: DateTime.now()
                                            .add(const Duration(days: -700)),
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
                                    saveInicial = pickedDate;
                                    fechaInicial =
                                        "Fecha Inicial: ${DateFormat('yyyy-MM-dd').format(pickedDate)}";
                                  });
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: Colors.blueAccent,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Text(
                                  fechaInicial,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            InkWell(
                              onTap: () {
                                showDatePicker(
                                        context: ctx,
                                        initialDate: savefinal,
                                        firstDate: DateTime.now()
                                            .add(const Duration(days: -700)),
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
                                    savefinal = pickedDate;
                                    fechaFinal =
                                        "Fecha final: ${DateFormat('yyyy-MM-dd').format(pickedDate)}";
                                  });
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: Colors.blueAccent,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Text(
                                  fechaFinal,
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
                                action!(PeriodoModel(
                                    id: data.id > 0 ? data.id : 0,
                                    nombre: _textFieldController2.text,
                                    clave: _textFieldController3.text,
                                    estatus: status ? "1" : "0",
                                    endDate: DateFormat('yyyy-MM-dd')
                                        .format(savefinal),
                                    startDate: DateFormat('yyyy-MM-dd')
                                        .format(saveInicial)));
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

import 'package:flutter/material.dart';
import 'package:school/components/LoadingAlert.dart';
import 'package:school/models/ResultadoPruebaRequest.dart';

import '../constants.dart';
import '../models/PerfilModel.dart';
import '../models/PreguntaRespuesta.dart';
import '../models/PruebasModel.dart';
import '../models/PruebasPerfil.dart';
import '../models/ResultadoPrueba.dart';
import '../models/SolicitudPrueba.dart';
import '../models/SolicitudesModel.dart';
import '../services/perfilServices.dart';
import '../services/pruebasServices.dart';
import '../services/solicitudesServices.dart';
import '../views/MainMenu/pages/userTest/carrouselDesign.dart';
import 'counter.dart';

void showResultTestModal({
  required int solicitudId,
  required BuildContext ctx,
  required void Function() close,
}) async {
  showLoadingAlert(context: ctx);
  if (listaPruebas.isEmpty) {
    listaPruebas = await consultAllPruebas();
  }
  List<PruebasModel> response = [];
  List<SolicitudPrueba> resp =
      await consultAllSolicitudesPruebaByPersona(solicitudId);
  for (SolicitudPrueba item2 in resp) {
    PruebasModel temp =
        listaPruebas.firstWhere((element) => element.id == item2.pruebasId);
    if (temp != null) {
      response.add(temp);
    }
  }
  PruebasModel selectedPrueba = response[0];
  List<ResultadoPrueba> resultados = await consulPruebasResultados(
      data: ResultadoPruebaRequest(
          solicitudId: solicitudId, pruebaId: selectedPrueba.id));
  closeLoadingAlert(context: ctx);

  final horizontalController = ScrollController();
  final verticalController = ScrollController();

  showModalBottomSheet<void>(
    context: ctx,
    isScrollControlled: true,
    isDismissible: false,
    constraints: BoxConstraints(
      maxWidth: MediaQuery.of(ctx).size.width * 0.9,
    ),
    builder: (BuildContext context) {
      return StatefulBuilder(builder: (BuildContext ctx, StateSetter stst) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.95,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(20), topLeft: Radius.circular(20)),
              border: Border.all(color: Colors.grey)),
          child: Column(
            children: [
              const SizedBox(
                height: 15,
              ),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const SizedBox(
                      width: 15,
                    ),
                    DropdownMenu<PruebasModel>(
                      initialSelection: selectedPrueba,
                      onSelected: (value) async {
                        selectedPrueba = value!;
                        resultados = await consulPruebasResultados(
                            data: ResultadoPruebaRequest(
                                solicitudId: solicitudId,
                                pruebaId: selectedPrueba.id));
                        stst(() {});
                      },
                      dropdownMenuEntries: response
                          .map<DropdownMenuEntry<PruebasModel>>(
                              (PruebasModel value) {
                        return DropdownMenuEntry<PruebasModel>(
                            value: value, label: value.nombre!);
                      }).toList(),
                    ),
                    const Spacer(),
                    InkWell(
                        onTap: close, child: const Icon(Icons.close_rounded)),
                    const SizedBox(
                      width: 15,
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Expanded(
                child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Scrollbar(
                        thumbVisibility: true,
                        thickness: 10,
                        controller: verticalController,
                        child: SingleChildScrollView(
                          controller: verticalController,
                          scrollDirection: Axis.vertical,
                          child: Scrollbar(
                            thumbVisibility: true,
                            thickness: 10,
                            controller: horizontalController,
                            child: SingleChildScrollView(
                              controller: horizontalController,
                              scrollDirection: Axis.horizontal,
                              child: Container(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: DataTable(
                                    headingTextStyle:
                                        const TextStyle(color: Colors.white),
                                    headingRowColor:
                                        MaterialStateColor.resolveWith(
                                            (states) => orange4),
                                    columns: [
                                      DataColumn(
                                        label: SizedBox(
                                          width:
                                              MediaQuery.sizeOf(context).width *
                                                  0.2,
                                          child: Text('Descipción',
                                              style: TextStyle(
                                                  color: Colors.white)),
                                        ),
                                      ),
                                      DataColumn(
                                        label: SizedBox(
                                          width:
                                              MediaQuery.sizeOf(context).width *
                                                  0.2,
                                          child: Text('Puntos',
                                              style: TextStyle(
                                                  color: Colors.white)),
                                        ),
                                      ),
                                    ],
                                    rows: List<DataRow>.generate(
                                      resultados.length,
                                      (index) => DataRow(
                                        cells: [
                                          DataCell(Text(
                                              resultados[index].descripcion)),
                                          DataCell(
                                              Text(resultados[index].puntos)),
                                        ],
                                      ),
                                    ),
                                  )),
                            ),
                          ),
                        ))),
              )
            ],
          ),
        );
      });
    },
  );
}

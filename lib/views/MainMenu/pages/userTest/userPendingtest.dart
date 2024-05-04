import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:school/components/LoadingAlert.dart';
import 'package:school/components/ResponTestModal.dart';
import 'package:school/services/pruebasServices.dart';
import 'dart:html';
import '../../../../components/LoaginPage.dart';
import '../../../../constants.dart';
import '../../../../models/PreguntaRespuesta.dart';
import '../../../../models/PruebasModel.dart';
import '../../../../models/SolicitudPrueba.dart';
import '../../../../models/SolicitudesModel.dart';
import '../../../../services/carreraServices.dart';
import '../../../../services/periodoServices.dart';
import '../../../../services/solicitudesServices.dart';
import '../../../../services/updatePruebaModelo.dart';

class UserPendingTest extends StatefulWidget {
  const UserPendingTest({super.key});

  @override
  State<UserPendingTest> createState() => _UserPendingTestState();
}

class _UserPendingTestState extends State<UserPendingTest> {
  int _sortColumnIndex = 0;
  bool _sortAscending = true;
  int solicitudId = 0;
  String intrucciones = "";
  DateTime startTime = DateTime.now();
  DateTime endTime = DateTime.now();
  late SolicitudPrueba selectedPrueba;
  void refreshData() async {
    setState(() {
      dataFuture = fetchData();
    });
  }

  List<PruebasModel> _lista = [];
  late Future<List<PruebasModel>> dataFuture;

  Future<List<PruebasModel>> fetchData() async {
    if (listaCarrera.isEmpty) {
      listaCarrera = await consultAllCarrera();
    }
    if (listaPeriodos.isEmpty) {
      listaPeriodos = await consultAllPeriodos();
    }
    if (listaPruebas.isEmpty) {
      listaPruebas = await consultAllPruebas();
    }
    List<SolicitudesModel> solicitudes =
        await consultAllSolicitudesByPersona(loginPerson.id);
    List<PruebasModel> response = [];
    for (SolicitudesModel item in solicitudes) {
      solicitudId = item.id;
      List<SolicitudPrueba> resp =
          await consultAllSolicitudesPruebaByPersona(item.id);
      for (SolicitudPrueba item2 in resp) {
        PruebasModel temp =
            listaPruebas.firstWhere((element) => element.id == item2.pruebasId);
        if (temp != null) {
          temp.pruebaSolicitudId = item2.id;
          temp.estatus = item2.estatus;
          response.add(temp);
        }
      }
    }
    return response;
  }

  @override
  void initState() {
    super.initState();
    dataFuture = fetchData();
  }

  void _sort<T>(Comparable<T> Function(SolicitudesModel ticket) getField,
      int columnIndex, bool ascending) {
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
      listaSolicitudes.sort((a, b) {
        final aValue = getField(a);
        final bValue = getField(b);
        return ascending
            ? Comparable.compare(aValue, bValue)
            : Comparable.compare(bValue, aValue);
      });
    });
  }

  Future<void> editMethod(PruebasModel data) async {
    showLoadingAlert(context: context);
    startTime = DateTime.now();
    await updateSolicitudesPrueba(
        data: updatePruebaModelo(
            id: data.pruebaSolicitudId!,
            fechaInicio: DateFormat('yyyy-MM-dd HH:mm').format(startTime),
            fechaTermino: "",
            estatus: 2));
    List<PreguntaRespuesta> prg = await consultaPreguntas(data.id);
    if (!mounted) {
      return;
    }
    closeLoadingAlert(context: context);
    showRespondTestModal(
        instruction: data.Instruccion ?? "",
        solicitudId: solicitudId,
        time: data.minutos!,
        questions: prg,
        ctx: context,
        close: () async {
          Navigator.pop(context);
          showLoadingAlert(context: context);
          endTime = DateTime.now();
          await updateSolicitudesPrueba(
            data: updatePruebaModelo(
                id: data.pruebaSolicitudId!,
                fechaInicio: DateFormat('yyyy-MM-dd HH:mm').format(startTime),
                fechaTermino: DateFormat('yyyy-MM-dd HH:mm').format(endTime),
                estatus: 3),
          );
          window.location.reload();
        });
  }

  final horizontalController = ScrollController();
  final verticalController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: FutureBuilder<List<PruebasModel>>(
          future: dataFuture,
          builder: (BuildContext context,
              AsyncSnapshot<List<PruebasModel>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: loadingPage(),
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              _lista = snapshot.data!;
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        width: 15,
                      ),
                      Text(
                        "Solicitudes",
                        style: TextStyle(
                            color: orange2,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
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
                                      padding:
                                          const EdgeInsets.only(bottom: 20),
                                      child: DataTable(
                                        sortColumnIndex: _sortColumnIndex,
                                        sortAscending: _sortAscending,
                                        headingTextStyle: const TextStyle(
                                            color: Colors.white),
                                        headingRowColor:
                                            MaterialStateColor.resolveWith(
                                                (states) => orange4),
                                        columns: [
                                          DataColumn(
                                            label: SizedBox(
                                              width: MediaQuery.sizeOf(context)
                                                      .width *
                                                  0.1,
                                              child: Text('Nombre',
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                            ),
                                          ),
                                          DataColumn(
                                            label: SizedBox(
                                              width: MediaQuery.sizeOf(context)
                                                      .width *
                                                  0.1,
                                              child: Text('Estatus',
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                            ),
                                          ),
                                          DataColumn(
                                            label: SizedBox(
                                              width: MediaQuery.sizeOf(context)
                                                      .width *
                                                  0.1,
                                              child: Text('Tiempo',
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                            ),
                                          ),
                                          const DataColumn(
                                            label: Text(''),
                                          ),
                                        ],
                                        rows: List<DataRow>.generate(
                                          _lista.length,
                                          (index) => DataRow(
                                            cells: [
                                              DataCell(
                                                  Text(_lista[index].nombre!)),
                                              DataCell(Text(statusTest[
                                                  int.parse(_lista[index]
                                                          .estatus!) -
                                                      1])),
                                              DataCell(
                                                  Text(_lista[index].tiempo!)),
                                              _lista[index].estatus == "1"
                                                  ? DataCell(InkWell(
                                                      onTap: () => editMethod(
                                                          _lista[index]),
                                                      child: const Text(
                                                        "Contestar",
                                                        style: TextStyle(
                                                            color: Colors
                                                                .blueAccent),
                                                      ),
                                                    ))
                                                  : const DataCell(Text("")),
                                            ],
                                          ),
                                        ),
                                      )),
                                ),
                              ),
                            ))),
                  )
                ],
              );
            }
          },
        ));
  }
}

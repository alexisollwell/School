import 'package:flutter/material.dart';

import '../../../../components/LoaginPage.dart';
import '../../../../constants.dart';
import '../../../../models/SolicitudesModel.dart';
import '../../../../services/carreraServices.dart';
import '../../../../services/periodoServices.dart';
import '../../../../services/personaServices.dart';
import '../../../../services/solicitudesServices.dart';

class Reportes extends StatefulWidget {
  const Reportes({super.key});

  @override
  State<Reportes> createState() => _ReportesState();
}

class _ReportesState extends State<Reportes> {
  int _sortColumnIndex = 0;
  bool _sortAscending = true;

  void refreshData() async {
    setState(() {
      dataFuture = fetchData();
    });
  }

  late Future<List<SolicitudesModel>> dataFuture;
  List<SolicitudesModel> _listaSolicitudes = [];
  Future<List<SolicitudesModel>> fetchData() async {
    if (listaCarrera.isEmpty) {
      listaCarrera = await consultAllCarrera();
    }
    if (listaPeriodos.isEmpty) {
      listaPeriodos = await consultAllPeriodos();
    }
    if (listaPersonas.isEmpty) {
      listaPersonas = await consultAllPersonas();
    }
    return await consultAllSolicitudesALL();
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

  final horizontalController = ScrollController();
  final verticalController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        body: FutureBuilder<List<SolicitudesModel>>(
          future: dataFuture,
          builder: (BuildContext context,
              AsyncSnapshot<List<SolicitudesModel>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: loadingPage(),
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              _listaSolicitudes = snapshot.data!;
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
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
                                                (states) => Colors.grey),
                                        columns: [
                                          DataColumn(
                                            label: SizedBox(
                                              width: MediaQuery.sizeOf(context)
                                                      .width *
                                                  0.1,
                                              child: Text('Fecha Aplicacion',
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
                                              child: Text('Comentarios',
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                            ),
                                          ),
                                          DataColumn(
                                            label: SizedBox(
                                              width: MediaQuery.sizeOf(context)
                                                      .width *
                                                  0.1,
                                              child: Text('Carrera',
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                            ),
                                          ),
                                          DataColumn(
                                            label: SizedBox(
                                              width: MediaQuery.sizeOf(context)
                                                      .width *
                                                  0.1,
                                              child: Text('Periodo',
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                            ),
                                          ),
                                          DataColumn(
                                            label: SizedBox(
                                              width: MediaQuery.sizeOf(context)
                                                      .width *
                                                  0.1,
                                              child: Text('Asignado',
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                            ),
                                          ),
                                          DataColumn(
                                            label: SizedBox(
                                              width: MediaQuery.sizeOf(context)
                                                      .width *
                                                  0.1,
                                              child: Text('Resultados',
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                            ),
                                          ),
                                          DataColumn(
                                            label: SizedBox(
                                              width: MediaQuery.sizeOf(context)
                                                      .width *
                                                  0.1,
                                              child: Text('Fecha Analisis',
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                            ),
                                          ),
                                          DataColumn(
                                            label: SizedBox(
                                              width: MediaQuery.sizeOf(context)
                                                      .width *
                                                  0.1,
                                              child: Text('Excel',
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                            ),
                                          ),
                                        ],
                                        rows: List<DataRow>.generate(
                                          _listaSolicitudes.length,
                                          (index) => DataRow(
                                            color: MaterialStateProperty.all<
                                                Color>(Colors.white),
                                            cells: [
                                              DataCell(Text(
                                                  _listaSolicitudes[index]
                                                      .fechaAplicacion!)),
                                              DataCell(Text(statusTest[
                                                  int.parse(_listaSolicitudes[
                                                              index]
                                                          .estatus!) -
                                                      1])),
                                              DataCell(Text(
                                                  _listaSolicitudes[index]
                                                          .comentarios ??
                                                      "")),
                                              DataCell(Text(listaCarrera
                                                  .firstWhere((element) =>
                                                      element.id ==
                                                      _listaSolicitudes[index]
                                                          .carreraId!)
                                                  .nombre!)),
                                              DataCell(Text(listaPeriodos
                                                  .firstWhere((element) =>
                                                      element.id ==
                                                      _listaSolicitudes[index]
                                                          .periodoId!)
                                                  .nombre!)),
                                              DataCell(Text(listaPersonas
                                                  .firstWhere((element) =>
                                                      element.id ==
                                                      _listaSolicitudes[index]
                                                          .personaId!)
                                                  .nombre!)),
                                              DataCell(Text(
                                                  _listaSolicitudes[index]
                                                          .Resultados ??
                                                      "")),
                                              DataCell(Text(
                                                  _listaSolicitudes[index]
                                                          .Fecha_analisis ??
                                                      ""),),
                                              DataCell(Icon(Icons.file_present_outlined))
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

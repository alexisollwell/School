import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:school/services/carreraServices.dart';
import 'package:school/services/divisionesServices.dart';

import '../../../../components/LoadingAlert.dart';
import '../../../../components/LoaginPage.dart';
import '../../../../components/OkDialogAlert.dart';
import '../../../../components/addDialogV1.dart';
import '../../../../components/addDialogV2.dart';
import '../../../../components/addDialogV3.dart';
import '../../../../components/add_button_design.dart';
import '../../../../components/decisionDialogAlert.dart';
import '../../../../components/refresh_button_design.dart';
import '../../../../constants.dart';
import '../../../../models/CarreraModel.dart';
import '../../../../models/DivisionesModel.dart';
import '../campus/campus.dart';

class Carreras extends StatefulWidget {
  const Carreras({super.key});

  @override
  State<Carreras> createState() => _CarrerasState();
}

class _CarrerasState extends State<Carreras> {
  int _sortColumnIndex = 0;
  bool _sortAscending = true;

  void refreshData() async {
    setState(() {
      dataFuture = fetchData();
    });
  }

  List<String> types = [
    "Licenciatura",
    "Maestria",
    "Postgrado",
    "RH",
    "Externo",
    "Preparatoria"
  ];
  List<String> mode = [
    "Cuatrimestre",
    "Semestre",
    "Departamento",
  ];
  late Future<List<CarreraModel>> dataFuture;

  Future<List<CarreraModel>> fetchData() async {
    listaDivisiones = await consultAllDivision();
    return await consultAllCarrera();
  }

  @override
  void initState() {
    super.initState();
    dataFuture = fetchData();
  }

  void _sort<T>(Comparable<T> Function(CarreraModel ticket) getField,
      int columnIndex, bool ascending) {
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
      listaCarrera.sort((a, b) {
        final aValue = getField(a);
        final bValue = getField(b);
        return ascending
            ? Comparable.compare(aValue, bValue)
            : Comparable.compare(bValue, aValue);
      });
    });
  }

  Future<void> editMethod(CarreraModel data) async {
    addDialogV3(
        context: context,
        data: data,
        modalidades: mode,
        tipos: types,
        divisiones: listaDivisiones,
        title: 'Actualiza Carrera',
        action: (CarreraModel data) async {
          CarreraModel response = await updateCarrera(data: data);
          if (response.id <= 0) {
            showOkAlert(
                context: context,
                title: "Error",
                message: "Error al actualizar intenta más tarde");
            return;
          }

          setState(() {
            dataFuture = fetchData();
          });
        },
        actionCancel: () {});
  }

  Future<void> deleteMethod(CarreraModel data) async {
    bool response = await showDecisionAlert(
            title: "Atención",
            message: "Estas seguro de eliminar la carrera : ${data.nombre}",
            context: context) ??
        false;
    if (response) {
      bool httpResponse = await deleteCarrera(id: data.id);
      if (!httpResponse) {
        showOkAlert(
            context: context,
            title: "Error",
            message: "Error al eliminar intenta más tarde");
        return;
      }
      setState(() {
        dataFuture = fetchData();
      });
    }
  }

  void addMethod() {
    addDialogV3(
        context: context,
        data: CarreraModel(id: -1),
        modalidades: mode,
        tipos: types,
        divisiones: listaDivisiones,
        title: 'Agrega Carrera',
        action: (CarreraModel data) async {
          CarreraModel response = await createCarrera(data: data);
          if (response.id <= 0) {
            showOkAlert(
                context: context,
                title: "Error",
                message: "Error al insertar intenta más tarde");
            return;
          }

          setState(() {
            dataFuture = fetchData();
          });
        },
        actionCancel: () {});
  }

  final horizontalController = ScrollController();
  final verticalController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        body: FutureBuilder<List<CarreraModel>>(
          future: dataFuture,
          builder: (BuildContext context,
              AsyncSnapshot<List<CarreraModel>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: loadingPage(),
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              listaCarrera = snapshot.data!;
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      RefreshButtonDesign(
                        onTap: refreshData,
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      userType == 1
                          ? AddButtonDesign(
                              onTap: addMethod,
                            )
                          : const SizedBox(
                              width: 1,
                            ),
                      const SizedBox(
                        width: 15,
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
                                                (states) => Colors.grey),
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
                                            onSort: (columnIndex, ascending) {
                                              _sort<String>(
                                                  (ticket) => ticket.nombre!,
                                                  columnIndex,
                                                  ascending);
                                            },
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
                                            onSort: (columnIndex, ascending) {
                                              _sort<String>(
                                                  (ticket) => ticket.estatus!,
                                                  columnIndex,
                                                  ascending);
                                            },
                                          ),
                                          DataColumn(
                                            label: SizedBox(
                                              width: MediaQuery.sizeOf(context)
                                                      .width *
                                                  0.1,
                                              child: Text('Clave',
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                            ),
                                            onSort: (columnIndex, ascending) {
                                              //_sort<String>((ticket) => ticket.subCategory, columnIndex, ascending);
                                            },
                                          ),
                                          DataColumn(
                                            label: SizedBox(
                                              width: MediaQuery.sizeOf(context)
                                                      .width *
                                                  0.1,
                                              child: Text('Division',
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                            ),
                                            onSort: (columnIndex, ascending) {
                                              _sort<String>(
                                                  (ticket) => ticket
                                                      .id_division_fk
                                                      .toString(),
                                                  columnIndex,
                                                  ascending);
                                            },
                                          ),
                                          DataColumn(
                                            label: SizedBox(
                                              width: MediaQuery.sizeOf(context)
                                                      .width *
                                                  0.1,
                                              child: Text('Modalidad',
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                            ),
                                            onSort: (columnIndex, ascending) {
                                              _sort<String>(
                                                  (ticket) => ticket.modalidad
                                                      .toString(),
                                                  columnIndex,
                                                  ascending);
                                            },
                                          ),
                                          DataColumn(
                                            label: SizedBox(
                                              width: MediaQuery.sizeOf(context)
                                                      .width *
                                                  0.1,
                                              child: Text('Tipo',
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                            ),
                                            onSort: (columnIndex, ascending) {
                                              _sort<String>(
                                                  (ticket) =>
                                                      ticket.tipo.toString(),
                                                  columnIndex,
                                                  ascending);
                                            },
                                          ),
                                          const DataColumn(
                                            label: Text(''),
                                          ),
                                          const DataColumn(
                                            label: Text(''),
                                          ),
                                        ],
                                        rows: List<DataRow>.generate(
                                          listaCarrera.length,
                                          (index) => DataRow(
                                            color: MaterialStateProperty.all<
                                                Color>(Colors.white),
                                            cells: [
                                              DataCell(Text(
                                                  listaCarrera[index].nombre!)),
                                              DataCell(Text(
                                                  listaCarrera[index].estatus ==
                                                          "1"
                                                      ? "Activo"
                                                      : "Inactivo")),
                                              DataCell(Text(
                                                  listaCarrera[index].clave!)),
                                              DataCell(Text(listaDivisiones
                                                      .firstWhere((element) =>
                                                          element.id ==
                                                          listaCarrera[index]
                                                              .id_division_fk!)
                                                      .nombre ??
                                                  "")),
                                              DataCell(Text(mode[
                                                  listaCarrera[index]
                                                          .modalidad! -
                                                      1])),
                                              DataCell(Text(types[
                                                  listaCarrera[index].tipo! -
                                                      1])),
                                              DataCell(InkWell(
                                                onTap: () => editMethod(
                                                    listaCarrera[index]),
                                                child: Icon(
                                                  Icons.edit,
                                                  color: Colors.green,
                                                ),
                                              )),
                                              DataCell(InkWell(
                                                onTap: () => deleteMethod(
                                                    listaCarrera[index]),
                                                child: Icon(
                                                  Icons.delete_outline,
                                                  color: Colors.red,
                                                ),
                                              )),
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

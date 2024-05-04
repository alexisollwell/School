import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:school/services/pruebasServices.dart';

import '../../../../components/LoadingAlert.dart';
import '../../../../components/LoaginPage.dart';
import '../../../../components/OkDialogAlert.dart';
import '../../../../components/addDialogV6.dart';
import '../../../../components/decisionDialogAlert.dart';
import '../../../../constants.dart';
import '../../../../models/PruebasModel.dart';
import '../campus/campus.dart';

class Pruebas extends StatefulWidget {
  const Pruebas({super.key});

  @override
  State<Pruebas> createState() => _PruebasState();
}

class _PruebasState extends State<Pruebas> {
  int _sortColumnIndex = 0;
  bool _sortAscending = true;

  void refreshData() async {
    setState(() {
      dataFuture = fetchData();
    });
  }

  late Future<List<PruebasModel>> dataFuture;

  Future<List<PruebasModel>> fetchData() async {
    return await consultAllPruebas();
  }

  @override
  void initState() {
    super.initState();
    dataFuture = fetchData();
  }

  void _sort<T>(Comparable<T> Function(PruebasModel ticket) getField,
      int columnIndex, bool ascending) {
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
      listaPruebas.sort((a, b) {
        final aValue = getField(a);
        final bValue = getField(b);
        return ascending
            ? Comparable.compare(aValue, bValue)
            : Comparable.compare(bValue, aValue);
      });
    });
  }

  Future<void> editMethod(PruebasModel data) async {
    addDialogV6(
        context: context,
        data: data,
        title: 'Actualiza Prueba',
        action: (PruebasModel data) async {
          PruebasModel response = await updatePrueba(data: data);
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

  Future<void> deleteMethod(PruebasModel data) async {
    bool response = await showDecisionAlert(
            title: "Atención",
            message: "Estas seguro de eliminar el perfil : ${data.nombre}",
            context: context) ??
        false;
    if (response) {
      bool httpResponse = await deletePrueba(id: data.id);
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
    addDialogV6(
        context: context,
        data: PruebasModel(id: -1),
        title: 'Agrega Prueba',
        action: (PruebasModel data) async {
          PruebasModel response = await createPrueba(data: data);
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
              listaPruebas = snapshot.data!;
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
                        "Pruebas",
                        style: TextStyle(
                            color: orange2,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      /*InkWell(
                        onTap: addMethod,
                        child: Container(
                          height: 40,
                          width: 120,
                          decoration: BoxDecoration(
                              color: Colors.blueAccent,
                              borderRadius: BorderRadius.circular(30)),
                          child: const Row(
                            children: [
                              SizedBox(
                                width: 10,
                              ),
                              Icon(
                                Icons.add,
                                size: 30,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Agregar",
                                style: TextStyle(color: Colors.white),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                            ],
                          ),
                        ),
                      ),*/
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
                                        dataRowMaxHeight: 200,
                                        dataRowMinHeight: 60,
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
                                              child: Text('Descripción',
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
                                              child: Text('Tiempo',
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                            ),
                                            onSort: (columnIndex, ascending) {
                                              //_sort<String>((ticket) => ticket.subCategory, columnIndex, ascending);
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
                                          listaPruebas.length,
                                          (index) => DataRow(
                                            cells: [
                                              DataCell(Text(
                                                  listaPruebas[index].nombre!)),
                                              DataCell(Text(
                                                  listaPruebas[index].estatus ==
                                                          "1"
                                                      ? "Activo"
                                                      : "Inactivo")),
                                              DataCell(SizedBox(
                                                width: 300,
                                                child: Text(listaPruebas[index]
                                                    .descripcion!),
                                              )),
                                              DataCell(Text(
                                                  listaPruebas[index].tiempo!)),
                                              DataCell(InkWell(
                                                onTap: () => editMethod(
                                                    listaPruebas[index]),
                                                child: Icon(
                                                  Icons.edit,
                                                  color: Colors.green,
                                                ),
                                              )),
                                              DataCell(InkWell(
                                                onTap: () => deleteMethod(
                                                    listaPruebas[index]),
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

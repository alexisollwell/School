import 'package:flutter/material.dart';
import 'package:school/services/periodoServices.dart';
import '../../../../components/LoaginPage.dart';
import '../../../../components/OkDialogAlert.dart';
import '../../../../components/addDialogV4.dart';
import '../../../../components/add_button_design.dart';
import '../../../../components/decisionDialogAlert.dart';
import '../../../../components/refresh_button_design.dart';
import '../../../../constants.dart';
import '../../../../models/PeriodoModel.dart';

class Periodos extends StatefulWidget {
  const Periodos({super.key});

  @override
  State<Periodos> createState() => _PeriodosState();
}

class _PeriodosState extends State<Periodos> {
  int _sortColumnIndex = 0;
  bool _sortAscending = true;

  void refreshData() async {
    setState(() {
      dataFuture = fetchData();
    });
  }

  late Future<List<PeriodoModel>> dataFuture;

  Future<List<PeriodoModel>> fetchData() async {
    return await consultAllPeriodos();
  }

  @override
  void initState() {
    super.initState();
    dataFuture = fetchData();
  }

  void _sort<T>(Comparable<T> Function(PeriodoModel ticket) getField,
      int columnIndex, bool ascending) {
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
      listaPeriodos.sort((a, b) {
        final aValue = getField(a);
        final bValue = getField(b);
        return ascending
            ? Comparable.compare(aValue, bValue)
            : Comparable.compare(bValue, aValue);
      });
    });
  }

  Future<void> editMethod(PeriodoModel data) async {
    addDialogV4(
        context: context,
        data: data,
        title: 'Actualiza Periodo',
        action: (PeriodoModel data) async {
          PeriodoModel response = await updatePeriodo(data: data);
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

  Future<void> deleteMethod(PeriodoModel data) async {
    bool response = await showDecisionAlert(
            title: "Atención",
            message: "Estas seguro de eliminar el periodo : ${data.nombre}",
            context: context) ??
        false;
    if (response) {
      bool httpResponse = await deletePeriodo(id: data.id);
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
    addDialogV4(
        context: context,
        data: PeriodoModel(id: -1),
        title: 'Agrega Periodo',
        action: (PeriodoModel data) async {
          PeriodoModel response = await createPeriodo(data: data);
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
        body: FutureBuilder<List<PeriodoModel>>(
          future: dataFuture,
          builder: (BuildContext context,
              AsyncSnapshot<List<PeriodoModel>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: loadingPage(),
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              listaPeriodos = snapshot.data!;
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
                                              child: Text('Fecha Inicial',
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
                                              child: Text('Fecha Final',
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
                                          listaPeriodos.length,
                                          (index) => DataRow(
                                            color: MaterialStateProperty.all<
                                                Color>(Colors.white),
                                            cells: [
                                              DataCell(Text(listaPeriodos[index]
                                                  .nombre!)),
                                              DataCell(Text(listaPeriodos[index]
                                                          .estatus ==
                                                      "1"
                                                  ? "Activo"
                                                  : "Inactivo")),
                                              DataCell(Text(
                                                  listaPeriodos[index].clave!)),
                                              DataCell(Text(listaPeriodos[index]
                                                  .startDate!)),
                                              DataCell(Text(listaPeriodos[index]
                                                  .endDate!)),
                                              userType == 1
                                                  ? DataCell(InkWell(
                                                      onTap: () => editMethod(
                                                          listaPeriodos[index]),
                                                      child: Icon(
                                                        Icons.edit,
                                                        color: Colors.green,
                                                      ),
                                                    ))
                                                  : const DataCell(Text("")),
                                              userType == 1
                                                  ? DataCell(InkWell(
                                                      onTap: () => deleteMethod(
                                                          listaPeriodos[index]),
                                                      child: Icon(
                                                        Icons.delete_outline,
                                                        color: Colors.red,
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

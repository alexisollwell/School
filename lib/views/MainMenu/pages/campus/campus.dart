import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:school/constants.dart';

import '../../../../components/LoadingAlert.dart';
import '../../../../components/LoaginPage.dart';
import '../../../../components/OkDialogAlert.dart';
import '../../../../components/addDialogV1.dart';
import '../../../../components/add_button_design.dart';
import '../../../../components/decisionDialogAlert.dart';
import '../../../../components/refresh_button_design.dart';
import '../../../../models/CampusModel.dart';
import '../../../../services/campusServices.dart';

class Campus extends StatefulWidget {
  const Campus({super.key});

  @override
  State<Campus> createState() => _CampusState();
}

class _CampusState extends State<Campus> {
  int _sortColumnIndex = 0;
  bool _sortAscending = true;

  void refreshData() async {
    setState(() {
      dataFuture = fetchData();
    });
  }

  late Future<List<CampusModel>> dataFuture;

  Future<List<CampusModel>> fetchData() async {
    return await consultAllCampus();
  }

  @override
  void initState() {
    super.initState();
    dataFuture = fetchData();
  }

  void _sort<T>(Comparable<T> Function(CampusModel ticket) getField,
      int columnIndex, bool ascending) {
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
      campus.sort((a, b) {
        final aValue = getField(a);
        final bValue = getField(b);
        return ascending
            ? Comparable.compare(aValue, bValue)
            : Comparable.compare(bValue, aValue);
      });
    });
  }

  Future<void> editCampus(CampusModel data) async {
    addDialogV1(
        context: context,
        field1: "Nombre",
        fieldValue1: data.nombre!,
        field2: "Estatus",
        fieldValue2: data.estatus!,
        title: 'Actualiza Campus',
        action: (String name, bool status) async {
          CampusModel response = await updateCampus(
            data: CampusModel(
                nombre: name, estatus: status ? "1" : "0", id: data.id),
          );
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

  Future<void> deleteCampusMethod(CampusModel data) async {
    bool response = await showDecisionAlert(
            title: "Atención",
            message: "Estas seguro de eliminar el Campus : ${data.nombre}",
            context: context) ??
        false;
    if (response) {
      bool httpResponse = await deleteCampus(id: data.id);
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

  void addCampusMethod() {
    addDialogV1(
        context: context,
        field1: "Nombre",
        fieldValue1: "",
        field2: "Estatus",
        fieldValue2: "0",
        title: 'Agrega Campus',
        action: (String name, bool status) async {
          CampusModel response = await createCampus(
            data: CampusModel(nombre: name, estatus: status ? "1" : "0", id: 0),
          );
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
        backgroundColor: Colors.grey[100],
        body: FutureBuilder<List<CampusModel>>(
          future: dataFuture,
          builder: (BuildContext context,
              AsyncSnapshot<List<CampusModel>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: loadingPage(),
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              campus = snapshot.data!;
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
                      AddButtonDesign(
                        onTap: addCampusMethod,
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
                                                  0.2,
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
                                                  0.2,
                                              child: Text('Estatus',
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
                                          campus.length,
                                          (index) => DataRow(
                                            color: MaterialStateProperty.all<
                                                Color>(Colors.white),
                                            cells: [
                                              DataCell(
                                                  Text(campus[index].nombre!)),
                                              DataCell(Text(
                                                  campus[index].estatus == "1"
                                                      ? "Activo"
                                                      : "Inactivo")),
                                              DataCell(InkWell(
                                                onTap: () =>
                                                    editCampus(campus[index]),
                                                child: Icon(
                                                  Icons.edit,
                                                  color: Colors.green,
                                                ),
                                              )),
                                              DataCell(InkWell(
                                                onTap: () => deleteCampusMethod(
                                                    campus[index]),
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

class UserTickets {}

class UserTicketsResponse {}

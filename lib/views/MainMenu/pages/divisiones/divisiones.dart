import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:school/services/divisionesServices.dart';
import '../../../../components/LoaginPage.dart';
import '../../../../components/OkDialogAlert.dart';
import '../../../../components/addDialogV1.dart';
import '../../../../components/addDialogV2.dart';
import '../../../../components/decisionDialogAlert.dart';
import '../../../../constants.dart';
import '../../../../models/DivisionesModel.dart';

class Divisiones extends StatefulWidget {
  const Divisiones({super.key});

  @override
  State<Divisiones> createState() => _DivisionesState();
}

class _DivisionesState extends State<Divisiones> {
  int _sortColumnIndex = 0;
  bool _sortAscending = true;

  void refreshData() async {
    setState(() {
      dataFuture = fetchData();
    });
  }

  late Future<List<DivisionesModel>> dataFuture;

  Future<List<DivisionesModel>> fetchData() async {
    return await consultAllDivision();
  }

  @override
  void initState() {
    super.initState();
    dataFuture = fetchData();
  }

  void _sort<T>(Comparable<T> Function(DivisionesModel ticket) getField,
      int columnIndex, bool ascending) {
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
      listaDivisiones.sort((a, b) {
        final aValue = getField(a);
        final bValue = getField(b);
        return ascending
            ? Comparable.compare(aValue, bValue)
            : Comparable.compare(bValue, aValue);
      });
    });
  }

  Future<void> editMethod(DivisionesModel data) async {
    addDialogV1(
        context: context,
        field1: "Nombre",
        fieldValue1: data.nombre!,
        field2: "Estatus",
        fieldValue2: data.estatus!,
        title: 'Actualiza División',
        action: (String name, bool status) async {
          DivisionesModel response = await updateDivision(
            data: DivisionesModel(
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

  Future<void> deleteMethod(DivisionesModel data) async {
    bool response = await showDecisionAlert(
            title: "Atención",
            message: "Estas seguro de eliminar la división : ${data.nombre}",
            context: context) ??
        false;
    if (response) {
      bool httpResponse = await deleteDivision(id: data.id);
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
    addDialogV2(
        context: context,
        field1: "Nombre",
        fieldValue1: "",
        field2: "Estatus",
        fieldValue2: "0",
        field3: "Clave",
        fieldValue3: "",
        title: 'Agrega División',
        action: (String name, bool status, String clave) async {
          DivisionesModel response = await createDivision(
            data: DivisionesModel(
                nombre: name, estatus: status ? "1" : "0", id: 0, clave: clave),
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
        backgroundColor: Colors.white,
        body: FutureBuilder<List<DivisionesModel>>(
          future: dataFuture,
          builder: (BuildContext context,
              AsyncSnapshot<List<DivisionesModel>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: loadingPage(),
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              listaDivisiones = snapshot.data!;
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
                        "Divisiones",
                        style: TextStyle(
                            color: orange2,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      InkWell(
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
                                              child: Text('Clave',
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
                                          listaDivisiones.length,
                                          (index) => DataRow(
                                            cells: [
                                              DataCell(Text(
                                                  listaDivisiones[index]
                                                      .nombre!)),
                                              DataCell(Text(
                                                  listaDivisiones[index]
                                                              .estatus ==
                                                          "1"
                                                      ? "Activo"
                                                      : "Inactivo")),
                                              DataCell(Text(
                                                  listaDivisiones[index]
                                                      .clave!)),
                                              DataCell(InkWell(
                                                onTap: () => editMethod(
                                                    listaDivisiones[index]),
                                                child: Icon(
                                                  Icons.edit,
                                                  color: Colors.green,
                                                ),
                                              )),
                                              DataCell(InkWell(
                                                onTap: () => deleteMethod(
                                                    listaDivisiones[index]),
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

import 'package:flutter/material.dart';
import 'package:school/components/LoadingAlert.dart';
import 'package:school/services/perfilServices.dart';
import 'package:school/services/pruebasServices.dart';
import '../../../../components/LoaginPage.dart';
import '../../../../components/OkDialogAlert.dart';
import '../../../../components/addDialogV5.dart';
import '../../../../components/addDialogV9.dart';
import '../../../../components/add_button_design.dart';
import '../../../../components/decisionDialogAlert.dart';
import '../../../../components/profileModal.dart';
import '../../../../components/refresh_button_design.dart';
import '../../../../constants.dart';
import '../../../../models/PerfilModel.dart';
import '../../../../models/PruebasModel.dart';
import '../../../../models/PruebasPerfil.dart';

class Perfil extends StatefulWidget {
  const Perfil({super.key});

  @override
  State<Perfil> createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  int _sortColumnIndex = 0;
  bool _sortAscending = true;

  void refreshData() async {
    setState(() {
      dataFuture = fetchData();
    });
  }

  late Future<List<PerfilModel>> dataFuture;

  Future<List<PerfilModel>> fetchData() async {
    if (listaPruebas.isEmpty) {
      listaPruebas = await consultAllPruebas();
    }
    return await consultAllPerfil();
  }

  @override
  void initState() {
    super.initState();
    dataFuture = fetchData();
  }

  void _sort<T>(Comparable<T> Function(PerfilModel ticket) getField,
      int columnIndex, bool ascending) {
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
      listaPerfiles.sort((a, b) {
        final aValue = getField(a);
        final bValue = getField(b);
        return ascending
            ? Comparable.compare(aValue, bValue)
            : Comparable.compare(bValue, aValue);
      });
    });
  }

  Future<void> editMethod(PerfilModel data) async {
    addDialogV5(
        context: context,
        data: data,
        title: 'Actualiza Perfil',
        action: (PerfilModel data) async {
          PerfilModel response = await updatePerfil(data: data);
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

  Future<void> deleteMethod(PerfilModel data) async {
    bool response = await showDecisionAlert(
            title: "Atención",
            message: "Estas seguro de eliminar el perfil : ${data.nombre}",
            context: context) ??
        false;
    if (response) {
      bool httpResponse = await deletePerfil(id: data.id);
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
    addDialogV5(
        context: context,
        data: PerfilModel(id: -1),
        title: 'Agrega Perfil',
        action: (PerfilModel data) async {
          PerfilModel response = await createPerfil(data: data);
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

  void addTestMethod(PerfilModel data) {
    showProfileTestModal(
        ctx: context,
        profile: data,
        tests: listaPruebas,
        delete: (PruebasPerfil data2) async {
          Navigator.pop(context);
          showLoadingAlert(context: context);
          bool response = await deletePerfilPrueba(data: data2);
          closeLoadingAlert(context: context);
          if (!response) {
            showOkAlert(
                context: context,
                title: "Error",
                message: "Error al eliminar intenta más tarde");
            return;
          }
          addTestMethod(data);
        },
        add: () {
          Navigator.pop(context);
          addDialogV9(
              context: context,
              title: 'Selecciona una prueba para el perfil:\n \n${data.nombre}',
              tests: listaPruebas,
              action: (PruebasModel data2) async {
                showLoadingAlert(context: context);
                PruebasPerfil response = await createPerfilPrueba(
                    data: PruebasPerfil(
                        perfil_id: data.id,
                        prueba_id: data2.id,
                        Descripcion: data2.descripcion,
                        Tiempo: data2.tiempo));
                closeLoadingAlert(context: context);
                if (response.prueba_id <= 0) {
                  showOkAlert(
                      context: context,
                      title: "Error",
                      message: "Error al insertar intenta más tarde");
                  return;
                }
                addTestMethod(data);
              });
        });
  }

  final horizontalController = ScrollController();
  final verticalController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        body: FutureBuilder<List<PerfilModel>>(
          future: dataFuture,
          builder: (BuildContext context,
              AsyncSnapshot<List<PerfilModel>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: loadingPage(),
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              listaPerfiles = snapshot.data!;
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
                        onTap: addMethod,
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
                                              child: Text('Descripción',
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
                                          const DataColumn(
                                            label: Text(''),
                                          ),
                                        ],
                                        rows: List<DataRow>.generate(
                                          listaPerfiles.length,
                                          (index) => DataRow(
                                            color: MaterialStateProperty.all<
                                                Color>(Colors.white),
                                            cells: [
                                              DataCell(Text(listaPerfiles[index]
                                                  .nombre!)),
                                              DataCell(Text(listaPerfiles[index]
                                                          .estatus ==
                                                      "1"
                                                  ? "Activo"
                                                  : "Inactivo")),
                                              DataCell(Text(listaPerfiles[index]
                                                  .descripcion!)),
                                              DataCell(InkWell(
                                                onTap: () => editMethod(
                                                    listaPerfiles[index]),
                                                child: const Icon(
                                                  Icons.edit,
                                                  color: Colors.green,
                                                ),
                                              )),
                                              DataCell(InkWell(
                                                onTap: () => deleteMethod(
                                                    listaPerfiles[index]),
                                                child: const Icon(
                                                  Icons.delete_outline,
                                                  color: Colors.red,
                                                ),
                                              )),
                                              DataCell(InkWell(
                                                onTap: () => addTestMethod(
                                                    listaPerfiles[index]),
                                                child: const Icon(
                                                  Icons.newspaper_outlined,
                                                  color: Colors.blue,
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

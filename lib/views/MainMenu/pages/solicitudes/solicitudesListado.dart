import 'package:flutter/material.dart';
import 'package:school/constants.dart';
import 'package:school/services/personaServices.dart';
import 'package:school/services/solicitudesServices.dart';
import '../../../../components/LoaginPage.dart';
import '../../../../components/OkDialogAlert.dart';
import '../../../../components/addDialogV10.dart';
import '../../../../components/add_button_design.dart';
import '../../../../components/decisionDialogAlert.dart';
import '../../../../components/refresh_button_design.dart';
import '../../../../components/resultTestModal.dart';
import '../../../../models/SolicitudesModel.dart';
import '../../../../services/carreraServices.dart';
import '../../../../services/periodoServices.dart';

class SolicitudesListado extends StatefulWidget {
  final void Function() onAdd;
  const SolicitudesListado({super.key, required this.onAdd});

  @override
  State<SolicitudesListado> createState() => _SolicitudesListadoState();
}

class _SolicitudesListadoState extends State<SolicitudesListado> {
  int _sortColumnIndex = 0;
  bool _sortAscending = true;
  TextEditingController controllerName = TextEditingController();

  void refreshData() async {
    setState(() {
      dataFuture = fetchData();
    });
  }

  late Future<List<SolicitudesModel>> dataFuture;

  List<SolicitudesModel> show = [];
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
    show = await consultAllSolicitudes(userId);
    return show;
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

  Future<void> editMethod(SolicitudesModel data) async {
    addDialogV10(
      context: context,
      data: data,
      title: 'Actualiza Solicitud',
      action: (SolicitudesModel data2) async {
        SolicitudesModel response = await updateSolicitudes(data: data2);
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
    );
  }

  Future<void> watchResultsMethod(SolicitudesModel data) async {
    showResultTestModal(
        solicitudId: data.id,
        ctx: context,
        close: () {
          Navigator.pop(context);
        });
  }

  Future<void> deleteMethod(SolicitudesModel data) async {
    bool response = await showDecisionAlert(
            title: "Atención",
            message: "Estas seguro de eliminar solicitud : ${data.id}",
            context: context) ??
        false;
    if (response) {
      bool httpResponse = await deleteSolicitudes(id: data.id);
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
    widget.onAdd();
  }

  void search(String? value) {
    if (value!.isEmpty) {
      show = listaSolicitudes;
    } else {
      show = [];
      for (var item in listaSolicitudes) {
        var prs =
            listaPersonas.firstWhere((element) => element.id == item.personaId);
        if (prs.nombre!.toLowerCase().contains(value.toLowerCase()) ||
            prs.apellido!.toLowerCase().contains(value.toLowerCase())) {
          show.add(item);
        }
      }
    }
    setState(() {});
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
              listaSolicitudes = snapshot.data!;
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
                                          show.length,
                                          (index) => DataRow(
                                            color: MaterialStateProperty.all<
                                                Color>(Colors.white),
                                            cells: [
                                              DataCell(Text(show[index]
                                                  .fechaAplicacion!)),
                                              DataCell(Text(statusTest[
                                                  int.parse(show[index]
                                                          .estatus!) -
                                                      1])),
                                              DataCell(Text(
                                                  "${listaPersonas.firstWhere((element) => element.id == show[index].personaId!).nombre!} ${listaPersonas.firstWhere((element) => element.id == show[index].personaId!).apellido!}")),
                                              DataCell(Text(
                                                  show[index].comentarios ??
                                                      "")),
                                              DataCell(Text(listaCarrera
                                                  .firstWhere((element) =>
                                                      element.id ==
                                                      show[index].carreraId!)
                                                  .nombre!)),
                                              DataCell(Text(listaPeriodos
                                                  .firstWhere((element) =>
                                                      element.id ==
                                                      show[index].periodoId!)
                                                  .nombre!)),
                                              DataCell(Text(
                                                  show[index].Resultados ??
                                                      "")),
                                              DataCell(Text(
                                                  show[index].Fecha_analisis ??
                                                      "")),
                                              DataCell(InkWell(
                                                onTap: () => watchResultsMethod(
                                                    show[index]),
                                                child: Icon(
                                                  Icons.remove_red_eye,
                                                  color: Colors.blue,
                                                ),
                                              )),
                                              DataCell(InkWell(
                                                onTap: () =>
                                                    editMethod(show[index]),
                                                child: Icon(
                                                  Icons.edit,
                                                  color: Colors.green,
                                                ),
                                              )),
                                              DataCell(InkWell(
                                                onTap: () =>
                                                    deleteMethod(show[index]),
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

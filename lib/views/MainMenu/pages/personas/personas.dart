import 'package:flutter/material.dart';
import 'package:school/models/user/UserRegisterResponse.dart';
import 'package:school/models/user/updatePassword.dart';
import 'package:school/services/campusServices.dart';
import 'package:school/services/personaServices.dart';
import '../../../../components/LoaginPage.dart';
import '../../../../components/OkDialogAlert.dart';
import '../../../../components/addDialogV7.dart';
import '../../../../components/addDialogV8.dart';
import '../../../../components/add_button_design.dart';
import '../../../../components/decisionDialogAlert.dart';
import '../../../../components/refresh_button_design.dart';
import '../../../../constants.dart';
import '../../../../models/user/PersonaModel.dart';
import '../../../../models/user/UserRegisterRequest.dart';

class Personas extends StatefulWidget {
  const Personas({super.key});

  @override
  State<Personas> createState() => _PersonasState();
}

class _PersonasState extends State<Personas> {
  int _sortColumnIndex = 0;
  bool _sortAscending = true;
  List<String> type = [];

  void refreshData() async {
    setState(() {
      dataFuture = fetchData();
    });
  }

  late Future<List<PersonaModel>> dataFuture;
  List<PersonaModel> show = [];
  Future<List<PersonaModel>> fetchData() async {
    if (campus.isEmpty) {
      campus = await consultAllCampus();
    }
    show = await consultAllPersonas();
    return show;
  }

  @override
  void initState() {
    super.initState();
    type.add("Todos");
    type.addAll(typeUsers);
    selectedType = type[0];
    dataFuture = fetchData();
  }

  void _sort<T>(Comparable<T> Function(PersonaModel ticket) getField,
      int columnIndex, bool ascending) {
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
      listaPersonas.sort((a, b) {
        final aValue = getField(a);
        final bValue = getField(b);
        return ascending
            ? Comparable.compare(aValue, bValue)
            : Comparable.compare(bValue, aValue);
      });
    });
  }

  Future<void> editMethod(PersonaModel data) async {
    addDialogV8(
      context: context,
      campus: campus,
      data: data,
      title: 'Actualiza Usuario',
      action: (PersonaModel data, UpdatePassword pss) async {
        if (pss.password.isNotEmpty) {
          await updatePersonaPassword(data: data, pss: pss);
        }
        PersonaModel response = await updatePersona(data: data);
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

  Future<void> deleteMethod(PersonaModel data) async {
    bool response = await showDecisionAlert(
            title: "Atención",
            message: "Estas seguro de eliminar el perfil : ${data.nombre}",
            context: context) ??
        false;
    if (response) {
      bool httpResponse = await deletePersona(id: data.id);
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
    addDialogV7(
        context: context,
        typeUserL: userType == 1 ? typeUsers : ["Evaluado"],
        campus: campus,
        title: 'Agrega Usuarios',
        action: (UserRegisterRequest request1, PersonaModel request2) async {
          UserRegisterResponse response =
              await createUser(data: request1, request: request2);
          if (response.token == null) {
            showOkAlert(
                context: context,
                title: "Error",
                message: "Error al insertar intenta más tarde");
            return;
          }
          setState(() {
            dataFuture = fetchData();
          });
        });
  }

  final horizontalController = ScrollController();
  final verticalController = ScrollController();

  String selectedType = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        body: FutureBuilder<List<PersonaModel>>(
          future: dataFuture,
          builder: (BuildContext context,
              AsyncSnapshot<List<PersonaModel>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: loadingPage(),
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              listaPersonas = snapshot.data!;
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
                      DropdownMenu<String>(
                        initialSelection: selectedType,
                        onSelected: (value) {
                          setState(() {
                            selectedType = value!;
                            if (selectedType == type[0]) {
                              show = listaPersonas;
                            } else {
                              int typeInt = type.indexOf(selectedType);
                              show = listaPersonas
                                  .where((element) => element.tipo == typeInt)
                                  .toList();
                            }
                          });
                        },
                        dropdownMenuEntries:
                            type.map<DropdownMenuEntry<String>>((String value) {
                          return DropdownMenuEntry<String>(
                              value: value, label: value);
                        }).toList(),
                      ),
                      const Spacer(),
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
                                              child: Text('Apellido',
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                            ),
                                            onSort: (columnIndex, ascending) {
                                              _sort<String>(
                                                  (ticket) => ticket.apellido!,
                                                  columnIndex,
                                                  ascending);
                                            },
                                          ),
                                          DataColumn(
                                            label: SizedBox(
                                              width: MediaQuery.sizeOf(context)
                                                      .width *
                                                  0.1,
                                              child: Text('Fecha Nacimiento',
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                            ),
                                            onSort: (columnIndex, ascending) {
                                              /* _sort<String>(
                                                      (ticket) => ticket.apellido!,
                                                  columnIndex,
                                                  ascending);*/
                                            },
                                          ),
                                          DataColumn(
                                            label: SizedBox(
                                              width: MediaQuery.sizeOf(context)
                                                      .width *
                                                  0.1,
                                              child: Text('Domicilio',
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                            ),
                                            onSort: (columnIndex, ascending) {
                                              /* _sort<String>(
                                                      (ticket) => ticket.apellido!,
                                                  columnIndex,
                                                  ascending);*/
                                            },
                                          ),
                                          DataColumn(
                                            label: SizedBox(
                                              width: MediaQuery.sizeOf(context)
                                                      .width *
                                                  0.1,
                                              child: Text('Telefono',
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                            ),
                                            onSort: (columnIndex, ascending) {
                                              /* _sort<String>(
                                                      (ticket) => ticket.apellido!,
                                                  columnIndex,
                                                  ascending);*/
                                            },
                                          ),
                                          DataColumn(
                                            label: SizedBox(
                                              width: MediaQuery.sizeOf(context)
                                                      .width *
                                                  0.1,
                                              child: Text('Correo',
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                            ),
                                            onSort: (columnIndex, ascending) {
                                              /* _sort<String>(
                                                      (ticket) => ticket.apellido!,
                                                  columnIndex,
                                                  ascending);*/
                                            },
                                          ),
                                          DataColumn(
                                            label: SizedBox(
                                              width: MediaQuery.sizeOf(context)
                                                      .width *
                                                  0.1,
                                              child: Text('Edo Civil',
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                            ),
                                            onSort: (columnIndex, ascending) {
                                              /* _sort<String>(
                                                      (ticket) => ticket.apellido!,
                                                  columnIndex,
                                                  ascending);*/
                                            },
                                          ),
                                          DataColumn(
                                            label: SizedBox(
                                              width: MediaQuery.sizeOf(context)
                                                      .width *
                                                  0.1,
                                              child: Text('Nacionalidad',
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                            ),
                                            onSort: (columnIndex, ascending) {
                                              /* _sort<String>(
                                                      (ticket) => ticket.apellido!,
                                                  columnIndex,
                                                  ascending);*/
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
                                              child: Text('Campus',
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
                                              child: Text('Tipo Usuario',
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                            ),
                                            onSort: (columnIndex, ascending) {
                                              /* _sort<String>(
                                                      (ticket) => ticket.apellido!,
                                                  columnIndex,
                                                  ascending);*/
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
                                          show.length,
                                          (index) => DataRow(
                                            color: MaterialStateProperty.all<
                                                Color>(Colors.white),
                                            cells: [
                                              DataCell(
                                                  Text(show[index].nombre!)),
                                              DataCell(
                                                  Text(show[index].apellido!)),
                                              DataCell(
                                                  Text(show[index].fechaNaC!)),
                                              DataCell(
                                                  Text(show[index].domicilio!)),
                                              DataCell(
                                                  Text(show[index].telefono!)),
                                              DataCell(
                                                  Text(show[index].correo!)),
                                              DataCell(
                                                  Text(show[index].edoCivil!)),
                                              DataCell(Text(
                                                  show[index].nacionalidad!)),
                                              DataCell(Text(
                                                  show[index].estatus == "1"
                                                      ? "Activo"
                                                      : "Inactivo")),
                                              DataCell(Text(campus
                                                  .firstWhere((element) =>
                                                      element.id ==
                                                      show[index].campusId!)
                                                  .nombre!)),
                                              DataCell(Text(typeUsers[
                                                  show[index].tipo! - 1])),
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

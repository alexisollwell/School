import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:school/components/LoadingAlert.dart';
import 'package:school/services/perfilServices.dart';
import 'package:school/services/solicitudesServices.dart';
import '../../../../components/LoaginPage.dart';
import '../../../../components/OkDialogAlert.dart';
import '../../../../components/addDialogV7.dart';
import '../../../../components/profileModal.dart';
import '../../../../constants.dart';
import '../../../../models/CarreraModel.dart';
import '../../../../models/PerfilModel.dart';
import '../../../../models/PeriodoModel.dart';
import '../../../../models/PruebasModel.dart';
import '../../../../models/PruebasPerfil.dart';
import '../../../../models/SolicitudesModel.dart';
import '../../../../models/user/PersonaModel.dart';
import '../../../../models/user/UserRegisterRequest.dart';
import '../../../../models/user/UserRegisterResponse.dart';
import '../../../../services/campusServices.dart';
import '../../../../services/carreraServices.dart';
import '../../../../services/periodoServices.dart';
import '../../../../services/personaServices.dart';
import '../../../../services/pruebasServices.dart';

class Solicitudes extends StatefulWidget {
  final void Function() goList;
  const Solicitudes({super.key, required this.goList});

  @override
  State<Solicitudes> createState() => _SolicitudesState();
}

class _SolicitudesState extends State<Solicitudes> {
  late PersonaModel selectedPersonModel;
  late CarreraModel selectedCarrera;
  late PeriodoModel selectedPeriodo;
  late PerfilModel selectedPerfil;
  late DateTime testDate;
  late String selectedTypeTest;
  late List<PruebasModel> selectedTests;

  void refreshData() async {
    setState(() {
      dataFuture = fetchData();
    });
  }

  void refreshSelectedTest(PruebasModel item) {
    int index = selectedTests.indexOf(item);
    if (index >= 0) {
      setState(() {
        selectedTests.removeAt(index);
      });
    } else {
      setState(() {
        selectedTests.add(item);
      });
    }
  }

  Widget validateSelectedTest(PruebasModel item) {
    int index = selectedTests.indexOf(item);
    if (index >= 0) {
      return const Icon(
        Icons.check_box_outlined,
        color: Colors.green,
      );
    } else {
      return const Icon(
        Icons.check_box_outline_blank_sharp,
        color: Colors.grey,
      );
    }
  }

  List<String> testTypes = ["Perfil", "Pruebas"];
  late Future<List<PersonaModel>> dataFuture;

  Future<List<PersonaModel>> fetchData() async {
    if (campus.isEmpty) {
      campus = await consultAllCampus();
    }
    if (listaCarrera.isEmpty) {
      listaCarrera = await consultAllCarrera();
    }
    if (listaPeriodos.isEmpty) {
      listaPeriodos = await consultAllPeriodos();
    }
    if (listaPerfiles.isEmpty) {
      listaPerfiles = await consultAllPerfil();
    }
    if (listaPruebas.isEmpty) {
      listaPruebas = await consultAllPruebas();
    }
    return await consultAllPersonas();
  }

  void seeTestsProfile(PerfilModel data) {
    showProfileTestModal(
        ctx: context,
        profile: data,
        hide: true,
        tests: listaPruebas,
        delete: (PruebasPerfil data2) {},
        add: () {});
  }

  void addSolicitud() async {
    showLoadingAlert(context: context);
    List<int> idtest = [];
    if (selectedTypeTest == testTypes[1]) {
      for (PruebasModel item in selectedTests) {
        idtest.add(item.id);
      }
    } else {
      List<PruebasPerfil> relation =
          await consultAllPerfilTest(id: selectedPerfil.id);
      for (PruebasPerfil item in relation) {
        idtest.add(item.prueba_id);
      }
    }
    SolicitudesModel resp = await createSolicitudes(
        data: SolicitudesModel(
            id: -1,
            estatus: "1",
            fechaAplicacion: DateFormat('yyyy-MM-dd HH:mm').format(testDate),
            comentarios: "",
            usuarioCapturoId: userId,
            carreraId: selectedCarrera.id,
            periodoId: selectedPeriodo.id,
            personaId: selectedPersonModel.id),
        tests: idtest);
    closeLoadingAlert(context: context);
    if (resp.id <= 0) {
      showOkAlert(
          title: "Atención",
          message: "Error al insertar prueba",
          context: context);
      return;
    }
    widget.goList();
  }

  @override
  void initState() {
    super.initState();
    dataFuture = fetchData();
    testDate = DateTime.now();
    selectedPersonModel = listaPersonas.isEmpty
        ? PersonaModel(id: -1, nombre: "")
        : listaPersonas[0];
    selectedCarrera = listaCarrera.isEmpty
        ? CarreraModel(id: -1, nombre: "")
        : listaCarrera[0];
    selectedPeriodo = listaPeriodos.isEmpty
        ? PeriodoModel(id: -1, nombre: "")
        : listaPeriodos[0];
    selectedPerfil = listaPerfiles.isEmpty
        ? PerfilModel(id: -1, nombre: "")
        : listaPerfiles[0];
    selectedTypeTest = testTypes[0];
    selectedTests = [];
  }

  void addPersonMethod() {
    addDialogV7(
        context: context,
        campus: campus,
        typeUserL: ["Evaluado"],
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<List<PersonaModel>>(
        future: dataFuture,
        builder:
            (BuildContext context, AsyncSnapshot<List<PersonaModel>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: loadingPage(),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            listaPersonas = snapshot.data!;
            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        width: 15,
                      ),
                      const Text("Selecciona una persona:"),
                      const SizedBox(
                        width: 15,
                      ),
                      DropdownMenu<PersonaModel>(
                        initialSelection: selectedPersonModel,
                        onSelected: (value) {
                          setState(() {
                            selectedPersonModel = value!;
                          });
                        },
                        dropdownMenuEntries: listaPersonas
                            .map<DropdownMenuEntry<PersonaModel>>(
                                (PersonaModel value) {
                          return DropdownMenuEntry<PersonaModel>(
                              value: value, label: value.nombre!);
                        }).toList(),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      InkWell(
                              onTap: addPersonMethod,
                              child: Container(
                                height: 40,
                                width: 175,
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
                                      "Agregar Persona",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                  ],
                                ),
                              ),
                            )
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        width: 15,
                      ),
                      const Text("Selecciona una fecha para prueba:"),
                      const SizedBox(
                        width: 15,
                      ),
                      InkWell(
                        onTap: () {
                          showDatePicker(
                                  context: context,
                                  initialDate: testDate,
                                  firstDate: DateTime.now()
                                      .add(const Duration(days: -700)),
                                  lastDate: DateTime.now().add(const Duration(
                                      days:
                                          365))) //what will be the up to supported date in picker
                              .then((pickedDate) async {
                            if (pickedDate == null) {
                              return;
                            }

                            final TimeOfDay? pickedTime = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.fromDateTime(pickedDate),
                            );
                            if (pickedTime != null) {
                              pickedDate = DateTime(
                                pickedDate.year,
                                pickedDate.month,
                                pickedDate.day,
                                pickedTime.hour,
                                pickedTime.minute,
                              );
                            } else {
                              return;
                            }

                            setState(() {
                              testDate = pickedDate!;
                            });
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.blueAccent,
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            DateFormat('yyyy-MM-dd HH:mm').format(testDate),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        width: 15,
                      ),
                      const Text("Selecciona una Carrera:"),
                      const SizedBox(
                        width: 15,
                      ),
                      DropdownMenu<CarreraModel>(
                        initialSelection: selectedCarrera,
                        onSelected: (value) {
                          setState(() {
                            selectedCarrera = value!;
                          });
                        },
                        dropdownMenuEntries: listaCarrera
                            .map<DropdownMenuEntry<CarreraModel>>(
                                (CarreraModel value) {
                          return DropdownMenuEntry<CarreraModel>(
                              value: value, label: value.nombre!);
                        }).toList(),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        width: 15,
                      ),
                      const Text("Selecciona un periodo:"),
                      const SizedBox(
                        width: 15,
                      ),
                      DropdownMenu<PeriodoModel>(
                        initialSelection: selectedPeriodo,
                        onSelected: (value) {
                          setState(() {
                            selectedPeriodo = value!;
                          });
                        },
                        dropdownMenuEntries: listaPeriodos
                            .map<DropdownMenuEntry<PeriodoModel>>(
                                (PeriodoModel value) {
                          return DropdownMenuEntry<PeriodoModel>(
                              value: value, label: value.nombre!);
                        }).toList(),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        width: 15,
                      ),
                      const Text("Selecciona un tipo de valuación:"),
                      const SizedBox(
                        width: 15,
                      ),
                      DropdownMenu<String>(
                        initialSelection: selectedTypeTest,
                        onSelected: (value) {
                          setState(() {
                            selectedTypeTest = value!;
                          });
                        },
                        dropdownMenuEntries: testTypes
                            .map<DropdownMenuEntry<String>>((String value) {
                          return DropdownMenuEntry<String>(
                              value: value, label: value);
                        }).toList(),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  selectedTypeTest == testTypes[0]
                      ? Row(
                          children: [
                            const SizedBox(
                              width: 15,
                            ),
                            const Text("Selecciona un perfil:"),
                            const SizedBox(
                              width: 15,
                            ),
                            DropdownMenu<PerfilModel>(
                              initialSelection: selectedPerfil,
                              onSelected: (value) {
                                setState(() {
                                  selectedPerfil = value!;
                                });
                              },
                              dropdownMenuEntries: listaPerfiles
                                  .map<DropdownMenuEntry<PerfilModel>>(
                                      (PerfilModel value) {
                                return DropdownMenuEntry<PerfilModel>(
                                    value: value, label: value.nombre!);
                              }).toList(),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            selectedPerfil.id > 0
                                ? InkWell(
                                    onTap: () =>
                                        seeTestsProfile(selectedPerfil),
                                    child: Container(
                                      height: 40,
                                      width: 180,
                                      decoration: BoxDecoration(
                                          color: Colors.blueAccent,
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                      child: const Row(
                                        children: [
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Icon(
                                            Icons.remove_red_eye,
                                            size: 30,
                                            color: Colors.white,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            "Ver Pruebas",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : const SizedBox(
                                    width: 1,
                                  )
                          ],
                        )
                      : const SizedBox(
                          width: 1,
                        ),
                  selectedTypeTest == testTypes[1]
                      ? Padding(
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
                                          headingTextStyle: const TextStyle(
                                              color: Colors.white),
                                          headingRowColor:
                                              MaterialStateColor.resolveWith(
                                                  (states) => orange4),
                                          columns: [
                                            DataColumn(
                                              label: SizedBox(
                                                width:
                                                    MediaQuery.sizeOf(context)
                                                            .width *
                                                        0.1,
                                                child: Text('Nombre',
                                                    style: TextStyle(
                                                        color: Colors.white)),
                                              ),
                                            ),
                                            DataColumn(
                                              label: SizedBox(
                                                width:
                                                    MediaQuery.sizeOf(context)
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
                                                width:
                                                    MediaQuery.sizeOf(context)
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
                                          ],
                                          rows: List<DataRow>.generate(
                                            listaPruebas.length,
                                            (index) => DataRow(
                                              cells: [
                                                DataCell(Text(
                                                    listaPruebas[index]
                                                        .nombre!)),
                                                DataCell(SizedBox(
                                                  width: 300,
                                                  child: Text(
                                                      listaPruebas[index]
                                                          .descripcion!),
                                                )),
                                                DataCell(Text(
                                                    listaPruebas[index]
                                                        .tiempo!)),
                                                DataCell(InkWell(
                                                    onTap: () =>
                                                        refreshSelectedTest(
                                                            listaPruebas[
                                                                index]),
                                                    child: validateSelectedTest(
                                                        listaPruebas[index]))),
                                              ],
                                            ),
                                          ),
                                        )),
                                  ),
                                ),
                              )))
                      : const SizedBox(
                          width: 1,
                        ),
                  const SizedBox(
                    height: 30,
                  ),
                  Center(
                    child: InkWell(
                      onTap: addSolicitud,
                      child: Container(
                        height: 40,
                        width: 175,
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
                              "Agregar Solicitud",
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

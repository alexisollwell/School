import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:school/components/LoaginPage.dart';
import 'package:school/components/accept_button_design.dart';
import 'package:school/constants.dart';
import 'package:school/models/CampusModel.dart';
import 'package:school/models/CarreraModel.dart';
import 'package:school/models/PerfilModel.dart';
import 'package:school/models/PeriodoModel.dart';
import 'package:school/models/user/PersonaModel.dart';
import 'package:school/services/campusServices.dart';
import 'package:school/services/carreraServices.dart';
import 'package:school/services/perfilServices.dart';
import 'package:school/services/periodoServices.dart';
import 'package:school/services/personaServices.dart';

class CargaMasiva extends StatefulWidget {
  const CargaMasiva({super.key});

  @override
  State<CargaMasiva> createState() => _CargaMasivaState();
}

class _CargaMasivaState extends State<CargaMasiva> {

  late CarreraModel selectedCarrera;
  late PeriodoModel selectedPeriodo;
  late PerfilModel selectedPerfil;
  late CampusModel selectedCampus;
  late Future<List<PersonaModel>> dataFuture;
  void refreshData() async {
    setState(() {
      dataFuture = fetchData();
    });
  }

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
    return await consultAllPersonas();
  }

  @override
  void initState() {
    super.initState();
    dataFuture = fetchData();
    selectedCampus = campus.isEmpty
        ? CampusModel(id: -1)
        : campus[0];
    selectedCarrera = listaCarrera.isEmpty
        ? CarreraModel(id: -1, nombre: "")
        : listaCarrera[0];
    selectedPeriodo = listaPeriodos.isEmpty
        ? PeriodoModel(id: -1, nombre: "")
        : listaPeriodos[0];
    selectedPerfil = listaPerfiles.isEmpty
        ? PerfilModel(id: -1, nombre: "")
        : listaPerfiles[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
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
            return Expanded(
              child: LayoutBuilder(
                builder: (_,constraint){
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 15,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 50,
                            width: constraint.constrainHeight()*0.3,
                            child: DropdownMenu<CampusModel>(
                              initialSelection: selectedCampus,
                              onSelected: (value) {
                                setState(() {
                                  selectedCampus = value!;
                                });
                              },
                              dropdownMenuEntries: campus
                                  .map<DropdownMenuEntry<CampusModel>>(
                                      (CampusModel value) {
                                return DropdownMenuEntry<CampusModel>(
                                    value: value, label: value.nombre!);
                              }).toList(),
                            ),
                          ),
                          SizedBox(
                            height: 50,
                            width: constraint.constrainHeight()*0.3,
                            child: DropdownMenu<PeriodoModel>(
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
                          ),                       
                        ],
                      ),
                      const SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [                       
                          SizedBox(
                            height: 50,
                            width: constraint.constrainHeight()*0.3,
                            child: DropdownMenu<CarreraModel>(
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
                          ),
                          SizedBox(
                            height: 50,
                            width: constraint.constrainHeight()*0.3,
                            child: DropdownMenu<PerfilModel>(
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
                          ),
                        ],
                      ),
                      const SizedBox(height: 50,),
                      AcceptButtonDesign(
                        title: "Cargar",
                        onTap: () {
                        },
                      ),
                    ],
                  );
                }
              )
            );
          }
        },
      ),
    );
  }
}


/**Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            height: 15,
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (_,constraint){
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DropdownMenu<CampusModel>(
                        initialSelection: selectedCampus,
                        onSelected: (value) {
                          setState(() {
                            selectedCampus = value!;
                          });
                        },
                        dropdownMenuEntries: campus
                            .map<DropdownMenuEntry<CampusModel>>(
                                (CampusModel value) {
                          return DropdownMenuEntry<CampusModel>(
                              value: value, label: value.nombre!);
                        }).toList(),
                      ),
                        SizedBox(
                          width: constraint.constrainHeight()*0.3,
                          height: 50,
                          child: const CupertinoTextField(
                            placeholder: "Periodo",
                            placeholderStyle: TextStyle(
                              color: Colors.black,
                            ),
                            textAlignVertical: TextAlignVertical.top,
                          ),
                        ),
                        SizedBox(
                          width: constraint.constrainHeight()*0.3,
                          height: 50,
                          child: const CupertinoTextField(
                            placeholder: "Carrera",
                            placeholderStyle: TextStyle(
                              color: Colors.black,
                            ),
                            textAlignVertical: TextAlignVertical.top,
                          ),
                        ),
                        SizedBox(
                          width: constraint.constrainHeight()*0.3,
                          height: 50,
                          child: const CupertinoTextField(
                            placeholder: "Perfil",
                            placeholderStyle: TextStyle(
                              color: Colors.black,
                            ),
                            textAlignVertical: TextAlignVertical.top,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 10,),
                    AcceptButtonDesign(
                      title: "Cargar",
                      onTap: () {
                      },
                    ),
                  ],
                );
              }
            )
          ),
        ],
      ) */
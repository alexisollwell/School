import 'package:flutter/material.dart';

import '../constants.dart';
import '../models/PerfilModel.dart';
import '../models/PruebasModel.dart';
import '../models/PruebasPerfil.dart';
import '../services/perfilServices.dart';

void showProfileTestModal(
    {required PerfilModel profile,
    required List<PruebasModel> tests,
    required BuildContext ctx,
    required void Function(PruebasPerfil) delete,
    required void Function() add,
    bool? hide}) async {
  final horizontalController = ScrollController();
  final verticalController = ScrollController();

  List<PruebasPerfil> relation = await consultAllPerfilTest(id: profile.id);
  hide = hide ?? false;
  List<PruebasModel> showTest = [];
  for (PruebasPerfil item in relation) {
    PruebasModel search =
        tests.firstWhere((element) => element.id == item.prueba_id);
    if (search.nombre != null) {
      showTest.add(search);
    }
  }
  if (!ctx.mounted) {
    return;
  }
  showModalBottomSheet<void>(
    context: ctx,
    isScrollControlled: true,
    constraints: BoxConstraints(
      maxWidth: MediaQuery.of(ctx).size.width * 0.9,
    ),
    builder: (BuildContext context) {
      return StatefulBuilder(builder: (BuildContext ctx, StateSetter stst) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.95,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(20), topLeft: Radius.circular(20)),
              border: Border.all(color: Colors.grey)),
          child: Column(
            children: [
              SizedBox(
                height: 50,
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    !hide!
                        ? InkWell(
                            onTap: add,
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
                          )
                        : const SizedBox(
                            width: 1,
                          ),
                    const SizedBox(
                      width: 50,
                    ),
                    InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(Icons.close_rounded)),
                    const SizedBox(
                      width: 15,
                    )
                  ],
                ),
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
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: DataTable(
                                    dataRowMaxHeight: 200,
                                    dataRowMinHeight: 60,
                                    headingTextStyle:
                                        const TextStyle(color: Colors.white),
                                    headingRowColor:
                                        MaterialStateColor.resolveWith(
                                            (states) => orange4),
                                    columns: [
                                      DataColumn(
                                        label: SizedBox(
                                          width:
                                              MediaQuery.sizeOf(context).width *
                                                  0.2,
                                          child: const Text('Nombre',
                                              style: TextStyle(
                                                  color: Colors.white)),
                                        ),
                                      ),
                                      DataColumn(
                                        label: SizedBox(
                                          width:
                                              MediaQuery.sizeOf(context).width *
                                                  0.2,
                                          child: const Text('Descripción',
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
                                              MediaQuery.sizeOf(context).width *
                                                  0.2,
                                          child: const Text('Tiempo',
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
                                      showTest.length,
                                      (index) => DataRow(
                                        cells: [
                                          DataCell(
                                              Text(showTest[index].nombre!)),
                                          DataCell(SizedBox(
                                            width: 300,
                                            child: Text(
                                                showTest[index].descripcion!),
                                          )),
                                          DataCell(
                                              Text(showTest[index].tiempo!)),
                                          !hide!
                                              ? DataCell(InkWell(
                                                  onTap: () {
                                                    delete(PruebasPerfil(
                                                        perfil_id: profile.id,
                                                        prueba_id:
                                                            showTest[index].id,
                                                        Descripcion:
                                                            showTest[index]
                                                                .descripcion,
                                                        Tiempo: showTest[index]
                                                            .tiempo));
                                                  },
                                                  child: const Icon(
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
          ),
        );
      });
    },
  );
}

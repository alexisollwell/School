import 'package:flutter/material.dart';

import '../constants.dart';
import '../models/PerfilModel.dart';
import '../models/PreguntaRespuesta.dart';
import '../models/PruebasModel.dart';
import '../models/PruebasPerfil.dart';
import '../services/perfilServices.dart';
import '../views/MainMenu/pages/userTest/carrouselDesign.dart';
import 'counter.dart';

void showRespondTestModal({
  required int solicitudId,
  required int time,
  required String instruction,
  required List<PreguntaRespuesta> questions,
  required BuildContext ctx,
  required void Function() close,
}) async {
  showModalBottomSheet<void>(
    context: ctx,
    isScrollControlled: true,
    isDismissible: false,
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
                    const SizedBox(
                      width: 15,
                    ),
                    const Spacer(),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text("Tiempo de la prueba"),
                        Counter(close: close, timeMinute: time),
                      ],
                    ),
                    const Spacer(),
                    /*InkWell(
                      onTap: close,
                      child: const Icon(Icons.close_rounded)),*/
                    const SizedBox(
                      width: 15,
                    )
                  ],
                ),
              ),
              const Spacer(),
              CarrouselDesign(
                instruction: instruction,
                solicitudId: solicitudId,
                preguntas: questions,
                onEnd: close,
              ),
              const Spacer(
                flex: 2,
              ),
            ],
          ),
        );
      });
    },
  );
}

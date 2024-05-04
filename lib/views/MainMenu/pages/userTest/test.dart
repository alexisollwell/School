import 'package:flutter/material.dart';

import '../../../../components/counter.dart';
import '../../../../models/PreguntaRespuesta.dart';
import 'carrouselDesign.dart';

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {

  List<PreguntaRespuesta> questions = [
    PreguntaRespuesta(
      pregunta: Pregunta(id: 1,pregunta: "Pregunta #1",orden: 1,valor: 1,agrupador: 1,pruebasId: 5,grupoRespuestaId: 1,estatus: 1),
      respuestas: [
        Respuesta(id: 1, respuesta: "No me gusta para nada", orden: 1, valor: 1, grupoId: 1, estatus: 1),
        Respuesta(id: 2, respuesta: "No me gusta", orden: 2, valor: 1, grupoId: 1, estatus: 1),
        Respuesta(id: 3, respuesta: "Neutral", orden: 3, valor: 1, grupoId: 1, estatus: 1),
        Respuesta(id: 4, respuesta: "Si me gusta", orden: 4, valor: 1, grupoId: 1, estatus: 1),
        Respuesta(id: 5, respuesta: "Me gusta mucho", orden: 5, valor: 1, grupoId: 1, estatus: 1),
      ]
    ),
    PreguntaRespuesta(
        pregunta: Pregunta(id: 2,pregunta: "Pregunta #2",orden: 1,valor: 1,agrupador: 1,pruebasId: 5,grupoRespuestaId: 1,estatus: 1),
        respuestas: [
          Respuesta(id: 1, respuesta: "No me gusta para nada", orden: 1, valor: 1, grupoId: 1, estatus: 1),
          Respuesta(id: 2, respuesta: "No me gusta", orden: 2, valor: 1, grupoId: 1, estatus: 1),
          Respuesta(id: 3, respuesta: "Neutral", orden: 3, valor: 1, grupoId: 1, estatus: 1),
          Respuesta(id: 4, respuesta: "Si me gusta", orden: 4, valor: 1, grupoId: 1, estatus: 1),
          Respuesta(id: 5, respuesta: "Me gusta mucho", orden: 5, valor: 1, grupoId: 1, estatus: 1),
        ]
    ),
    PreguntaRespuesta(
        pregunta: Pregunta(id: 3,pregunta: "Pregunta #3",orden: 1,valor: 1,agrupador: 1,pruebasId: 5,grupoRespuestaId: 1,estatus: 1),
        respuestas: [
          Respuesta(id: 1, respuesta: "No me gusta para nada", orden: 1, valor: 1, grupoId: 1, estatus: 1),
          Respuesta(id: 2, respuesta: "No me gusta", orden: 2, valor: 1, grupoId: 1, estatus: 1),
          Respuesta(id: 3, respuesta: "Neutral", orden: 3, valor: 1, grupoId: 1, estatus: 1),
          Respuesta(id: 4, respuesta: "Si me gusta", orden: 4, valor: 1, grupoId: 1, estatus: 1),
          Respuesta(id: 5, respuesta: "Me gusta mucho", orden: 5, valor: 1, grupoId: 1, estatus: 1),
        ]
    )
  ];
  int solicitudId = 0;
  void close(){
    print("ya se acabo akb");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Counter(close: close, timeMinute: 30),
          CarrouselDesign(
            instruction: "Contesta todas las preguntas correctamente",
            solicitudId: solicitudId,
            preguntas: questions,
            onEnd: close,
          ),
        ],
      ),
    );
  }
}



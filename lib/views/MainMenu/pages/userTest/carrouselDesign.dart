import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:school/components/LoadingAlert.dart';
import 'package:school/models/Respuesta.dart';

import '../../../../models/PreguntaRespuesta.dart';
import '../../../../services/solicitudesServices.dart';

class CarrouselDesign extends StatefulWidget {
  final int solicitudId;
  final String instruction;
  final List<PreguntaRespuesta> preguntas;
  final void Function() onEnd;
  const CarrouselDesign({super.key, required this.onEnd, required this.preguntas, required this.solicitudId,required this.instruction});

  @override
  State<CarrouselDesign> createState() => _CarrouselDesignState();
}

class _CarrouselDesignState extends State<CarrouselDesign> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }


  void nextPage(int respId, int valor) async{
    if (_currentPage < widget.preguntas.length - 1) {
      showLoadingAlert(context: context);
      await guardarRespuesta(
        data: RespuestaTest(
            solicitudId: widget.solicitudId,
            preguntaId: widget.preguntas[_currentPage].pregunta.id,
            respuestaId: respId,
            pruebaId: widget.preguntas[_currentPage].pregunta.pruebasId,
            punto: valor
        )
      );
      //await Future.delayed(Duration(seconds: 1));
      closeLoadingAlert(context: context);
      _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
    }
    else{
      showLoadingAlert(context: context);
      //await Future.delayed(Duration(seconds: 1));
      await guardarRespuesta(
          data: RespuestaTest(
              solicitudId: widget.solicitudId,
              preguntaId: widget.preguntas[_currentPage].pregunta.id,
              respuestaId: respId,
              pruebaId: widget.preguntas[_currentPage].pregunta.pruebasId,
              punto: valor
          )
      );
      //print("final");
      //print(widget.preguntas[_currentPage].pregunta.id);
      closeLoadingAlert(context: context);
      widget.onEnd();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      width: double.infinity,
      child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                physics: const NeverScrollableScrollPhysics(),
                controller: _pageController,
                itemCount: widget.preguntas.length,
                itemBuilder: (context, index) {
                  if (index < _currentPage) {
                    Future.microtask(() => _pageController.jumpToPage(_currentPage));
                  }
                  return Column(
                    children: [
                      const Row(),
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: [
                              Text("Pegunta ${_currentPage+1}/${widget.preguntas.length}",style:TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                              Text(widget.instruction,style: TextStyle(color: Colors.orange,fontSize: 20,fontWeight: FontWeight.bold),),
                              const Spacer(),
                              Text(widget.preguntas[index].pregunta.pregunta),
                              const Spacer(),
                            ],
                          ),
                        )
                      ),
                      Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: widget.preguntas[index].respuestas.length,
                          itemBuilder: (ctx,indx){
                            Respuesta resp = widget.preguntas[index].respuestas[indx];
                            return InkWell(
                              onTap: ()=>nextPage(resp.id,resp.valor),
                              child: Container(
                                width: 100,
                                padding: EdgeInsets.all(10),
                                margin: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(10)
                                ),
                                child: Center(child: Text(resp.respuesta,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)),
                              ),
                            );
                          }
                        ),
                      )
                    ],
                  );
                },
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
              ),
            ),
            //IconButton(onPressed: nextPage, icon: Icon(Icons.abc_sharp))
          ],
        ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../constants.dart';

class LoginTextField extends StatefulWidget {
  final double width;
  final String title;
  final TextEditingController controller;
  final Function? onSubmitted;
  final bool? isPassword;
  final bool? onlyNumbers;
  const LoginTextField({
    super.key,
    required this.width,
    required this.title,
    required this.controller,
    this. isPassword,
    this. onlyNumbers,
    this. onSubmitted,
  });

  @override
  State<LoginTextField> createState() => _LoginTextFieldState();
}

class _LoginTextFieldState extends State<LoginTextField> {

  late bool _isPassword;

  @override
  initState() {
    _isPassword = widget.isPassword??false;
  }

  void changePasswordVisible(){
    setState(() {
      _isPassword = !_isPassword;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.title,style: const TextStyle(color: Colors.black,fontSize: 15),),
        Container(
          height: 40,
          width: (widget.width/2)*0.8,
          decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(9)
          ),
          child: TextField(
            controller: widget.controller,
            obscuringCharacter: '*',
            obscureText: _isPassword,
            onSubmitted: (value){
              if(widget.onSubmitted!=null){
                widget.onSubmitted!();
              }
            },
            inputFormatters: (widget.onlyNumbers??false)
                            ?<TextInputFormatter>[
                                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                FilteringTextInputFormatter.digitsOnly
                              ]
                            :[],
            decoration: InputDecoration(
              suffixIcon: (widget.isPassword??false)
                  ? _isPassword
                    ? GestureDetector(
                        onTap: changePasswordVisible,
                        child: const Icon(Icons.remove_red_eye_outlined),
                      )
                    :GestureDetector(
                        onTap: changePasswordVisible,
                        child: const Icon(Icons.remove_red_eye),
                      )
                  : const Icon(null),
              fillColor: Colors.transparent,
              filled: true,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.only(
                left: 15,
                bottom: 11,
                top: 9,
                right: 15,
              ),
            ),

          ),
        )
      ],
    );
  }
}
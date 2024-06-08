import 'package:flutter/material.dart';

class AcceptButtonDesign extends StatelessWidget {
  final void Function() onTap;
  const AcceptButtonDesign({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 50,
        width: 120,
        decoration: BoxDecoration(
            color: Colors.orange, borderRadius: BorderRadius.circular(4)),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Aceptar",
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

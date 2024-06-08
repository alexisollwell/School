import 'package:flutter/material.dart';

class CancelButtonDesign extends StatelessWidget {
  final void Function() onTap;
  const CancelButtonDesign({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 50,
        width: 120,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Colors.black, width: 1)),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Cancelar",
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}

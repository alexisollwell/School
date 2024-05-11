import 'package:flutter/material.dart';

class AddButtonDesign extends StatelessWidget {
  final void Function() onTap;
  const AddButtonDesign({super.key, required this.onTap});

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
          ],
        ),
      ),
    );
  }
}

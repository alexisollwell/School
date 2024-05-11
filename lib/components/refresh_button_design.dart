import 'package:flutter/material.dart';

class RefreshButtonDesign extends StatelessWidget {
  final void Function() onTap;
  const RefreshButtonDesign({super.key, required this.onTap});

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
            border: Border.all(color: Colors.orange, width: 1)),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.refresh_rounded,
              size: 30,
              color: Colors.orange,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              "Refrescar",
              style: TextStyle(color: Colors.orange),
            ),
          ],
        ),
      ),
    );
  }
}

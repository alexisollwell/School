import 'package:flutter/material.dart';

class CloseDialogButton extends StatelessWidget {
  const CloseDialogButton({
    super.key,
    required this.width,
  });

  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 35,
      width: width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          InkWell(
            onTap: () {
              Navigator.of(context).pop(false);
            },
            child: const Icon(
              Icons.close,
              color: Colors.black,
              size: 25,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
    );
  }
}

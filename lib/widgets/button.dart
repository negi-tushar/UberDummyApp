import 'package:flutter/material.dart';

import '../brand_colors.dart';

class defaultButton extends StatelessWidget {
  const defaultButton({
    required this.title,
    this.onpressed,
    Key? key,
  }) : super(key: key);
  final String? title;
  final void Function()? onpressed;

  @override
  Widget build(BuildContext context) {
    onpressed() {}
    return ElevatedButton(
      onPressed: onpressed,
      style: ElevatedButton.styleFrom(
        primary: const Color.fromARGB(255, 33, 172, 105),
      ),
      child: Text(title!),
    );
  }
}

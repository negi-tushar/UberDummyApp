import 'package:flutter/material.dart';

// ignore: camel_case_types
class divider extends StatelessWidget {
  const divider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Divider(
      thickness: 1.0,
      color: Colors.black12,
    );
  }
}

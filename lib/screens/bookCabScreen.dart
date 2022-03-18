import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:uberdummy/brand_colors.dart';
import 'package:uberdummy/globalvariables.dart';

class BookCab extends StatelessWidget {
  const BookCab({
    Key? key,
    required this.height,
    required this.reset,
  }) : super(key: key);
  final double height;
  final Function reset;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
        height: height,
        curve: Curves.easeIn,
        duration: const Duration(microseconds: 100),
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                blurRadius: 10.0,
                spreadRadius: 0.3,
                offset: Offset(0.5, 0.3),
              )
            ]),
        // width: double.infinity,
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                child: TextLiquidFill(
                  text: 'Requesting for a Cab...',
                  waveColor: BrandColors.colorTextSemiLight,
                  boxBackgroundColor: Colors.white,
                  textStyle: const TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                  ),
                  boxHeight: 50.0,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                    border: Border.all(width: 1.0, color: Colors.black12),
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.white),
                child: IconButton(
                    icon: const Icon(
                      Icons.close,
                    ),
                    onPressed: () {
                      print('pressed');
                      rideRef.remove();
                      reset();
                    }),
              ),
              const SizedBox(
                height: 10,
              ),
              const SizedBox(
                child: Text('Cancel Ride'),
              ),
            ],
          ),
        ));
  }
}

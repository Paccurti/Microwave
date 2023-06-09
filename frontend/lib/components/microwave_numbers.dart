import 'package:flutter/material.dart';

class MicrowaveNumbers extends StatelessWidget {
  const MicrowaveNumbers({
    super.key,
    required this.firstNumber,
    required this.secondNumber,
    required this.thirdNumber,
    required this.function,
  });

  final String firstNumber;
  final String secondNumber;
  final String thirdNumber;
  final Function(String) function;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 160,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 73, 72, 72),
        borderRadius: BorderRadius.circular(
          10,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
          height: 10,
          width: 200,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(
              10,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                onTap: () {
                  String value = firstNumber;
                  function(value);
                },
                child: Text(
                  firstNumber,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
              const Text(
                '|',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
              InkWell(
                onTap: () {
                  String value = secondNumber;
                  function(value);
                },
                child: Text(
                  secondNumber,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
              const Text(
                '|',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
              InkWell(
                onTap: () {
                  String value = thirdNumber;
                  function(value);
                },
                child: Text(
                  thirdNumber,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

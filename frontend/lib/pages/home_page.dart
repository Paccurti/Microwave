import 'dart:async';
import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:microwave/models/classes/microwave.dart';
import 'package:microwave/models/cruds/microwave_list.dart';
import 'package:provider/provider.dart';

import '../components/microwave_numbers.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Microwave microwave = Microwave(
    id: 1,
    isRunning: false,
  );
  bool isOpen = false;
  bool isCooked = false;
  bool invalidTime = false;
  bool invalidPotency = false;
  Timer? timer;
  String dots = '';

  void startCountdown() {
    if (dots == 'Aquecimento concluído') {
      dots = '';
    }
    if (microwave.potency.isNull) {
      microwave.potency = 10;
    }
    Provider.of<MicrowaveList>(context, listen: false).startHeating(microwave);
    const oneSec = Duration(seconds: 1);
    timer = Timer.periodic(oneSec, (Timer timer) {
      setState(() {
        if (microwave.cookingTime! < 1) {
          timer.cancel(); // Parar a contagem regressiva quando chegar a 0
          microwave.isRunning = false;
          dots = 'Aquecimento concluído';
          isCooked = true;
        } else if (microwave.isRunning == true) {
          microwave.cookingTime = microwave.cookingTime! -
              1; // Atualizar o valor da contagem regressiva
          dots += ' ${'.' * microwave.potency!}';
        }
      });
    });
  }

  String convertToMinutes(int value) {
    int minutes = value ~/ 60; // Divisão inteira para obter os minutos
    int seconds = value % 60; // Obter os segundos restantes

    String minutesText = minutes
        .toString()
        .padLeft(2, '0'); // Converter para string com dois dígitos
    String secondsText = seconds
        .toString()
        .padLeft(2, '0'); // Converter para string com dois dígitos
    setState(() {});
    return '$minutesText:$secondsText';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Center(child: Text(widget.title)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              decoration: const BoxDecoration(
                color: Colors.grey,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isOpen == false)
                      Container(
                        height: 608,
                        width: 900,
                        decoration: const BoxDecoration(
                          color: Colors.black,
                        ),
                        child: Center(
                          child: invalidTime == false
                              ? Text(
                                  dots,
                                  style: const TextStyle(
                                    fontSize: 40,
                                    color: Colors.green,
                                  ),
                                )
                              : invalidPotency == false
                                  ? const Center(
                                      child: Text(
                                        'Digite um tempo entre 1 e 120 segundos!!!',
                                        style: TextStyle(
                                          fontSize: 40,
                                          color: Colors.green,
                                        ),
                                      ),
                                    )
                                  : const Center(
                                      child: Text(
                                        'Digite um tempo entre 1 e 120 segundos!!!',
                                        style: TextStyle(
                                          fontSize: 40,
                                          color: Colors.green,
                                        ),
                                      ),
                                    ),
                        ),
                      ),
                    if (isOpen == true)
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            height: 608,
                            width: 900,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage(
                                  'assets/images/microwave_inside.png',
                                ),
                              ),
                              // color: Colors.red,
                            ),
                          ),
                          if (isCooked == false)
                            Image.asset(
                              'assets/images/Frango-cru.png',
                              scale: 5,
                            ),
                          if (isCooked == true)
                            Image.asset(
                              'assets/images/Frango-Assado.png',
                              scale: 5,
                            )
                        ],
                      ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Column(
                        children: [
                          Container(
                            height: 500,
                            width: 200,
                            decoration: const BoxDecoration(
                              color: Colors.black,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(
                                  height: 40,
                                ),
                                Container(
                                  height: 80,
                                  width: 160,
                                  decoration: BoxDecoration(
                                    color:
                                        const Color.fromARGB(255, 73, 72, 72),
                                    borderRadius: BorderRadius.circular(
                                      20,
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
                                          20,
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          microwave.cookingTime != null &&
                                                  microwave.cookingTime! > 60 &&
                                                  microwave.cookingTime! < 100
                                              ? convertToMinutes(
                                                  microwave.cookingTime!)
                                              : microwave.cookingTime == 0
                                                  ? "00:00"
                                                  : (microwave.cookingTime ??
                                                          "00:00")
                                                      .toString(),
                                          style: const TextStyle(
                                            fontSize: 40,
                                            color: Colors.green,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const Expanded(
                                  child: SizedBox(
                                    height: 30,
                                  ),
                                ),
                                DropdownButton<int>(
                                  dropdownColor: Colors.black,
                                  value: microwave.potency,
                                  onChanged: (int? newValue) {
                                    setState(() {
                                      microwave.potency = newValue;
                                    });
                                  },
                                  items: [
                                    const DropdownMenuItem<int>(
                                      value: null,
                                      child: Text(
                                        'POTÊNCIA            ',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    for (int i = 1; i <= 10; i++)
                                      DropdownMenuItem<int>(
                                        value: i,
                                        child: Text(
                                          i.toString(),
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                MicrowaveNumbers(
                                  function: (value) {
                                    setState(() {
                                      microwave.cookingTime = int.parse(
                                          '${microwave.cookingTime ?? ''}$value');
                                      if (microwave.cookingTime! <= 0 ||
                                          microwave.cookingTime! > 120) {
                                        invalidTime = true;
                                      }
                                    });
                                  },
                                  firstNumber: '1',
                                  secondNumber: '2',
                                  thirdNumber: '3',
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                MicrowaveNumbers(
                                  function: (value) {
                                    setState(() {
                                      microwave.cookingTime = int.parse(
                                          '${microwave.cookingTime ?? ''}$value');
                                      if (microwave.cookingTime! <= 0 ||
                                          microwave.cookingTime! > 120) {
                                        invalidTime = true;
                                      }
                                    });
                                  },
                                  firstNumber: '4',
                                  secondNumber: '5',
                                  thirdNumber: '6',
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                MicrowaveNumbers(
                                  function: (value) {
                                    setState(() {
                                      microwave.cookingTime = int.parse(
                                          '${microwave.cookingTime ?? ''}$value');
                                      if (microwave.cookingTime! <= 0 ||
                                          microwave.cookingTime! > 120) {
                                        invalidTime = true;
                                      }
                                    });
                                  },
                                  firstNumber: '7',
                                  secondNumber: '8',
                                  thirdNumber: '9',
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            height: 45,
                                            width: 60,
                                            decoration: BoxDecoration(
                                              color: const Color.fromARGB(
                                                  255, 73, 72, 72),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                10,
                                              ),
                                            ),
                                            child: TextButton(
                                              onPressed: () {
                                                setState(() {
                                                  microwave.isRunning == false
                                                      ? microwave.cookingTime =
                                                          null
                                                      : microwave.isRunning =
                                                          false;
                                                  if (timer != null) {
                                                    timer!.cancel();
                                                  }
                                                  if (microwave.isRunning ==
                                                      false) {
                                                    dots = '';
                                                    invalidTime = false;
                                                  }
                                                });
                                              },
                                              child: const Text(
                                                '00',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          const Text(
                                            'PAUSAR\ncancelar',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10,
                                              color: Colors.white,
                                            ),
                                          )
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          top: 5.0,
                                          left: 1,
                                          right: 1,
                                        ),
                                        child: Container(
                                          height: 35,
                                          width: 40,
                                          decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                                255, 73, 72, 72),
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Container(
                                              height: 10,
                                              width: 10,
                                              decoration: BoxDecoration(
                                                color: Colors.black,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  10,
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        microwave.cookingTime =
                                                            int.parse(
                                                                '${microwave.cookingTime ?? ''}0');
                                                        if (microwave
                                                                    .cookingTime! <=
                                                                0 ||
                                                            microwave
                                                                    .cookingTime! >
                                                                120) {
                                                          invalidTime = true;
                                                        }
                                                      });
                                                    },
                                                    child: const Text(
                                                      '0',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 20,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            height: 45,
                                            width: 60,
                                            decoration: BoxDecoration(
                                              color: const Color.fromARGB(
                                                  255, 73, 72, 72),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                10,
                                              ),
                                            ),
                                            child: IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  if (microwave.cookingTime !=
                                                          null &&
                                                      (microwave.cookingTime! <=
                                                              0 ||
                                                          microwave
                                                                  .cookingTime! >
                                                              120)) {
                                                    invalidTime = true;
                                                  } else {
                                                    if (microwave
                                                        .cookingTime.isNull) {
                                                      microwave.cookingTime =
                                                          30;
                                                    }
                                                    if (microwave.isRunning ==
                                                        false) {
                                                      microwave.isRunning =
                                                          true;
                                                      startCountdown();
                                                    } else if (microwave
                                                                .cookingTime !=
                                                            null &&
                                                        (microwave.cookingTime! >
                                                                0 &&
                                                            microwave
                                                                    .cookingTime! <=
                                                                90)) {
                                                      microwave.cookingTime =
                                                          microwave
                                                                  .cookingTime! +
                                                              30;
                                                    }
                                                  }
                                                });
                                              },
                                              icon: const Icon(
                                                Icons.play_arrow_outlined,
                                                color: Colors.white,
                                                size: 30,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          const Text(
                                            'LIGAR\n+30 seg.',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10,
                                              color: Colors.white,
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  isOpen = !isOpen;
                                });
                              },
                              child: Container(
                                height: 100,
                                width: 200,
                                decoration: const BoxDecoration(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

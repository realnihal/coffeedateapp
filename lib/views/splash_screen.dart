// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:coffee_splashscreen/constants.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _coffeeController;
  bool copAnimated = false;
  bool animateCafeText = false;

  @override
  void initState() {
    super.initState();
    _coffeeController = AnimationController(vsync: this);
    _coffeeController.addListener(() {
      if (_coffeeController.value > 0.7) {
        _coffeeController.stop();
        copAnimated = true;
        setState(() {});
        Future.delayed(const Duration(seconds: 1), () {
          animateCafeText = true;
          setState(() {});
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _coffeeController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: cafeBrown,
      body: Stack(
        children: [
          // White Container top half
          AnimatedContainer(
            duration: const Duration(seconds: 1),
            height: copAnimated ? screenHeight / 1.9 : screenHeight,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(copAnimated ? 40.0 : 0.0),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Visibility(
                  visible: !copAnimated,
                  child: Lottie.asset(
                    'assets/coffeesplash.json',
                    controller: _coffeeController,
                    onLoaded: (composition) {
                      _coffeeController
                        ..duration = composition.duration
                        ..forward();
                    },
                  ),
                ),
                Visibility(
                  visible: copAnimated,
                  child: Image.asset(
                    'assets/coffeepic2.png',
                    height: 190.0,
                    width: 190.0,
                  ),
                ),
                Center(
                  child: AnimatedOpacity(
                    opacity: animateCafeText ? 1 : 0,
                    duration: const Duration(seconds: 1),
                    child: Column(
                      children: [
                        const Text(
                          "Let's bond over coffee",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 28.0, color: cafeBrown,fontWeight: FontWeight.bold),
                        ),
                        const Text(
                          'Nihal',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20.0, color:Colors.brown),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Text bottom part
          Visibility(visible: copAnimated, child: const _BottomPart()),
        ],
      ),
    );
  }
}

void sendMail(String name) async {
  String username = 'nihalpuram59@gmail.com';
  String password = 'Nihalpuram007';

  // ignore: deprecated_member_use
  final smtpServer = gmail(username, password);
  final equivalentMessage = Message()
    ..from = Address(username)
    ..recipients.add(const Address('puramnihal@gmail.com'))
    ..subject = 'Test Dart Mailer library :: 😀 :: ${DateTime.now()}'
    ..text = 'You got an invite for Coffee!.\n from ' + name;

  await send(equivalentMessage, smtpServer);
}

class _BottomPart extends StatefulWidget {
  const _BottomPart({Key? key}) : super(key: key);

  @override
  State<_BottomPart> createState() => _BottomPartState();
}

class _BottomPartState extends State<_BottomPart> {
  @override
  Widget build(BuildContext context) {
    String inputText = "";
    TextEditingController _controller = TextEditingController();

    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Let's meet for a cup at a click of a button",
              style: TextStyle(
                  fontSize: 27.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            Container(
              height: 20,
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.brown.shade50,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextField(
                  controller: _controller,
                  textAlign: TextAlign.center,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      floatingLabelAlignment: FloatingLabelAlignment.center,
                      labelText: "Enter your Lovely name...",
                      labelStyle: TextStyle(
                        color: Colors.grey,
                      )),
                  onChanged: (context) {
                    inputText = context;
                  },
                ),
              ),
            ),
            const SizedBox(height: 50.0),
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {
                  (inputText != "")
                      ? sendMail(inputText)
                      : print("not recieved input");
                  (inputText != "")
                      ? setState(() {
                          _controller.clear();
                          final snackBar = SnackBar(
                            backgroundColor: Colors.brown.shade600,
                            content: const Text('Yay! Message sent'),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        })
                      : print("couldnt try snackbar");
                },
                child: Container(
                  height: 85.0,
                  width: 85.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2.0),
                  ),
                  child: const Icon(
                    Icons.chevron_right,
                    size: 50.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 50.0),
          ],
        ),
      ),
    );
  }
}

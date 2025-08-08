import 'package:flutter/material.dart';
import 'package:eye_of_sauron_flutter/widgets/eye_of_sauron_widget.dart';

class EyeOfSauronScreen extends StatelessWidget {
  const EyeOfSauronScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0x00000000),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const EyeOfSauronWidget(),
            const SizedBox(height: 20),
            /*
            const Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: "\nImplemented by "),
                  TextSpan(
                    text: "Victor Jaume",
                    style: TextStyle(color: Colors.blue),
                  ),
                ],
              ),
              style: TextStyle(color: Colors.white, fontSize: 12),
              textAlign: TextAlign.center,
            ),
            */
          ],
        ),
      ),
    );
  }
}
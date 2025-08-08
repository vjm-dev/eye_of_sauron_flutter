import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:eye_of_sauron_flutter/screens/eye_of_sauron_screen.dart';

void main() {
  runApp(
    const MaterialApp(
      home: EyeOfSauronScreen(),
      debugShowCheckedModeBanner: kDebugMode
    )
  );
}

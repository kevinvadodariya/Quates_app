import 'dart:async';
import 'dart:io';

import 'package:app/home_page.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';

class splash extends StatefulWidget{
  @override
  State<splash> createState() => _splashState();
}

class _splashState extends State<splash> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 5), () {
      loadDatabase();
    });
  }

  void loadDatabase() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "quotes.db");
    var exists = await databaseExists(path);

    if (!exists) {
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      // Copy from asset
      ByteData data = await rootBundle.load(url.join("assets", "quotes.db"));
      List<int> bytes =
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Write and flush the bytes written
      await File(path).writeAsBytes(bytes, flush: true);
      Navigator.push(this.context,  MaterialPageRoute(builder: (context)=>Home_page(
      )));

    } else {
      Navigator.push(this.context,  MaterialPageRoute(builder: (context)=>Home_page(
      )));
    }
  }


  @override
  Widget build(BuildContext context) {
    return const Scaffold(
    body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image(
          image: AssetImage("lib/Images/welcome-sign.png"),
        ),
        CircularProgressIndicator(color:Colors.redAccent ,)
      ],
    )
    );
  }
}
import 'dart:io';
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:app/Database/quotes_model.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';

import 'Database/database_helper.dart';

class Quotes extends StatefulWidget {
  final int ID;

  Quotes({required this.ID, Key? key}) : super(key: key);

  @override
  State<Quotes> createState() => _QuotesState();
}

class _QuotesState extends State<Quotes> {
  final List<GlobalObjectKey<FormState>> formKeyList =
      List.generate(200, (index) => GlobalObjectKey<FormState>(index));
  List<bool> isQuoteDownloaded = List.generate(200, (index) => false);

  List<String> imageList = [
    "img1.jpg",
    "img2.jpg",
    "img3.jpg",
    "img4.jpg",
    "img5.jpg",
    "img6.jpg",
    "img7.jpg",
    "img8.jpg",
    "img9.jpg",
    "img10.jpg",
    "img11.jpg",
    "img12.jpg",
    "img13.jpg",
    "img14.jpg",
    "img15.jpg",
    "img16.jpg",
    "img18.jpg",
    "img19.jpg",
    "img20.jpg",
    "img21.jpg",
    "img22.jpg",
    "img24.jpg",
    "img25.jpg",
    "img26.jpg",
    "img27.jpg",
    "img29.jpg",
    "img30.jpg",
    "img31.jpg"
  ];


  // int originalSize = 800;
  List<QuotesModel> quotesList = [];
  bool isLoading = true;
  DatabaseHelper helper = DatabaseHelper();
  late List<bool> isQuoteCopiedList;

  Future<void> loadQuotesDataData() async {
    try {
      quotesList.clear();
      var dbUpdateListDB = await helper.getDbUpdateList1(widget.ID);
      if (dbUpdateListDB.isNotEmpty) {
        quotesList.addAll(dbUpdateListDB);
      }
    } finally {
      isLoading = false;
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    loadQuotesDataData();
    isQuoteCopiedList = List.generate(200, (index) => false);
  }

  // var quotes=["जो सभी का मित्र होता है, वो किसी का मित्र नहीं होता। ~अरस्तू"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          titleTextStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          title: Text("Quotes"),
          centerTitle: true,
          toolbarHeight: 70,
        ),
        body: ListView.builder(
          itemBuilder: (context, index) {
            isLoading == false;

            SizedBox(
              child: CircularProgressIndicator(
                color: Colors.redAccent,
              ),
            );
            return Padding(
              padding: const EdgeInsets.only(
                  top: 10, bottom: 20, left: 30, right: 30),
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.center,
                    height: 200,
                    // width: 500,
                    color: Colors.white70,
                    child: RepaintBoundary(
                      key: formKeyList[index],
                      child: Container(
                        padding: EdgeInsets.only(top: 20, left: 10, right: 10),
                        decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage(
                                "assets/image/${imageList[index % imageList.length]}",
                              ),
                            ),
                            borderRadius: BorderRadius.circular(20),
                            // color: Colors.cyan,
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                color: Colors.grey,
                                blurRadius: 5.0,
                              ),
                            ]),
                        child: Container(
                            alignment: Alignment.center,
                            // color: Colors.white,
                            height: 206,
                            width: 350,
                            child: Text(quotesList[index].quote.toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.normal,
                                    letterSpacing: 0.5,
                                    wordSpacing: 0))),
                      ),
                    ),
                  ),
                  Container(
                    width:270,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        IconButton(
                            padding: EdgeInsets.only(left: 30,),
                            onPressed: () {
                              int? id = quotesList[index].id;
                              int? likedCount = quotesList[index].liked;

                              if (id != null && likedCount != null) {
                                setState(() {

                                  if (likedCount == 0) {
                                    likedCount = 1; // Increment liked count
                                    // likedQuotesList.add(quotesList[index]); // Add quote to likedQuotesList
                                  } else {
                                    likedCount = 0; // Decrement liked count
                                    // likedQuotesList.removeWhere((quote) => quote.id == id); // Remove quote from likedQuotesList
                                  }
                                  quotesList[index].liked = likedCount;
                                });

                                // print("kevin ${likedQuotesList}");
                                helper.updateQuoteLikedStatus(
                                    id,
                                    likedCount ??
                                        0); // Update liked count in the database
                              }
                            },

                            icon: Icon(
                              Icons.thumb_up_outlined,
                              color: quotesList[index].liked != null &&
                                      quotesList[index].liked! > 0
                                  ? Colors.red
                                  : null,
                              size: 30,
                            )),
                        IconButton(
                            padding: EdgeInsets.only(left: 30,),
                            onPressed: () {
                              _download(index);
                            },
                            icon: Icon(isQuoteDownloaded[index] ? Icons.save : Icons.save_alt, size: 30)),
                        IconButton(
                          padding: EdgeInsets.only(left: 30),
                            onPressed: () {
                              Clipboard.setData(ClipboardData(
                                      text: quotesList[index].quote.toString()))
                                  .then((_) {
                                setState(() {
                                  isQuoteCopiedList = List.generate(quotesList.length, (index) => false); // Reset all icons
                                  isQuoteCopiedList[index] = true; // Update icon
                                });
                                Fluttertoast.showToast(
                                  msg: "Quote Copied...",
                                  toastLength: Toast.LENGTH_SHORT,
                                  timeInSecForIosWeb: 1,
                                );
                              });
                            },
                          icon:  isQuoteCopiedList[index] ? Icon(Icons.check,color: Colors.deepOrange,size: 30) : Icon(Icons.copy_outlined,size: 30),

                        ),
                        PopupMenuButton<String>(
                          icon: Icon(
                            Icons.share_outlined,
                            size: 28,
                          ),
                          padding: EdgeInsets.only(left: 30),
                          color: Colors.lightBlue,
                          onSelected: (value) {
                            if (value == 'text') {
                              // Perform action for sharing as text
                              FlutterShare.share(
                                  title: '♥ Best Quotes & Status ♥',
                                  text: quotesList[index].quote);
                            } else if (value == 'image') {
                              _capturePng(index);
                            }
                          },
                          itemBuilder: (BuildContext context) {
                            return [
                              PopupMenuItem(
                                value: 'text',
                                // Unique value for sharing as text
                                child: Text(
                                  "As Text",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FontStyle.normal,
                                    letterSpacing: 0,
                                    wordSpacing: 0,
                                  ),
                                ),
                              ),
                              PopupMenuItem(
                                value: 'image',
                                // Unique value for sharing as image
                                child: Text(
                                  "As Image",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FontStyle.normal,
                                    letterSpacing: 0,
                                    wordSpacing: 0,
                                  ),
                                ),
                              ),
                            ];
                          },
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
          itemCount: quotesList.length,
        ));
  }

  Future<void> _capturePng(int index) async {
    try {
      RenderRepaintBoundary boundary = formKeyList[index]
          .currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage();

      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      final String dir = (await getApplicationDocumentsDirectory()).path;
      final String fullPath = '$dir/${DateTime.now().millisecond}.png';
      File capturedFile = File(fullPath);
      await capturedFile.writeAsBytes(pngBytes);
      print(capturedFile.path);

      Share.shareFiles([capturedFile.path], text: 'Check out these quotes!');
    } catch (e) {
      print(e);
    }
  }

  Future<void> _download(int index) async {
    try {
      RenderRepaintBoundary boundary = formKeyList[index]
          .currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage();

      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();
      setState(() {
        isQuoteDownloaded[index] = true;
      });

      await ImageGallerySaver.saveImage(pngBytes);
      Fluttertoast.showToast(
        msg: "Quotes Is Downloaded",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
      );
    } catch (e) {
      print(e);
    }
  }
}

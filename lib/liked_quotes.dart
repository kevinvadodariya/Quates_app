import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'Database/database_helper.dart';
import 'Database/quotes_model.dart';

class Liked_Quotes extends StatefulWidget {
  @override
  State<Liked_Quotes> createState() => _Liked_QuotesState();
}

class _Liked_QuotesState extends State<Liked_Quotes> {
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
  List<QuotesModel> quotesList = [];

  late List<QuotesModel> likedQuotesList;

  DatabaseHelper helper = DatabaseHelper();

  void fetchLikedQuotes() async {
    likedQuotesList = await helper.getLikedQuotes();
    // Update the state to rebuild the widget with the fetched data
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    fetchLikedQuotes();
  }

  final List<GlobalObjectKey<FormState>> formKeyList =
      List.generate(200, (index) => GlobalObjectKey<FormState>(index));
  List<bool> isQuoteDownloaded = List.generate(200, (index) => false);

  @override
  Widget build(BuildContext context) {
    late List<bool> isQuoteCopiedList;

    List<QuotesModel> filteredQuotesList =
        likedQuotesList.where((quote) => quote.liked == 1).toList();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        titleTextStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        title: Text("Liked Quotes"),
        toolbarHeight: 70,
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: filteredQuotesList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Column(
              children: [
                RepaintBoundary(
                  key: formKeyList[index],
                  child: Container(
                    decoration: BoxDecoration(
                      // color: Colors.blue,
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage(
                          "assets/image/${imageList[index % imageList.length]}",
                        ),
                      ),
                    ),
                    child: Container(
                        alignment: Alignment.center,
                        // color: Colors.white,
                        height: 180,
                        width: 350,
                        child: Text(likedQuotesList[index].quote.toString(),
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
                SizedBox(
                  height: 4,
                ),
                Container(
                  width: 230,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    // color: Colors.blue,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                          padding: EdgeInsets.only(left: 23, right: 23),
                          onPressed: () {
                            _download(index);
                          },
                          icon: Icon(
                            Icons.save_alt_outlined,
                            size: 30,
                          )),
                      IconButton(
                          padding: EdgeInsets.only(left: 23, right: 23),
                          onPressed: () {
                            // print("kevin ${likedQuotesList[index].quote.toString()}");
                            Clipboard.setData(ClipboardData(
                                    text: likedQuotesList[index]
                                        .quote
                                        .toString()))
                                .then((_) {
                              setState(() {
                                isQuoteCopiedList = List.generate(
                                    likedQuotesList.length,
                                    (index) => false); // Reset all icons
                                isQuoteCopiedList[index] = true; // Update icon
                              });
                              Fluttertoast.showToast(
                                msg: "Quote Copied...",
                                toastLength: Toast.LENGTH_SHORT,
                                timeInSecForIosWeb: 1,
                              );
                            });
                          },
                          icon: Icon(
                            Icons.copy,
                            size: 30,
                          )),
                      IconButton(
                          padding: EdgeInsets.only(left: 23, right: 23),
                          onPressed: () {
                            _capturePng(index);
                          },
                          icon: Icon(
                            Icons.share_outlined,
                            size: 30,
                          )),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
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

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'Database/database_helper.dart';
import 'Database/quotes_model.dart';

class Quotes_day extends StatefulWidget{
  @override
  State<Quotes_day> createState() => _Quotes_dayState();
}

class _Quotes_dayState extends State<Quotes_day> {

  bool isLoading = true;
  List<QuotesModel> quotesList = [];
  DatabaseHelper helper = DatabaseHelper();
  Future<void> loadRandomQuote() async {
    try {
      quotesList.clear();
      var randomQuote = await helper.getRandomQuote();
      if (randomQuote != null) {
        quotesList.add(randomQuote);
        print('Random quote loaded: ${randomQuote.quote}');
      }
    } finally {
      isLoading = false;
      print('isLoading set to false');
      setState(() {});
    }
  }
  void reloadQuoteAt12PM() {
    var now = DateTime.now();
    var twelvePM = DateTime(now.year, now.month, now.day, 12, 0, 0);
    if (now.isAfter(twelvePM) && now.isBefore(twelvePM.add(Duration(seconds: 5)))) {
      // If the current time is between 12:00 PM and 12:01 PM, reload the quote
      loadRandomQuote();
    }
  }

  @override
  void initState() {
    super.initState();
    reloadQuoteAt12PM();
    // loadRandomQuote();


  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar (
        backgroundColor: Colors.green,
        titleTextStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        title: Text("Quotes Of The Day"),
        toolbarHeight: 70,
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: Colors.deepOrange,))
          : quotesList.isEmpty
          ? Center(child: Text('No quotes available'))
          : _bodybulding(),
    );
  }
  Widget _bodybulding(){
    return  Padding(
      padding: const EdgeInsets.only(left: 30,top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              // color: Colors.blue,
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(
                  "assets/image/img11.jpg",
                ),
              ),
            ),
            child: Container(
                alignment: Alignment.center,
                // color: Colors.white,
                height: 180,
                width: 350,
                child: Text(quotesList[0].quote.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.normal,
                        letterSpacing: 0.5,
                        wordSpacing: 0))),
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
                      // _download(index);
                    },
                    icon: Icon(
                      Icons.save_alt_outlined,
                      size: 30,
                    )),
                IconButton(
                    padding: EdgeInsets.only(left: 23, right: 23),
                    onPressed: () {
                      print("kevin ${quotesList[0].quote.toString()}");
                      Clipboard.setData(ClipboardData(
                          text: quotesList[0]
                              .quote
                              .toString()))
                          .then((_) {
                        setState(() {
                          // isQuoteCopiedList = List.generate(
                          //     quotesList.length,
                          //         (index) => false); // Reset all icons
                          // isQuoteCopiedList[0] = true; // Update icon
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
                      // _capturePng(index);
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
  }
}
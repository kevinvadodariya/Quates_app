import 'package:app/Drawer.dart';
import 'package:app/Quotes.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Database/category_model.dart';
import 'Database/database_helper.dart';

class Home_page extends StatefulWidget {
  @override
  State<Home_page> createState() => _Home_pageState();
}

class _Home_pageState extends State<Home_page> {
  List<Color> colorList = [
    Colors.pink,
    Colors.deepOrange,
    Colors.green,
    Colors.yellow.shade600,
    Colors.blue,
    Colors.black,
    Colors.lightGreenAccent
  ];

  List<DbUpdateModel> defaultList = [];
  bool isLoading = true;
  DatabaseHelper helper = DatabaseHelper();

  Future<void> loadInitialData() async {
    try {
      var dbUpdateListDB = await helper.getDbUpdateList();
      if (dbUpdateListDB.isNotEmpty) {
        defaultList.addAll(dbUpdateListDB);
      }
    } finally {
      isLoading = false;
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    loadInitialData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        titleTextStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        title: Text("Best Quotes For You"),
        centerTitle: true,
        toolbarHeight: 70,
      ),
      body: isLoading == false
          ? Padding(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return Padding(
                      padding:
                          const EdgeInsets.only(left: 25, right: 25, top: 25),
                      child: InkWell(
                        onTap: (){
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Quotes(
                                  ID: defaultList[index]
                                      .id!
                                      .toInt(),
                                ),
                              ));
                        },
                        child: Container(
                            height: 130,
                            decoration: BoxDecoration(
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                    color: Colors.grey,
                                    blurRadius: 5.0,
                                  )
                                ],
                                borderRadius: BorderRadius.circular(20),
                                color: colorList[index % colorList.length]),
                            child: Center(
                              child: ListTile(
                                  leading: Image.asset(
                                      "assets/image/category${defaultList[index].id}.png",
                                      height: 80,
                                      width: 80),
                                  title: Text(
                                    defaultList[index].name.toString(),
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white),
                                  ),
                                  subtitle: Text(
                                    "Total Quotes : ${defaultList[index].total}",
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white),
                                  ),
                                  trailing: IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => Quotes(
                                                ID: defaultList[index]
                                                    .id!
                                                    .toInt(),
                                              ),
                                            ));
                                      },
                                      icon: Icon(
                                        Icons.arrow_forward,
                                        size: 20,
                                        color: Colors.white,
                                      ))),
                            )),
                      ));
                },
                itemCount: defaultList.length,
                scrollDirection: Axis.vertical,
                // separatorBuilder: (context, index) =>
                //     Divider(height: 30, thickness: 2),
              ),
            )
          : SizedBox(
              child: Center(
                  child: CircularProgressIndicator(
                color: Colors.redAccent,
              )),
            ),
      drawer: drawer(),
    );
  }
}

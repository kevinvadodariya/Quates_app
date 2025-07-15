import 'package:app/Quotes_of%20_day.dart';
import 'package:app/home_page.dart';
import 'package:app/liked_quotes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Database/database_helper.dart';
import 'Database/quotes_model.dart';

class drawer extends StatefulWidget {
  @override
  State<drawer> createState() => _drawerState();
}

class _drawerState extends State<drawer> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(padding: EdgeInsets.all(0), children: [
      DrawerHeader(
          decoration: BoxDecoration(color: Colors.black),
          child: UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: Colors.black,
            ),
            accountName:
                Text("Kevin Vadodariya", style: TextStyle(fontSize: 18)),
            accountEmail:
                Text("kevin32@gmail.com", style: TextStyle(fontSize: 11)),
            currentAccountPictureSize: Size.square(40),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text("K"),
            ),
          )),
      ListTile(
        leading: Icon(
          _selectedIndex == 0 ? Icons.home : Icons.home_outlined,
          color:_selectedIndex == 0 ? Colors.black : Colors.grey,
        ),
        title: Text("Home",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400,color:_selectedIndex == 0 ? Colors.black : Colors.grey)),
        onTap: () {
          setState(() {
            _selectedIndex = 0;
          });
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Home_page(),
              ));
        },
      ),
      ListTile(
        leading: Icon(
            _selectedIndex == 1 ? Icons.thumb_up : Icons.thumb_up_outlined,
            color:_selectedIndex == 1 ? Colors.black : Colors.grey),
        title: Text("Liked Quotes",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400,color:_selectedIndex == 1 ? Colors.black : Colors.grey)),
        onTap: () {
          setState(() {
            _selectedIndex = 1;
          });
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Liked_Quotes(),
              ));
        },
      ),
      ListTile(
        leading: Icon(
          _selectedIndex == 2
              ? Icons.emoji_emotions
              : Icons.emoji_emotions_outlined,
          color:_selectedIndex == 2 ? Colors.black : Colors.grey,
        ),
        title: Text("Quotes of The Day",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400,color:_selectedIndex == 2 ? Colors.black : Colors.grey)),
        onTap: () {
          setState(() {
            _selectedIndex = 2;
            Navigator.push(context, MaterialPageRoute(builder: (context) =>Quotes_day(),));
          });
        },
      ),
      ListTile(
        leading: Icon(
          _selectedIndex == 3 ? Icons.mail : Icons.mail_outline,
          color:_selectedIndex == 3 ? Colors.black : Colors.grey,
        ),
        title: Text("Contect Us",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400,color:_selectedIndex == 3 ? Colors.black : Colors.grey)),
        onTap: () {
          setState(() {
            _selectedIndex = 3;
            // Navigator.pop(context);
          });
        },
      ),
      ListTile(
        leading: Icon(
          _selectedIndex == 4 ? Icons.star : Icons.star_border_outlined,
          color:_selectedIndex == 4 ? Colors.black : Colors.grey,
        ),
        title: Text("Rate Us",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400,color:_selectedIndex == 4 ? Colors.black : Colors.grey)),
        onTap: () {
          setState(() {
            _selectedIndex = 4;
          });
        },
      ),
      ListTile(
        leading: Icon(
          _selectedIndex == 5 ? Icons.share : Icons.share_outlined,
          color:_selectedIndex == 5 ? Colors.black : Colors.grey,
        ),
        title: Text("Share App",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400,color:_selectedIndex == 5 ? Colors.black : Colors.grey)),
        onTap: () {
          setState(() {
            _selectedIndex = 5;
          });
        },
      ),
      ListTile(
        leading: Icon(_selectedIndex==6?
          Icons.local_police :Icons.local_police_outlined,
          color:_selectedIndex == 6 ? Colors.black : Colors.grey,
        ),
        title: Text("Privet Policy",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400,color:_selectedIndex == 6 ? Colors.black : Colors.grey)),
        onTap: () {setState(() {
          _selectedIndex = 6;
        });

        },
      ),
    ]));
  }
}

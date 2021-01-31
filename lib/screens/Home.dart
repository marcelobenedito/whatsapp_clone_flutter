import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_clone/RouteGenerator.dart';
import 'package:whatsapp_clone/screens/ContactsScreen.dart';
import 'package:whatsapp_clone/screens/Login.dart';
import 'package:whatsapp_clone/screens/TalksScreen.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {

  TabController _tabController;
  List<String> menuItems = [
    "Settings",
    "Sign Out"
  ];
  String _userEmail = "";

  Future _getEmail() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User loggedUser = await auth.currentUser;

    setState(() {
      _userEmail = loggedUser.email;
    });

  }

  @override
  void initState() {
    super.initState();
    _getEmail();
    _tabController = TabController(
        length: 2,
        vsync: this
    );
  }

  _chooseMenuOption(String selectedOption) {
    switch (selectedOption) {
      case "Settings":
        Navigator.pushNamed(context, RouteGenerator.SETTINGS_ROUTE);
        break;
      case "Sign Out":
        _signOutUser();
        break;
    }
  }

  _signOutUser() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut();
    Navigator.pushReplacementNamed(context, RouteGenerator.LOGIN_ROUTE);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("WhatsApp Clone"),
        bottom: TabBar(
          indicatorWeight: 4,
          labelStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold
          ),
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: [
            Tab(text: "Talks"),
            Tab(text: "Contacts"),
          ],
        ),
        actions: [
          PopupMenuButton(
            onSelected: _chooseMenuOption,
            itemBuilder: (context) {
              return menuItems.map((String item) {
                return PopupMenuItem(
                  value: item,
                  child: Text(item),
                );
              }).toList();
            }
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          TalksScreen(),
          ContactsScreen(),
        ],
      ),
    );
  }
}

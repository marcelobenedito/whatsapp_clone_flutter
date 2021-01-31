import 'package:flutter/material.dart';
import 'package:whatsapp_clone/model/Talk.dart';

class ContactsScreen extends StatefulWidget {
  @override
  _ContactsScreenState createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {

  List<Talk> talkList = [
    Talk(
        "Caroline",
        "Hiii lovesss!!! s2",
        "https://firebasestorage.googleapis.com/v0/b/whatsapp-clone-8e987.appspot.com/o/profile%2Fperfil1.jpg?alt=media&token=d8034904-832b-4314-8b82-972dc464f15b"
    ),
    Talk(
        "Morgan Leah",
        "Cool!!! its amazing!!! Don't forget send to Marie...",
        "https://firebasestorage.googleapis.com/v0/b/whatsapp-clone-8e987.appspot.com/o/profile%2Fperfil3.jpg?alt=media&token=9670c11e-9e2a-40bd-b767-5cf83913bc7c"
    ),
    Talk(
        "John Oliver",
        "Thank you. I'll check mail later",
        "https://firebasestorage.googleapis.com/v0/b/whatsapp-clone-8e987.appspot.com/o/profile%2Fperfil5.jpg?alt=media&token=16e33944-f222-4980-b81f-ea02c7b43d21"
    ),
    Talk(
        "Will",
        "OK. If u need im here bro",
        "https://firebasestorage.googleapis.com/v0/b/whatsapp-clone-8e987.appspot.com/o/profile%2Fperfil2.jpg?alt=media&token=a3556683-b662-4bd6-ab85-54137f9c2eea"
    ),
    Talk(
        "Natasha Allen",
        "What is the name that series that you told me last week????",
        "https://firebasestorage.googleapis.com/v0/b/whatsapp-clone-8e987.appspot.com/o/profile%2Fperfil4.jpg?alt=media&token=2ef06206-68f2-4eb5-9a3a-4d5233334bf5"
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: talkList.length,
        itemBuilder: (context, index) {
          Talk talk = talkList[index];
          return ListTile(
            contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 8),
            leading: CircleAvatar(
              maxRadius: 30,
              backgroundColor: Colors.grey,
              backgroundImage: NetworkImage(talk.imagePath),
            ),
            title: Text(
              talk.name,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16
              ),
            ),
          );
        }
    );
  }
}


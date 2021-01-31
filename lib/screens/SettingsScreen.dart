import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  TextEditingController _nameController = TextEditingController();
  File _image;
  String _loggedUserId;
  bool _uploadingImage = false;
  String _imageUrl;

  Future _getImage(String imageResource) async {
    File selectedImage;

    switch (imageResource) {
      case "Camera":
        selectedImage = await ImagePicker.pickImage(source: ImageSource.camera);
        break;
      case "Gallery":
        selectedImage =
            await ImagePicker.pickImage(source: ImageSource.gallery);
        break;
    }

    setState(() {
      _image = selectedImage;
      if (_image != null) {
        _uploadingImage = true;
        _uploadImage();
      }
    });
  }

  Future _uploadImage() {
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference rootFolder = storage.ref();
    Reference file = rootFolder.child("profile").child("$_loggedUserId.jpg");
    UploadTask task = file.putFile(_image);
    task.snapshotEvents.listen((TaskSnapshot snapshot) {
      if (snapshot.state == TaskState.running) {
        setState(() {
          _uploadingImage = true;
        });
      } else if (snapshot.state == TaskState.success) {
        setState(() {
          _uploadingImage = false;
        });
      }
    });

    task.then((TaskSnapshot snapshot) {
      _getImageUrl(snapshot);
    });
  }

  _updateNameFirestore() {
    String name = _nameController.text;
    FirebaseFirestore db = FirebaseFirestore.instance;

    Map<String, dynamic> map = {"name": name};

    db.collection("users").doc(_loggedUserId).update(map);
  }

  _updateImageUrlFirestore(url) {
    FirebaseFirestore db = FirebaseFirestore.instance;

    Map<String, dynamic> map = {"imageUrl": url};

    db.collection("users").doc(_loggedUserId).update(map);
  }

  Future _getImageUrl(TaskSnapshot snapshot) async {
    String url = await snapshot.ref.getDownloadURL();
    _updateImageUrlFirestore(url);
    setState(() {
      _imageUrl = url;
    });
  }

  _getUserData() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User loggedUser = await auth.currentUser;
    _loggedUserId = loggedUser.uid;
    FirebaseFirestore db = FirebaseFirestore.instance;
    DocumentSnapshot snapshot =
        await db.collection("users").doc(_loggedUserId).get();

    Map<String, dynamic> map = snapshot.data();
    _nameController.text = map["name"];
    if (map["imageUrl"] != null) {
      setState(() {
        _imageUrl = map["imageUrl"];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  child: _uploadingImage ? CircularProgressIndicator() : Container(),
                ),
                CircleAvatar(
                  radius: 100,
                  backgroundColor: Colors.grey,
                  backgroundImage:
                      _imageUrl != null ? NetworkImage(_imageUrl) : null,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FlatButton(
                      child: Text("Camera"),
                      onPressed: () {
                        _getImage("Camera");
                      },
                    ),
                    FlatButton(
                      child: Text("Gallery"),
                      onPressed: () {
                        _getImage("Gallery");
                      },
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: TextField(
                    controller: _nameController,
                    autofocus: true,
                    keyboardType: TextInputType.text,
                    style: TextStyle(fontSize: 20),
                    onChanged: (text) {
                      _updateNameFirestore();
                    },
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        hintText: "Name",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32))),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16, bottom: 10),
                  child: RaisedButton(
                    child: Text(
                      "Save",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    color: Colors.green,
                    padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32)),
                    onPressed: () {
                      _updateNameFirestore();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'dart:async';
import 'dart:io';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eight/models/channelModel.dart';
import 'package:eight/resources/constants.dart';
import 'package:eight/screens/home_screen.dart';
import 'package:eight/screens/size_config.dart';
import 'package:eight/screens/stream_page_mj.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ChooseChannelScreen extends StatefulWidget {
  final String name;
  const ChooseChannelScreen({Key key, this.name}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ChooseChannelScreenState();
}

class ChooseChannelScreenState extends State<ChooseChannelScreen> {
  /// create a channelController to retrieve text value
  final _channelController = TextEditingController();
  // final _nameController = TextEditingController();

  /// if channel textField is validated to have error
  bool _validateError = false;
  //ClientRole _role = ClientRole.Broadcaster;

  File _image;
  String _uploadFileURL;

  _imgFromGallery() async {
    PickedFile pickedImage = await ImagePicker.platform
        .pickImage(source: ImageSource.gallery, imageQuality: 50);
    File image = File(pickedImage.path);
    setState(() {
      _image = image;
    });
  }

  uploadData() async {
    Reference storageReference = FirebaseStorage.instance
        .ref()
        .child("images/" + widget.name + _channelController.text.trim());
    UploadTask uploadTask = storageReference.putFile(_image);
    uploadTask.whenComplete(() {
      storageReference.getDownloadURL().then((fileURL) {
        setState(() {
          _uploadFileURL = fileURL;
        });
        List channelList = [];
        FirebaseFirestore.instance
            .collection("users")
            .doc(phone)
            .get()
            .then((user) {
          List oldList = user.data()["channels"];
          oldList.forEach((element) {
            channelList.add(element);
          });
        }).then((value) {
          channelList.add({
            "channelName": _channelController.text.trim(),
            "channelBanner": _uploadFileURL
          });
          FirebaseFirestore.instance
              .collection("users")
              .doc(phone)
              .update({"channels": FieldValue.arrayUnion(channelList)});
        });
      });
    });
  }

  @override
  void dispose() {
    // dispose input controller
    _channelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.2, 0.35, 0.5, 0.7],
          colors: [kGradColor1, kGradColor2, kGradColor3, kGradColor4],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: EdgeInsets.symmetric(vertical: 50, horizontal: 12),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "What would you like to call yourself",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "MJ",
                      style: TextStyle(
                          color: Colors.yellow,
                          fontWeight: FontWeight.w700,
                          fontSize: 25),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      widget.name,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 25),
                    ),
                    // Expanded(
                    //   child: TextFormField(
                    //     controller: _nameController,
                    //     keyboardType: TextInputType.text,
                    //     textCapitalization: TextCapitalization.words,
                    //     style: TextStyle(color: Colors.white, fontSize: 18),
                    //     decoration: InputDecoration(
                    //       errorText:
                    //           _validateError ? "Name is mandatory" : null,
                    //       focusedBorder: UnderlineInputBorder(
                    //         borderSide: BorderSide(
                    //           color: Colors.white,
                    //           width: 1.5,
                    //         ),
                    //       ),
                    //       contentPadding: EdgeInsets.all(0),
                    //       enabledBorder: UnderlineInputBorder(
                    //         borderSide: BorderSide(
                    //           color: Colors.white,
                    //           width: 1.5,
                    //         ),
                    //       ),
                    //       hintText: "Your name",
                    //       hintStyle: TextStyle(color: Colors.white54),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
                SizedBox(
                  height: 25,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Your Stations",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Container(
                          width: SizeConfig.screenWidth * 0.3,
                          height: SizeConfig.screenWidth * 0.3,
                          decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(20)),
                        )
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 25,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Create Station",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => _imgFromGallery(),
                          child: _image == null
                              ? Container(
                                  width: SizeConfig.screenWidth * 0.3,
                                  height: SizeConfig.screenWidth * 0.3,
                                  decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 25, vertical: 35),
                                    child: Center(
                                      child: Text(
                                        "Upload Banner",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                    ),
                                  ),
                                )
                              : Container(
                                  width: SizeConfig.screenWidth * 0.3,
                                  height: SizeConfig.screenWidth * 0.3,
                                  decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.file(
                                      _image,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: SizeConfig.screenWidth * 0.6,
                              child: TextFormField(
                                controller: _channelController,
                                keyboardType: TextInputType.text,
                                textCapitalization: TextCapitalization.words,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14),
                                decoration: InputDecoration(
                                    errorText: _validateError
                                        ? "Channel name is mandatory"
                                        : null,
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.white,
                                        width: 1.5,
                                      ),
                                    ),
                                    contentPadding: EdgeInsets.all(0),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.white,
                                        width: 1.5,
                                      ),
                                    ),
                                    hintText: "Station name",
                                    hintStyle:
                                        TextStyle(color: Colors.white54)),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "define #tags",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12),
                            )
                          ],
                        )
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      onTap: onJoin,
                      child: Container(
                        alignment: Alignment.center,
                        width: SizeConfig.screenWidth * 0.4,
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                        decoration: BoxDecoration(
                            gradient: LinearGradient(stops: [
                          0.2,
                          0.8
                        ], colors: [
                          kGradColor1,
                          kGradColor4,
                        ])),
                        child: Text('CREATE  STATION',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600)),
                      ),
                    )
                  ],
                ),
                // Column(
                //   children: [
                // ListTile(
                //   title: Text(ClientRole.Broadcaster.toString()),
                //   leading: Radio(
                //     value: ClientRole.Broadcaster,
                //     groupValue: _role,
                //     onChanged: (ClientRole value) {
                //       setState(() {
                //         _role = value;
                //       });
                //     },
                //   ),
                // ),
                // ListTile(
                //   title: Text(ClientRole.Audience.toString()),
                //   leading: Radio(
                //     value: ClientRole.Audience,
                //     groupValue: _role,
                //     onChanged: (ClientRole value) {
                //       setState(() {
                //         _role = value;
                //       });
                //     },
                //   ),
                // )
                //   ],
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> onJoin() async {
    // update input validation
    setState(() {
      _channelController.text.isEmpty
          ? _validateError = true
          : _validateError = false;
    });
    if (_channelController.text.isNotEmpty) {
      // await for mic permissions
      await _handleMic(Permission.microphone);
      await uploadData();
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => StreamPageMJ(
            channelName: _channelController.text,
            role: ClientRole.Broadcaster,
            image: _uploadFileURL,
          ),
        ),
      );
    }
  }

  Future<void> _handleMic(Permission permission) async {
    final status = await permission.request();
    print(status);
  }
}

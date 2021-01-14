import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eight/models/channelModel.dart';
import 'package:eight/screens/choose_channel_screen.dart';
import 'package:eight/screens/size_config.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

String phone;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController nameController;
  String name;
  bool loader = true;
  List channelList = new List();

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  getUserData() async {
    await SharedPreferences.getInstance().then((prefs) async {
      phone = prefs.getString("phone");
      FirebaseFirestore.instance
          .collection("users")
          .doc(phone)
          .get()
          .then((snapshot) {
        print(snapshot.data());
        setState(() {
          name = snapshot.data()["username"];
          nameController = new TextEditingController(text: name);
        });
      });
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection("users").get();
      var list = querySnapshot.docs;
      print(list[0].data());
      list.forEach((user) {
        channelList.add(user.data()["channels"]);
      });
      setState(() {
        loader = false;
      });
      return;
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return loader
        ? CircularProgressIndicator()
        : GestureDetector(
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
              FirebaseFirestore.instance
                  .collection("users")
                  .doc(phone)
                  .update({"username": name});
            },
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.2, 0.35, 0.5, 0.7],
                  colors: [
                    Color(0xFF010000),
                    Color(0xFF340509),
                    Color(0xFF4b040d),
                    Color(0xFFcc0025),
                  ],
                ),
              ),
              child: Scaffold(
                backgroundColor: Colors.transparent,
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerDocked,
                floatingActionButton: Container(
                  alignment: Alignment.center,
                  width: SizeConfig.screenWidth,
                  height: SizeConfig.screenHeight * 0.1,
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 40),
                  decoration: BoxDecoration(
                      color: Colors.yellow,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [0.03, 0.7, 0.88],
                        colors: [
                          Colors.transparent,
                          Color(0xFF010000),
                          Colors.transparent
                        ],
                      )),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.play_circle_fill,
                        size: 50,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Stairway to Heaven",
                              style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600)),
                          Text("DJ Gogo",
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.yellow,
                                  fontWeight: FontWeight.w600))
                        ],
                      ),
                    ],
                  ),
                ),
                body: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            vertical: getProportionateScreenHeight(30),
                            horizontal: getProportionateScreenWidth(15)),
                        width: double.infinity,
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 4),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                          color: Colors.white, width: 1)),
                                  child: Text(
                                    "Featured",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "MJ ",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 30,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    Container(
                                      width: SizeConfig.screenWidth * 0.6,
                                      child: TextFormField(
                                        cursorColor: Colors.black,
                                        controller: nameController,
                                        keyboardType: TextInputType.text,
                                        onChanged: (value) {
                                          setState(() {
                                            name = value;
                                          });
                                          print(name);
                                        },
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 30,
                                            fontWeight: FontWeight.w700),
                                        decoration: new InputDecoration(
                                            border: InputBorder.none,
                                            focusedBorder: InputBorder.none,
                                            enabledBorder: InputBorder.none,
                                            errorBorder: InputBorder.none,
                                            disabledBorder: InputBorder.none,
                                            hintStyle: TextStyle(
                                                color: Colors.white70,
                                                fontSize: 30,
                                                fontWeight: FontWeight.w700),
                                            hintText: "Your Name"),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "200",
                                      style: TextStyle(
                                          color: Colors.yellow,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      " followers",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 15),
                                    )
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            vertical: getProportionateScreenHeight(15),
                            horizontal: getProportionateScreenWidth(15)),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Icon(
                              Icons.wifi,
                              color: Colors.red,
                              size: 60,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => ChooseChannelScreen(
                                          name: name,
                                        )));
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "GO LIVE",
                                    style: TextStyle(
                                        color: Colors.yellow,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  Text(
                                    "GET STARTED",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700),
                                  )
                                ],
                              ),
                            ),
                            Icon(
                              Icons.navigate_next_rounded,
                              color: Colors.white,
                              size: 45,
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(
                            top: getProportionateScreenHeight(30),
                            left: getProportionateScreenWidth(15)),
                        width: double.infinity,
                        decoration: BoxDecoration(),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Popular Channels",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: getProportionateScreenHeight(2),
                                  horizontal: getProportionateScreenWidth(1)),
                              width: double.infinity,
                              height: SizeConfig.screenHeight * 0.25,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: 15,
                                  itemBuilder: (context, index) {
                                    return Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Container(
                                            height:
                                                SizeConfig.screenHeight * 0.15,
                                            width:
                                                SizeConfig.screenHeight * 0.15,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "MJ Adeetya",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            Text(
                                              "300 views",
                                              style: TextStyle(
                                                  color: Colors.yellow,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500),
                                            )
                                          ],
                                        )
                                      ],
                                    );
                                  }),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(
                            top: getProportionateScreenWidth(15),
                            left: getProportionateScreenWidth(15)),
                        width: double.infinity,
                        decoration: BoxDecoration(),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Join your friends",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            ),
                            Container(
                              width: double.infinity,
                              height: SizeConfig.screenHeight * 0.2,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: 15,
                                  itemBuilder: (context, index) {
                                    return Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Container(
                                            height:
                                                SizeConfig.screenHeight * 0.1,
                                            width:
                                                SizeConfig.screenHeight * 0.1,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        SizeConfig
                                                                .screenHeight *
                                                            0.1)),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          "Adeetya",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    );
                                  }),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(
                            top: getProportionateScreenHeight(5),
                            left: getProportionateScreenWidth(15)),
                        width: double.infinity,
                        decoration: BoxDecoration(),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Buy Music",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: getProportionateScreenWidth(1),
                                  vertical: 15),
                              width: double.infinity,
                              height: SizeConfig.screenHeight * 0.25,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: 15,
                                  itemBuilder: (context, index) {
                                    return Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Container(
                                            height:
                                                SizeConfig.screenHeight * 0.15,
                                            width:
                                                SizeConfig.screenHeight * 0.15,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                          ),
                                        ),
                                      ],
                                    );
                                  }),
                            ),
                          ],
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
